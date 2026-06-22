part of 'group_list_screen.dart';

class _TodoSearchResults extends StatelessWidget {
  final String query;
  final List<TaskList> groups;
  final AsyncValue<List<Task>> tasksAsync;

  const _TodoSearchResults({
    required this.query,
    required this.groups,
    required this.tasksAsync,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final groupsById = {for (final group in groups) group.id: group};
    if (query.isEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 96),
        children: [
          Icon(Icons.search, size: 48, color: colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            '搜索待办和分组',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            '可以搜索待办标题、备注、分组名称。点结果会进入对应分组。',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 18),
          _SearchFilterHints(colorScheme: colorScheme),
        ],
      );
    }
    return tasksAsync.when(
      data: (tasks) {
        final normalized = query.toLowerCase();
        final groupResults = groups.where((group) {
          return group.name.toLowerCase().contains(normalized);
        }).toList();
        final taskResults = tasks.where((task) {
          final title = task.title.toLowerCase();
          final desc = (task.description ?? '').toLowerCase();
          return title.contains(normalized) || desc.contains(normalized);
        }).toList();
        final openTasks = taskResults
            .where((task) => task.state != AppConstants.taskStateCompleted)
            .toList();
        final doneTasks = taskResults
            .where((task) => task.state == AppConstants.taskStateCompleted)
            .toList();
        if (groupResults.isEmpty && taskResults.isEmpty) {
          return Center(
            child: Text(
              '没有找到相关待办',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          children: [
            if (groupResults.isNotEmpty) ...[
              _SectionLabel(title: '分组', trailing: '${groupResults.length} 个'),
              const SizedBox(height: 6),
              for (final group in groupResults)
                ListTile(
                  leading: CircleAvatar(
                    radius: 9,
                    backgroundColor: Color(group.color),
                  ),
                  title: Text(group.name),
                  subtitle: const Text('分组'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GroupDetailScreen(group: group),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
            ],
            if (openTasks.isNotEmpty) ...[
              _SectionLabel(title: '未完成', trailing: '${openTasks.length} 项'),
              const SizedBox(height: 6),
              for (final task in openTasks)
                _SearchTaskTile(
                  task: task,
                  group: groupsById[task.listId],
                  colorScheme: colorScheme,
                ),
            ],
            if (doneTasks.isNotEmpty) ...[
              const SizedBox(height: 12),
              _SectionLabel(title: '已完成', trailing: '${doneTasks.length} 项'),
              const SizedBox(height: 6),
              for (final task in doneTasks)
                _SearchTaskTile(
                  task: task,
                  group: groupsById[task.listId],
                  colorScheme: colorScheme,
                ),
            ],
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const Center(child: Text('搜索加载失败')),
    );
  }
}

class _SearchFilterHints extends StatelessWidget {
  final ColorScheme colorScheme;

  const _SearchFilterHints({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    const hints = [
      ('重点', Icons.star_outline),
      ('P1 / P2', Icons.flag_outlined),
      ('有日期', Icons.event_outlined),
      ('已完成', Icons.check_circle_outline),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final hint in hints)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(hint.$2, size: 16, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 5),
                Text(
                  hint.$1,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SearchTaskTile extends StatelessWidget {
  final Task task;
  final TaskList? group;
  final ColorScheme colorScheme;

  const _SearchTaskTile({
    required this.task,
    required this.group,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.state == AppConstants.taskStateCompleted;
    final accent = effectiveTaskColor(
      task,
      Color(group?.color ?? colorScheme.primary.toARGB32()),
    );
    final chips = <String>[
      if (task.isFocus == 1) '重点',
      if (task.priority > 0) 'P${task.priority}',
      if (task.dueDayNum != null) '有日期',
      if (task.estimatedMinutes > 0) '${task.estimatedMinutes}分',
    ];
    return ListTile(
      leading: Icon(
        isCompleted
            ? Icons.check_circle_outline
            : task.isFocus == 1
            ? Icons.star
            : Icons.radio_button_unchecked,
        color: isCompleted ? colorScheme.onSurfaceVariant : accent,
      ),
      title: Text(
        task.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: isCompleted
            ? TextStyle(
                color: colorScheme.onSurfaceVariant,
                decoration: TextDecoration.lineThrough,
              )
            : null,
      ),
      subtitle: Text(
        [
          group?.name ?? '未知分组',
          if (chips.isNotEmpty) chips.join(' · '),
        ].join(' · '),
      ),
      onTap: group == null
          ? null
          : () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GroupDetailScreen(group: group!),
              ),
            ),
    );
  }
}

class _TodoHomeTitle extends StatelessWidget {
  final _TodoHomeMode mode;
  final ValueChanged<_TodoHomeMode> onChanged;

  const _TodoHomeTitle({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final nextMode = mode == _TodoHomeMode.todo
        ? _TodoHomeMode.done
        : _TodoHomeMode.todo;
    return Tooltip(
      message: mode == _TodoHomeMode.todo ? '切换到已办' : '切换到待办',
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onChanged(nextMode),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(mode == _TodoHomeMode.done ? '已办' : '待办'),
            const SizedBox(width: 4),
            Icon(
              Icons.swap_horiz,
              size: 23,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
