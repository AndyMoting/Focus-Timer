import 'dart:math' as math;

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/presentation/providers/daily_log_provider.dart';
import 'package:focus_timer/presentation/providers/heatmap_provider.dart';
import 'package:focus_timer/presentation/providers/timer_provider.dart';
import 'package:focus_timer/presentation/screens/app_time_picker_sheet.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';
import 'package:focus_timer/shared/services/background_timer_service.dart';
import 'package:focus_timer/shared/utils/date_utils.dart' as app_date;

part 'stats_layout_widgets.dart';
part 'stats_heatmap_widgets.dart';
part 'stats_pie_widgets.dart';
part 'stats_timeline_widgets.dart';
part 'stats_common_widgets.dart';
part 'stats_range_actions.dart';
part 'stats_manual_entry_sheet.dart';
part 'stats_record_manager_sheet.dart';
part 'stats_record_manager_fields.dart';
part 'stats_record_actions.dart';
part 'stats_chart_manager_sheet.dart';
part 'stats_daily_log_sheet.dart';

class StatsScreen extends HookConsumerWidget {
  final String title;

  const StatsScreen({super.key, this.title = '统计'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final snapshotAsync = ref.watch(statsSnapshotProvider);
    final visibleChartsAsync = ref.watch(visibleStatsChartsProvider);
    final visibleCharts =
        visibleChartsAsync.valueOrNull ??
        [
          StatsChartId.heatmap,
          StatsChartId.pie,
          StatsChartId.dailyLog,
          StatsChartId.timeline,
        ];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: '补录',
            icon: const Icon(Icons.edit_calendar_outlined),
            onPressed: () => _showManualEntrySheet(context, ref),
          ),
          IconButton(
            tooltip: '图表管理',
            icon: const Icon(Icons.tune),
            onPressed: () => _showChartManager(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: snapshotAsync.when(
          data: (snapshot) => Stack(
            children: [
              _StatsContent(
                snapshot: snapshot,
                visibleCharts: visibleCharts,
                colorScheme: colorScheme,
                onPreviousRange: () => _shiftRange(ref, snapshot.range, -1),
                onNextRange: () => _shiftRange(ref, snapshot.range, 1),
                onManualEntry: () => _showManualEntrySheet(context, ref),
                onDailyCheckIn: (type) => _checkInDailyLog(context, ref, type),
                onRecordTap: (record) =>
                    _showManualEntrySheet(context, ref, record: record),
                onDailyLogTap: (log) => _showDailyLogSheet(context, ref, log),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: _FloatingRangeControl(
                  selected: snapshot.range.type,
                  colorScheme: colorScheme,
                  onChanged: (type) => _setRangeType(ref, type),
                  onCustomRange: () => _pickCustomRange(context, ref),
                  onPrevious: () => _shiftRange(ref, snapshot.range, -1),
                  onNext: () => _shiftRange(ref, snapshot.range, 1),
                ),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(
              '统计加载失败',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _checkInDailyLog(
  BuildContext context,
  WidgetRef ref,
  int type,
) async {
  await ref.read(dailyLogNotifierProvider.notifier).checkIn(type: type);
  ref.invalidate(statsSnapshotProvider);
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(type == AppConstants.dailyLogWake ? '已记录起床' : '已记录睡觉'),
    ),
  );
}
