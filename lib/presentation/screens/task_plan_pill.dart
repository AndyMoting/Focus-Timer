part of 'task_plan_screen.dart';

class _PlannedTaskPill extends StatelessWidget {
  final TaskPlan plan;
  final String title;
  final Task? task;
  final Color color;
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

  const _PlannedTaskPill({
    required this.plan,
    required this.title,
    required this.task,
    required this.color,
    required this.onDeletePlan,
    required this.onUpdatePlanDuration,
    required this.onMovePlanToDay,
    required this.onToggleTaskComplete,
    required this.onStartPlan,
    required this.dragX,
  });

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<TaskPlan>(
      data: plan,
      dragAnchorStrategy: childDragAnchorStrategy,
      onDragStarted: () {
        dragX.value = MediaQuery.sizeOf(context).width * 0.72;
      },
      onDragUpdate: (details) {
        dragX.value = details.globalPosition.dx;
      },
      onDragEnd: (_) {
        dragX.value = 0;
      },
      onDraggableCanceled: (_, _) {
        dragX.value = 0;
      },
      feedback: _DragFeedback(label: title, color: color, dragX: dragX),
      childWhenDragging: Opacity(
        opacity: 0.35,
        child: _PlannedPillBody(
          plan: plan,
          title: title,
          task: task,
          color: color,
          onMore: null,
        ),
      ),
      child: _PlannedPillBody(
        plan: plan,
        title: title,
        task: task,
        color: color,
        onMore: () => _showPlanActionSheet(context),
      ),
    );
  }
}
