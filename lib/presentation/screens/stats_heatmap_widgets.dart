part of 'stats_screen.dart';

class _DailyHeatmap extends StatelessWidget {
  final StatsSnapshot snapshot;
  final ColorScheme colorScheme;
  final ValueChanged<FocusTimeData> onRecordTap;
  final ValueChanged<DailyLog> onDailyLogTap;

  const _DailyHeatmap({
    required this.snapshot,
    required this.colorScheme,
    required this.onRecordTap,
    required this.onDailyLogTap,
  });

  @override
  Widget build(BuildContext context) {
    final dayCount = snapshot.range.endDayNum - snapshot.range.startDayNum + 1;
    final showLabels = dayCount <= 62;
    final columns = dayCount <= 1
        ? 1
        : dayCount <= 7
        ? 7
        : 7;

    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = showLabels ? 6.0 : 4.0;
        final cellSize = (constraints.maxWidth - gap * (columns - 1)) / columns;
        final maxMinutes = snapshot.dailyFocusMinutes.values.fold<int>(
          0,
          math.max,
        );

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dayCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: gap,
            mainAxisSpacing: gap,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final date = snapshot.range.start.add(Duration(days: index));
            final minutes = snapshot.dailyFocusMinutes[date] ?? 0;
            return _HeatDayCell(
              date: date,
              minutes: minutes,
              size: cellSize,
              color: _heatColor(minutes, maxMinutes, colorScheme),
              showLabel: showLabels,
              colorScheme: colorScheme,
              onTap: () => _showDayStatsSheet(
                context,
                snapshot,
                date,
                onRecordTap,
                onDailyLogTap,
              ),
            );
          },
        );
      },
    );
  }
}

class _HeatDayCell extends StatelessWidget {
  final DateTime date;
  final int minutes;
  final double size;
  final Color color;
  final bool showLabel;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _HeatDayCell({
    required this.date,
    required this.minutes,
    required this.size,
    required this.color,
    required this.showLabel,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasData = minutes > 0;
    final textColor = hasData ? colorScheme.onPrimary : colorScheme.onSurface;

    return Tooltip(
      message: hasData
          ? '${_formatDate(date)}，$minutes 分钟'
          : '${_formatDate(date)}，无记录',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(showLabel ? 7 : 4),
        child: InkWell(
          borderRadius: BorderRadius.circular(showLabel ? 7 : 4),
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(showLabel ? 7 : 4),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: showLabel
                ? Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: hasData ? FontWeight.w700 : FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class _HeatLegend extends StatelessWidget {
  final ColorScheme colorScheme;

  const _HeatLegend({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '少',
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(width: 8),
        ...[0, 1, 2, 3, 4].map(
          (index) => Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: index == 0
                    ? colorScheme.surfaceContainerHighest
                    : Color.lerp(
                        colorScheme.primaryContainer,
                        colorScheme.primary,
                        index / 4,
                      ),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '多',
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

Future<void> _showDayStatsSheet(
  BuildContext context,
  StatsSnapshot snapshot,
  DateTime date,
  ValueChanged<FocusTimeData> onRecordTap,
  ValueChanged<DailyLog> onDailyLogTap,
) async {
  final colorScheme = Theme.of(context).colorScheme;
  final dayNum = app_date.DateUtils.calculateDayNum(date);
  final records =
      snapshot.records.where((record) => record.dayNum == dayNum).toList()
        ..sort((a, b) => b.startTime.compareTo(a.startTime));
  final logs = snapshot.dailyLogs.where((log) => log.dayNum == dayNum).toList()
    ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
  final totalMs = records.fold<int>(
    0,
    (sum, record) => sum + _recordDurationMs(record),
  );

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _formatDate(date),
                style: Theme.of(
                  sheetContext,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      label: '专注',
                      value: _formatDurationMs(totalMs),
                      colorScheme: colorScheme,
                    ),
                  ),
                  Expanded(
                    child: _StatTile(
                      label: '记录',
                      value: '${records.length} 次',
                      colorScheme: colorScheme,
                    ),
                  ),
                  Expanded(
                    child: _StatTile(
                      label: '打卡',
                      value: '${logs.length} 条',
                      colorScheme: colorScheme,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (records.isEmpty && logs.isEmpty)
                _EmptyPanel(text: '当天暂无记录', colorScheme: colorScheme)
              else ...[
                for (final record in records)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.timer_outlined,
                      color: _typeColor(record.type, colorScheme),
                    ),
                    title: Text(record.name),
                    subtitle: Text(
                      '${_formatTime(DateTime.fromMillisecondsSinceEpoch(record.startTime))} · ${_typeLabel(record.type)}',
                    ),
                    trailing: Text(
                      _formatDurationMs(_recordDurationMs(record)),
                    ),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      onRecordTap(record);
                    },
                  ),
                for (final log in logs)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      log.type == AppConstants.dailyLogWake
                          ? Icons.wb_sunny_outlined
                          : Icons.bedtime_outlined,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      log.type == AppConstants.dailyLogWake ? '起床打卡' : '睡觉打卡',
                    ),
                    subtitle: Text(
                      _formatTime(
                        DateTime.fromMillisecondsSinceEpoch(log.loggedAt),
                      ),
                    ),
                    trailing: const Text('编辑'),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      onDailyLogTap(log);
                    },
                  ),
              ],
            ],
          ),
        ),
      );
    },
  );
}
