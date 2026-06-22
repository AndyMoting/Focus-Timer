part of 'task_plan_screen.dart';

List<_PlanActionData> _buildPlanPillActions({
  required _PlannedTaskPill pill,
  required BuildContext context,
  required BuildContext sheetContext,
  required ColorScheme colorScheme,
  required bool completed,
}) {
  final task = pill.task;
  return [
    _PlanActionData(
      icon: Icons.timer_outlined,
      label: '自由计时',
      color: colorScheme.primary,
      onTap: task == null
          ? null
          : () {
              Navigator.pop(sheetContext);
              pill.onStartPlan(pill.plan, task);
            },
    ),
    _PlanActionData(
      icon: Icons.spa_outlined,
      label: '番茄计时',
      color: colorScheme.primary,
      onTap: task == null
          ? null
          : () {
              Navigator.pop(sheetContext);
              pill.onStartPlan(
                pill.plan,
                task,
                type: AppConstants.typePomodoro,
                targetDurationMs: AppConstants.defaultPomodoroMs,
              );
            },
    ),
    _PlanActionData(
      icon: Icons.videocam_outlined,
      label: '视频打卡',
      color: const Color(0xFF8E6AD8),
      onTap: task == null
          ? null
          : () {
              Navigator.pop(sheetContext);
              pill.onStartPlan(
                pill.plan,
                task,
                type: AppConstants.typeVideoStudy,
              );
            },
    ),
    _PlanActionData(
      icon: completed ? Icons.undo : Icons.check_circle_outline,
      label: completed ? '取消完成' : '完成',
      color: completed ? colorScheme.tertiary : const Color(0xFF2E7D32),
      onTap: task == null
          ? null
          : () async {
              await pill.onToggleTaskComplete(task);
              if (sheetContext.mounted) {
                Navigator.pop(sheetContext);
              }
            },
    ),
    _PlanActionData(
      icon: Icons.track_changes_outlined,
      label: '设定目标',
      color: const Color(0xFF2E7D32),
      onTap: () {
        Navigator.pop(sheetContext);
        _showPlanDurationSheet(context, pill);
      },
    ),
    _PlanActionData(
      icon: Icons.event_outlined,
      label: '计划日期',
      color: colorScheme.secondary,
      onTap: () {
        Navigator.pop(sheetContext);
        _pickPlanDate(context, pill);
      },
    ),
    _PlanActionData(
      icon: Icons.delete_outline,
      label: '删除',
      color: colorScheme.error,
      onTap: () async {
        await pill.onDeletePlan(pill.plan);
        if (sheetContext.mounted) Navigator.pop(sheetContext);
      },
    ),
    _PlanActionData(
      icon: Icons.pie_chart_outline,
      label: '统计',
      color: const Color(0xFF7B3FB0),
      onTap: () {
        Navigator.pop(sheetContext);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StatsScreen(title: '统计')),
        );
      },
    ),
  ];
}
