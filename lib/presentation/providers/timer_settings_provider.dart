import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_timer/domain/models/timer_settings.dart';
import 'package:path_provider/path_provider.dart';

final timerSettingsProvider =
    AsyncNotifierProvider<TimerSettingsNotifier, TimerSettingsValue>(
      TimerSettingsNotifier.new,
    );

class TimerSettingsNotifier extends AsyncNotifier<TimerSettingsValue> {
  @override
  Future<TimerSettingsValue> build() async {
    final file = await _settingsFile();
    if (!await file.exists()) return TimerSettingsValue.defaults;
    final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    return TimerSettingsValue.fromJson(json).normalized();
  }

  Future<void> save(TimerSettingsValue settings) async {
    final value = settings.normalized();
    state = AsyncData(value);
    final file = await _settingsFile();
    await file.writeAsString(jsonEncode(value.toJson()));
  }

  Future<File> _settingsFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/timer_settings.json');
  }
}
