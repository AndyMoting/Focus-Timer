part of 'group_list_screen.dart';

class _CompletedOverviewCard extends StatelessWidget {
  final List<Task> tasks;

  const _CompletedOverviewCard({required this.tasks});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final tomorrowStart = todayStart.add(const Duration(days: 1));
    final weekStart = todayStart.subtract(Duration(days: now.weekday - 1));
    final monthStart = DateTime(now.year, now.month);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '统计概览',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _CompletedStatItem(
                  icon: Icons.today_outlined,
                  value: _countCompletedBetween(
                    tasks,
                    todayStart,
                    tomorrowStart,
                  ),
                  label: '今日',
                ),
              ),
              Expanded(
                child: _CompletedStatItem(
                  icon: Icons.date_range_outlined,
                  value: _countCompletedSince(tasks, weekStart),
                  label: '本周',
                ),
              ),
              Expanded(
                child: _CompletedStatItem(
                  icon: Icons.calendar_month_outlined,
                  value: _countCompletedSince(tasks, monthStart),
                  label: '本月',
                ),
              ),
              Expanded(
                child: _CompletedStatItem(
                  icon: Icons.bar_chart_outlined,
                  value: tasks.length,
                  label: '总计',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompletedStatItem extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;

  const _CompletedStatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.75),
          child: Icon(icon, size: 20, color: colorScheme.onPrimaryContainer),
        ),
        const SizedBox(height: 8),
        Text(
          '$value',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
