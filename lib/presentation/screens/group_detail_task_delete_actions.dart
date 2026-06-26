part of 'group_detail_screen.dart';

Future<void> _confirmDeleteTask(
  BuildContext context,
  WidgetRef ref,
  TaskList group,
  Task task,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('删除待办'),
      content: Text('确定删除“${task.title}”吗？'),
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
  if (!context.mounted) return;
  await _deleteTaskWithUndo(context, ref, group, task);
}

Future<void> _deleteTaskWithUndo(
  BuildContext context,
  WidgetRef ref,
  TaskList group,
  Task task,
) async {
  final notifier = ref.read(taskListProvider(group.id).notifier);
  final snapshot = await notifier.deleteTask(task.id);
  if (!context.mounted || snapshot == null) return;
  showTaskUndoSnackBar(
    context,
    message: '已删除“${task.title}”',
    onUndo: () => ref
        .read(taskListProvider(group.id).notifier)
        .restoreDeletedTask(snapshot),
  );
}
