part of 'stats_screen.dart';

class _RecordEditFields {
  _RecordEditFields({
    required this.selectedType,
    required this.selectedDate,
    required this.selectedTime,
    required this.endTimeOfDay,
    required this.durationMinutes,
  });

  int selectedType;
  DateTime selectedDate;
  TimeOfDay selectedTime;
  TimeOfDay endTimeOfDay;
  int durationMinutes;

  DateTime get startTime => DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    selectedTime.hour,
    selectedTime.minute,
  );

  int get durationMs => durationMinutes * 60 * 1000;

  DateTime get endTime {
    var end = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      endTimeOfDay.hour,
      endTimeOfDay.minute,
    );
    if (!end.isAfter(startTime)) end = end.add(const Duration(days: 1));
    return end;
  }

  void updateDurationFromEndTime() {
    durationMinutes = math.max(1, endTime.difference(startTime).inMinutes);
  }

  void updateEndTimeFromDuration() {
    endTimeOfDay = TimeOfDay.fromDateTime(
      startTime.add(Duration(minutes: durationMinutes)),
    );
  }

  int get dayNum => app_date.DateUtils.calculateDayNum(selectedDate);
}

_RecordEditFields _initialRecordEditFields(FocusTimeData record) {
  final initialStart = DateTime.fromMillisecondsSinceEpoch(record.startTime);
  final initialDurationMinutes = math.max(
    1,
    (_recordDurationMs(record) / 60000).round(),
  );
  return _RecordEditFields(
    selectedType: record.type,
    selectedDate: DateTime(
      initialStart.year,
      initialStart.month,
      initialStart.day,
    ),
    selectedTime: TimeOfDay.fromDateTime(initialStart),
    endTimeOfDay: TimeOfDay.fromDateTime(
      initialStart.add(Duration(minutes: initialDurationMinutes)),
    ),
    durationMinutes: initialDurationMinutes,
  );
}

_RecordEditFields _initialManualEntryFields() {
  return _RecordEditFields(
    selectedType: AppConstants.typeFreeCount,
    selectedDate: DateTime.now(),
    selectedTime: TimeOfDay.now(),
    endTimeOfDay: TimeOfDay.fromDateTime(
      DateTime.now().add(const Duration(minutes: 30)),
    ),
    durationMinutes: 30,
  );
}
