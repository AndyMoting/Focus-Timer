import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    FocusTime,
    ActiveTimerSession,
    DailyLogs,
    TaskLists,
    Tasks,
    TaskPlans,
    TaskPlanSettings,
    StatsSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 15;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(taskLists, taskLists.color);
          await m.addColumn(taskLists, taskLists.isDeleted);
          await m.addColumn(taskLists, taskLists.isDailyReset);
          await m.addColumn(taskLists, taskLists.deletedAt);
        }
        if (from < 3) {
          await m.createTable(taskPlans);
        }
        if (from < 4) {
          await m.addColumn(taskPlans, taskPlans.startMinute);
          await m.createTable(taskPlanSettings);
        }
        if (from < 5) {
          await m.createTable(statsSettings);
        }
        if (from < 6) {
          await m.addColumn(tasks, tasks.dueDayNum);
          await m.addColumn(tasks, tasks.estimatedMinutes);
          await m.addColumn(tasks, tasks.isFocus);
        }
        if (from < 7) {
          await m.addColumn(taskLists, taskLists.iconCodePoint);
        }
        if (from < 8) {
          await m.addColumn(tasks, tasks.color);
        }
        if (from < 9) {
          await m.createTable(activeTimerSession);
        }
        if (from < 10) {
          await m.addColumn(focusTime, focusTime.note);
          await m.addColumn(focusTime, focusTime.evidenceUri);
          await m.addColumn(activeTimerSession, activeTimerSession.note);
          await m.addColumn(activeTimerSession, activeTimerSession.evidenceUri);
        }
        if (from < 11) {
          await m.addColumn(focusTime, focusTime.evidenceDisplayName);
          await m.addColumn(focusTime, focusTime.evidenceRelativePath);
          await m.addColumn(focusTime, focusTime.evidenceMimeType);
          await m.addColumn(
            activeTimerSession,
            activeTimerSession.evidenceDisplayName,
          );
          await m.addColumn(
            activeTimerSession,
            activeTimerSession.evidenceRelativePath,
          );
          await m.addColumn(
            activeTimerSession,
            activeTimerSession.evidenceMimeType,
          );
        }
        if (from < 12) {
          await m.createTable(dailyLogs);
          await customStatement('''
            INSERT INTO daily_logs (
              user_id,
              day_num,
              type,
              logged_at,
              note,
              created_at,
              updated_at
            )
            SELECT
              user_id,
              day_num,
              CASE
                WHEN name LIKE '%起床%' THEN 1
                ELSE 2
              END,
              start_time,
              note,
              created_at,
              updated_at
            FROM focus_time
            WHERE type = 9
          ''');
          await customStatement('DELETE FROM focus_time WHERE type = 9');
          await customStatement(
            '''
            UPDATE stats_settings
            SET
              visible_charts = CASE
                WHEN trim(visible_charts) = '' THEN 'heatmap,pie,dailyLog,timeline'
                WHEN instr(',' || visible_charts || ',', ',timeline,') > 0
                  THEN replace(visible_charts, 'timeline', 'dailyLog,timeline')
                ELSE visible_charts || ',dailyLog'
              END,
              updated_at = ?
            WHERE instr(',' || visible_charts || ',', ',dailyLog,') = 0
            ''',
            [DateTime.now().millisecondsSinceEpoch],
          );
        }
        if (from < 13) {
          await customStatement(
            '''
            UPDATE stats_settings
            SET
              visible_charts = CASE
                WHEN trim(visible_charts) = '' THEN 'heatmap,pie,dailyLog,timeline'
                WHEN instr(',' || visible_charts || ',', ',timeline,') > 0
                  THEN replace(visible_charts, 'timeline', 'dailyLog,timeline')
                ELSE visible_charts || ',dailyLog'
              END,
              updated_at = ?
            WHERE instr(',' || visible_charts || ',', ',dailyLog,') = 0
            ''',
            [DateTime.now().millisecondsSinceEpoch],
          );
        }
        if (from < 14) {
          await m.addColumn(tasks, tasks.isPinned);
          await m.addColumn(tasks, tasks.pinnedAt);
          await m.addColumn(tasks, tasks.reminderAt);
          await m.addColumn(tasks, tasks.repeatRule);
        }
        if (from < 15) {
          await m.addColumn(focusTime, focusTime.taskId);
          await m.addColumn(focusTime, focusTime.listId);
          await m.addColumn(focusTime, focusTime.planId);
          await m.addColumn(activeTimerSession, activeTimerSession.taskId);
          await m.addColumn(activeTimerSession, activeTimerSession.listId);
          await m.addColumn(activeTimerSession, activeTimerSession.planId);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'focus_timer.db'));
    return NativeDatabase(file);
  });
}
