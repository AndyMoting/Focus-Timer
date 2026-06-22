import 'package:focus_timer/data/database/database.dart';

abstract class TimerRepository {
  Future<int> saveTimer(FocusTimeCompanion timer);
  Future<void> updateRecord(int id, FocusTimeCompanion record);
  Future<List<FocusTimeData>> getTodayRecords();
  Future<List<FocusTimeData>> getRecordsForDay(int dayNum);
  Future<List<FocusTimeData>> getRecordsInRange(int startDayNum, int endDayNum);
  Future<List<FocusTimeData>> getRecordsByTask(int taskId, {int limit = 20});
  Future<int> getTodayFocusDuration();
  Future<int> getFocusDurationForDay(int dayNum);
  Future<void> deleteRecord(int id);
  Future<ActiveTimerSessionData?> getActiveSession();
  Future<void> saveActiveSession(ActiveTimerSessionCompanion session);
  Future<void> clearActiveSession();
  Future<Map<DateTime, int>> getMonthlyHeatmap(int year, int month);
  Future<List<String>> getVisibleStatsCharts();
  Future<void> saveVisibleStatsCharts(List<String> chartIds);
}
