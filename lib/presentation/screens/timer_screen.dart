import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/domain/models/timer_settings.dart';
import 'package:focus_timer/presentation/providers/heatmap_provider.dart';
import 'package:focus_timer/presentation/providers/task_provider.dart';
import 'package:focus_timer/presentation/providers/timer_settings_provider.dart';
import 'package:focus_timer/presentation/providers/timer_provider.dart';
import 'package:focus_timer/presentation/screens/timer_running_surface.dart';
import 'package:focus_timer/presentation/screens/timer_settings_screen.dart';
import 'package:focus_timer/presentation/screens/timer_start_flow_actions.dart';
import 'package:focus_timer/presentation/screens/timer_start_surface.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';
import 'package:focus_timer/shared/utils/date_utils.dart' as app_date;

class TimerScreen extends HookConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final timerSettings =
        ref.watch(timerSettingsProvider).valueOrNull ??
        TimerSettingsValue.defaults;
    final timerNotifier = ref.read(timerProvider.notifier);
    final customDurationMin = useState(10);
    final isStopped = timerState.state == AppConstants.stateStop;
    final todayDayNum = app_date.DateUtils.todayDayNum;
    final todayPlans =
        ref
            .watch(taskPlanProvider(TaskPlanKey(dayNum: todayDayNum)))
            .valueOrNull ??
        const <TaskPlan>[];
    final plannedTaskIds = {for (final plan in todayPlans) plan.taskId};
    final activeTasks =
        (ref.watch(allTaskListProvider).valueOrNull ?? const <Task>[])
            .where((task) => task.state != AppConstants.taskStateCompleted)
            .toList();
    final startableTasks = _prioritizeStartableTasks(
      activeTasks,
      plannedTaskIds,
      todayDayNum,
    ).take(6).toList();
    final sourceGroups = ref.watch(groupListProvider).valueOrNull ?? const [];

    void startTimer({
      required int type,
      required String name,
      required int targetDurationMs,
      String? note,
      int? taskId,
      int? listId,
      int? planId,
      String? evidenceUri,
      String? evidenceDisplayName,
      String? evidenceRelativePath,
      String? evidenceMimeType,
    }) {
      timerNotifier.createTimer(
        type: type,
        name: name,
        targetDurationMs: targetDurationMs,
        note: note,
        taskId: taskId,
        listId: listId,
        planId: planId,
        evidenceUri: evidenceUri,
        evidenceDisplayName: evidenceDisplayName,
        evidenceRelativePath: evidenceRelativePath,
        evidenceMimeType: evidenceMimeType,
      );
      timerNotifier.startTimer();
    }

    void openStartFlow(int type) {
      if (!isStopped) {
        showTimerSnack(context, '当前计时结束后再切换');
        return;
      }
      showTimerStartFlow(
        context: context,
        type: type,
        customDurationMin: customDurationMin,
        onStart: startTimer,
      );
    }

    Future<void> refreshTimerRecordViews() async {
      ref.invalidate(statsSnapshotProvider);
      ref.invalidate(heatmapDataProvider);
      await timerNotifier.refreshTodayData();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('计时'),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: '计时设置',
            icon: const Icon(Icons.tune),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TimerSettingsScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: isStopped
              ? TimerStartSurface(
                  key: const ValueKey('timer-start'),
                  timerState: timerState,
                  timerNotifier: timerNotifier,
                  quickRestMinutes: timerQuickRestMinutes,
                  onStart: startTimer,
                  onStartType: openStartFlow,
                  onQuickRest: (minutes) => startQuickRestTimer(
                    context: context,
                    minutes: minutes,
                    onStart: startTimer,
                  ),
                  startableTasks: startableTasks,
                  sourceGroups: sourceGroups,
                  onRecordChanged: refreshTimerRecordViews,
                )
              : TimerRunningSurface(
                  key: const ValueKey('timer-running'),
                  timerState: timerState,
                  timerNotifier: timerNotifier,
                  timerSettings: timerSettings,
                  onMessage: (message) => showTimerSnack(context, message),
                ),
        ),
      ),
    );
  }
}

List<Task> _prioritizeStartableTasks(
  List<Task> tasks,
  Set<int> plannedTaskIds,
  int todayDayNum,
) {
  final sorted = [...tasks];
  sorted.sort((a, b) {
    final scoreCompare = _startTaskScore(
      b,
      plannedTaskIds,
      todayDayNum,
    ).compareTo(_startTaskScore(a, plannedTaskIds, todayDayNum));
    if (scoreCompare != 0) return scoreCompare;
    final pinCompare = b.isPinned.compareTo(a.isPinned);
    if (pinCompare != 0) return pinCompare;
    final priorityCompare = b.priority.compareTo(a.priority);
    if (priorityCompare != 0) return priorityCompare;
    return a.sortOrder.compareTo(b.sortOrder);
  });
  return sorted;
}

int _startTaskScore(Task task, Set<int> plannedTaskIds, int todayDayNum) {
  var score = 0;
  if (plannedTaskIds.contains(task.id)) score += 1000;
  if (task.dueDayNum == todayDayNum || task.dayNum == todayDayNum) {
    score += 700;
  } else if (task.dueDayNum != null && task.dueDayNum! < todayDayNum) {
    score += 650;
  }
  if (task.isFocus == 1) score += 500;
  if (task.isPinned == 1) score += 400;
  score += task.priority * 80;
  if (task.reminderAt != null) {
    final reminderDayNum = app_date.DateUtils.calculateDayNum(
      DateTime.fromMillisecondsSinceEpoch(task.reminderAt!),
    );
    score += reminderDayNum == todayDayNum ? 120 : 30;
  }
  if (task.estimatedMinutes > 0) score += 10;
  return score;
}
