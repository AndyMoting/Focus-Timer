part of 'day_countdown_screen.dart';

class _DayCountdownEmptyState extends StatelessWidget {
  final ColorScheme colorScheme;
  final VoidCallback onCreate;

  const _DayCountdownEmptyState({
    required this.colorScheme,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.event_note_outlined, size: 68, color: colorScheme.outline),
        const SizedBox(height: 16),
        Text(
          '还没有日倒计时',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            '设置后会显示在待办首页，用来提醒考试、生日、交付日这类重要日期。',
            textAlign: TextAlign.center,
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: onCreate,
          icon: const Icon(Icons.add),
          label: const Text('新建'),
        ),
      ],
    );
  }
}

class _DayCountdownContent extends StatelessWidget {
  final DayCountdownState state;
  final ColorScheme colorScheme;

  const _DayCountdownContent({required this.state, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final days = state.remainingDays.abs();
    final label = _countdownLabel(state);
    final countColor = state.isPast ? colorScheme.outline : colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(
            Icons.event_available_outlined,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          state.eventName,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$days',
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: countColor,
                height: 0.9,
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '目标: ${state.targetDate!.year}/${state.targetDate!.month}/${state.targetDate!.day}',
          style: TextStyle(color: colorScheme.outline),
        ),
        const SizedBox(height: 12),
        Text(
          state.isPast ? '这个日期已经过去，可以保留作纪念，也可以右下角修改。' : '会在待办首页持续显示，方便每天扫一眼。',
          textAlign: TextAlign.center,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

String _countdownLabel(DayCountdownState state) {
  if (state.isToday) return '就是今天';
  if (state.isPast) return '天前';
  return '天后';
}
