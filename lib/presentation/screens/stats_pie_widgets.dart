part of 'stats_screen.dart';

class _PieSection extends StatelessWidget {
  final StatsSnapshot snapshot;
  final ColorScheme colorScheme;

  const _PieSection({required this.snapshot, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final slices = _buildSlices(snapshot.durationByType, colorScheme);
    final totalMs = slices.fold<int>(0, (sum, slice) => sum + slice.durationMs);

    if (totalMs <= 0) {
      return _EmptyPanel(text: '暂无记录', colorScheme: colorScheme);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 420;
          final chart = SizedBox(
            width: isWide ? 160 : 132,
            height: isWide ? 160 : 132,
            child: CustomPaint(
              painter: _PieChartPainter(
                slices: slices,
                totalMs: totalMs,
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
              child: Center(
                child: Text(
                  _formatDurationMs(totalMs),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          );
          final legend = Column(
            children: slices
                .map(
                  (slice) => _PieLegendRow(
                    slice: slice,
                    totalMs: totalMs,
                    colorScheme: colorScheme,
                    onTap: () =>
                        _showTypeStatsSheet(context, snapshot, slice.type),
                  ),
                )
                .toList(),
          );

          if (isWide) {
            return Row(
              children: [
                chart,
                const SizedBox(width: 18),
                Expanded(child: legend),
              ],
            );
          }
          return Column(children: [chart, const SizedBox(height: 14), legend]);
        },
      ),
    );
  }

  List<_PieSlice> _buildSlices(Map<int, int> source, ColorScheme colorScheme) {
    final colors = [
      colorScheme.primary,
      const Color(0xFF00A6A6),
      const Color(0xFFE05D5D),
      const Color(0xFF8E6AD8),
      const Color(0xFFB88724),
      colorScheme.tertiary,
    ];
    final entries = source.entries.where((entry) => entry.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return [
      for (var i = 0; i < entries.length; i++)
        _PieSlice(
          type: entries[i].key,
          label: _typeLabel(entries[i].key),
          durationMs: entries[i].value,
          color: colors[i % colors.length],
        ),
    ];
  }
}

class _PieSlice {
  final int type;
  final String label;
  final int durationMs;
  final Color color;

  const _PieSlice({
    required this.type,
    required this.label,
    required this.durationMs,
    required this.color,
  });
}

class _PieChartPainter extends CustomPainter {
  final List<_PieSlice> slices;
  final int totalMs;
  final Color backgroundColor;

  const _PieChartPainter({
    required this.slices,
    required this.totalMs,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final strokeWidth = size.shortestSide * 0.18;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    paint.color = backgroundColor;
    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      -math.pi / 2,
      math.pi * 2,
      false,
      paint,
    );

    var start = -math.pi / 2;
    for (final slice in slices) {
      final sweep = math.pi * 2 * (slice.durationMs / totalMs);
      paint.color = slice.color;
      canvas.drawArc(rect.deflate(strokeWidth / 2), start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    return oldDelegate.slices != slices ||
        oldDelegate.totalMs != totalMs ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

class _PieLegendRow extends StatelessWidget {
  final _PieSlice slice;
  final int totalMs;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _PieLegendRow({
    required this.slice,
    required this.totalMs,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final percent = totalMs <= 0 ? 0 : slice.durationMs / totalMs * 100;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: slice.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  slice.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Text(
                '${percent.toStringAsFixed(0)}% · ${_formatDurationMs(slice.durationMs)}',
                style: TextStyle(
                  fontSize: 12,
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

Future<void> _showTypeStatsSheet(
  BuildContext context,
  StatsSnapshot snapshot,
  int type,
) async {
  final colorScheme = Theme.of(context).colorScheme;
  final records =
      snapshot.records.where((record) => record.type == type).toList()
        ..sort((a, b) => b.startTime.compareTo(a.startTime));
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
                _typeLabel(type),
                style: Theme.of(
                  sheetContext,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                '${records.length} 次 · ${_formatDurationMs(totalMs)}',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              if (records.isEmpty)
                _EmptyPanel(text: '暂无记录', colorScheme: colorScheme)
              else
                for (final record in records)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.timer_outlined,
                      color: _typeColor(record.type, colorScheme),
                    ),
                    title: Text(record.name),
                    subtitle: Text(
                      '${_formatDate(DateTime.fromMillisecondsSinceEpoch(record.startTime))} ${_formatTime(DateTime.fromMillisecondsSinceEpoch(record.startTime))}',
                    ),
                    trailing: Text(
                      _formatDurationMs(_recordDurationMs(record)),
                    ),
                  ),
            ],
          ),
        ),
      );
    },
  );
}
