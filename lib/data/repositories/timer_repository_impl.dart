import 'package:drift/drift.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/domain/repositories/timer_repository.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';
import 'package:focus_timer/shared/utils/date_utils.dart' as app_date;

class TimerRepositoryImpl implements TimerRepository {
  final AppDatabase _db;

  TimerRepositoryImpl(this._db);

  @override
  Future<int> saveTimer(FocusTimeCompanion timer) async {
    return await _db.into(_db.focusTime).insert(timer);
  }

  @override
  Future<void> updateRecord(int id, FocusTimeCompanion record) async {
    await (_db.update(
      _db.focusTime,
    )..where((t) => t.id.equals(id))).write(record);
  }

  @override
  Future<List<FocusTimeData>> getTodayRecords() async {
    return getRecordsForDay(app_date.DateUtils.todayDayNum);
  }

  @override
  Future<List<FocusTimeData>> getRecordsForDay(int dayNum) async {
    return await (_db.select(_db.focusTime)
          ..where((t) => t.dayNum.equals(dayNum))
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
        .get();
  }

  @override
  Future<List<FocusTimeData>> getRecordsInRange(
    int startDayNum,
    int endDayNum,
  ) async {
    return await (_db.select(_db.focusTime)
          ..where((t) => t.dayNum.isBetweenValues(startDayNum, endDayNum))
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
        .get();
  }

  @override
  Future<List<FocusTimeData>> getRecordsByTask(
    int taskId, {
    int limit = 20,
  }) async {
    return await (_db.select(_db.focusTime)
          ..where((t) => t.taskId.equals(taskId))
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
          ..limit(limit))
        .get();
  }

  @override
  Future<int> getTodayFocusDuration() async {
    return getFocusDurationForDay(app_date.DateUtils.todayDayNum);
  }

  @override
  Future<int> getFocusDurationForDay(int dayNum) async {
    final query = _db.selectOnly(_db.focusTime)
      ..addColumns([_db.focusTime.durationMs.sum()])
      ..where(
        _db.focusTime.dayNum.equals(dayNum) &
            _db.focusTime.type.isNotIn([
              AppConstants.typePomoBreak,
              AppConstants.typePomoLongBreak,
              AppConstants.typeSleep,
            ]),
      );

    final result = await query.getSingle();
    return result.read(_db.focusTime.durationMs.sum()) ?? 0;
  }

  @override
  Future<void> deleteRecord(int id) async {
    await (_db.delete(_db.focusTime)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<ActiveTimerSessionData?> getActiveSession() async {
    return await (_db.select(
      _db.activeTimerSession,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
  }

  @override
  Future<void> saveActiveSession(ActiveTimerSessionCompanion session) async {
    await _db.into(_db.activeTimerSession).insertOnConflictUpdate(session);
  }

  @override
  Future<void> clearActiveSession() async {
    await (_db.delete(
      _db.activeTimerSession,
    )..where((t) => t.id.equals(1))).go();
  }

  @override
  Future<List<String>> getVisibleStatsCharts() async {
    final row = await (_db.select(
      _db.statsSettings,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    final raw = row?.visibleCharts.trim();
    if (raw == null || raw.isEmpty) {
      return ['heatmap', 'pie', 'dailyLog', 'timeline'];
    }
    return raw
        .split(',')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();
  }

  @override
  Future<void> saveVisibleStatsCharts(List<String> chartIds) async {
    final normalized = <String>[];
    for (final chartId in chartIds) {
      if (chartId.trim().isEmpty || normalized.contains(chartId)) continue;
      normalized.add(chartId);
    }
    await _db
        .into(_db.statsSettings)
        .insertOnConflictUpdate(
          StatsSettingsCompanion.insert(
            visibleCharts: Value(normalized.join(',')),
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
  }

  @override
  Future<Map<DateTime, int>> getMonthlyHeatmap(int year, int month) async {
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);
    final startDayNum = app_date.DateUtils.calculateDayNum(firstDay);
    final endDayNum = app_date.DateUtils.calculateDayNum(lastDay);

    final query = _db.selectOnly(_db.focusTime)
      ..addColumns([_db.focusTime.dayNum, _db.focusTime.durationMs.sum()])
      ..where(
        _db.focusTime.dayNum.isBetweenValues(startDayNum, endDayNum) &
            _db.focusTime.type.isNotIn([
              AppConstants.typePomoBreak,
              AppConstants.typePomoLongBreak,
              AppConstants.typeSleep,
            ]),
      )
      ..groupBy([_db.focusTime.dayNum]);

    final rows = await query.get();
    final result = <DateTime, int>{};

    for (final row in rows) {
      final dayNum = row.read(_db.focusTime.dayNum);
      final totalMs = row.read(_db.focusTime.durationMs.sum()) ?? 0;
      if (dayNum != null && totalMs > 0) {
        final date = app_date.DateUtils.dateFromDayNum(dayNum);
        result[date] = totalMs ~/ 60000; // 转换为分钟
      }
    }

    return result;
  }
}
