import 'dart:async';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/data/repositories/timer_repository_impl.dart';
import 'package:focus_timer/domain/models/timer_settings.dart';
import 'package:focus_timer/domain/repositories/timer_repository.dart';
import 'package:focus_timer/presentation/providers/database_provider.dart';
import 'package:focus_timer/presentation/providers/task_provider.dart';
import 'package:focus_timer/presentation/providers/timer_settings_provider.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';
import 'package:focus_timer/shared/services/background_timer_service.dart';
import 'package:focus_timer/shared/services/notification_service.dart';
import 'package:focus_timer/shared/utils/date_utils.dart' as app_date;

final timerRepositoryProvider = Provider<TimerRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return TimerRepositoryImpl(db);
});

final timerRecordsRevisionProvider = StateProvider<int>((ref) => 0);

class TimerState {
  final int? currentId;
  final int type;
  final String name;
  final int startTimeMs;
  final int? pauseStartMs;
  final int pauseTotalMs;
  final int targetDurationMs;
  final int state;
  final String? note;
  final int? taskId;
  final int? listId;
  final int? planId;
  final String? evidenceUri;
  final String? evidenceDisplayName;
  final String? evidenceRelativePath;
  final String? evidenceMimeType;
  final List<FocusTimeData> todayRecords;
  final int todayFocusDurationMs;
  final int tickMs;

  const TimerState({
    this.currentId,
    required this.type,
    required this.name,
    required this.startTimeMs,
    this.pauseStartMs,
    required this.pauseTotalMs,
    required this.targetDurationMs,
    required this.state,
    this.note,
    this.taskId,
    this.listId,
    this.planId,
    this.evidenceUri,
    this.evidenceDisplayName,
    this.evidenceRelativePath,
    this.evidenceMimeType,
    this.todayRecords = const [],
    this.todayFocusDurationMs = 0,
    this.tickMs = 0,
  });

  factory TimerState.initial() {
    return TimerState(
      type: AppConstants.typeFreeCount,
      name: '自由计时',
      startTimeMs: 0,
      pauseTotalMs: 0,
      targetDurationMs: 0,
      state: AppConstants.stateStop,
    );
  }

  int get elapsedMs {
    if (startTimeMs == 0) return 0;
    final nowMs = state == AppConstants.statePause && pauseStartMs != null
        ? pauseStartMs!
        : DateTime.now().millisecondsSinceEpoch;
    return (nowMs - startTimeMs).clamp(0, 1 << 62);
  }

  int get focusDurationMs => (elapsedMs - pauseTotalMs).clamp(0, 1 << 62);

  int get remainingMs {
    if (targetDurationMs <= 0) return 0;
    return (targetDurationMs - focusDurationMs).clamp(0, targetDurationMs);
  }

  double get progress {
    if (targetDurationMs <= 0) return 0.0;
    return (focusDurationMs / targetDurationMs).clamp(0.0, 1.0);
  }

  bool get isCompleted =>
      targetDurationMs > 0 && focusDurationMs >= targetDurationMs;

  String get formattedElapsed =>
      app_date.DateUtils.formatDuration(focusDurationMs);

  String get formattedRemaining =>
      app_date.DateUtils.formatDuration(remainingMs);

  TimerState copyWith({
    int? currentId,
    int? type,
    String? name,
    int? startTimeMs,
    int? pauseStartMs,
    int? pauseTotalMs,
    int? targetDurationMs,
    int? state,
    String? note,
    int? taskId,
    int? listId,
    int? planId,
    String? evidenceUri,
    String? evidenceDisplayName,
    String? evidenceRelativePath,
    String? evidenceMimeType,
    List<FocusTimeData>? todayRecords,
    int? todayFocusDurationMs,
    int? tickMs,
    bool clearPauseStart = false,
    bool clearNote = false,
    bool clearTaskLink = false,
    bool clearEvidenceUri = false,
    bool clearEvidenceMetadata = false,
  }) {
    return TimerState(
      currentId: currentId ?? this.currentId,
      type: type ?? this.type,
      name: name ?? this.name,
      startTimeMs: startTimeMs ?? this.startTimeMs,
      pauseStartMs: clearPauseStart
          ? null
          : (pauseStartMs ?? this.pauseStartMs),
      pauseTotalMs: pauseTotalMs ?? this.pauseTotalMs,
      targetDurationMs: targetDurationMs ?? this.targetDurationMs,
      state: state ?? this.state,
      note: clearNote ? null : (note ?? this.note),
      taskId: clearTaskLink ? null : (taskId ?? this.taskId),
      listId: clearTaskLink ? null : (listId ?? this.listId),
      planId: clearTaskLink ? null : (planId ?? this.planId),
      evidenceUri: clearEvidenceUri ? null : (evidenceUri ?? this.evidenceUri),
      evidenceDisplayName: clearEvidenceMetadata
          ? null
          : (evidenceDisplayName ?? this.evidenceDisplayName),
      evidenceRelativePath: clearEvidenceMetadata
          ? null
          : (evidenceRelativePath ?? this.evidenceRelativePath),
      evidenceMimeType: clearEvidenceMetadata
          ? null
          : (evidenceMimeType ?? this.evidenceMimeType),
      todayRecords: todayRecords ?? this.todayRecords,
      todayFocusDurationMs: todayFocusDurationMs ?? this.todayFocusDurationMs,
      tickMs: tickMs ?? this.tickMs,
    );
  }
}

class TimerNotifier extends StateNotifier<TimerState> {
  final TimerRepository _repository;
  final Ref _ref;
  late final Future<void> ready;
  Timer? _timer;
  bool _isStopping = false;
  bool _isRestoring = false;
  bool _earlyReminderSent = false;

  TimerNotifier(this._repository, this._ref) : super(TimerState.initial()) {
    ready = _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _loadTodayData();
      if (!mounted) return;
      await _restoreActiveSession();
    } catch (_) {
      if (mounted) rethrow;
    }
  }

  Future<void> _loadTodayData() async {
    final settings = await _readTimerSettings();
    final dayNum = app_date.DateUtils.todayDayNumWithStartMinute(
      settings.dayStartMinute,
    );
    final records = await _repository.getRecordsForDay(dayNum);
    if (!mounted) return;
    final duration = await _repository.getFocusDurationForDay(dayNum);
    if (!mounted) return;
    state = state.copyWith(
      todayRecords: records,
      todayFocusDurationMs: duration,
    );
  }

  Future<void> _restoreActiveSession() async {
    final session = await _repository.getActiveSession();
    if (!mounted || session == null) return;
    if (session.state == AppConstants.stateStop || session.startTimeMs <= 0) {
      await _repository.clearActiveSession();
      return;
    }

    _isRestoring = true;
    _earlyReminderSent = false;
    state = state.copyWith(
      type: session.type,
      name: session.name,
      startTimeMs: session.startTimeMs,
      pauseStartMs: session.pauseStartMs,
      pauseTotalMs: session.pauseTotalMs,
      targetDurationMs: session.targetDurationMs,
      state: session.state,
      note: session.note,
      taskId: session.taskId,
      listId: session.listId,
      planId: session.planId,
      evidenceUri: session.evidenceUri,
      evidenceDisplayName: session.evidenceDisplayName,
      evidenceRelativePath: session.evidenceRelativePath,
      evidenceMimeType: session.evidenceMimeType,
      tickMs: DateTime.now().millisecondsSinceEpoch,
    );
    _isRestoring = false;

    if (state.isCompleted) {
      await stopTimer();
      return;
    }

    if (state.state == AppConstants.stateFocusing) {
      _startPeriodicTimer();
      _startBackgroundService();
    }
  }

  Future<void> refreshTodayData() async {
    await _loadTodayData();
  }

  Future<void> renameRecord(int id, String name) async {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) return;
    await _repository.updateRecord(
      id,
      FocusTimeCompanion(
        name: drift.Value(normalizedName),
        updatedAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
    await _loadTodayData();
    _markTimerRecordsChanged();
  }

  Future<void> updateRecordDuration(int id, int durationMs) async {
    if (durationMs <= 0) return;
    final record = state.todayRecords
        .where((item) => item.id == id)
        .firstOrNull;
    final endTime = record == null ? null : record.startTime + durationMs;
    await _repository.updateRecord(
      id,
      FocusTimeCompanion(
        endTime: drift.Value(endTime),
        durationMs: drift.Value(durationMs),
        scheduledTime: drift.Value(record?.scheduledTime),
        updatedAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
    await _loadTodayData();
    _markTimerRecordsChanged();
  }

  Future<void> updateRecordDetails({
    required int id,
    required String name,
    required int type,
    required int startTime,
    required int durationMs,
    String? note,
    int? taskId,
    int? listId,
    int? planId,
    String? evidenceUri,
    String? evidenceDisplayName,
    String? evidenceRelativePath,
    String? evidenceMimeType,
  }) async {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty || durationMs <= 0) return;
    final settings = await _readTimerSettings();
    final dayNum = app_date.DateUtils.calculateDayNum(
      DateTime.fromMillisecondsSinceEpoch(startTime),
      dayStartMinute: settings.dayStartMinute,
    );
    await _repository.updateRecord(
      id,
      FocusTimeCompanion(
        dayNum: drift.Value(dayNum),
        type: drift.Value(type),
        state: const drift.Value(AppConstants.stateStop),
        startTime: drift.Value(startTime),
        endTime: drift.Value(startTime + durationMs),
        durationMs: drift.Value(durationMs),
        scheduledTime: drift.Value(durationMs),
        name: drift.Value(normalizedName),
        note: drift.Value(_emptyToNull(note)),
        taskId: drift.Value(taskId),
        listId: drift.Value(listId),
        planId: drift.Value(planId),
        evidenceUri: drift.Value(_emptyToNull(evidenceUri)),
        evidenceDisplayName: drift.Value(_emptyToNull(evidenceDisplayName)),
        evidenceRelativePath: drift.Value(_emptyToNull(evidenceRelativePath)),
        evidenceMimeType: drift.Value(_emptyToNull(evidenceMimeType)),
        updatedAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
    await _loadTodayData();
    _markTimerRecordsChanged();
  }

  Future<void> deleteRecord(int id) async {
    await _repository.deleteRecord(id);
    await _loadTodayData();
    _markTimerRecordsChanged();
  }

  void createTimer({
    required int type,
    required String name,
    required int targetDurationMs,
    String? note,
    int? taskId,
    int? listId,
    int? planId,
    String? evidenceUri,
    String? evidenceDisplayName,
    String? evidenceRelativePath,
    String? evidenceMimeType,
  }) {
    _stopTimer();
    _earlyReminderSent = false;
    final normalizedName = name.trim().isEmpty
        ? _defaultNameForType(type)
        : name.trim();
    state = TimerState.initial().copyWith(
      type: type,
      name: normalizedName,
      targetDurationMs: targetDurationMs,
      note: _emptyToNull(note),
      taskId: taskId,
      listId: listId,
      planId: planId,
      evidenceUri: _emptyToNull(evidenceUri),
      evidenceDisplayName: _emptyToNull(evidenceDisplayName),
      evidenceRelativePath: _emptyToNull(evidenceRelativePath),
      evidenceMimeType: _emptyToNull(evidenceMimeType),
      todayRecords: state.todayRecords,
      todayFocusDurationMs: state.todayFocusDurationMs,
    );
  }

  void startTimer() {
    if (state.state == AppConstants.stateFocusing) return;

    if (state.state == AppConstants.statePause && state.pauseStartMs != null) {
      final pauseDuration =
          DateTime.now().millisecondsSinceEpoch - state.pauseStartMs!;
      state = state.copyWith(
        state: AppConstants.stateFocusing,
        pauseTotalMs: state.pauseTotalMs + pauseDuration,
        clearPauseStart: true,
      );
      _startPeriodicTimer();
      _startBackgroundService();
      unawaited(_persistActiveSession());
      return;
    }

    state = state.copyWith(
      state: AppConstants.stateFocusing,
      startTimeMs: DateTime.now().millisecondsSinceEpoch,
    );
    _earlyReminderSent = false;
    _startPeriodicTimer();
    _startBackgroundService();
    unawaited(_persistActiveSession());
  }

  void pauseTimer() {
    if (state.state != AppConstants.stateFocusing) return;
    state = state.copyWith(
      state: AppConstants.statePause,
      pauseStartMs: DateTime.now().millisecondsSinceEpoch,
    );
    _stopPeriodicTimer();
    BackgroundTimerService().stop();
    unawaited(_persistActiveSession());
  }

  Future<void> stopTimer({bool save = true}) async {
    if (state.state == AppConstants.stateStop || state.startTimeMs == 0) {
      _stopTimer();
      return;
    }
    if (_isStopping) return;

    _isStopping = true;
    final endTimeMs = DateTime.now().millisecondsSinceEpoch;
    try {
      if (save) {
        await _saveRecord(endTimeMs);
      }
      _stopTimer();
      await _repository.clearActiveSession();
      if (save) {
        await _loadTodayData();
      }
    } finally {
      _isStopping = false;
    }
  }

  Future<void> stopTimerAndCompleteLinkedTask() async {
    final linkedTaskId = state.taskId;
    final linkedListId = state.listId;
    await stopTimer();
    if (linkedTaskId == null || linkedListId == null) return;
    await _ref
        .read(taskListProvider(linkedListId).notifier)
        .completeIfActive(linkedTaskId);
    _ref.invalidate(allTaskListProvider);
    _ref.invalidate(taskPlanProvider);
  }

  void resetTimer() {
    _stopTimer();
    unawaited(_repository.clearActiveSession());
  }

  void _stopTimer() {
    _stopPeriodicTimer();
    BackgroundTimerService().stop();
    _earlyReminderSent = false;
    state = TimerState.initial().copyWith(
      todayRecords: state.todayRecords,
      todayFocusDurationMs: state.todayFocusDurationMs,
    );
  }

  void _startBackgroundService() {
    final effectiveStartTimeMs =
        DateTime.now().millisecondsSinceEpoch - state.focusDurationMs;
    BackgroundTimerService().start(
      startTimeMs: effectiveStartTimeMs,
      targetDurationMs: state.targetDurationMs,
      name: state.name,
    );
  }

  void _startPeriodicTimer() {
    _stopPeriodicTimer();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _maybeSendEarlyReminder();
      if (state.isCompleted) {
        final settings = _ref.read(timerSettingsProvider).valueOrNull;
        if (settings?.completionNotification ?? true) {
          NotificationService.instance.showTimerComplete(
            name: state.name,
            durationMs: state.focusDurationMs,
            type: state.type,
            soundEnabled: settings?.soundEnabled ?? true,
            vibrationEnabled: settings?.vibrationEnabled ?? true,
          );
        }
        unawaited(stopTimer());
      } else {
        state = state.copyWith(tickMs: DateTime.now().millisecondsSinceEpoch);
      }
    });
  }

  void _stopPeriodicTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _saveRecord(int endTimeMs) async {
    final durationMs =
        (state.targetDurationMs > 0
                ? state.focusDurationMs.clamp(0, state.targetDurationMs)
                : state.focusDurationMs)
            .toInt();
    if (durationMs <= 0) return;

    final settings = await _readTimerSettings();
    final companion = FocusTimeCompanion.insert(
      dayNum: app_date.DateUtils.calculateDayNum(
        DateTime.fromMillisecondsSinceEpoch(state.startTimeMs),
        dayStartMinute: settings.dayStartMinute,
      ),
      type: state.type,
      state: AppConstants.stateStop,
      startTime: state.startTimeMs,
      endTime: drift.Value(endTimeMs),
      durationMs: drift.Value(durationMs),
      scheduledTime: drift.Value(
        state.targetDurationMs > 0 ? state.targetDurationMs : null,
      ),
      name: state.name,
      note: drift.Value(state.note),
      taskId: drift.Value(state.taskId),
      listId: drift.Value(state.listId),
      planId: drift.Value(state.planId),
      evidenceUri: drift.Value(state.evidenceUri),
      evidenceDisplayName: drift.Value(state.evidenceDisplayName),
      evidenceRelativePath: drift.Value(state.evidenceRelativePath),
      evidenceMimeType: drift.Value(state.evidenceMimeType),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _repository.saveTimer(companion);
    _markTimerRecordsChanged();
  }

  void _markTimerRecordsChanged() {
    _ref.read(timerRecordsRevisionProvider.notifier).state++;
  }

  void _maybeSendEarlyReminder() {
    if (_earlyReminderSent ||
        state.targetDurationMs <= 0 ||
        state.remainingMs <= 0 ||
        state.state != AppConstants.stateFocusing) {
      return;
    }

    final settings = _ref.read(timerSettingsProvider).valueOrNull;
    final reminderMs = (settings?.earlyReminderMinutes ?? 0) * 60 * 1000;
    if ((settings?.completionNotification ?? true) == false ||
        reminderMs <= 0 ||
        state.remainingMs > reminderMs) {
      return;
    }

    _earlyReminderSent = true;
    unawaited(
      NotificationService.instance.showTimerEarlyReminder(
        name: state.name,
        remainingMs: state.remainingMs,
        type: state.type,
        soundEnabled: settings?.soundEnabled ?? true,
        vibrationEnabled: settings?.vibrationEnabled ?? true,
      ),
    );
  }

  Future<TimerSettingsValue> _readTimerSettings() async {
    try {
      return (await _ref.read(timerSettingsProvider.future)).normalized();
    } catch (_) {
      return TimerSettingsValue.defaults;
    }
  }

  Future<void> _persistActiveSession() async {
    if (_isRestoring) return;
    if (state.state == AppConstants.stateStop || state.startTimeMs == 0) {
      await _repository.clearActiveSession();
      return;
    }

    final nowMs = DateTime.now().millisecondsSinceEpoch;
    await _repository.saveActiveSession(
      ActiveTimerSessionCompanion.insert(
        id: const drift.Value(1),
        type: state.type,
        name: state.name,
        startTimeMs: state.startTimeMs,
        pauseStartMs: drift.Value(state.pauseStartMs),
        pauseTotalMs: drift.Value(state.pauseTotalMs),
        targetDurationMs: drift.Value(state.targetDurationMs),
        state: state.state,
        note: drift.Value(state.note),
        taskId: drift.Value(state.taskId),
        listId: drift.Value(state.listId),
        planId: drift.Value(state.planId),
        evidenceUri: drift.Value(state.evidenceUri),
        evidenceDisplayName: drift.Value(state.evidenceDisplayName),
        evidenceRelativePath: drift.Value(state.evidenceRelativePath),
        evidenceMimeType: drift.Value(state.evidenceMimeType),
        createdAt: nowMs,
        updatedAt: nowMs,
      ),
    );
  }

  String _defaultNameForType(int type) {
    switch (type) {
      case AppConstants.typePomodoro:
        return '番茄计时';
      case AppConstants.typeCountdown:
        return '倒计时';
      case AppConstants.typePomoBreak:
        return '休息';
      case AppConstants.typePomoLongBreak:
        return '长休息';
      case AppConstants.typeVideoStudy:
        return '视频打卡';
      case AppConstants.typeFreeCount:
      default:
        return '自由计时';
    }
  }

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  @override
  void dispose() {
    _stopPeriodicTimer();
    super.dispose();
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  final repository = ref.watch(timerRepositoryProvider);
  return TimerNotifier(repository, ref);
});
