part of 'task_plan_screen.dart';

class _Timeline extends StatelessWidget {
  static const double _slotExtent = 72;
  static const double _plannedItemHeight = 48;
  static const double _plannedItemGap = 6;
  static const int _maxInlineItems = 3;

  final List<int> slots;
  final int endMinute;
  final List<TaskPlan> plans;
  final Map<int, Task> tasksById;
  final Map<int, Color> taskColorsByListId;
  final int slotMinutes;
  final Future<void> Function(Task task, int startMinute) onAddPlan;
  final Future<void> Function(TaskPlan plan, int startMinute) onMovePlan;
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

  const _Timeline({
    required this.slots,
    required this.endMinute,
    required this.plans,
    required this.tasksById,
    required this.taskColorsByListId,
    required this.slotMinutes,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 2, 12, 8),
          child: Text(
            '${_formatMinute(slots.first)} - ${_formatMinute(endMinute)} · ${_slotLabel(slotMinutes)}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 96),
            itemCount: slots.length,
            itemBuilder: (context, index) {
              final startMinute = slots[index];
              final slotPlans = plans
                  .where(
                    (plan) => _isPlanInSlot(plan, startMinute, slotMinutes),
                  )
                  .toList();
              return _TimelineSlotRow(
                startMinute: startMinute,
                height: _slotHeight(slotPlans.length),
                plans: slotPlans,
                tasksById: tasksById,
                taskColorsByListId: taskColorsByListId,
                onAddPlan: (task) => onAddPlan(task, startMinute),
                onMovePlan: (plan) => onMovePlan(plan, startMinute),
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
      ],
    );
  }

  double _slotHeight(int planCount) {
    if (planCount <= 1) return _slotExtent;
    final visibleCount = planCount.clamp(1, _maxInlineItems).toInt();
    final listHeight =
        visibleCount * _plannedItemHeight +
        (visibleCount - 1) * _plannedItemGap;
    final overflowHintHeight = planCount > _maxInlineItems ? 22 : 0;
    return (14 + listHeight + overflowHintHeight)
        .clamp(_slotExtent, 196)
        .toDouble();
  }

  bool _isPlanInSlot(TaskPlan plan, int slotStart, int slotMinutes) {
    final minute = _planStartMinute(plan);
    return minute >= slotStart && minute < slotStart + slotMinutes;
  }

  int _planStartMinute(TaskPlan plan) {
    return plan.startMinute ?? plan.startHour * 60;
  }

  String _formatMinute(int minute) {
    if (minute == 24 * 60) return '24:00';
    final hour = minute ~/ 60;
    final rest = minute % 60;
    return '${hour.toString().padLeft(2, '0')}:'
        '${rest.toString().padLeft(2, '0')}';
  }

  String _slotLabel(int minutes) {
    if (minutes < 60) return '每 $minutes 分钟';
    return '每 ${minutes ~/ 60} 小时';
  }
}
