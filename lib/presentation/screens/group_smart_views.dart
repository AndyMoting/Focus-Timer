part of 'group_list_screen.dart';

enum _SmartViewKind {
  today('今日', Icons.today_outlined),
  overdue('逾期', Icons.warning_amber_outlined),
  focus('重点', Icons.star_outline),
  pinned('置顶', Icons.push_pin_outlined),
  reminders('提醒', Icons.notifications_outlined),
  repeats('重复', Icons.repeat_outlined),
  planned('已计划', Icons.calendar_view_day_outlined);

  final String label;
  final IconData icon;

  const _SmartViewKind(this.label, this.icon);
}

class _SmartViewsStrip extends StatelessWidget {
  final List<TaskList> groups;
  final AsyncValue<List<Task>> tasksAsync;
  final AsyncValue<List<TaskPlan>> plansAsync;

  const _SmartViewsStrip({
    required this.groups,
    required this.tasksAsync,
    required this.plansAsync,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tasks = tasksAsync.valueOrNull;
    final plans = plansAsync.valueOrNull ?? const <TaskPlan>[];
    if (tasks == null) {
      return const SizedBox(
        height: 74,
        child: Center(child: LinearProgressIndicator()),
      );
    }

    final today = app_date.DateUtils.todayDayNum;
    final plannedTaskIds = {for (final plan in plans) plan.taskId};
    final cards = [
      for (final kind in _SmartViewKind.values)
        _SmartViewCardData(
          kind: kind,
          count: _filterSmartTasks(
            tasks: tasks,
            kind: kind,
            today: today,
            plannedTaskIds: plannedTaskIds,
          ).length,
        ),
    ];

    return SizedBox(
      height: 78,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final card = cards[index];
          return _SmartViewChip(
            data: card,
            colorScheme: colorScheme,
            onTap: () {
              final visibleTasks = _filterSmartTasks(
                tasks: tasks,
                kind: card.kind,
                today: today,
                plannedTaskIds: plannedTaskIds,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => _SmartTaskListScreen(
                    title: card.kind.label,
                    kind: card.kind,
                    groups: groups,
                    tasks: visibleTasks,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _SmartViewCardData {
  final _SmartViewKind kind;
  final int count;

  const _SmartViewCardData({required this.kind, required this.count});
}

class _SmartViewChip extends StatelessWidget {
  final _SmartViewCardData data;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _SmartViewChip({
    required this.data,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          width: 92,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Icon(data.kind.icon, size: 18, color: colorScheme.primary),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.kind.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${data.count} 项',
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmartTaskListScreen extends StatelessWidget {
  final String title;
  final _SmartViewKind kind;
  final List<TaskList> groups;
  final List<Task> tasks;

  const _SmartTaskListScreen({
    required this.title,
    required this.kind,
    required this.groups,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final groupsById = {for (final group in groups) group.id: group};
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: false),
      body: tasks.isEmpty
          ? Center(
              child: Text(
                '暂无${kind.label}待办',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              itemCount: tasks.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return _SearchTaskTile(
                  task: task,
                  group: groupsById[task.listId],
                  colorScheme: colorScheme,
                );
              },
            ),
    );
  }
}

List<Task> _filterSmartTasks({
  required List<Task> tasks,
  required _SmartViewKind kind,
  required int today,
  required Set<int> plannedTaskIds,
}) {
  final active = tasks
      .where((task) => task.state != AppConstants.taskStateCompleted)
      .toList();
  bool hasText(String value) => value.trim().isNotEmpty;

  final filtered = switch (kind) {
    _SmartViewKind.today => active.where(
      (task) => task.dayNum == today || task.dueDayNum == today,
    ),
    _SmartViewKind.overdue => active.where(
      (task) => task.dueDayNum != null && task.dueDayNum! < today,
    ),
    _SmartViewKind.focus => active.where((task) => task.isFocus == 1),
    _SmartViewKind.pinned => active.where((task) => task.isPinned == 1),
    _SmartViewKind.reminders => active.where((task) => task.reminderAt != null),
    _SmartViewKind.repeats => active.where(
      (task) => hasText(task.repeatRule) && task.repeatRule != 'none',
    ),
    _SmartViewKind.planned => active.where(
      (task) => plannedTaskIds.contains(task.id),
    ),
  };

  return filtered.toList()..sort((a, b) {
    final pinCompare = b.isPinned.compareTo(a.isPinned);
    if (pinCompare != 0) return pinCompare;
    final focusCompare = b.isFocus.compareTo(a.isFocus);
    if (focusCompare != 0) return focusCompare;
    final priorityCompare = b.priority.compareTo(a.priority);
    if (priorityCompare != 0) return priorityCompare;
    return a.sortOrder.compareTo(b.sortOrder);
  });
}
