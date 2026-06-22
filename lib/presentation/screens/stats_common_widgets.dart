part of 'stats_screen.dart';

List<DropdownMenuItem<int>> _recordTypeMenuItems() {
  return const [
    DropdownMenuItem(value: AppConstants.typeFreeCount, child: Text('自由计时')),
    DropdownMenuItem(value: AppConstants.typePomodoro, child: Text('番茄计时')),
    DropdownMenuItem(value: AppConstants.typeCountdown, child: Text('倒计时')),
    DropdownMenuItem(value: AppConstants.typeVideoStudy, child: Text('视频打卡')),
    DropdownMenuItem(value: AppConstants.typePomoBreak, child: Text('休息')),
    DropdownMenuItem(value: AppConstants.typePomoLongBreak, child: Text('长休息')),
  ];
}

int _durationMenuValue(int minutes) {
  const presets = [5, 10, 15, 25, 30, 45, 60, 90, 120];
  return presets.contains(minutes) ? minutes : minutes.clamp(1, 24 * 60);
}

List<DropdownMenuItem<int>> _durationMenuItems(int currentMinutes) {
  final values = {
    5,
    10,
    15,
    25,
    30,
    45,
    60,
    90,
    120,
    currentMinutes,
  }.where((minutes) => minutes > 0).toList()..sort();
  return values
      .map(
        (minutes) =>
            DropdownMenuItem(value: minutes, child: Text('$minutes 分钟')),
      )
      .toList();
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colorScheme;

  const _StatTile({
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

Color _heatColor(int minutes, int maxMinutes, ColorScheme colorScheme) {
  if (minutes <= 0) return colorScheme.surfaceContainerHighest;
  final strength = maxMinutes <= 0
      ? 1.0
      : (minutes / maxMinutes).clamp(0.18, 1.0);
  return Color.lerp(
    colorScheme.primaryContainer,
    colorScheme.primary,
    strength,
  )!;
}

Color _typeColor(int type, ColorScheme colorScheme) {
  return switch (type) {
    AppConstants.typePomodoro => colorScheme.primary,
    AppConstants.typeFreeCount => const Color(0xFF00A6A6),
    AppConstants.typeCountdown => const Color(0xFFE05D5D),
    AppConstants.typePomoBreak => const Color(0xFFB88724),
    AppConstants.typePomoLongBreak => const Color(0xFFB88724),
    AppConstants.typeVideoStudy => const Color(0xFF8E6AD8),
    _ => colorScheme.secondary,
  };
}

String _typeLabel(int type) {
  return switch (type) {
    AppConstants.typePomodoro => '番茄计时',
    AppConstants.typeFreeCount => '自由计时',
    AppConstants.typeCountdown => '倒计时',
    AppConstants.typePomoBreak => '休息',
    AppConstants.typePomoLongBreak => '长休息',
    AppConstants.typeVideoStudy => '视频打卡',
    _ => '计时',
  };
}

int _recordDurationMs(FocusTimeData record) {
  if (record.durationMs > 0) return record.durationMs;
  final endTime = record.endTime;
  if (endTime == null || endTime <= record.startTime) return 0;
  return endTime - record.startTime;
}

String _formatDurationMs(int milliseconds) {
  if (milliseconds <= 0) return '0 分钟';
  if (milliseconds < 60000) return '<1 分钟';
  final duration = Duration(milliseconds: milliseconds);
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  if (hours <= 0) return '$minutes 分钟';
  if (minutes == 0) return '$hours 小时';
  return '$hours 小时 $minutes 分';
}

String _formatDate(DateTime date) {
  return '${date.year}/${date.month}/${date.day}';
}

String _formatTime(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
