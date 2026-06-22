part of 'group_list_screen.dart';

void _showMoveCompletedTaskSheet(
  BuildContext context,
  WidgetRef ref,
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
                          .read(taskListProvider(task.listId).notifier)
                          .moveTaskToGroup(task.id, target.id);
                      ref.invalidate(allTaskListProvider);
                      if (sheetContext.mounted) Navigator.pop(sheetContext);
                      if (context.mounted) _showTodoSnack(context, '已移动');
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

Future<void> _pickTaskDueDate(
  BuildContext context,
  WidgetRef ref,
  Task task,
) async {
  final picked = await showDatePicker(
    context: context,
    initialDate: task.dueDayNum == null
        ? DateTime.now()
        : DateTime(1970).add(Duration(days: task.dueDayNum!)),
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
  );
  if (picked == null) return;

  await ref
      .read(taskListProvider(task.listId).notifier)
      .updateTaskDetails(
        task.id,
        title: task.title,
        description: task.description,
        priority: task.priority,
        dueDayNum: picked.difference(DateTime(1970)).inDays,
        estimatedMinutes: task.estimatedMinutes,
        isFocus: task.isFocus == 1,
        isPinned: task.isPinned == 1,
        reminderAt: task.reminderAt,
        repeatRule: task.repeatRule,
      );
  ref.invalidate(allTaskListProvider);
  if (context.mounted) _showTodoSnack(context, '计划日期已更新');
}
