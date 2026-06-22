part of 'group_list_screen.dart';

class _CountdownHomeCard extends StatelessWidget {
  final DayCountdownState state;
  final VoidCallback onTap;

  const _CountdownHomeCard({required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasCountdown = state.targetDate != null;
    final days = state.remainingDays.abs();
    final label = !hasCountdown
        ? '设置一个重要日期'
        : state.isToday
        ? '就是今天'
        : state.isPast
        ? '$days 天前'
        : '$days 天后';
    final title = hasCountdown ? state.eventName : '日倒计时';
    final subtitle = hasCountdown
        ? '目标 ${state.targetDate!.year}/${state.targetDate!.month}/${state.targetDate!.day}'
        : '会显示在待办首页，别让重要日子沉底';

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.event_outlined,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
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
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: hasCountdown ? 18 : 13,
                fontWeight: FontWeight.w900,
                color: hasCountdown
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
