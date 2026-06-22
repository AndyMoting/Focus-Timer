part of 'task_plan_screen.dart';

class _TimelineLane extends StatelessWidget {
  static const double _plannedItemHeight = _Timeline._plannedItemHeight;
  static const double _plannedItemGap = _Timeline._plannedItemGap;
  static const int _maxInlineItems = _Timeline._maxInlineItems;

  final bool isHovering;
  final List<TaskPlan> plans;
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

  const _TimelineLane({
    required this.isHovering,
    required this.plans,
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
    final hasPlans = plans.isNotEmpty;
    final inlineCount = plans.length.clamp(0, _maxInlineItems).toInt();
    final maxHeight = inlineCount == 0
        ? null
        : inlineCount * _plannedItemHeight +
              (inlineCount - 1) * _plannedItemGap;
    final extraCount = plans.length - _maxInlineItems;

    return Container(
      decoration: BoxDecoration(
        color: hasPlans ? Colors.transparent : colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: hasPlans
            ? null
            : Border.all(
                color: isHovering
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
                width: isHovering ? 1.4 : 1,
              ),
      ),
      child: hasPlans
          ? Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHeight!),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    physics: plans.length > _maxInlineItems
                        ? const BouncingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    itemCount: plans.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: _plannedItemGap),
                    itemBuilder: (context, index) {
                      return _PlannedTaskTile(
                        plan: plans[index],
                        tasksById: tasksById,
                        taskColorsByListId: taskColorsByListId,
                        onDeletePlan: onDeletePlan,
                        onUpdatePlanDuration: onUpdatePlanDuration,
                        onMovePlanToDay: onMovePlanToDay,
                        onToggleTaskComplete: onToggleTaskComplete,
                        onStartPlan: onStartPlan,
                        dragX: dragX,
                      );
                    },
                  ),
                ),
                if (extraCount > 0) ...[
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '还有 $extraCount 项，上下滑动',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ],
            )
          : Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  isHovering ? '松手安排到此时段' : '',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
    );
  }
}
