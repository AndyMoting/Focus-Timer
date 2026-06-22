import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/domain/models/timer_settings.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';
import 'package:focus_timer/shared/services/background_timer_service.dart';
import 'package:focus_timer/shared/services/data_restore_service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

void main() {
  late AppDatabase db;
  late DataRestoreService service;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('focus_timer_restore_test_');
    PathProviderPlatform.instance = _FakePathProvider(tempDir.path);
    db = AppDatabase.forTesting(NativeDatabase.memory());
    service = DataRestoreService(db);
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('preview counts linked focus records and video evidence', () {
    final preview = service.previewJson(
      'backup.json',
      jsonEncode({
        'app': AppConstants.appName,
        'exportScope': 'all',
        'taskLists': [
          {'id': 1, 'name': '学习', 'createdAt': 1, 'updatedAt': 1},
        ],
        'focusTimes': [
          {
            'id': 1,
            'dayNum': 1,
            'type': AppConstants.typeFreeCount,
            'state': AppConstants.stateStop,
            'startTime': 10,
            'durationMs': 60,
            'name': '数学',
            'taskId': 2,
            'createdAt': 10,
            'updatedAt': 10,
          },
        ],
        'videoEvidence': [
          {'recordId': 1, 'uri': 'content://video'},
        ],
      }),
    );

    expect(preview.ok, isTrue);
    expect(preview.counts['taskLists'], 1);
    expect(preview.linkedFocusTimeCount, 1);
    expect(preview.videoEvidenceCount, 1);
  });

  test('restore appends data and remaps task/list/plan ids', () async {
    final raw = jsonEncode({
      'app': AppConstants.appName,
      'exportScope': 'all',
      'taskLists': [
        {
          'id': 100,
          'name': '学习',
          'color': 0xFF4F6FA8,
          'iconCodePoint': 0xf428,
          'sortOrder': 0,
          'isDeleted': 0,
          'isDailyReset': 0,
          'createdAt': 1000,
          'updatedAt': 1000,
        },
      ],
      'tasks': [
        {
          'id': 200,
          'listId': 100,
          'dayNum': 1,
          'title': '数学',
          'state': AppConstants.taskStateNormal,
          'priority': 2,
          'estimatedMinutes': 45,
          'isFocus': 1,
          'isPinned': 1,
          'repeatRule': 'weekly',
          'sortOrder': 0,
          'createdAt': 2000,
          'updatedAt': 2000,
        },
      ],
      'taskPlans': [
        {
          'id': 300,
          'listId': 100,
          'taskId': 200,
          'dayNum': 1,
          'startHour': 9,
          'startMinute': 540,
          'durationMinutes': 60,
          'sortOrder': 0,
          'createdAt': 3000,
          'updatedAt': 3000,
        },
      ],
      'focusTimes': [
        {
          'id': 400,
          'dayNum': 1,
          'type': AppConstants.typeFreeCount,
          'state': AppConstants.stateStop,
          'startTime': 3600000,
          'endTime': 7200000,
          'durationMs': 3600000,
          'scheduledTime': 3600000,
          'name': '数学',
          'taskId': 200,
          'listId': 100,
          'planId': 300,
          'evidenceUri': 'content://video',
          'evidenceDisplayName': 'video.mp4',
          'evidenceRelativePath': 'Download/Focus Timer/Videos',
          'evidenceMimeType': 'video/mp4',
          'createdAt': 4000,
          'updatedAt': 4000,
        },
      ],
      'dailyLogs': [
        {
          'id': 500,
          'dayNum': 1,
          'type': AppConstants.dailyLogWake,
          'loggedAt': 5000,
          'createdAt': 5000,
          'updatedAt': 5000,
        },
      ],
      'dayCountdown': {
        'eventName': '考试',
        'targetDateMs': 123456789,
      },
      'timerSettings': {
        'dayStartMinute': 300,
        'completionNotification': true,
        'soundEnabled': false,
        'vibrationEnabled': true,
        'earlyReminderMinutes': 5,
        'keepScreenOn': true,
        'clockStyle': TimerClockStyle.minimal.index,
      },
      'appearanceSettings': {
        'themeColor': 0xFF8E3B46,
        'themeMode': 2,
        'todoLayout': 'grid',
      },
      'taskPlanSettings': [
        {
          'id': 1,
          'startMinute': 360,
          'endMinute': 1440,
          'slotMinutes': 30,
          'updatedAt': 6000,
        },
      ],
      'statsSettings': [
        {
          'id': 1,
          'visibleCharts': 'heatmap,pie,timeline',
          'updatedAt': 7000,
        },
      ],
    });

    final result = await service.restoreJsonFiles([
      PickedTextFileResult(
        uri: 'content://backup',
        displayName: 'backup.json',
        mimeType: 'application/json',
        content: raw,
      ),
    ], scheduleReminders: false);

    expect(result.taskLists, 1);
    expect(result.tasks, 1);
    expect(result.taskPlans, 1);
    expect(result.focusTimes, 1);
    expect(result.dailyLogs, 1);
    expect(result.settings, 5);

    final list = (await db.select(db.taskLists).get()).single;
    final task = (await db.select(db.tasks).get()).single;
    final plan = (await db.select(db.taskPlans).get()).single;
    final record = (await db.select(db.focusTime).get()).single;

    expect(task.listId, list.id);
    expect(plan.listId, list.id);
    expect(plan.taskId, task.id);
    expect(record.listId, list.id);
    expect(record.taskId, task.id);
    expect(record.planId, plan.id);
    expect(record.evidenceDisplayName, 'video.mp4');
    expect(
      await File(p.join(tempDir.path, 'countdown.json')).exists(),
      isTrue,
    );
    final timerSettings = jsonDecode(
      await File(p.join(tempDir.path, 'timer_settings.json')).readAsString(),
    ) as Map<String, dynamic>;
    expect(timerSettings['dayStartMinute'], 300);
    expect(timerSettings['clockStyle'], TimerClockStyle.minimal.index);
    final appearanceSettings = jsonDecode(
      await File(
        p.join(tempDir.path, 'appearance_settings.json'),
      ).readAsString(),
    ) as Map<String, dynamic>;
    expect(appearanceSettings['themeColor'], 0xFF8E3B46);
    expect(appearanceSettings['themeMode'], ThemeMode.dark.index);
    expect(appearanceSettings['todoLayout'], 'grid');

    final second = await service.restoreJsonFiles([
      PickedTextFileResult(
        uri: 'content://backup',
        displayName: 'backup.json',
        mimeType: 'application/json',
        content: raw,
      ),
    ], scheduleReminders: false);

    expect(second.taskLists, 0);
    expect(second.tasks, 0);
    expect(second.taskPlans, 0);
    expect(second.focusTimes, 0);
    expect(second.dailyLogs, 0);
  });
}

class _FakePathProvider extends PathProviderPlatform {
  final String path;

  _FakePathProvider(this.path);

  @override
  Future<String?> getApplicationDocumentsPath() async => path;

  @override
  Future<String?> getApplicationSupportPath() async => path;

  @override
  Future<String?> getTemporaryPath() async => path;
}
