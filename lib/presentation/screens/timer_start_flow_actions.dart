import 'package:flutter/material.dart';
import 'package:focus_timer/presentation/screens/timer_setup_sheets.dart';
import 'package:focus_timer/presentation/screens/timer_start_surface.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';
import 'package:focus_timer/shared/services/background_timer_service.dart';

const timerDurationPresets = [5, 10, 15, 20, 25, 30, 45, 60];
const timerQuickRestMinutes = [5, 10, 20];

void showTimerStartFlow({
  required BuildContext context,
  required int type,
  required ValueNotifier<int> customDurationMin,
  required TimerStartCallback onStart,
}) {
  switch (type) {
    case AppConstants.typePomodoro:
      _showTimerSetupSheet(
        context: context,
        type: type,
        title: '番茄计时',
        defaultName: '番茄计时',
        initialMinutes: AppConstants.defaultPomodoroMs ~/ 60000,
        onStart: onStart,
      );
      return;
    case AppConstants.typeCountdown:
      _showTimerSetupSheet(
        context: context,
        type: type,
        title: '倒计时',
        defaultName: '倒计时',
        initialMinutes: customDurationMin.value,
        onDurationChanged: (minutes) => customDurationMin.value = minutes,
        onStart: onStart,
      );
      return;
    case AppConstants.typePomoBreak:
      onStart(
        type: type,
        name: '短休息',
        targetDurationMs: AppConstants.defaultBreakMs,
      );
      return;
    case AppConstants.typePomoLongBreak:
      onStart(
        type: type,
        name: '长休息',
        targetDurationMs: AppConstants.defaultLongBreakMs,
      );
      return;
    case AppConstants.typeVideoStudy:
      _startVideoCheckIn(context: context, onStart: onStart);
      return;
    case AppConstants.typeFreeCount:
    default:
      _showTimerSetupSheet(
        context: context,
        type: AppConstants.typeFreeCount,
        title: '自由计时',
        defaultName: '自由计时',
        onStart: onStart,
      );
      return;
  }
}

Future<void> _showTimerSetupSheet({
  required BuildContext context,
  required int type,
  required String title,
  required String defaultName,
  int? initialMinutes,
  ValueChanged<int>? onDurationChanged,
  required TimerStartCallback onStart,
}) async {
  final request = await showModalBottomSheet<TimerStartRequest>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    builder: (_) => TimerSetupSheet(
      type: type,
      title: title,
      defaultName: defaultName,
      initialMinutes: initialMinutes,
      durationPresets: timerDurationPresets,
      onDurationChanged: onDurationChanged,
    ),
  );
  if (!context.mounted || request == null) return;
  onStart(
    type: request.type,
    name: request.name,
    targetDurationMs: request.targetDurationMs,
    taskId: request.taskId,
    listId: request.listId,
    planId: request.planId,
  );
}

Future<void> _startVideoCheckIn({
  required BuildContext context,
  required TimerStartCallback onStart,
}) async {
  final action = await showDialog<_VideoCheckInAction>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('视频打卡'),
      content: const Text(
        '可以现场拍摄，也可以选择已有视频。文件会复制到 Download/Focus Timer/Videos，之后能在应用内播放。',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () =>
              Navigator.pop(dialogContext, _VideoCheckInAction.pick),
          child: const Text('选择视频'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.pop(dialogContext, _VideoCheckInAction.camera),
          child: const Text('去拍摄'),
        ),
      ],
    ),
  );
  if (!context.mounted || action == null) return;

  final output = action == _VideoCheckInAction.camera
      ? await BackgroundTimerService().startVideoCheckIn()
      : await BackgroundTimerService().pickVideoFile();
  if (!context.mounted) return;
  if (output == null) {
    showTimerSnack(context, '未完成视频打卡');
    return;
  }

  onStart(
    type: AppConstants.typeVideoStudy,
    name: '视频打卡',
    targetDurationMs: 0,
    evidenceUri: output.uri,
    evidenceDisplayName: output.displayName,
    evidenceRelativePath: output.relativePath,
    evidenceMimeType: output.mimeType,
  );
  showTimerSnack(context, '视频打卡已开始');
}

enum _VideoCheckInAction { camera, pick }

void startQuickRestTimer({
  required BuildContext context,
  required int minutes,
  required TimerStartCallback onStart,
}) {
  final type = minutes >= 20
      ? AppConstants.typePomoLongBreak
      : AppConstants.typePomoBreak;
  onStart(type: type, name: '休息', targetDurationMs: minutes * 60 * 1000);
  showTimerSnack(context, '休息开始');
}

void showTimerSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
  );
}
