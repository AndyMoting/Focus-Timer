part of 'timer_running_surface.dart';

class _RunningStatus extends StatelessWidget {
  final TimerState timerState;

  const _RunningStatus({required this.timerState});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPaused = timerState.state == AppConstants.statePause;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isPaused
            ? colorScheme.primaryContainer.withValues(alpha: 0.72)
            : colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${timerLabelForType(timerState.type)} · ${isPaused ? '已暂停' : '进行中'}',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class _TimerDisplay extends StatelessWidget {
  final TimerState timerState;
  final TimerClockStyle clockStyle;

  const _TimerDisplay({required this.timerState, required this.clockStyle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isRunning = timerState.state == AppConstants.stateFocusing;
    final isPaused = timerState.state == AppConstants.statePause;
    final hasTarget = timerState.targetDurationMs > 0;
    final primaryText = hasTarget
        ? timerState.formattedRemaining
        : timerState.formattedElapsed;
    final progressColor = isRunning
        ? colorScheme.primary
        : isPaused
        ? colorScheme.primary.withValues(alpha: 0.58)
        : colorScheme.outline;

    final content = _TimerDisplayContent(
      timerState: timerState,
      primaryText: primaryText,
      hasTarget: hasTarget,
      colorScheme: colorScheme,
    );

    return switch (clockStyle) {
      TimerClockStyle.ring => SizedBox(
        width: 260,
        height: 260,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 260,
              height: 260,
              child: CircularProgressIndicator(
                value: hasTarget ? 1 - timerState.progress : null,
                strokeWidth: 7,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
            Padding(padding: const EdgeInsets.all(28), child: content),
          ],
        ),
      ),
      TimerClockStyle.digital => Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 360, minHeight: 210),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: content,
      ),
      TimerClockStyle.flip => Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 390, minHeight: 220),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: _FlipTimerDisplayContent(
          timerState: timerState,
          primaryText: primaryText,
          hasTarget: hasTarget,
          colorScheme: colorScheme,
        ),
      ),
      TimerClockStyle.bar => Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 420, minHeight: 190),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: _BarTimerDisplayContent(
          timerState: timerState,
          primaryText: primaryText,
          hasTarget: hasTarget,
          progressColor: progressColor,
          colorScheme: colorScheme,
        ),
      ),
      TimerClockStyle.minimal => SizedBox(
        width: double.infinity,
        child: _MinimalTimerDisplayContent(
          timerState: timerState,
          primaryText: primaryText,
          hasTarget: hasTarget,
          colorScheme: colorScheme,
        ),
      ),
    };
  }
}

class _TimerDisplayContent extends StatelessWidget {
  final TimerState timerState;
  final String primaryText;
  final bool hasTarget;
  final ColorScheme colorScheme;

  const _TimerDisplayContent({
    required this.timerState,
    required this.primaryText,
    required this.hasTarget,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            primaryText,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          timerState.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        ),
        if (hasTarget) ...[
          const SizedBox(height: 4),
          Text(
            '${elapsedLabelForType(timerState.type)} ${timerState.formattedElapsed}',
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}

class _FlipTimerDisplayContent extends StatelessWidget {
  final TimerState timerState;
  final String primaryText;
  final bool hasTarget;
  final ColorScheme colorScheme;

  const _FlipTimerDisplayContent({
    required this.timerState,
    required this.primaryText,
    required this.hasTarget,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final parts = primaryText.split(':');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < parts.length; i++) ...[
                if (i > 0) _FlipSeparator(colorScheme: colorScheme),
                _FlipNumberBlock(value: parts[i], colorScheme: colorScheme),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          timerState.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        ),
        if (hasTarget) ...[
          const SizedBox(height: 4),
          Text(
            '${elapsedLabelForType(timerState.type)} ${timerState.formattedElapsed}',
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}

class _FlipNumberBlock extends StatelessWidget {
  final String value;
  final ColorScheme colorScheme;

  const _FlipNumberBlock({required this.value, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 92,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.w800,
          fontFeatures: const [FontFeature.tabularFigures()],
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _FlipSeparator extends StatelessWidget {
  final ColorScheme colorScheme;

  const _FlipSeparator({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.w800,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _BarTimerDisplayContent extends StatelessWidget {
  final TimerState timerState;
  final String primaryText;
  final bool hasTarget;
  final Color progressColor;
  final ColorScheme colorScheme;

  const _BarTimerDisplayContent({
    required this.timerState,
    required this.primaryText,
    required this.hasTarget,
    required this.progressColor,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          timerState.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15, color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            primaryText,
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w800,
              fontFeatures: const [FontFeature.tabularFigures()],
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: hasTarget ? timerState.progress : null,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
        if (hasTarget) ...[
          const SizedBox(height: 8),
          Text(
            '${elapsedLabelForType(timerState.type)} ${timerState.formattedElapsed}',
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}

class _MinimalTimerDisplayContent extends StatelessWidget {
  final TimerState timerState;
  final String primaryText;
  final bool hasTarget;
  final ColorScheme colorScheme;

  const _MinimalTimerDisplayContent({
    required this.timerState,
    required this.primaryText,
    required this.hasTarget,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            primaryText,
            style: TextStyle(
              fontSize: 68,
              fontWeight: FontWeight.w300,
              fontFeatures: const [FontFeature.tabularFigures()],
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          timerState.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        ),
        if (hasTarget) ...[
          const SizedBox(height: 6),
          Text(
            '${(timerState.progress * 100).round()}%',
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}

class _RunningControls extends StatelessWidget {
  final TimerState timerState;
  final TimerNotifier timerNotifier;
  final ValueChanged<String> onMessage;

  const _RunningControls({
    required this.timerState,
    required this.timerNotifier,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    final isRunning = timerState.state == AppConstants.stateFocusing;

    if (isRunning) {
      return Center(
        child: SizedBox(
          width: 124,
          height: 124,
          child: FilledButton(
            onPressed: timerNotifier.pauseTimer,
            style: FilledButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
            ),
            child: const Icon(Icons.pause, size: 44),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilledButton.icon(
          onPressed: timerNotifier.startTimer,
          icon: const Icon(Icons.play_arrow, size: 28),
          label: const Text('继续'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
        const SizedBox(width: 14),
        IconButton.filledTonal(
          tooltip: '结束',
          onPressed: () => _handleStop(context),
          icon: const Icon(Icons.stop),
          iconSize: 28,
        ),
      ],
    );
  }

  Future<void> _handleStop(BuildContext context) async {
    final shouldConfirmTargetTimer =
        shouldConfirmTargetStop(timerState.type) &&
        timerState.state == AppConstants.statePause;
    final canCompleteLinkedTask =
        timerState.taskId != null &&
        timerState.listId != null &&
        isFocusTimerType(timerState.type);

    if (shouldConfirmTargetTimer) {
      final choice = await showDialog<_StopChoice>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text('结束${timerLabelForType(timerState.type)}'),
          content: Text(
            canCompleteLinkedTask
                ? '可以放弃本次计时，也可以按当前已用时长保存记录；如果这个待办已经做完，可以同时标记完成。'
                : '可以放弃本次计时，也可以按当前已用时长保存记录。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, _StopChoice.discard),
              child: const Text('放弃'),
            ),
            if (canCompleteLinkedTask)
              TextButton(
                onPressed: () => Navigator.pop(
                  dialogContext,
                  _StopChoice.finishAndCompleteTask,
                ),
                child: const Text('保存并完成待办'),
              ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, _StopChoice.finish),
              child: const Text('保存'),
            ),
          ],
        ),
      );
      if (!context.mounted || choice == null) return;
      switch (choice) {
        case _StopChoice.discard:
          await timerNotifier.stopTimer(save: false);
          if (context.mounted) onMessage('已放弃本次计时');
        case _StopChoice.finish:
          await timerNotifier.stopTimer();
          if (context.mounted) onMessage('已保存记录');
        case _StopChoice.finishAndCompleteTask:
          await timerNotifier.stopTimerAndCompleteLinkedTask();
          if (context.mounted) onMessage('已保存记录并完成待办');
      }
      return;
    }

    if (canCompleteLinkedTask) {
      final choice = await showDialog<_StopChoice>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('结束计时'),
          content: const Text('这次计时已关联待办。保存记录后，可以选择是否把待办标记为已完成。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(
                dialogContext,
                _StopChoice.finishAndCompleteTask,
              ),
              child: const Text('保存并完成待办'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, _StopChoice.finish),
              child: const Text('仅保存'),
            ),
          ],
        ),
      );
      if (!context.mounted || choice == null) return;
      switch (choice) {
        case _StopChoice.finish:
          await timerNotifier.stopTimer();
          if (context.mounted) onMessage('已保存记录');
        case _StopChoice.finishAndCompleteTask:
          await timerNotifier.stopTimerAndCompleteLinkedTask();
          if (context.mounted) onMessage('已保存记录并完成待办');
        case _StopChoice.discard:
          await timerNotifier.stopTimer(save: false);
          if (context.mounted) onMessage('已放弃本次计时');
      }
      return;
    }

    await timerNotifier.stopTimer();
    if (context.mounted) {
      onMessage(isFocusTimerType(timerState.type) ? '已保存记录' : '休息已结束');
    }
  }
}

class _RunningDetails extends StatelessWidget {
  final TimerState timerState;
  final ColorScheme colorScheme;

  const _RunningDetails({required this.timerState, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final hasTarget = timerState.targetDurationMs > 0;
    final sourceLabel = _sourceLabel();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TimerStatItem(
                  label: hasTarget ? '目标' : '类型',
                  value: hasTarget
                      ? formatShortDuration(timerState.targetDurationMs)
                      : timerLabelForType(timerState.type),
                  colorScheme: colorScheme,
                ),
              ),
              Expanded(
                child: TimerStatItem(
                  label: elapsedLabelForType(timerState.type),
                  value: timerState.formattedElapsed,
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),
          if (sourceLabel != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.link_outlined,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    sourceLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String? _sourceLabel() {
    if (timerState.taskId == null && timerState.planId == null) return null;
    if (timerState.taskId != null && timerState.planId != null) {
      return '来源：计划待办 #${timerState.taskId}';
    }
    if (timerState.planId != null) return '来源：计划 #${timerState.planId}';
    return '来源：待办 #${timerState.taskId}';
  }
}
