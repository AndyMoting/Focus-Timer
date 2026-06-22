import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:focus_timer/domain/models/timer_settings.dart';
import 'package:focus_timer/presentation/providers/timer_provider.dart';
import 'package:focus_timer/presentation/screens/timer_common_widgets.dart';
import 'package:focus_timer/presentation/screens/timer_ui_helpers.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';
import 'package:focus_timer/shared/services/background_timer_service.dart';

part 'timer_running_widgets.dart';

class TimerRunningSurface extends HookWidget {
  final TimerState timerState;
  final TimerNotifier timerNotifier;
  final TimerSettingsValue timerSettings;
  final ValueChanged<String> onMessage;

  const TimerRunningSurface({
    super.key,
    required this.timerState,
    required this.timerNotifier,
    required this.timerSettings,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      final service = BackgroundTimerService();
      unawaited(service.setKeepScreenOn(timerSettings.keepScreenOn));
      return () => unawaited(service.setKeepScreenOn(false));
    }, [timerSettings.keepScreenOn]);

    final colorScheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 112),
      children: [
        Center(child: _RunningStatus(timerState: timerState)),
        const SizedBox(height: 24),
        Center(
          child: _TimerDisplay(
            timerState: timerState,
            clockStyle: timerSettings.clockStyle,
          ),
        ),
        const SizedBox(height: 28),
        _RunningControls(
          timerState: timerState,
          timerNotifier: timerNotifier,
          onMessage: onMessage,
        ),
        const SizedBox(height: 28),
        _RunningDetails(timerState: timerState, colorScheme: colorScheme),
      ],
    );
  }
}

enum _StopChoice { finish, finishAndCompleteTask, discard }
