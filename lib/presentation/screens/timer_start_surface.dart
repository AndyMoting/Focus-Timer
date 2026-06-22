import 'package:flutter/material.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/presentation/providers/timer_provider.dart';
import 'package:focus_timer/presentation/screens/timer_common_widgets.dart';
import 'package:focus_timer/presentation/screens/timer_record_widgets.dart';
import 'package:focus_timer/presentation/screens/timer_ui_helpers.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';

part 'timer_start_widgets.dart';

class TimerStartSurface extends StatelessWidget {
  final TimerState timerState;
  final TimerNotifier timerNotifier;
  final List<int> quickRestMinutes;
  final TimerStartCallback onStart;
  final ValueChanged<int> onStartType;
  final ValueChanged<int> onQuickRest;
  final List<Task> startableTasks;
  final List<TaskList> sourceGroups;
  final Future<void> Function()? onRecordChanged;

  const TimerStartSurface({
    super.key,
    required this.timerState,
    required this.timerNotifier,
    required this.quickRestMinutes,
    required this.onStart,
    required this.onStartType,
    required this.onQuickRest,
    this.startableTasks = const [],
    this.sourceGroups = const [],
    this.onRecordChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 112),
      children: [
        _TodayOverview(timerState: timerState, colorScheme: colorScheme),
        if (timerState.todayRecords.isNotEmpty) ...[
          const SizedBox(height: 12),
          RecentTimerRecordCard(
            record: timerState.todayRecords.first,
            timerNotifier: timerNotifier,
            onStart: onStart,
            sourceGroups: sourceGroups,
            onChanged: onRecordChanged,
          ),
        ],
        const SizedBox(height: 20),
        if (startableTasks.isNotEmpty) ...[
          const TimerSectionHeader(title: '从待办开始'),
          const SizedBox(height: 10),
          _TaskStartList(
            tasks: startableTasks,
            colorScheme: colorScheme,
            onStart: onStart,
          ),
          const SizedBox(height: 24),
        ],
        const TimerSectionHeader(title: '开始计时'),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 560;
            final cardWidth = isWide
                ? (constraints.maxWidth - 12) / 2
                : constraints.maxWidth;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _TimerActionCard(
                  width: cardWidth,
                  icon: Icons.spa_outlined,
                  title: '番茄计时',
                  subtitle: '25 分钟',
                  colorScheme: colorScheme,
                  onTap: () => onStartType(AppConstants.typePomodoro),
                ),
                _TimerActionCard(
                  width: cardWidth,
                  icon: Icons.timer_outlined,
                  title: '自由计时',
                  subtitle: '不限时',
                  colorScheme: colorScheme,
                  onTap: () => onStartType(AppConstants.typeFreeCount),
                ),
                _TimerActionCard(
                  width: cardWidth,
                  icon: Icons.hourglass_bottom_outlined,
                  title: '倒计时',
                  subtitle: '自定义',
                  colorScheme: colorScheme,
                  onTap: () => onStartType(AppConstants.typeCountdown),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        const TimerSectionHeader(title: '快速休息'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: quickRestMinutes
              .map(
                (minutes) => FilledButton.tonalIcon(
                  onPressed: () => onQuickRest(minutes),
                  icon: const Icon(Icons.coffee_outlined),
                  label: Text('$minutes 分钟'),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
        const TimerSectionHeader(title: '凭证记录'),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 560;
            final cardWidth = isWide
                ? (constraints.maxWidth - 12) / 2
                : constraints.maxWidth;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _TimerActionCard(
                  width: cardWidth,
                  icon: Icons.videocam_outlined,
                  title: '视频打卡',
                  subtitle: '拍摄凭证后记录',
                  colorScheme: colorScheme,
                  onTap: () => onStartType(AppConstants.typeVideoStudy),
                ),
              ],
            );
          },
        ),
        if (timerState.todayRecords.length > 1) ...[
          const SizedBox(height: 24),
          const TimerSectionHeader(title: '今日记录'),
          const SizedBox(height: 10),
          TodayTimerRecordsList(
            records: timerState.todayRecords.skip(1).take(5).toList(),
            timerNotifier: timerNotifier,
            onStart: onStart,
            sourceGroups: sourceGroups,
            onChanged: onRecordChanged,
          ),
        ],
      ],
    );
  }
}

typedef TimerStartCallback =
    void Function({
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
    });
