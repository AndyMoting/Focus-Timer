part of 'stats_screen.dart';

void _setRangeType(WidgetRef ref, StatsRangeType type) {
  ref.read(currentStatsRangeTypeProvider.notifier).state = type;
}

Future<void> _pickCustomRange(BuildContext context, WidgetRef ref) async {
  final current = ref.read(statsDateRangeProvider);
  final picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
    initialDateRange: DateTimeRange(start: current.start, end: current.end),
  );
  if (picked == null) return;
  ref.read(customStatsDateRangeProvider.notifier).state = picked;
  ref.read(currentStatsRangeTypeProvider.notifier).state =
      StatsRangeType.custom;
}

void _shiftRange(WidgetRef ref, StatsDateRange range, int offset) {
  if (range.type == StatsRangeType.custom) {
    final days = range.endDayNum - range.startDayNum + 1;
    final nextStart = range.start.add(Duration(days: offset * days));
    final nextEnd = range.end.add(Duration(days: offset * days));
    ref.read(customStatsDateRangeProvider.notifier).state = DateTimeRange(
      start: nextStart,
      end: nextEnd,
    );
    ref.read(currentStatsAnchorProvider.notifier).state = nextStart;
    return;
  }
  final anchor = ref.read(currentStatsAnchorProvider);
  final next = switch (range.type) {
    StatsRangeType.day => anchor.add(Duration(days: offset)),
    StatsRangeType.week => anchor.add(Duration(days: offset * 7)),
    StatsRangeType.month => DateTime(anchor.year, anchor.month + offset, 1),
    StatsRangeType.year => DateTime(anchor.year + offset, anchor.month, 1),
    StatsRangeType.custom => anchor,
  };
  ref.read(currentStatsAnchorProvider.notifier).state = DateTime(
    next.year,
    next.month,
    next.day,
  );
}
