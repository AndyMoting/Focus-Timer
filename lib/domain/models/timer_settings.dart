enum TimerClockStyle { ring, digital, flip, bar, minimal }

class TimerSettingsValue {
  final int dayStartMinute;
  final bool completionNotification;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final int earlyReminderMinutes;
  final bool keepScreenOn;
  final TimerClockStyle clockStyle;

  const TimerSettingsValue({
    required this.dayStartMinute,
    required this.completionNotification,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.earlyReminderMinutes,
    required this.keepScreenOn,
    required this.clockStyle,
  });

  static const defaults = TimerSettingsValue(
    dayStartMinute: 0,
    completionNotification: true,
    soundEnabled: true,
    vibrationEnabled: true,
    earlyReminderMinutes: 0,
    keepScreenOn: false,
    clockStyle: TimerClockStyle.ring,
  );

  factory TimerSettingsValue.fromJson(Map<String, dynamic> json) {
    final clockStyleIndex = json['clockStyle'] as int? ?? 0;
    return TimerSettingsValue(
      dayStartMinute: json['dayStartMinute'] as int? ?? 0,
      completionNotification: json['completionNotification'] as bool? ?? true,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      earlyReminderMinutes: json['earlyReminderMinutes'] as int? ?? 0,
      keepScreenOn: json['keepScreenOn'] as bool? ?? false,
      clockStyle: TimerClockStyle
          .values[clockStyleIndex.clamp(0, TimerClockStyle.values.length - 1)],
    );
  }

  Map<String, Object> toJson() {
    return {
      'dayStartMinute': dayStartMinute,
      'completionNotification': completionNotification,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'earlyReminderMinutes': earlyReminderMinutes,
      'keepScreenOn': keepScreenOn,
      'clockStyle': clockStyle.index,
    };
  }

  TimerSettingsValue normalized() {
    final dayMinute = dayStartMinute.clamp(0, 23 * 60 + 59);
    final reminder = earlyReminderMinutes.clamp(0, 60);
    return copyWith(dayStartMinute: dayMinute, earlyReminderMinutes: reminder);
  }

  TimerSettingsValue copyWith({
    int? dayStartMinute,
    bool? completionNotification,
    bool? soundEnabled,
    bool? vibrationEnabled,
    int? earlyReminderMinutes,
    bool? keepScreenOn,
    TimerClockStyle? clockStyle,
  }) {
    return TimerSettingsValue(
      dayStartMinute: dayStartMinute ?? this.dayStartMinute,
      completionNotification:
          completionNotification ?? this.completionNotification,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      earlyReminderMinutes: earlyReminderMinutes ?? this.earlyReminderMinutes,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      clockStyle: clockStyle ?? this.clockStyle,
    );
  }
}
