part of 'task_plan_screen.dart';

void _startPlanTimer(
  BuildContext context,
  WidgetRef ref,
  TaskPlan plan,
  Task task, {
  int type = AppConstants.typeFreeCount,
  int targetDurationMs = 0,
}) {
  final timer = ref.read(timerProvider);
  if (timer.state != AppConstants.stateStop) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('当前计时结束后再开始')));
    ref.read(homeTabIndexProvider.notifier).state = 1;
    Navigator.pop(context);
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
        planId: plan.id,
      );
  ref.read(timerProvider.notifier).startTimer();
  ref.read(homeTabIndexProvider.notifier).state = 1;
  Navigator.pop(context);
}
