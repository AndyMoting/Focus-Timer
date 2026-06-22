part of 'stats_screen.dart';

class _TimelineSection extends StatelessWidget {
  final StatsSnapshot snapshot;
  final ColorScheme colorScheme;
  final ValueChanged<FocusTimeData> onRecordTap;
  final ValueChanged<DailyLog> onDailyLogTap;

  const _TimelineSection({
    required this.snapshot,
    required this.colorScheme,
    required this.onRecordTap,
    required this.onDailyLogTap,
  });

  @override
  Widget build(BuildContext context) {
    final entries = _buildTimelineEntries(snapshot);
    if (entries.isEmpty) {
      return _EmptyPanel(text: '暂无记录', colorScheme: colorScheme);
    }

    return Column(
      children: entries
          .map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: switch (entry) {
                _TimerTimelineEntry(:final record) => _TimelineTile(
                  record: record,
                  sourceLabel: snapshot.sourceLabelForRecord(record),
                  colorScheme: colorScheme,
                  onTap: () => onRecordTap(record),
                ),
                _DailyLogTimelineEntry(:final log) => _DailyLogTimelineTile(
                  log: log,
                  colorScheme: colorScheme,
                  onTap: () => onDailyLogTap(log),
                ),
              },
            ),
          )
          .toList(),
    );
  }
}

sealed class _StatsTimelineEntry {
  int get timeMs;
}

class _TimerTimelineEntry extends _StatsTimelineEntry {
  final FocusTimeData record;

  _TimerTimelineEntry(this.record);

  @override
  int get timeMs => record.startTime;
}

class _DailyLogTimelineEntry extends _StatsTimelineEntry {
  final DailyLog log;

  _DailyLogTimelineEntry(this.log);

  @override
  int get timeMs => log.loggedAt;
}

List<_StatsTimelineEntry> _buildTimelineEntries(StatsSnapshot snapshot) {
  return <_StatsTimelineEntry>[
    ...snapshot.records.map(_TimerTimelineEntry.new),
    ...snapshot.dailyLogs.map(_DailyLogTimelineEntry.new),
  ]..sort((a, b) => b.timeMs.compareTo(a.timeMs));
}

class _TimelineTile extends StatelessWidget {
  final FocusTimeData record;
  final String sourceLabel;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _TimelineTile({
    required this.record,
    required this.sourceLabel,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final start = DateTime.fromMillisecondsSinceEpoch(record.startTime);
    final end = record.endTime == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(record.endTime!);
    final typeColor = _typeColor(record.type, colorScheme);

    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 44,
                decoration: BoxDecoration(
                  color: typeColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatDate(start)} ${_formatTime(start)}'
                      '${end == null ? '' : ' - ${_formatTime(end)}'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (sourceLabel.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        sourceLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatDurationMs(_recordDurationMs(record)),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _typeLabel(record.type),
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyLogTimelineTile extends StatelessWidget {
  final DailyLog log;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _DailyLogTimelineTile({
    required this.log,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final time = DateTime.fromMillisecondsSinceEpoch(log.loggedAt);
    final isWake = log.type == AppConstants.dailyLogWake;
    final typeColor = isWake ? const Color(0xFFF2B84B) : colorScheme.tertiary;
    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 44,
                decoration: BoxDecoration(
                  color: typeColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                isWake ? Icons.wb_sunny_outlined : Icons.bedtime_outlined,
                color: typeColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isWake ? '起床打卡' : '睡觉打卡',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatDate(time)} ${_formatTime(time)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '编辑',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  final String text;
  final ColorScheme colorScheme;

  const _EmptyPanel({required this.text, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
