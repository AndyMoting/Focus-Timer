part of 'group_detail_screen.dart';

void _showMoveTaskSheet(
  BuildContext context,
  WidgetRef ref,
  TaskList group,
  Task task,
) {
  final groupsAsync = ref.read(groupListProvider);
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      return SafeArea(
        child: groupsAsync.when(
          data: (groups) {
            final targets = groups
                .where((item) => item.id != task.listId)
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
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: Text('移动到分组'),
                ),
                for (final target in targets)
                  ListTile(
                    leading: CircleAvatar(
                      radius: 8,
                      backgroundColor: Color(target.color),
                    ),
                    title: Text(target.name),
                    onTap: () async {
                      await ref
                          .read(taskListProvider(group.id).notifier)
                          .moveTaskToGroup(task.id, target.id);
                      if (sheetContext.mounted) Navigator.pop(sheetContext);
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
