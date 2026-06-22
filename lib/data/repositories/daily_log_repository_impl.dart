import 'package:drift/drift.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/domain/repositories/daily_log_repository.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';

class DailyLogRepositoryImpl implements DailyLogRepository {
  final AppDatabase _db;

  DailyLogRepositoryImpl(this._db);

  @override
  Future<void> migrateLegacySleepTimerRecords() async {
    await _db.transaction(() async {
      final legacyRecords = await (_db.select(
        _db.focusTime,
      )..where((t) => t.type.equals(AppConstants.typeSleep))).get();
      if (legacyRecords.isEmpty) return;

      for (final record in legacyRecords) {
        await _db
            .into(_db.dailyLogs)
            .insert(
              DailyLogsCompanion.insert(
                userId: Value(record.userId),
                dayNum: record.dayNum,
                type: _dailyLogTypeForLegacyRecord(record),
                loggedAt: record.startTime,
                note: Value(record.note),
                createdAt: record.createdAt,
                updatedAt: record.updatedAt,
              ),
            );
      }
      await (_db.delete(
        _db.focusTime,
      )..where((t) => t.type.equals(AppConstants.typeSleep))).go();
    });
  }

  @override
  Future<int> saveLog(DailyLogsCompanion log) {
    return _db.into(_db.dailyLogs).insert(log);
  }

  @override
  Future<void> updateLog(int id, DailyLogsCompanion log) async {
    await (_db.update(_db.dailyLogs)..where((t) => t.id.equals(id))).write(log);
  }

  @override
  Future<List<DailyLog>> getLogsInRange(int startDayNum, int endDayNum) {
    return (_db.select(_db.dailyLogs)
          ..where((t) => t.dayNum.isBetweenValues(startDayNum, endDayNum))
          ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)]))
        .get();
  }

  @override
  Future<DailyLog?> getLatestLogForDay(int dayNum, int type) {
    return (_db.select(_db.dailyLogs)
          ..where((t) => t.dayNum.equals(dayNum) & t.type.equals(type))
          ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  @override
  Future<void> deleteLog(int id) async {
    await (_db.delete(_db.dailyLogs)..where((t) => t.id.equals(id))).go();
  }

  int _dailyLogTypeForLegacyRecord(FocusTimeData record) {
    return record.name.contains('起床')
        ? AppConstants.dailyLogWake
        : AppConstants.dailyLogSleep;
  }
}
