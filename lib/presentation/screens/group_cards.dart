part of 'group_list_screen.dart';

class _GroupCard extends HookConsumerWidget {
  final TaskList group;
  final bool compact;

  const _GroupCard({required this.group, this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final groupColor = Color(group.color);
    final tasksAsync = ref.watch(taskListProvider(group.id));
    final subtitle = tasksAsync.maybeWhen(
      data: _buildSubtitle,
      orElse: () => '正在加载待办',
    );
    final previewTasks = tasksAsync.maybeWhen(
      data: (tasks) => _previewTasks(tasks, compact ? 2 : 3),
      orElse: () => const <Task>[],
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: compact ? EdgeInsets.zero : const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GroupDetailScreen(group: group)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: groupColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      groupIconData(group.iconCodePoint),
                      size: 19,
                      color: groupColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Row(
                      children: [
                        if (group.isDailyReset == 1)
                          Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '每日重置',
                              style: TextStyle(
                                fontSize: 10,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        Expanded(
                          child: Text(
                            group.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () => _showActionSheet(context, ref),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (previewTasks.isNotEmpty) ...[
                const SizedBox(height: 10),
                ...previewTasks.map(
                  (task) => TaskPreviewLine(
                    task: task,
                    groupColor: groupColor,
                    onTap: () => ref
                        .read(taskListProvider(group.id).notifier)
                        .toggleComplete(task.id),
                    onLongPress: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GroupDetailScreen(group: group),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Task> _previewTasks(List<Task> tasks, int limit) {
    final active = tasks
        .where((task) => task.state != AppConstants.taskStateCompleted)
        .take(limit)
        .toList();
    if (active.isNotEmpty) return active;
    return tasks.take(limit).toList();
  }
}
