import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/domain/models/timer_settings.dart';
import 'package:focus_timer/presentation/providers/theme_provider.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';
import 'package:focus_timer/shared/services/background_timer_service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImportPreviewResult {
  final String fileName;
  final bool ok;
  final String message;
  final Map<String, int> counts;
  final int linkedFocusTimeCount;
  final int videoEvidenceCount;

  const ImportPreviewResult({
    required this.fileName,
    required this.ok,
    required this.message,
    this.counts = const {},
    this.linkedFocusTimeCount = 0,
    this.videoEvidenceCount = 0,
  });
}

class RestoreFileResult {
  final String fileName;
  final bool ok;
  final String message;

  const RestoreFileResult({
    required this.fileName,
    required this.ok,
    required this.message,
  });
}

class DataRestoreBatchResult {
  final List<RestoreFileResult> files;
  final int taskLists;
  final int tasks;
  final int taskPlans;
  final int focusTimes;
  final int dailyLogs;
  final int settings;
  final int skipped;
  final int scheduledReminders;

  const DataRestoreBatchResult({
    required this.files,
    required this.taskLists,
    required this.tasks,
    required this.taskPlans,
    required this.focusTimes,
    required this.dailyLogs,
    required this.settings,
    required this.skipped,
    required this.scheduledReminders,
  });

  bool get hasWrites =>
      taskLists + tasks + taskPlans + focusTimes + dailyLogs + settings > 0;

  String get summary {
    final parts = <String>[
      if (taskLists > 0) '分组 $taskLists',
      if (tasks > 0) '待办 $tasks',
      if (taskPlans > 0) '计划 $taskPlans',
      if (focusTimes > 0) '计时 $focusTimes',
      if (dailyLogs > 0) '打卡 $dailyLogs',
      if (settings > 0) '设置 $settings',
      if (scheduledReminders > 0) '提醒 $scheduledReminders',
      if (skipped > 0) '跳过 $skipped',
    ];
    return parts.isEmpty ? '没有可恢复的新数据' : parts.join('，');
  }
}

class DataRestoreService {
  final AppDatabase _db;
  final BackgroundTimerService _backgroundService;

  DataRestoreService(
    this._db, {
    BackgroundTimerService? backgroundService,
  }) : _backgroundService = backgroundService ?? BackgroundTimerService();

  ImportPreviewResult previewJson(String fileName, String raw) {
    final decoded = _decodePayload(fileName, raw);
    if (!decoded.ok || decoded.payload == null) {
      return ImportPreviewResult(
        fileName: fileName,
        ok: false,
        message: decoded.error ?? 'JSON 解析失败',
      );
    }

    final payload = decoded.payload!;
    final app = payload['app']?.toString() ?? '未知应用';
    final scope = payload['exportScope']?.toString() ?? '未知范围';
    final counts = <String, int>{};
    for (final key in _importListKeys) {
      final value = payload[key];
      if (value is List) counts[key] = value.length;
    }
    final focusTimes = _listOfMaps(payload, 'focusTimes');
    final linkedCount = focusTimes.where(_hasLinkedTimerJson).length;
    final videoCount = _listOfMaps(payload, 'videoEvidence').length;
    final parts = counts.entries.map((entry) => '${entry.key} ${entry.value}');
    return ImportPreviewResult(
      fileName: fileName,
      ok: true,
      counts: counts,
      linkedFocusTimeCount: linkedCount,
      videoEvidenceCount: videoCount,
      message: counts.isEmpty
          ? '可解析：$app / $scope，但未发现可恢复列表'
          : '可解析：$app / $scope，${parts.join('，')}'
                '${linkedCount > 0 ? '，关联计时 $linkedCount' : ''}'
                '${videoCount > 0 ? '，视频索引 $videoCount' : ''}',
    );
  }

  Future<DataRestoreBatchResult> restoreJsonFiles(
    List<PickedTextFileResult> files, {
    bool scheduleReminders = true,
  }) async {
    final decodedFiles = <_DecodedImportFile>[];
    final fileResults = <RestoreFileResult>[];
    for (final file in files) {
      final decoded = _decodePayload(file.displayName, file.content);
      if (!decoded.ok || decoded.payload == null) {
        fileResults.add(
          RestoreFileResult(
            fileName: file.displayName,
            ok: false,
            message: decoded.error ?? 'JSON 解析失败',
          ),
        );
        continue;
      }
      decodedFiles.add(
        _DecodedImportFile(
          fileName: file.displayName,
          payload: decoded.payload!,
        ),
      );
    }

    var insertedLists = 0;
    var insertedTasks = 0;
    var insertedPlans = 0;
    var insertedFocusTimes = 0;
    var insertedDailyLogs = 0;
    var restoredSettings = 0;
    var skipped = 0;
    final importedTaskIds = <int>{};

    await _db.transaction(() async {
      final context = _RestoreContext();

      for (final file in decodedFiles) {
        final before = context.insertedTotal;
        insertedLists += await _restoreTaskLists(file.payload, context);
        insertedTasks += await _restoreTasks(
          file.payload,
          context,
          importedTaskIds,
        );
        insertedPlans += await _restoreTaskPlans(file.payload, context);
        insertedFocusTimes += await _restoreFocusTimes(file.payload, context);
        insertedDailyLogs += await _restoreDailyLogs(file.payload);
        restoredSettings += await _restoreFileBackedSettings(file.payload);
        restoredSettings += await _restoreTaskPlanSettings(file.payload);
        restoredSettings += await _restoreStatsSettings(file.payload);

        final inserted = context.insertedTotal - before;
        fileResults.add(
          RestoreFileResult(
            fileName: file.fileName,
            ok: true,
            message: inserted > 0 ? '已追加 $inserted 条数据' : '没有发现新数据',
          ),
        );
      }
      skipped = context.skipped;
    });

    final scheduled = scheduleReminders
        ? await _scheduleFutureReminders(importedTaskIds)
        : 0;

    return DataRestoreBatchResult(
      files: fileResults,
      taskLists: insertedLists,
      tasks: insertedTasks,
      taskPlans: insertedPlans,
      focusTimes: insertedFocusTimes,
      dailyLogs: insertedDailyLogs,
      settings: restoredSettings,
      skipped: skipped,
      scheduledReminders: scheduled,
    );
  }

  Future<int> _restoreTaskLists(
    Map<String, dynamic> payload,
    _RestoreContext context,
  ) async {
    var inserted = 0;
    for (final row in _listOfMaps(payload, 'taskLists')) {
      final oldId = _intOrNull(row, 'id');
      final name = _string(row, 'name', fallback: '导入分组').trim();
      if (name.isEmpty) {
        context.skipped++;
        continue;
      }
      final createdAt = _int(row, 'createdAt', fallback: _nowMs());
      final existing = await (_db.select(_db.taskLists)
            ..where((table) => table.name.equals(name))
            ..where((table) => table.createdAt.equals(createdAt)))
          .getSingleOrNull();
      if (existing != null) {
        if (oldId != null) context.listIdMap[oldId] = existing.id;
        context.skipped++;
        continue;
      }
      final newId = await _db.into(_db.taskLists).insert(
            TaskListsCompanion.insert(
              name: name,
              color: Value(_int(row, 'color', fallback: 0xFF4F6FA8)),
              iconCodePoint: Value(
                _int(row, 'iconCodePoint', fallback: 0xf428),
              ),
              sortOrder: Value(_int(row, 'sortOrder')),
              isDeleted: Value(_int(row, 'isDeleted')),
              isDailyReset: Value(_int(row, 'isDailyReset')),
              deletedAt: Value(_intOrNull(row, 'deletedAt')),
              createdAt: createdAt,
              updatedAt: _int(row, 'updatedAt', fallback: createdAt),
            ),
          );
      if (oldId != null) context.listIdMap[oldId] = newId;
      context.insertedTotal++;
      inserted++;
    }
    return inserted;
  }

  Future<int> _restoreTasks(
    Map<String, dynamic> payload,
    _RestoreContext context,
    Set<int> importedTaskIds,
  ) async {
    var inserted = 0;
    for (final row in _listOfMaps(payload, 'tasks')) {
      final oldId = _intOrNull(row, 'id');
      final oldListId = _intOrNull(row, 'listId');
      final listId = oldListId == null
          ? await _fallbackListId(context)
          : context.listIdMap[oldListId] ?? await _fallbackListId(context);
      final title = _string(row, 'title', fallback: '导入待办').trim();
      if (title.isEmpty) {
        context.skipped++;
        continue;
      }
      final createdAt = _int(row, 'createdAt', fallback: _nowMs());
      final existing = await (_db.select(_db.tasks)
            ..where((table) => table.listId.equals(listId))
            ..where((table) => table.title.equals(title))
            ..where((table) => table.createdAt.equals(createdAt)))
          .getSingleOrNull();
      if (existing != null) {
        if (oldId != null) context.taskIdMap[oldId] = existing.id;
        context.skipped++;
        continue;
      }
      final newId = await _db.into(_db.tasks).insert(
            TasksCompanion.insert(
              listId: listId,
              dayNum: _int(row, 'dayNum'),
              title: title,
              description: Value(_stringOrNull(row, 'description')),
              color: Value(_intOrNull(row, 'color')),
              state: Value(_int(row, 'state')),
              priority: Value(_int(row, 'priority')),
              dueDayNum: Value(_intOrNull(row, 'dueDayNum')),
              estimatedMinutes: Value(_int(row, 'estimatedMinutes')),
              isFocus: Value(_int(row, 'isFocus')),
              isPinned: Value(_int(row, 'isPinned')),
              pinnedAt: Value(_intOrNull(row, 'pinnedAt')),
              reminderAt: Value(_intOrNull(row, 'reminderAt')),
              repeatRule: Value(_repeatRule(row['repeatRule'])),
              sortOrder: Value(_int(row, 'sortOrder')),
              createdAt: createdAt,
              updatedAt: _int(row, 'updatedAt', fallback: createdAt),
              completedAt: Value(_intOrNull(row, 'completedAt')),
            ),
          );
      if (oldId != null) context.taskIdMap[oldId] = newId;
      importedTaskIds.add(newId);
      context.insertedTotal++;
      inserted++;
    }
    return inserted;
  }

  Future<int> _restoreTaskPlans(
    Map<String, dynamic> payload,
    _RestoreContext context,
  ) async {
    var inserted = 0;
    for (final row in _listOfMaps(payload, 'taskPlans')) {
      final oldId = _intOrNull(row, 'id');
      final oldListId = _intOrNull(row, 'listId');
      final oldTaskId = _intOrNull(row, 'taskId');
      final listId = oldListId == null ? null : context.listIdMap[oldListId];
      final taskId = oldTaskId == null ? null : context.taskIdMap[oldTaskId];
      if (listId == null || taskId == null) {
        context.skipped++;
        continue;
      }
      final startMinute =
          _intOrNull(row, 'startMinute') ?? _int(row, 'startHour') * 60;
      final dayNum = _int(row, 'dayNum');
      final existing = await (_db.select(_db.taskPlans)
            ..where((table) => table.taskId.equals(taskId))
            ..where((table) => table.dayNum.equals(dayNum))
            ..where((table) => table.startMinute.equals(startMinute)))
          .getSingleOrNull();
      if (existing != null) {
        if (oldId != null) context.planIdMap[oldId] = existing.id;
        context.skipped++;
        continue;
      }
      final createdAt = _int(row, 'createdAt', fallback: _nowMs());
      final newId = await _db.into(_db.taskPlans).insert(
            TaskPlansCompanion.insert(
              listId: listId,
              taskId: taskId,
              dayNum: dayNum,
              startHour: startMinute ~/ 60,
              startMinute: Value(startMinute),
              durationMinutes: Value(_int(row, 'durationMinutes', fallback: 60)),
              sortOrder: Value(_int(row, 'sortOrder')),
              createdAt: createdAt,
              updatedAt: _int(row, 'updatedAt', fallback: createdAt),
            ),
          );
      if (oldId != null) context.planIdMap[oldId] = newId;
      context.insertedTotal++;
      inserted++;
    }
    return inserted;
  }

  Future<int> _restoreFocusTimes(
    Map<String, dynamic> payload,
    _RestoreContext context,
  ) async {
    var inserted = 0;
    for (final row in _listOfMaps(payload, 'focusTimes')) {
      final name = _string(row, 'name', fallback: '导入计时').trim();
      if (name.isEmpty) {
        context.skipped++;
        continue;
      }
      final startTime = _int(row, 'startTime');
      final durationMs = _int(row, 'durationMs');
      final type = _int(row, 'type', fallback: AppConstants.typeFreeCount);
      final existing = await (_db.select(_db.focusTime)
            ..where((table) => table.startTime.equals(startTime))
            ..where((table) => table.type.equals(type))
            ..where((table) => table.name.equals(name))
            ..where((table) => table.durationMs.equals(durationMs)))
          .getSingleOrNull();
      if (existing != null) {
        context.skipped++;
        continue;
      }
      final createdAt = _int(row, 'createdAt', fallback: _nowMs());
      await _db.into(_db.focusTime).insert(
            FocusTimeCompanion.insert(
              dayNum: _int(row, 'dayNum'),
              type: type,
              state: _int(row, 'state'),
              startTime: startTime,
              endTime: Value(_intOrNull(row, 'endTime')),
              durationMs: Value(durationMs),
              scheduledTime: Value(_intOrNull(row, 'scheduledTime')),
              name: name,
              note: Value(_stringOrNull(row, 'note')),
              taskId: Value(_remapNullable(row, 'taskId', context.taskIdMap)),
              listId: Value(_remapNullable(row, 'listId', context.listIdMap)),
              planId: Value(_remapNullable(row, 'planId', context.planIdMap)),
              evidenceUri: Value(_stringOrNull(row, 'evidenceUri')),
              evidenceDisplayName: Value(
                _stringOrNull(row, 'evidenceDisplayName'),
              ),
              evidenceRelativePath: Value(
                _stringOrNull(row, 'evidenceRelativePath'),
              ),
              evidenceMimeType: Value(_stringOrNull(row, 'evidenceMimeType')),
              createdAt: createdAt,
              updatedAt: _int(row, 'updatedAt', fallback: createdAt),
            ),
          );
      context.insertedTotal++;
      inserted++;
    }
    return inserted;
  }

  Future<int> _restoreDailyLogs(Map<String, dynamic> payload) async {
    var inserted = 0;
    for (final row in _listOfMaps(payload, 'dailyLogs')) {
      final loggedAt = _int(row, 'loggedAt');
      final type = _int(row, 'type', fallback: AppConstants.dailyLogWake);
      final existing = await (_db.select(_db.dailyLogs)
            ..where((table) => table.loggedAt.equals(loggedAt))
            ..where((table) => table.type.equals(type)))
          .getSingleOrNull();
      if (existing != null) continue;
      final createdAt = _int(row, 'createdAt', fallback: _nowMs());
      await _db.into(_db.dailyLogs).insert(
            DailyLogsCompanion.insert(
              dayNum: _int(row, 'dayNum'),
              type: type,
              loggedAt: loggedAt,
              note: Value(_stringOrNull(row, 'note')),
              createdAt: createdAt,
              updatedAt: _int(row, 'updatedAt', fallback: createdAt),
            ),
          );
      inserted++;
    }
    return inserted;
  }

  Future<int> _restoreTaskPlanSettings(Map<String, dynamic> payload) async {
    final rows = _listOfMaps(payload, 'taskPlanSettings');
    if (rows.isEmpty) return 0;
    final row = rows.last;
    await _db.into(_db.taskPlanSettings).insertOnConflictUpdate(
          TaskPlanSettingsCompanion.insert(
            id: const Value(1),
            startMinute: Value(_int(row, 'startMinute')),
            endMinute: Value(_int(row, 'endMinute', fallback: 1440)),
            slotMinutes: Value(_int(row, 'slotMinutes', fallback: 60)),
            updatedAt: _int(row, 'updatedAt', fallback: _nowMs()),
          ),
        );
    return 1;
  }

  Future<int> _restoreStatsSettings(Map<String, dynamic> payload) async {
    final rows = _listOfMaps(payload, 'statsSettings');
    if (rows.isEmpty) return 0;
    final row = rows.last;
    await _db.into(_db.statsSettings).insertOnConflictUpdate(
          StatsSettingsCompanion.insert(
            id: const Value(1),
            visibleCharts: Value(
              _string(
                row,
                'visibleCharts',
                fallback: 'heatmap,pie,dailyLog,timeline',
              ),
            ),
            updatedAt: _int(row, 'updatedAt', fallback: _nowMs()),
          ),
        );
    return 1;
  }

  Future<int> _restoreFileBackedSettings(Map<String, dynamic> payload) async {
    var restored = 0;
    final countdown = payload['dayCountdown'];
    if (countdown is Map) {
      final name = countdown['eventName']?.toString().trim() ?? '';
      final targetDateMs = _intFromAny(countdown['targetDateMs']);
      if (name.isNotEmpty && targetDateMs != null) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File(p.join(dir.path, 'countdown.json'));
        await file.writeAsString(
          jsonEncode({'name': name, 'dateMs': targetDateMs}),
        );
        restored++;
      }
    }

    final timerSettings = payload['timerSettings'];
    if (timerSettings is Map) {
      final value = TimerSettingsValue.fromJson(
        timerSettings.map((key, value) => MapEntry(key.toString(), value)),
      ).normalized();
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'timer_settings.json'));
      await file.writeAsString(jsonEncode(value.toJson()));
      restored++;
    }

    final appearanceSettings = payload['appearanceSettings'];
    if (appearanceSettings is Map) {
      final value = AppAppearanceSettings.fromJson(
        appearanceSettings.map((key, value) => MapEntry(key.toString(), value)),
      );
      await saveAppearanceSettings(value);
      restored++;
    }
    return restored;
  }

  Future<int> _scheduleFutureReminders(Set<int> taskIds) async {
    if (taskIds.isEmpty) return 0;
    final now = _nowMs();
    final tasks = await (_db.select(_db.tasks)
          ..where((table) => table.id.isIn(taskIds.toList())))
        .get();
    var count = 0;
    for (final task in tasks) {
      final reminderAt = task.reminderAt;
      if (task.state == AppConstants.taskStateCompleted ||
          reminderAt == null ||
          reminderAt <= now) {
        continue;
      }
      await _backgroundService.scheduleTaskReminder(
        taskId: task.id,
        title: task.title,
        reminderAtMs: reminderAt,
      );
      count++;
    }
    return count;
  }

  Future<int> _fallbackListId(_RestoreContext context) async {
    final cached = context.fallbackListId;
    if (cached != null) return cached;
    final existing = await (_db.select(_db.taskLists)
          ..where((table) => table.name.equals('导入恢复')))
        .getSingleOrNull();
    if (existing != null) {
      context.fallbackListId = existing.id;
      return existing.id;
    }
    final now = _nowMs();
    final id = await _db.into(_db.taskLists).insert(
          TaskListsCompanion.insert(
            name: '导入恢复',
            color: const Value(0xFF4F6FA8),
            iconCodePoint: const Value(0xf428),
            createdAt: now,
            updatedAt: now,
          ),
        );
    context.fallbackListId = id;
    context.insertedTotal++;
    return id;
  }

  _DecodedPayload _decodePayload(String fileName, String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return const _DecodedPayload(error: 'JSON 顶层不是对象');
      }
      return _DecodedPayload(payload: decoded);
    } catch (_) {
      return const _DecodedPayload(error: 'JSON 解析失败');
    }
  }
}

const _importListKeys = [
  'taskLists',
  'tasks',
  'taskPlans',
  'focusTimes',
  'dailyLogs',
  'videoEvidence',
];

class _DecodedPayload {
  final Map<String, dynamic>? payload;
  final String? error;

  const _DecodedPayload({this.payload, this.error});

  bool get ok => payload != null && error == null;
}

class _DecodedImportFile {
  final String fileName;
  final Map<String, dynamic> payload;

  const _DecodedImportFile({required this.fileName, required this.payload});
}

class _RestoreContext {
  final Map<int, int> listIdMap = {};
  final Map<int, int> taskIdMap = {};
  final Map<int, int> planIdMap = {};
  int? fallbackListId;
  int insertedTotal = 0;
  int skipped = 0;
}

List<Map<String, dynamic>> _listOfMaps(Map<String, dynamic> payload, String key) {
  final value = payload[key];
  if (value is! List) return const [];
  return value.whereType<Map>().map((item) {
    return item.map((key, value) => MapEntry(key.toString(), value));
  }).toList();
}

bool _hasLinkedTimerJson(Object? item) {
  if (item is! Map) return false;
  return item['taskId'] != null ||
      item['listId'] != null ||
      item['planId'] != null;
}

int _int(Map<String, dynamic> row, String key, {int fallback = 0}) {
  final value = row[key];
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

int? _intOrNull(Map<String, dynamic> row, String key) {
  return _intFromAny(row[key]);
}

int? _intFromAny(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

String _string(
  Map<String, dynamic> row,
  String key, {
  String fallback = '',
}) {
  final value = row[key];
  if (value == null) return fallback;
  return value.toString();
}

String? _stringOrNull(Map<String, dynamic> row, String key) {
  final value = row[key];
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

String _repeatRule(Object? value) {
  return switch (value?.toString()) {
    'daily' || 'weekly' || 'monthly' => value.toString(),
    _ => 'none',
  };
}

int? _remapNullable(
  Map<String, dynamic> row,
  String key,
  Map<int, int> idMap,
) {
  final oldId = _intOrNull(row, key);
  if (oldId == null) return null;
  return idMap[oldId];
}

int _nowMs() => DateTime.now().millisecondsSinceEpoch;
