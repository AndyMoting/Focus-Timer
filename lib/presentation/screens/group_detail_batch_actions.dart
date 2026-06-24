part of 'group_detail_screen.dart';

void _showMoveSelectedTasksSheet(
  BuildContext context,
  WidgetRef ref,
  TaskList group,
  ValueNotifier<Set<int>> selectedTaskIds,
) {
  final selectedIds = selectedTaskIds.value.toList();
  if (selectedIds.isEmpty) return;
  final groupsAsync = ref.read(groupListProvider);
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      return SafeArea(
        child: groupsAsync.when(
          data: (groups) {
            final targets = groups
                .where((item) => item.id != group.id)
                .toList();
            if (targets.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Text('没有其他分组可移动'),
              );
            }
            return ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: Text('移动 ${selectedIds.length} 项到分组'),
                ),
                for (final target in targets)
                  ListTile(
                    leading: CircleAvatar(
                      radius: 8,
                      backgroundColor: Color(target.color),
                    ),
                    title: Text(target.name),
                    onTap: () async {
                      final notifier = ref.read(
                        taskListProvider(group.id).notifier,
                      );
                      for (final id in selectedIds) {
                        await notifier.moveTaskToGroup(id, target.id);
                      }
                      selectedTaskIds.value = <int>{};
                      ref.invalidate(allTaskListProvider);
                      if (sheetContext.mounted) Navigator.pop(sheetContext);
                      if (context.mounted) {
                        _showSnack(context, '已移动 ${selectedIds.length} 项');
                      }
                    },
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) =>
              const Padding(padding: EdgeInsets.all(24), child: Text('分组加载失败')),
        ),
      );
    },
  );
}

Future<void> _confirmDeleteSelectedTasks(
  BuildContext context,
  WidgetRef ref,
  TaskList group,
  ValueNotifier<Set<int>> selectedTaskIds,
) async {
  final ids = selectedTaskIds.value.toList();
  if (ids.isEmpty) return;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('删除待办'),
      content: Text('确定删除选中的 ${ids.length} 项待办吗？'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('删除'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;

  final notifier = ref.read(taskListProvider(group.id).notifier);
  final snapshots = <DeletedTaskSnapshot>[];
  for (final id in ids) {
    final snapshot = await notifier.deleteTask(id);
    if (snapshot != null) snapshots.add(snapshot);
  }
  selectedTaskIds.value = <int>{};
  ref.invalidate(allTaskListProvider);
  if (!context.mounted || snapshots.isEmpty) return;
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      content: Text('已删除 ${snapshots.length} 项'),
      duration: const Duration(seconds: 4),
      persist: false,
      action: SnackBarAction(
        label: '撤销',
        onPressed: () async {
          for (final snapshot in snapshots) {
            await notifier.restoreDeletedTask(snapshot);
          }
          ref.invalidate(allTaskListProvider);
        },
      ),
    ),
  );
}
