import 'package:flutter/material.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';

String timerLabelForType(int type) {
  switch (type) {
    case AppConstants.typePomodoro:
      return '番茄计时';
    case AppConstants.typeCountdown:
      return '倒计时';
    case AppConstants.typePomoBreak:
      return '休息';
    case AppConstants.typePomoLongBreak:
      return '长休息';
    case AppConstants.typeVideoStudy:
      return '视频打卡';
    case AppConstants.typeFreeCount:
    default:
      return '自由计时';
  }
}

IconData timerIconForType(int type) {
  switch (type) {
    case AppConstants.typePomodoro:
      return Icons.spa_outlined;
    case AppConstants.typeCountdown:
      return Icons.hourglass_bottom_outlined;
    case AppConstants.typePomoBreak:
    case AppConstants.typePomoLongBreak:
      return Icons.coffee_outlined;
    case AppConstants.typeVideoStudy:
      return Icons.videocam_outlined;
    case AppConstants.typeFreeCount:
    default:
      return Icons.timer_outlined;
  }
}

bool isFocusTimerType(int type) {
  return type != AppConstants.typePomoBreak &&
      type != AppConstants.typePomoLongBreak;
}

bool isRestTimerType(int type) {
  return type == AppConstants.typePomoBreak ||
      type == AppConstants.typePomoLongBreak;
}

bool shouldConfirmTargetStop(int type) {
  return type == AppConstants.typePomodoro ||
      type == AppConstants.typeCountdown;
}

String elapsedLabelForType(int type) {
  if (isRestTimerType(type)) return '已休息';
  return '已专注';
}

String formatShortDuration(int milliseconds) {
  if (milliseconds <= 0) return '0 分钟';
  final totalMinutes = (milliseconds / 60000).round();
  if (totalMinutes < 1) return '<1 分钟';
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes.remainder(60);
  if (hours == 0) return '$totalMinutes 分钟';
  if (minutes == 0) return '$hours 小时';
  return '$hours 小时 $minutes 分';
}

String formatRecordTimeRange(FocusTimeData record) {
  final start = formatClock(record.startTime);
  final endTime = record.endTime;
  if (endTime == null) return start;
  return '$start - ${formatClock(endTime)}';
}

String timerRecordSourceLabel(FocusTimeData record) {
  final parts = <String>[];
  if (record.taskId != null) parts.add('关联待办');
  if (record.listId != null) parts.add('分组 #${record.listId}');
  if (record.planId != null) parts.add('计划 #${record.planId}');
  return parts.join(' · ');
}

String formatClock(int millisecondsSinceEpoch) {
  final time = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
