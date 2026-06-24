import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/presentation/providers/daily_log_provider.dart';
import 'package:focus_timer/presentation/providers/task_provider.dart';
import 'package:focus_timer/presentation/providers/timer_provider.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';
import 'package:focus_timer/shared/utils/date_utils.dart' as app_date;

enum StatsRangeType { day, week, month, year, custom }

enum StatsChartId { heatmap, pie, dailyLog, timeline }

extension StatsChartIdKey on StatsChartId {
  String get key => switch (this) {
    StatsChartId.heatmap => 'heatmap',
    StatsChartId.pie => 'pie',
    StatsChartId.dailyLog => 'dailyLog',
    StatsChartId.timeline => 'timeline',
  };
}

class StatsDateRange {
  final StatsRangeType type;
  final DateTime anchor;
  final DateTime start;
  final DateTime end;

  const StatsDateRange({
    required this.type,
    required this.anchor,
    required this.start,
    required this.end,
  });

  int get startDayNum => app_date.DateUtils.calculateDayNum(start);
  int get endDayNum => app_date.DateUtils.calculateDayNum(end);
  int get anchorDayNum => app_date.DateUtils.calculateDayNum(anchor);
}

class StatsSnapshot {
  final StatsDateRange range;
  final List<FocusTimeData> records;
  final List<DailyLog> dailyLogs;
  final List<Task> tasks;
  final List<TaskList> taskLists;
  final List<TaskPlan> plans;

  const StatsSnapshot({
    required this.range,
    required this.records,
    required this.dailyLogs,
    required this.tasks,
    required this.taskLists,
    required this.plans,
  });

  Map<int, Task> get taskById => {for (final task in tasks) task.id: task};

  Map<int, TaskList> get listById => {
    for (final list in taskLists) list.id: list,
  };

  Map<int, TaskPlan> get planById => {for (final plan in plans) plan.id: plan};

  Map<DateTime, int> get dailyFocusMinutes {
    final result = <DateTime, int>{};
    for (final record in records.where(_isFocusType)) {
      final date = app_date.DateUtils.dateFromDayNum(record.dayNum);
      result[date] = (result[date] ?? 0) + (_durationMs(record) ~/ 60000);
    }
    return result;
  }

  int get totalFocusMs => records
      .where(_isFocusType)
      .fold<int>(0, (sum, record) => sum + _durationMs(record));

  int get focusRecordCount => records.where(_isFocusType).length;

  List<FocusTimeData> get linkedFocusRecords => records
      .where(_isFocusType)
      .where(
        (record) =>
            record.taskId != null ||
            record.listId != null ||
            record.planId != null,
      )
      .toList();

  int get linkedFocusMs => linkedFocusRecords.fold<int>(
    0,
    (sum, record) => sum + _durationMs(record),
  );

  int get linkedTaskCount => {
    for (final record in linkedFocusRecords)
      if (record.taskId != null) record.taskId!,
  }.length;

  int get plannedLinkedRecordCount =>
      linkedFocusRecords.where((record) => record.planId != null).length;

  List<FocusTimeData> get planHitRecords {
    final result = <FocusTimeData>[];
    for (final record in linkedFocusRecords) {
      if (_recordHitsPlan(record)) result.add(record);
    }
    return result;
  }

  int get planHitRecordCount => planHitRecords.length;

  int get plannedFocusRecordCount {
    final plannedTaskIds = {for (final plan in plans) plan.taskId};
    return linkedFocusRecords
        .where(
          (record) =>
              record.planId != null ||
              (record.taskId != null && plannedTaskIds.contains(record.taskId)),
        )
        .length;
  }

  double get planHitRate {
    final total = plannedFocusRecordCount;
    if (total <= 0) return 0;
    return planHitRecordCount / total;
  }

  int get completedTaskCountInRange {
    final startMs = range.start.millisecondsSinceEpoch;
    final endMs = range.end.add(const Duration(days: 1)).millisecondsSinceEpoch;
    return tasks
        .where(
          (task) =>
              task.completedAt != null &&
              task.completedAt! >= startMs &&
              task.completedAt! < endMs,
        )
        .length;
  }

  int get taskCountInRange => tasks
      .where(
        (task) =>
            task.dayNum >= range.startDayNum && task.dayNum <= range.endDayNum,
      )
      .length;

  double get completionRate {
    final total = taskCountInRange;
    if (total <= 0) return 0;
    return completedTaskCountInRange / total;
  }

  int get overdueTaskCount {
    final today = app_date.DateUtils.todayDayNum;
    return tasks
        .where(
          (task) =>
              task.state != AppConstants.taskStateCompleted &&
              task.dueDayNum != null &&
              task.dueDayNum! < today,
        )
        .length;
  }

  int get focusTaskCompletedCountInRange {
    final startMs = range.start.millisecondsSinceEpoch;
    final endMs = range.end.add(const Duration(days: 1)).millisecondsSinceEpoch;
    return tasks
        .where(
          (task) =>
              task.isFocus == 1 &&
              task.completedAt != null &&
              task.completedAt! >= startMs &&
              task.completedAt! < endMs,
        )
        .length;
  }

  int get estimatedTaskMs {
    return tasks
            .where(
              (task) =>
                  task.dayNum >= range.startDayNum &&
                  task.dayNum <= range.endDayNum,
            )
            .fold<int>(
              0,
              (sum, task) =>
                  sum + task.estimatedMinutes.clamp(0, 24 * 60).toInt(),
            ) *
        60000;
  }

  int get linkedEstimatedTaskMs {
    final linkedTaskIds = {
      for (final record in linkedFocusRecords)
        if (record.taskId != null) record.taskId!,
    };
    return tasks
            .where((task) => linkedTaskIds.contains(task.id))
            .fold<int>(
              0,
              (sum, task) =>
                  sum + task.estimatedMinutes.clamp(0, 24 * 60).toInt(),
            ) *
        60000;
  }

  Map<String, int> get durationByTaskName {
    final result = <String, int>{};
    for (final record in linkedFocusRecords) {
      final name = taskNameForRecord(record);
      result[name] = (result[name] ?? 0) + _durationMs(record);
    }
    return _sortedDurationMap(result);
  }

  Map<String, int> get durationByListName {
    final result = <String, int>{};
    for (final record in linkedFocusRecords) {
      final name = listNameForRecord(record);
      result[name] = (result[name] ?? 0) + _durationMs(record);
    }
    return _sortedDurationMap(result);
  }

  String taskNameForRecord(FocusTimeData record) {
    final taskId = record.taskId;
    if (taskId == null) return record.name;
    return taskById[taskId]?.title ?? record.name;
  }

  String listNameForRecord(FocusTimeData record) {
    final listId = record.listId ?? taskById[record.taskId]?.listId;
    if (listId == null) return '未分组';
    return listById[listId]?.name ?? '已删除分组';
  }

  String sourceLabelForRecord(FocusTimeData record) {
    final parts = <String>[];
    if (record.taskId != null) parts.add(taskNameForRecord(record));
    final listName = listNameForRecord(record);
    if (record.listId != null || record.taskId != null) parts.add(listName);
    if (record.planId != null) parts.add('计划 #${record.planId}');
    return parts.isEmpty ? '' : parts.join(' · ');
  }

  int get activeDays => dailyFocusMinutes.values.where((m) => m > 0).length;

  int get averageDailyFocusMs {
    final dayCount = range.endDayNum - range.startDayNum + 1;
    if (dayCount <= 0) return 0;
    return totalFocusMs ~/ dayCount;
  }

  Map<int, int> get durationByType {
    final result = <int, int>{};
    for (final record in records) {
      result[record.type] = (result[record.type] ?? 0) + _durationMs(record);
    }
    return result;
  }

  DailyLog? get anchorWakeLog {
    return _latestDailyLogForDay(range.anchorDayNum, AppConstants.dailyLogWake);
  }

  DailyLog? get anchorSleepLog {
    return _latestDailyLogForDay(
      range.anchorDayNum,
      AppConstants.dailyLogSleep,
    );
  }

  int get wakeLogCount =>
      dailyLogs.where((log) => log.type == AppConstants.dailyLogWake).length;

  int get sleepLogCount =>
      dailyLogs.where((log) => log.type == AppConstants.dailyLogSleep).length;

  int get dailyLogActiveDays =>
      {for (final log in dailyLogs) log.dayNum}.length;

  DailyLog? _latestDailyLogForDay(int dayNum, int type) {
    DailyLog? latest;
    for (final log in dailyLogs) {
      if (log.dayNum != dayNum || log.type != type) continue;
      if (latest == null || log.loggedAt > latest.loggedAt) latest = log;
    }
    return latest;
  }

  bool _recordHitsPlan(FocusTimeData record) {
    if (record.planId != null && planById.containsKey(record.planId)) {
      return true;
    }
    final taskId = record.taskId;
    if (taskId == null) return false;
    final start = DateTime.fromMillisecondsSinceEpoch(record.startTime);
    final startMinute = start.hour * 60 + start.minute;
    for (final plan in plans) {
      if (plan.taskId != taskId || plan.dayNum != record.dayNum) continue;
      final planStart = plan.startMinute ?? plan.startHour * 60;
      final planEnd = planStart + plan.durationMinutes;
      if (startMinute >= planStart && startMinute < planEnd) return true;
    }
    return false;
  }

  Map<String, int> _sortedDurationMap(Map<String, int> source) {
    final entries = source.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return {for (final entry in entries) entry.key: entry.value};
  }
}

final currentStatsRangeTypeProvider = StateProvider<StatsRangeType>(
  (ref) => StatsRangeType.month,
);

final currentStatsAnchorProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final customStatsDateRangeProvider = StateProvider<DateTimeRange?>((ref) {
  return null;
});

final visibleStatsChartsProvider =
    AsyncNotifierProvider<VisibleStatsChartsNotifier, List<StatsChartId>>(
      VisibleStatsChartsNotifier.new,
    );

class VisibleStatsChartsNotifier extends AsyncNotifier<List<StatsChartId>> {
  @override
  Future<List<StatsChartId>> build() async {
    final repo = ref.watch(timerRepositoryProvider);
    final keys = await repo.getVisibleStatsCharts();
    final charts = <StatsChartId>[];
    for (final key in keys) {
      final chart = StatsChartId.values
          .where((chart) => chart.key == key)
          .firstOrNull;
      if (chart != null && !charts.contains(chart)) {
        charts.add(chart);
      }
    }
    if (charts.isEmpty) {
      return [
        StatsChartId.heatmap,
        StatsChartId.pie,
        StatsChartId.dailyLog,
        StatsChartId.timeline,
      ];
    }
    return charts;
  }

  Future<void> save(List<StatsChartId> charts) async {
    final ordered = <StatsChartId>[];
    for (final chart in charts) {
      if (!ordered.contains(chart)) ordered.add(chart);
    }
    state = AsyncData(ordered);
    final repo = ref.read(timerRepositoryProvider);
    await repo.saveVisibleStatsCharts(
      ordered.map((chart) => chart.key).toList(),
    );
  }
}

final statsDateRangeProvider = Provider<StatsDateRange>((ref) {
  final type = ref.watch(currentStatsRangeTypeProvider);
  final anchor = ref.watch(currentStatsAnchorProvider);
  final date = DateTime(anchor.year, anchor.month, anchor.day);

  switch (type) {
    case StatsRangeType.custom:
      final custom = ref.watch(customStatsDateRangeProvider);
      if (custom == null) {
        return StatsDateRange(type: type, anchor: date, start: date, end: date);
      }
      final start = DateTime(
        custom.start.year,
        custom.start.month,
        custom.start.day,
      );
      final end = DateTime(custom.end.year, custom.end.month, custom.end.day);
      return StatsDateRange(type: type, anchor: date, start: start, end: end);
    case StatsRangeType.day:
      return StatsDateRange(type: type, anchor: date, start: date, end: date);
    case StatsRangeType.week:
      final start = date.subtract(Duration(days: date.weekday - 1));
      final end = start.add(const Duration(days: 6));
      return StatsDateRange(type: type, anchor: date, start: start, end: end);
    case StatsRangeType.month:
      final start = DateTime(date.year, date.month, 1);
      final end = DateTime(date.year, date.month + 1, 0);
      return StatsDateRange(type: type, anchor: date, start: start, end: end);
    case StatsRangeType.year:
      final start = DateTime(date.year, 1, 1);
      final end = DateTime(date.year, 12, 31);
      return StatsDateRange(type: type, anchor: date, start: start, end: end);
  }
});

final statsSnapshotProvider = FutureProvider<StatsSnapshot>((ref) async {
  ref.watch(timerRecordsRevisionProvider);
  final range = ref.watch(statsDateRangeProvider);
  final repo = ref.watch(timerRepositoryProvider);
  final taskRepo = ref.watch(taskRepositoryProvider);
  final records = await repo.getRecordsInRange(
    range.startDayNum,
    range.endDayNum,
  );
  final tasks = await taskRepo.getTasksByActiveLists();
  final taskLists = await taskRepo.getActiveLists();
  final plans = <TaskPlan>[];
  for (var dayNum = range.startDayNum; dayNum <= range.endDayNum; dayNum++) {
    plans.addAll(await taskRepo.getPlansByDay(dayNum));
  }
  final dailyLogs = await ref.watch(
    dailyLogSnapshotProvider((
      startDayNum: range.startDayNum,
      endDayNum: range.endDayNum,
    )).future,
  );
  return StatsSnapshot(
    range: range,
    records: records,
    dailyLogs: dailyLogs.logs,
    tasks: tasks,
    taskLists: taskLists,
    plans: plans,
  );
});

final currentHeatmapMonth = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
});

final heatmapDataProvider = FutureProvider.family<Map<DateTime, int>, DateTime>(
  (ref, month) async {
    ref.watch(timerRecordsRevisionProvider);
    final repo = ref.watch(timerRepositoryProvider);
    return repo.getMonthlyHeatmap(month.year, month.month);
  },
);

bool _isFocusType(FocusTimeData record) {
  return record.type != 4 && record.type != 5 && record.type != 9;
}

int _durationMs(FocusTimeData record) {
  if (record.durationMs > 0) return record.durationMs;
  final endTime = record.endTime;
  if (endTime == null || endTime <= record.startTime) return 0;
  return endTime - record.startTime;
}
