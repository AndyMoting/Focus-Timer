import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/data/repositories/daily_log_repository_impl.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';

void main() {
  late AppDatabase db;
  late DailyLogRepositoryImpl repo;
  final now = DateTime.now().millisecondsSinceEpoch;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = DailyLogRepositoryImpl(db);
  });

  tearDown(() => db.close());

  test('daily logs save, query by range, and return latest by day', () async {
    await repo.saveLog(
      DailyLogsCompanion.insert(
        dayNum: 100,
        type: AppConstants.dailyLogWake,
        loggedAt: now,
        note: const Value('早起'),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await repo.saveLog(
      DailyLogsCompanion.insert(
        dayNum: 100,
        type: AppConstants.dailyLogWake,
        loggedAt: now + 1000,
        createdAt: now + 1000,
        updatedAt: now + 1000,
      ),
    );
    await repo.saveLog(
      DailyLogsCompanion.insert(
        dayNum: 101,
        type: AppConstants.dailyLogSleep,
        loggedAt: now + 2000,
        createdAt: now + 2000,
        updatedAt: now + 2000,
      ),
    );

    final logs = await repo.getLogsInRange(100, 101);
    final latestWake = await repo.getLatestLogForDay(
      100,
      AppConstants.dailyLogWake,
    );

    expect(logs, hasLength(3));
    expect(logs.map((log) => log.loggedAt), [now + 2000, now + 1000, now]);
    expect(latestWake, isNotNull);
    expect(latestWake!.loggedAt, now + 1000);
  });

  test('legacy sleep timer records migrate into daily logs', () async {
    await db
        .into(db.focusTime)
        .insert(
          FocusTimeCompanion.insert(
            dayNum: 200,
            type: AppConstants.typeSleep,
            state: AppConstants.stateStop,
            startTime: now,
            durationMs: const Value(0),
            name: '起床',
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db
        .into(db.focusTime)
        .insert(
          FocusTimeCompanion.insert(
            dayNum: 200,
            type: AppConstants.typeSleep,
            state: AppConstants.stateStop,
            startTime: now + 1000,
            durationMs: const Value(0),
            name: '睡觉',
            createdAt: now + 1000,
            updatedAt: now + 1000,
          ),
        );

    await repo.migrateLegacySleepTimerRecords();

    final focusRows = await db.select(db.focusTime).get();
    final logs = await repo.getLogsInRange(200, 200);

    expect(focusRows, isEmpty);
    expect(logs, hasLength(2));
    expect(logs.map((log) => log.type), [
      AppConstants.dailyLogSleep,
      AppConstants.dailyLogWake,
    ]);
  });

  test('daily log can be updated and deleted', () async {
    final id = await repo.saveLog(
      DailyLogsCompanion.insert(
        dayNum: 300,
        type: AppConstants.dailyLogWake,
        loggedAt: now,
        createdAt: now,
        updatedAt: now,
      ),
    );

    await repo.updateLog(
      id,
      DailyLogsCompanion(
        dayNum: const Value(301),
        type: const Value(AppConstants.dailyLogSleep),
        loggedAt: Value(now + 3000),
        note: const Value('晚睡'),
        updatedAt: Value(now + 3000),
      ),
    );

    var logs = await repo.getLogsInRange(300, 301);
    expect(logs, hasLength(1));
    expect(logs.single.dayNum, 301);
    expect(logs.single.type, AppConstants.dailyLogSleep);
    expect(logs.single.note, '晚睡');

    await repo.deleteLog(id);
    logs = await repo.getLogsInRange(300, 301);
    expect(logs, isEmpty);
  });
}
