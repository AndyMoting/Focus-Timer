part of 'task_plan_screen.dart';

class _PlannedTaskTile extends StatelessWidget {
  final TaskPlan plan;
  final Map<int, Task> tasksById;
  final Map<int, Color> taskColorsByListId;
  final Future<void> Function(TaskPlan plan) onDeletePlan;
  final Future<void> Function(TaskPlan plan, int durationMinutes)
  onUpdatePlanDuration;
  final Future<void> Function(TaskPlan plan, int dayNum) onMovePlanToDay;
  final Future<void> Function(Task task) onToggleTaskComplete;
  final void Function(
    TaskPlan plan,
    Task task, {
    int type,
    int targetDurationMs,
  })
  onStartPlan;
  final ValueNotifier<double> dragX;

  const _PlannedTaskTile({
    required this.plan,
    required this.tasksById,
    required this.taskColorsByListId,
    required this.onDeletePlan,
    required this.onUpdatePlanDuration,
    required this.onMovePlanToDay,
    required this.onToggleTaskComplete,
    required this.onStartPlan,
    required this.dragX,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final task = tasksById[plan.taskId];
    final color = task == null
        ? colorScheme.primary
        : _effectiveTaskColor(
            task,
            taskColorsByListId[task.listId] ?? colorScheme.primary,
          );
    return SizedBox(
      height: _TimelineLane._plannedItemHeight,
      child: _PlannedTaskPill(
        plan: plan,
        title: task?.title ?? '已删除待办',
        task: task,
        color: color,
        onDeletePlan: onDeletePlan,
        onUpdatePlanDuration: onUpdatePlanDuration,
        onMovePlanToDay: onMovePlanToDay,
        onToggleTaskComplete: onToggleTaskComplete,
        onStartPlan: onStartPlan,
        dragX: dragX,
      ),
    );
  }
}

Color _effectiveTaskColor(Task task, Color fallback) {
  return task.color == null ? fallback : Color(task.color!);
}
