import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/domain/models/task_plan_settings.dart';
import 'package:focus_timer/presentation/providers/task_provider.dart';
import 'package:focus_timer/presentation/providers/timer_provider.dart';
import 'package:focus_timer/presentation/screens/home_screen.dart';
import 'package:focus_timer/presentation/screens/stats_screen.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';
import 'package:focus_timer/shared/utils/date_utils.dart' as app_date;

part 'task_plan_view.dart';
part 'task_plan_pool.dart';
part 'task_plan_timeline.dart';
part 'task_plan_timeline_row.dart';
part 'task_plan_timeline_lane.dart';
part 'task_plan_items.dart';
part 'task_plan_pill.dart';
part 'task_plan_pill_actions.dart';
part 'task_plan_pill_action_items.dart';
part 'task_plan_pill_edit_sheets.dart';
part 'task_plan_action_grid.dart';
part 'task_plan_pill_body.dart';
part 'task_plan_feedback.dart';
part 'task_plan_settings_sheet.dart';
part 'task_plan_actions.dart';

class TaskPlanScreen extends HookConsumerWidget {
  final TaskList? group;

  const TaskPlanScreen({super.key, this.group});
  const TaskPlanScreen.forGroup({super.key, required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDayNum = useState(app_date.DateUtils.todayDayNum);
    final hideCompleted = ref.watch(hideCompletedTasksProvider);
    final taskColorsByListId = group == null
        ? ref
              .watch(groupListProvider)
              .maybeWhen(
                data: (groups) => {
                  for (final list in groups) list.id: Color(list.color),
                },
                orElse: () => <int, Color>{},
              )
        : <int, Color>{group!.id: Color(group!.color)};
    final tasksAsync = group == null
        ? ref.watch(allTaskListProvider)
        : ref.watch(taskListProvider(group!.id));
    final planKey = TaskPlanKey(
      listId: group?.id,
      dayNum: selectedDayNum.value,
    );
    final plansAsync = ref.watch(taskPlanProvider(planKey));
    final settingsAsync = ref.watch(taskPlanSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(group == null ? '计划模式' : '${group!.name}计划'),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: '前一天',
            icon: const Icon(Icons.chevron_left),
            onPressed: () => selectedDayNum.value -= 1,
          ),
          IconButton(
            tooltip: '后一天',
            icon: const Icon(Icons.chevron_right),
            onPressed: () => selectedDayNum.value += 1,
          ),
          IconButton(
            tooltip: '时段设置',
            icon: const Icon(Icons.tune),
            onPressed: () => _showSettingsSheet(context, ref),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.content_copy_outlined),
            tooltip: '复制计划',
            onSelected: (value) async {
              final notifier = ref.read(taskPlanProvider(planKey).notifier);
              if (value == 'yesterday') {
                await notifier.copyPlansFromPreviousDay();
              } else if (value == 'last_week') {
                await notifier.copyPlansFromLastWeekSameDay();
              }
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value == 'yesterday' ? '已复制昨日计划' : '已复制上周同日计划'),
                ),
              );
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'yesterday', child: Text('复制昨日计划')),
              PopupMenuItem(value: 'last_week', child: Text('复制上周同日')),
            ],
          ),
        ],
      ),
      body: tasksAsync.when(
        data: (tasks) {
          final poolTasks = hideCompleted
              ? tasks
                    .where((t) => t.state != AppConstants.taskStateCompleted)
                    .toList()
              : tasks;
          return plansAsync.when(
            data: (plans) => settingsAsync.when(
              data: (settings) => PlanModeView(
                scopeTitle: group?.name ?? '全部待办',
                tasks: poolTasks,
                allTasks: tasks,
                plans: plans,
                dayNum: selectedDayNum.value,
                settings: settings,
                onAddPlan: (task, startMinute) => ref
                    .read(taskPlanProvider(planKey).notifier)
                    .addPlan(task, startMinute),
                onMovePlan: (plan, startMinute) => ref
                    .read(taskPlanProvider(planKey).notifier)
                    .movePlan(plan, startMinute),
                onDeletePlan: (plan) => ref
                    .read(taskPlanProvider(planKey).notifier)
                    .deletePlan(plan.id),
                onUpdatePlanDuration: (plan, duration) => ref
                    .read(taskPlanProvider(planKey).notifier)
                    .updatePlanDuration(plan, duration),
                onMovePlanToDay: (plan, dayNum) => ref
                    .read(taskPlanProvider(planKey).notifier)
                    .movePlanToDay(plan, dayNum),
                onToggleTaskComplete: (task) => ref
                    .read(taskListProvider(task.listId).notifier)
                    .toggleComplete(task.id),
                onStartPlan: (plan, task, {int? type, int? targetDurationMs}) =>
                    _startPlanTimer(
                      context,
                      ref,
                      plan,
                      task,
                      type: type ?? AppConstants.typeFreeCount,
                      targetDurationMs: targetDurationMs ?? 0,
                    ),
                onClearPlans: () =>
                    ref.read(taskPlanProvider(planKey).notifier).clearPlans(),
                taskColorsByListId: taskColorsByListId,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const Center(child: Text('时段设置加载失败')),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => const Center(child: Text('计划加载失败')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text('待办加载失败')),
      ),
    );
  }
}
