import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/presentation/providers/database_provider.dart';
import 'package:focus_timer/presentation/providers/timer_provider.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  test('stopTimer does not save a record before a timer starts', () async {
    final notifier = container.read(timerProvider.notifier);
    await notifier.ready;

    await notifier.stopTimer();

    final rows = await db.select(db.focusTime).get();
    expect(rows, isEmpty);
  });

  test('stopping while paused excludes the current pause duration', () async {
    final notifier = container.read(timerProvider.notifier);
    await notifier.ready;

    notifier.createTimer(
      type: AppConstants.typeFreeCount,
      name: '  ',
      targetDurationMs: 0,
    );
    notifier.startTimer();
    await Future<void>.delayed(const Duration(milliseconds: 30));
    notifier.pauseTimer();
    final durationAtPause = container.read(timerProvider).focusDurationMs;
    await Future<void>.delayed(const Duration(milliseconds: 30));

    await notifier.stopTimer();

    final rows = await db.select(db.focusTime).get();
    expect(rows, hasLength(1));
    expect(rows.single.name, '自由计时');
    expect(rows.single.durationMs, lessThan(durationAtPause + 30));
  });

  test('stopTimer can discard a running record without saving', () async {
    final notifier = container.read(timerProvider.notifier);
    await notifier.ready;

    notifier.createTimer(
      type: AppConstants.typePomodoro,
      name: '番茄',
      targetDurationMs: AppConstants.defaultPomodoroMs,
    );
    notifier.startTimer();
    await Future<void>.delayed(const Duration(milliseconds: 20));

    await notifier.stopTimer(save: false);

    final rows = await db.select(db.focusTime).get();
    expect(rows, isEmpty);
    expect(container.read(timerProvider).state, AppConstants.stateStop);
  });

  test('running timer session is restored after provider rebuild', () async {
    final notifier = container.read(timerProvider.notifier);
    await notifier.ready;

    notifier.createTimer(
      type: AppConstants.typeCountdown,
      name: '恢复测试',
      targetDurationMs: 10 * 60 * 1000,
    );
    notifier.startTimer();
    await Future<void>.delayed(const Duration(milliseconds: 30));

    final storedSession = await db.select(db.activeTimerSession).getSingle();
    expect(storedSession.name, '恢复测试');
    expect(storedSession.state, AppConstants.stateFocusing);

    container.dispose();
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    await container.read(timerProvider.notifier).ready;

    final restored = container.read(timerProvider);
    expect(restored.state, AppConstants.stateFocusing);
    expect(restored.name, '恢复测试');
    expect(restored.targetDurationMs, 10 * 60 * 1000);
    expect(restored.focusDurationMs, greaterThanOrEqualTo(0));
  });

  test(
    'paused timer session persists and stop clears active session',
    () async {
      final notifier = container.read(timerProvider.notifier);
      await notifier.ready;

      notifier.createTimer(
        type: AppConstants.typeFreeCount,
        name: '暂停留存',
        targetDurationMs: 0,
      );
      notifier.startTimer();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      notifier.pauseTimer();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final pausedSession = await db.select(db.activeTimerSession).getSingle();
      expect(pausedSession.state, AppConstants.statePause);
      expect(pausedSession.pauseStartMs, isNotNull);

      await notifier.stopTimer();

      final sessions = await db.select(db.activeTimerSession).get();
      expect(sessions, isEmpty);
    },
  );

  test('rest timer is recorded but excluded from today focus total', () async {
    final notifier = container.read(timerProvider.notifier);
    await notifier.ready;

    notifier.createTimer(
      type: AppConstants.typePomoBreak,
      name: '休息',
      targetDurationMs: AppConstants.defaultBreakMs,
    );
    notifier.startTimer();
    await Future<void>.delayed(const Duration(milliseconds: 20));

    await notifier.stopTimer();

    final rows = await db.select(db.focusTime).get();
    final state = container.read(timerProvider);
    expect(rows, hasLength(1));
    expect(rows.single.type, AppConstants.typePomoBreak);
    expect(rows.single.name, '休息');
    expect(state.todayRecords, hasLength(1));
    expect(state.todayFocusDurationMs, 0);
  });

  test('rename duration update and delete refresh today data', () async {
    final notifier = container.read(timerProvider.notifier);
    await notifier.ready;

    notifier.createTimer(
      type: AppConstants.typeFreeCount,
      name: '原名称',
      targetDurationMs: 0,
    );
    notifier.startTimer();
    await Future<void>.delayed(const Duration(milliseconds: 20));
    await notifier.stopTimer();

    final created = container.read(timerProvider).todayRecords.single;
    await notifier.renameRecord(created.id, '新名称');

    var state = container.read(timerProvider);
    expect(state.todayRecords.single.name, '新名称');

    await notifier.updateRecordDuration(created.id, 5 * 60 * 1000);

    state = container.read(timerProvider);
    expect(state.todayRecords.single.durationMs, 5 * 60 * 1000);
    expect(
      state.todayRecords.single.endTime,
      state.todayRecords.single.startTime + 5 * 60 * 1000,
    );

    await notifier.deleteRecord(created.id);

    state = container.read(timerProvider);
    expect(state.todayRecords, isEmpty);
  });
}
