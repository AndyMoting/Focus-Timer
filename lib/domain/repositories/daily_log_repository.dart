import 'package:focus_timer/data/database/database.dart';

abstract class DailyLogRepository {
  Future<void> migrateLegacySleepTimerRecords();
  Future<int> saveLog(DailyLogsCompanion log);
  Future<void> updateLog(int id, DailyLogsCompanion log);
  Future<List<DailyLog>> getLogsInRange(int startDayNum, int endDayNum);
  Future<DailyLog?> getLatestLogForDay(int dayNum, int type);
  Future<void> deleteLog(int id);
}
