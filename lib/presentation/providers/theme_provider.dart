import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AppAppearanceSettings {
  final int themeColor;
  final int themeModeIndex;
  final String todoLayout;

  const AppAppearanceSettings({
    required this.themeColor,
    required this.themeModeIndex,
    required this.todoLayout,
  });

  static const defaults = AppAppearanceSettings(
    themeColor: 0xFF4F6FA8,
    themeModeIndex: 0,
    todoLayout: 'list',
  );

  factory AppAppearanceSettings.fromJson(Map<String, dynamic> json) {
    return AppAppearanceSettings(
      themeColor: _int(json['themeColor'], defaults.themeColor),
      themeModeIndex: _int(json['themeMode'], defaults.themeModeIndex),
      todoLayout: json['todoLayout']?.toString() ?? defaults.todoLayout,
    ).normalized();
  }

  Map<String, Object> toJson() {
    return {
      'themeColor': themeColor,
      'themeMode': themeModeIndex,
      'todoLayout': todoLayout,
    };
  }

  ThemeMode get themeMode {
    final index = themeModeIndex.clamp(0, ThemeMode.values.length - 1);
    return ThemeMode.values[index];
  }

  AppAppearanceSettings normalized() {
    return AppAppearanceSettings(
      themeColor: themeColor,
      themeModeIndex: themeModeIndex.clamp(0, ThemeMode.values.length - 1),
      todoLayout: todoLayout == 'grid' ? 'grid' : 'list',
    );
  }
}

class AppAppearanceController extends AsyncNotifier<AppAppearanceSettings> {
  @override
  Future<AppAppearanceSettings> build() async {
    final file = await appearanceSettingsFile();
    if (!await file.exists()) return AppAppearanceSettings.defaults;
    final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    return AppAppearanceSettings.fromJson(json);
  }

  Future<void> save(AppAppearanceSettings settings) async {
    final value = settings.normalized();
    state = AsyncData(value);
    final file = await appearanceSettingsFile();
    await file.writeAsString(jsonEncode(value.toJson()));
  }
}

final appAppearanceProvider =
    AsyncNotifierProvider<AppAppearanceController, AppAppearanceSettings>(
      AppAppearanceController.new,
    );

final themeColorProvider = StateProvider<Color>(
  (ref) {
    final appearance = ref.watch(appAppearanceProvider).valueOrNull;
    return Color(appearance?.themeColor ?? AppAppearanceSettings.defaults.themeColor);
  },
);

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  final appearance = ref.watch(appAppearanceProvider).valueOrNull;
  return appearance?.themeMode ?? ThemeMode.system;
});

Future<void> saveAppearanceSettings(AppAppearanceSettings settings) async {
  final file = await appearanceSettingsFile();
  await file.writeAsString(jsonEncode(settings.normalized().toJson()));
}

Future<File> appearanceSettingsFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File(p.join(dir.path, 'appearance_settings.json'));
}

int _int(Object? value, int fallback) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

String themeModeLabel(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.system:
      return '跟随系统';
    case ThemeMode.light:
      return '浅色';
    case ThemeMode.dark:
      return '深色';
  }
}

class ThemeColors {
  static const List<ThemeColorOption> presets = [
    ThemeColorOption(name: '雾蓝', color: Color(0xFF4F6FA8)),
    ThemeColorOption(name: '靛蓝', color: Colors.indigo),
    ThemeColorOption(name: '深紫', color: Colors.deepPurple),
    ThemeColorOption(name: '灰蓝', color: Color(0xFF607D8B)),
    ThemeColorOption(name: '酒红', color: Color(0xFF8E3B46)),
    ThemeColorOption(name: '橙色', color: Colors.orange),
    ThemeColorOption(name: '粉红', color: Colors.pink),
    ThemeColorOption(name: '青绿', color: Colors.teal),
  ];
}

class ThemeColorOption {
  final String name;
  final Color color;

  const ThemeColorOption({required this.name, required this.color});
}
