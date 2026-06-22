import 'package:flutter/services.dart';

class SharedFileResult {
  final String uri;
  final String displayName;
  final String relativePath;
  final String mimeType;

  const SharedFileResult({
    required this.uri,
    required this.displayName,
    required this.relativePath,
    required this.mimeType,
  });

  factory SharedFileResult.fromMap(Map<dynamic, dynamic> map) {
    return SharedFileResult(
      uri: (map['uri'] ?? '').toString(),
      displayName: (map['displayName'] ?? '').toString(),
      relativePath: (map['relativePath'] ?? '').toString(),
      mimeType: (map['mimeType'] ?? '').toString(),
    );
  }

  Map<String, String> toJson() {
    return {
      'uri': uri,
      'displayName': displayName,
      'relativePath': relativePath,
      'mimeType': mimeType,
    };
  }
}

class PickedTextFileResult {
  final String uri;
  final String displayName;
  final String mimeType;
  final String content;

  const PickedTextFileResult({
    required this.uri,
    required this.displayName,
    required this.mimeType,
    required this.content,
  });

  factory PickedTextFileResult.fromMap(Map<dynamic, dynamic> map) {
    return PickedTextFileResult(
      uri: (map['uri'] ?? '').toString(),
      displayName: (map['displayName'] ?? '').toString(),
      mimeType: (map['mimeType'] ?? '').toString(),
      content: (map['content'] ?? '').toString(),
    );
  }
}

class BackgroundTimerService {
  static const _channel = MethodChannel('com.focustimer/timer');

  Future<void> start({
    required int startTimeMs,
    required int targetDurationMs,
    required String name,
  }) async {
    try {
      await _channel.invokeMethod('startBackgroundTimer', {
        'startTimeMs': startTimeMs,
        'targetDurationMs': targetDurationMs,
        'name': name,
      });
    } catch (_) {
      // Platform channel not available (non-Android or error)
    }
  }

  Future<void> stop() async {
    try {
      await _channel.invokeMethod('stopBackgroundTimer');
    } catch (_) {
      // Platform channel not available
    }
  }

  Future<SharedFileResult?> startVideoCheckIn() async {
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'startVideoCheckIn',
      );
      if (result == null || result['uri'] == null) return null;
      return SharedFileResult.fromMap(result);
    } catch (_) {
      return null;
    }
  }

  Future<SharedFileResult?> writeExportJson({
    required String displayName,
    required String content,
  }) async {
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'writeExportJson',
        {'displayName': displayName, 'content': content},
      );
      if (result == null || result['uri'] == null) return null;
      return SharedFileResult.fromMap(result);
    } catch (_) {
      return null;
    }
  }

  Future<List<PickedTextFileResult>> pickJsonFiles() async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>(
        'pickJsonFiles',
      );
      if (result == null) return const [];
      return result
          .whereType<Map<dynamic, dynamic>>()
          .map(PickedTextFileResult.fromMap)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<SharedFileResult?> pickVideoFile() async {
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'pickVideoFile',
      );
      if (result == null || result['uri'] == null) return null;
      return SharedFileResult.fromMap(result);
    } catch (_) {
      return null;
    }
  }

  Future<bool> openFile({
    required String uri,
    String? mimeType,
    String? title,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>('openFile', {
        'uri': uri,
        'mimeType': mimeType,
        'title': title,
      });
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> scheduleTaskReminder({
    required int taskId,
    required String title,
    required int reminderAtMs,
  }) async {
    try {
      await _channel.invokeMethod('scheduleTaskReminder', {
        'taskId': taskId,
        'title': title,
        'reminderAtMs': reminderAtMs,
      });
    } catch (_) {
      // Platform channel not available.
    }
  }

  Future<bool> canScheduleExactAlarms() async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'canScheduleExactAlarms',
      );
      return result ?? true;
    } catch (_) {
      return true;
    }
  }

  Future<bool> openExactAlarmSettings() async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'openExactAlarmSettings',
      );
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> cancelTaskReminder(int taskId) async {
    try {
      await _channel.invokeMethod('cancelTaskReminder', {'taskId': taskId});
    } catch (_) {
      // Platform channel not available.
    }
  }

  Future<void> setKeepScreenOn(bool enabled) async {
    try {
      await _channel.invokeMethod('setKeepScreenOn', {'enabled': enabled});
    } catch (_) {
      // Platform channel not available.
    }
  }
}
