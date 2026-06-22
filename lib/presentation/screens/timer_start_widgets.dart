part of 'timer_start_surface.dart';

class _TodayOverview extends StatelessWidget {
  final TimerState timerState;
  final ColorScheme colorScheme;

  const _TodayOverview({required this.timerState, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final focusRecords = timerState.todayRecords
        .where((record) => isFocusTimerType(record.type))
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '今日',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TimerStatItem(
                  label: '今日专注',
                  value: formatShortDuration(timerState.todayFocusDurationMs),
                  colorScheme: colorScheme,
                ),
              ),
              Expanded(
                child: TimerStatItem(
                  label: '今日次数',
                  value: '${focusRecords.length} 次',
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimerActionCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final String title;
  final String subtitle;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _TimerActionCard({
    required this.width,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 96,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: colorScheme.onPrimaryContainer),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskStartList extends StatelessWidget {
  final List<Task> tasks;
  final ColorScheme colorScheme;
  final TimerStartCallback onStart;

  const _TaskStartList({
    required this.tasks,
    required this.colorScheme,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tasks
          .map(
            (task) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => onStart(
                    type: AppConstants.typeFreeCount,
                    name: task.title,
                    targetDurationMs: 0,
                    note: task.description,
                    taskId: task.id,
                    listId: task.listId,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: _taskColor(task, colorScheme),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            task.isFocus == 1
                                ? Icons.flag_outlined
                                : Icons.checklist_outlined,
                            size: 18,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                _taskSubtitle(task),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.play_arrow, color: colorScheme.primary),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Color _taskColor(Task task, ColorScheme colorScheme) {
    final colorValue = task.color;
    if (colorValue == null) return colorScheme.primaryContainer;
    return Color(colorValue).withValues(alpha: 0.22);
  }

  String _taskSubtitle(Task task) {
    final parts = <String>[];
    if (task.isPinned == 1) parts.add('置顶');
    if (task.isFocus == 1) parts.add('重点');
    if (task.estimatedMinutes > 0) {
      parts.add('预计 ${task.estimatedMinutes} 分钟');
    }
    if (task.reminderAt != null) parts.add('有提醒');
    if (task.repeatRule != 'none') parts.add('重复');
    return parts.isEmpty ? '自由计时，停止后可保存并完成待办' : parts.join(' · ');
  }
}
