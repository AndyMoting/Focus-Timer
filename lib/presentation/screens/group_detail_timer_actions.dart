part of 'group_detail_screen.dart';

void _startFromRequest(
  BuildContext context,
  WidgetRef ref,
  TimerStartRequest req,
  Task task,
) {
  final timer = ref.read(timerProvider);
  if (timer.state != AppConstants.stateStop) {
    _showSnack(context, '当前计时结束后再开始');
    ref.read(homeTabIndexProvider.notifier).state = 1;
    return;
  }
  ref
      .read(timerProvider.notifier)
      .createTimer(
        type: req.type,
        name: req.name,
        targetDurationMs: req.targetDurationMs,
        taskId: task.id,
        listId: task.listId,
        planId: req.planId,
      );
  ref.read(timerProvider.notifier).startTimer();
  ref.read(homeTabIndexProvider.notifier).state = 1;
}

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
  );
}
