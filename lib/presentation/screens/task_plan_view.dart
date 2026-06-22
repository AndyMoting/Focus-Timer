part of 'task_plan_screen.dart';

class PlanModeView extends HookWidget {
  final String scopeTitle;
  final List<Task> tasks;
  final List<Task> allTasks;
  final List<TaskPlan> plans;
  final int dayNum;
  final TaskPlanSettingsValue settings;
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
  final Future<void> Function() onClearPlans;
  final Map<int, Color> taskColorsByListId;

  const PlanModeView({
    super.key,
    required this.scopeTitle,
    required this.tasks,
    required this.allTasks,
    required this.plans,
    required this.dayNum,
    required this.settings,
    required this.onAddPlan,
    required this.onMovePlan,
    required this.onDeletePlan,
    required this.onUpdatePlanDuration,
    required this.onMovePlanToDay,
    required this.onToggleTaskComplete,
    required this.onStartPlan,
    required this.onClearPlans,
    required this.taskColorsByListId,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dragX = useValueNotifier(0.0);
    final date = app_date.DateUtils.dateFromDayNum(dayNum);
    final tasksById = {for (final task in allTasks) task.id: task};
    final slots = _buildSlots(settings);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${_dateLabel(date)} · $scopeTitle',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: plans.isEmpty ? null : onClearPlans,
                icon: const Icon(Icons.cleaning_services_outlined),
                label: const Text('一键清空'),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 138,
                child: _TaskPool(
                  title: scopeTitle,
                  tasks: tasks,
                  taskColorsByListId: taskColorsByListId,
                  onAcceptPlan: onDeletePlan,
                  dragX: dragX,
                ),
              ),
              VerticalDivider(width: 1, color: colorScheme.outlineVariant),
              Expanded(
                child: _Timeline(
                  slots: slots,
                  endMinute: settings.endMinute,
                  plans: plans,
                  tasksById: tasksById,
                  taskColorsByListId: taskColorsByListId,
                  slotMinutes: settings.slotMinutes,
                  onAddPlan: onAddPlan,
                  onMovePlan: onMovePlan,
                  onDeletePlan: onDeletePlan,
                  onUpdatePlanDuration: onUpdatePlanDuration,
                  onMovePlanToDay: onMovePlanToDay,
                  onToggleTaskComplete: onToggleTaskComplete,
                  onStartPlan: onStartPlan,
                  dragX: dragX,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<int> _buildSlots(TaskPlanSettingsValue value) {
    final normalized = value.normalized();
    return [
      for (
        var minute = normalized.startMinute;
        minute < normalized.endMinute;
        minute += normalized.slotMinutes
      )
        minute,
    ];
  }

  String _dateLabel(DateTime date) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    if (dateOnly == todayOnly) return '${date.month}月${date.day}日 今天';
    return '${date.month}月${date.day}日';
  }
}
