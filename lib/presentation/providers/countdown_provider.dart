import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class DayCountdownState {
  final String eventName;
  final DateTime? targetDate;

  const DayCountdownState({this.eventName = '', this.targetDate});

  int get remainingDays {
    if (targetDate == null) return 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(
      targetDate!.year,
      targetDate!.month,
      targetDate!.day,
    );
    return target.difference(today).inDays;
  }

  bool get isPast => remainingDays < 0;
  bool get isToday => remainingDays == 0;

  DayCountdownState copyWith({String? eventName, DateTime? targetDate}) {
    return DayCountdownState(
      eventName: eventName ?? this.eventName,
      targetDate: targetDate ?? this.targetDate,
    );
  }
}

class CountdownNotifier extends StateNotifier<DayCountdownState> {
  CountdownNotifier() : super(const DayCountdownState()) {
    _load();
  }

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/countdown.json');
  }

  Future<void> _load() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return;
      final json =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final name = json['name'] as String? ?? '';
      final ms = json['dateMs'] as int?;
      final date = ms != null ? DateTime.fromMillisecondsSinceEpoch(ms) : null;
      state = DayCountdownState(eventName: name, targetDate: date);
    } catch (_) {}
  }

  Future<void> setEvent(String name, DateTime date) async {
    final file = await _getFile();
    await file.writeAsString(
      jsonEncode({'name': name, 'dateMs': date.millisecondsSinceEpoch}),
    );
    state = state.copyWith(eventName: name, targetDate: date);
  }

  Future<void> clear() async {
    final file = await _getFile();
    if (await file.exists()) await file.delete();
    state = const DayCountdownState();
  }
}

final countdownProvider =
    StateNotifierProvider<CountdownNotifier, DayCountdownState>((ref) {
      return CountdownNotifier();
    });
