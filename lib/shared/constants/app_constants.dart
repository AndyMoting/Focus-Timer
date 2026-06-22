class AppConstants {
  AppConstants._();

  static const String appName = 'Focus Timer';
  static const String appVersion = '0.1.0';

  static const String databaseName = 'focus_timer.db';
  static const int databaseVersion = 15;

  static const int stateStop = 0;
  static const int stateFocusing = 1;
  static const int statePause = 2;
  static const int stateWaiting = 3;

  static const int typePomodoro = 1;
  static const int typeFreeCount = 2;
  static const int typeCountdown = 3;
  static const int typePomoBreak = 4;
  static const int typePomoLongBreak = 5;
  static const int typeVideoStudy = 8;
  static const int typeSleep = 9;

  static const int dailyLogWake = 1;
  static const int dailyLogSleep = 2;

  static const int defaultPomodoroMs = 25 * 60 * 1000;
  static const int defaultBreakMs = 5 * 60 * 1000;
  static const int defaultLongBreakMs = 15 * 60 * 1000;

  static const int taskStateNormal = 0;
  static const int taskStateCompleted = 1;
  static const int taskStateArchived = 2;
}
