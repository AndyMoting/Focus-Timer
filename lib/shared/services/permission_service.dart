import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:focus_timer/shared/services/background_timer_service.dart';

class PermissionService {
  static Future<bool> hasNotificationPermission() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  static Future<bool> hasStoragePermission() async {
    return true;
  }

  static Future<bool> hasCameraPermission() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  static Future<bool> canScheduleExactAlarms() async {
    if (!Platform.isAndroid) return true;
    return BackgroundTimerService().canScheduleExactAlarms();
  }

  static Future<void> requestNotificationPermission() async {
    if (!Platform.isAndroid) return;
    final status = await Permission.notification.request();
    if (!status.isGranted) {
      await openNotificationSettings();
    }
  }

  static Future<bool> openNotificationSettings() async {
    return openAppSettings();
  }

  static Future<void> requestStoragePermission() async {
    return;
  }

  static Future<void> requestCameraPermission() async {
    if (!Platform.isAndroid) return;
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      await openAppSettings();
    }
  }

  static Future<void> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return;
    await BackgroundTimerService().openExactAlarmSettings();
  }

  static Future<bool> requestAll(BuildContext context) async {
    final needsNotification = !await hasNotificationPermission();
    final needsCamera = !await hasCameraPermission();
    final needsExactAlarm = !await canScheduleExactAlarms();

    if (!needsNotification && !needsCamera && !needsExactAlarm) return true;

    final buffer = StringBuffer('Focus Timer 需要以下权限才能正常运行：\n\n');
    if (needsNotification) {
      buffer.writeln('通知权限');
      buffer.writeln('计时完成、待办提醒时发送通知\n');
    }
    if (needsExactAlarm) {
      buffer.writeln('精确提醒设置');
      buffer.writeln('让待办提醒尽量按设定时间触发\n');
    }
    if (needsCamera) {
      buffer.writeln('相机权限');
      buffer.writeln('用于视频打卡拍摄；也可以改选已有视频\n');
    }

    if (!context.mounted) return false;
    final accepted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('需要权限'),
        content: Text(buffer.toString().trimRight()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('稍后'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('允许'),
          ),
        ],
      ),
    );

    if (accepted != true) return false;

    if (needsNotification) {
      await requestNotificationPermission();
    }
    if (needsExactAlarm) {
      await requestExactAlarmPermission();
    }
    if (needsCamera) {
      await requestCameraPermission();
    }

    return true;
  }
}
