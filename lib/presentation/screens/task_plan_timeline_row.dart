part of 'task_plan_screen.dart';

class _TimelineSlotRow extends StatelessWidget {
  final int startMinute;
  final double height;
  final List<TaskPlan> plans;
  final Map<int, Task> tasksById;
  final Map<int, Color> taskColorsByListId;
  final Future<void> Function(Task task) onAddPlan;
  final Future<void> Function(TaskPlan plan) onMovePlan;
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

  const _TimelineSlotRow({
    required this.startMinute,
    required this.height,
    required this.plans,
    required this.tasksById,
    required this.taskColorsByListId,
    required this.onAddPlan,
    required this.onMovePlan,
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
    return DragTarget<Object>(
      onWillAcceptWithDetails: (details) {
        return details.data is Task || details.data is TaskPlan;
      },
      onAcceptWithDetails: (details) {
        final data = details.data;
        if (data is Task) {
          onAddPlan(data);
        } else if (data is TaskPlan) {
          onMovePlan(data);
        }
      },
      builder: (context, candidates, _) {
        final isHovering = candidates.isNotEmpty;
        return SizedBox(
          height: height,
          child: Container(
            decoration: BoxDecoration(
              color: isHovering
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerLowest,
              border: Border(
                top: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 58,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      _formatMinute(startMinute),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
                    child: _TimelineLane(
                      isHovering: isHovering,
                      plans: plans,
                      tasksById: tasksById,
                      taskColorsByListId: taskColorsByListId,
                      onDeletePlan: onDeletePlan,
                      onUpdatePlanDuration: onUpdatePlanDuration,
                      onMovePlanToDay: onMovePlanToDay,
                      onToggleTaskComplete: onToggleTaskComplete,
                      onStartPlan: onStartPlan,
                      dragX: dragX,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatMinute(int minute) {
    final hour = minute ~/ 60;
    final rest = minute % 60;
    return '${hour.toString().padLeft(2, '0')}:'
        '${rest.toString().padLeft(2, '0')}';
  }
}
