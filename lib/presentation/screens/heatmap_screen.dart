import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:heatmap_calendar_plus/heatmap_calendar_plus.dart';
import 'package:focus_timer/presentation/providers/heatmap_provider.dart';
import 'package:focus_timer/shared/utils/date_utils.dart' as app_date;

class HeatmapScreen extends HookConsumerWidget {
  const HeatmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentMonth = ref.watch(currentHeatmapMonth);
    final heatmapAsync = ref.watch(heatmapDataProvider(currentMonth));

    final year = currentMonth.year;
    final month = currentMonth.month;
    final monthLabel = '$year 年 $month 月';

    return Scaffold(
      appBar: AppBar(title: const Text('专注热力图'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    ref.read(currentHeatmapMonth.notifier).state = DateTime(
                      year,
                      month - 1,
                      1,
                    );
                  },
                ),
                Text(
                  monthLabel,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    ref.read(currentHeatmapMonth.notifier).state = DateTime(
                      year,
                      month + 1,
                      1,
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: heatmapAsync.when(
              data: (data) => _buildHeatmap(context, data, colorScheme),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('加载失败')),
            ),
          ),
          _buildLegend(colorScheme),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeatmap(
    BuildContext ctx,
    Map<DateTime, int> data,
    ColorScheme colorScheme,
  ) {
    if (data.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_month, size: 64, color: colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              '暂无专注记录',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return HeatMap(
      datasets: data,
      colorMode: ColorMode.color,
      defaultColor: colorScheme.surfaceContainerHighest,
      colorsets: const {
        30: Color(0xFF9BE9A8),
        60: Color(0xFF40C463),
        120: Color(0xFF30A14E),
        180: Color(0xFF216E39),
      },
      onClick: (date) {
        final minutes = data[date];
        if (minutes != null) {
          final formatted = app_date.DateUtils.formatDuration(
            minutes * 60 * 1000,
          );
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text('${date.month}/${date.day}: $formatted'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }

  Widget _buildLegend(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _legendCell(Colors.grey.shade300, '无'),
          const SizedBox(width: 4),
          _legendCell(const Color(0xFF9BE9A8), '<30分'),
          const SizedBox(width: 4),
          _legendCell(const Color(0xFF40C463), '30-60分'),
          const SizedBox(width: 4),
          _legendCell(const Color(0xFF30A14E), '1-2时'),
          const SizedBox(width: 4),
          _legendCell(const Color(0xFF216E39), '>2时'),
        ],
      ),
    );
  }

  Widget _legendCell(Color color, String label) {
    return Tooltip(
      message: label,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
