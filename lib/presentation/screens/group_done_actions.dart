part of 'group_list_screen.dart';

void _startTaskTimerFromHome(
  BuildContext context,
  WidgetRef ref,
  Task task, {
  required int type,
  required int targetDurationMs,
}) {
  final timer = ref.read(timerProvider);
  if (timer.state != AppConstants.stateStop) {
    _showTodoSnack(context, '当前计时结束后再开始');
    _openTimerFromHome(context, ref);
    return;
  }

  ref
      .read(timerProvider.notifier)
      .createTimer(
        type: type,
        name: task.title,
        targetDurationMs: targetDurationMs,
        taskId: task.id,
        listId: task.listId,
      );
  ref.read(timerProvider.notifier).startTimer();
  _openTimerFromHome(context, ref);
  _showTodoSnack(
    context,
    type == AppConstants.typePomodoro ? '已开始番茄计时' : '已开始自由计时',
  );
}

Future<void> _toggleTaskCompleteFromHome(
  BuildContext context,
  WidgetRef ref,
  Task task,
) async {
  await ref
      .read(taskListProvider(task.listId).notifier)
      .toggleComplete(task.id);
  ref.invalidate(allTaskListProvider);
  if (context.mounted) _showTodoSnack(context, '已取消完成');
}

Future<void> _confirmDeleteTaskFromHome(
  BuildContext context,
  WidgetRef ref,
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

  final notifier = ref.read(taskListProvider(task.listId).notifier);
  final snapshot = await notifier.deleteTask(task.id);
  ref.invalidate(allTaskListProvider);
  if (!context.mounted || snapshot == null) return;
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      content: Text('已删除“${task.title}”'),
      duration: const Duration(seconds: 4),
      persist: false,
      action: SnackBarAction(
        label: '撤销',
        onPressed: () async {
          await notifier.restoreDeletedTask(snapshot);
          ref.invalidate(allTaskListProvider);
        },
      ),
    ),
  );
}

void _openTimerFromHome(BuildContext context, WidgetRef ref) {
  Navigator.of(context).popUntil((route) => route.isFirst);
  ref.read(homeTabIndexProvider.notifier).state = 1;
}

void _openStatsFromHome(BuildContext context, WidgetRef ref) {
  Navigator.of(context).popUntil((route) => route.isFirst);
  ref.read(homeTabIndexProvider.notifier).state = 2;
}

void _showTodoSnack(BuildContext context, String message) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
  );
}
