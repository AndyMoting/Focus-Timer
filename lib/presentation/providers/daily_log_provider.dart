import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/data/repositories/daily_log_repository_impl.dart';
import 'package:focus_timer/domain/repositories/daily_log_repository.dart';
import 'package:focus_timer/presentation/providers/database_provider.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';
import 'package:focus_timer/shared/utils/date_utils.dart' as app_date;

final dailyLogRepositoryProvider = Provider<DailyLogRepository>((ref) {
  return DailyLogRepositoryImpl(ref.watch(databaseProvider));
});

class DailyLogSnapshot {
  final List<DailyLog> logs;

  const DailyLogSnapshot({required this.logs});

  DailyLog? latestWakeForDay(int dayNum) {
    return _latestForDay(dayNum, AppConstants.dailyLogWake);
  }

  DailyLog? latestSleepForDay(int dayNum) {
    return _latestForDay(dayNum, AppConstants.dailyLogSleep);
  }

  int get wakeCount =>
      logs.where((log) => log.type == AppConstants.dailyLogWake).length;

  int get sleepCount =>
      logs.where((log) => log.type == AppConstants.dailyLogSleep).length;

  DailyLog? _latestForDay(int dayNum, int type) {
    DailyLog? latest;
    for (final log in logs) {
      if (log.dayNum != dayNum || log.type != type) continue;
      if (latest == null || log.loggedAt > latest.loggedAt) latest = log;
    }
    return latest;
  }
}

typedef DailyLogRange = ({int startDayNum, int endDayNum});

final dailyLogSnapshotProvider =
    FutureProvider.family<DailyLogSnapshot, DailyLogRange>((ref, range) async {
      final repo = ref.watch(dailyLogRepositoryProvider);
      await repo.migrateLegacySleepTimerRecords();
      final logs = await repo.getLogsInRange(
        range.startDayNum,
        range.endDayNum,
      );
      return DailyLogSnapshot(logs: logs);
    });

class DailyLogNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> checkIn({
    required int type,
    DateTime? loggedAt,
    String? note,
  }) async {
    final time = loggedAt ?? DateTime.now();
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final repo = ref.read(dailyLogRepositoryProvider);
    await repo.saveLog(
      DailyLogsCompanion.insert(
        dayNum: app_date.DateUtils.calculateDayNum(time),
        type: type,
        loggedAt: time.millisecondsSinceEpoch,
        note: drift.Value(_emptyToNull(note)),
        createdAt: nowMs,
        updatedAt: nowMs,
      ),
    );
    ref.invalidate(dailyLogSnapshotProvider);
  }

  Future<void> deleteLog(int id) async {
    await ref.read(dailyLogRepositoryProvider).deleteLog(id);
    ref.invalidate(dailyLogSnapshotProvider);
  }

  Future<void> updateLog({
    required DailyLog log,
    required int type,
    required DateTime loggedAt,
    String? note,
  }) async {
    await ref
        .read(dailyLogRepositoryProvider)
        .updateLog(
          log.id,
          DailyLogsCompanion(
            dayNum: drift.Value(app_date.DateUtils.calculateDayNum(loggedAt)),
            type: drift.Value(type),
            loggedAt: drift.Value(loggedAt.millisecondsSinceEpoch),
            note: drift.Value(_emptyToNull(note)),
            updatedAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );
    ref.invalidate(dailyLogSnapshotProvider);
  }

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}

final dailyLogNotifierProvider = AsyncNotifierProvider<DailyLogNotifier, void>(
  DailyLogNotifier.new,
);
