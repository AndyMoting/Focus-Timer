import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';
import 'package:focus_timer/shared/utils/date_utils.dart' as app_date;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);

    const channel = AndroidNotificationChannel(
      'timer_complete',
      '计时完成',
      description: '计时器完成时的提醒通知',
      importance: Importance.high,
      enableVibration: true,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    _initialized = true;
  }

  Future<void> showTimerComplete({
    required String name,
    required int durationMs,
    int? type,
    bool soundEnabled = true,
    bool vibrationEnabled = true,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'timer_complete',
        '计时完成',
        channelDescription: '计时器完成时的提醒通知',
        importance: Importance.high,
        priority: Priority.high,
        playSound: soundEnabled,
        enableVibration: vibrationEnabled,
      ),
    );

    await _plugin.show(
      0,
      _titleForType(type),
      '$name - ${app_date.DateUtils.formatDuration(durationMs)}',
      details,
    );
  }

  Future<void> showTimerEarlyReminder({
    required String name,
    required int remainingMs,
    int? type,
    bool soundEnabled = true,
    bool vibrationEnabled = true,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'timer_complete',
        '计时完成',
        channelDescription: '计时器完成时的提醒通知',
        importance: Importance.high,
        priority: Priority.high,
        playSound: soundEnabled,
        enableVibration: vibrationEnabled,
      ),
    );

    await _plugin.show(
      1,
      _earlyReminderTitleForType(type),
      '$name - 剩余 ${app_date.DateUtils.formatDuration(remainingMs)}',
      details,
    );
  }

  String _titleForType(int? type) {
    switch (type) {
      case AppConstants.typePomoBreak:
      case AppConstants.typePomoLongBreak:
        return '休息结束';
      case AppConstants.typeCountdown:
        return '倒计时结束';
      default:
        return '专注完成';
    }
  }

  String _earlyReminderTitleForType(int? type) {
    switch (type) {
      case AppConstants.typePomoBreak:
      case AppConstants.typePomoLongBreak:
        return '休息即将结束';
      case AppConstants.typeCountdown:
        return '倒计时即将结束';
      default:
        return '专注即将结束';
    }
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  Future<bool> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return true;
    return await android.requestNotificationsPermission() ?? false;
  }
}
