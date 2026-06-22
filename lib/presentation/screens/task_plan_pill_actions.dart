part of 'task_plan_screen.dart';

extension _PlannedTaskPillActions on _PlannedTaskPill {
  void _showPlanActionSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final colorScheme = Theme.of(sheetContext).colorScheme;
        final completed = task?.state == AppConstants.taskStateCompleted;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                if (completed && task?.completedAt != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    '完成时间：${_formatPlanDateTime(task!.completedAt!)}',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 22),
                _PlanActionGrid(
                  actions: _buildPlanPillActions(
                    pill: this,
                    context: context,
                    sheetContext: sheetContext,
                    colorScheme: colorScheme,
                    completed: completed,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
