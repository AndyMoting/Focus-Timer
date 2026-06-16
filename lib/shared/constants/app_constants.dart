/// 应用常量
class AppConstants {
  AppConstants._();

  // 应用信息
  static const String appName = 'Focus Timer';
  static const String appVersion = '0.1.0';

  // 数据库
  static const String databaseName = 'focus_timer.db';
  static const int databaseVersion = 1;

  // 计时器状态
  static const int stateStop = 0;
  static const int stateFocusing = 1;
  static const int statePause = 2;
  static const int stateWaiting = 3;

  // 计时器类型
  static const int typePomodoro = 1;      // 番茄钟
  static const int typeFreeCount = 2;     // 自由计时
  static const int typeCountdown = 3;     // 倒计时
  static const int typePomoBreak = 4;     // 番茄钟休息
  static const int typePomoLongBreak = 5; // 番茄钟长休息
  static const int typeCustomPomodoro = 6;// 自定义番茄钟
  static const int typeCustomCountdown = 7;// 自定义倒计时

  // 默认时长（毫秒）
  static const int defaultPomodoroMs = 25 * 60 * 1000; // 25分钟
  static const int defaultBreakMs = 5 * 60 * 1000;     // 5分钟
  static const int defaultLongBreakMs = 15 * 60 * 1000; // 15分钟

  // 任务状态
  static const int taskStateNormal = 0;
  static const int taskStateCompleted = 1;
  static const int taskStateArchived = 2;
}
