part of 'trash_screen.dart';

class TrashEmptyState extends StatelessWidget {
  final ColorScheme colorScheme;

  const TrashEmptyState({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_outline, size: 64, color: colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            '暂无已删除分组',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class TrashGroupCard extends StatelessWidget {
  final TaskList group;
  final AsyncValue<List<Task>> tasksAsync;
  final ColorScheme colorScheme;
  final VoidCallback onRestore;
  final VoidCallback onDeleteForever;

  const TrashGroupCard({
    super.key,
    required this.group,
    required this.tasksAsync,
    required this.colorScheme,
    required this.onRestore,
    required this.onDeleteForever,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Color(group.color),
              child: const Icon(Icons.folder_outlined, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _TrashGroupDetails(group: group, tasksAsync: tasksAsync),
            ),
            Wrap(
              spacing: 2,
              children: [
                IconButton(
                  tooltip: '恢复',
                  icon: const Icon(Icons.restore),
                  onPressed: onRestore,
                ),
                IconButton(
                  tooltip: '彻底删除',
                  icon: Icon(Icons.delete_forever, color: colorScheme.error),
                  onPressed: onDeleteForever,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TrashGroupDetails extends StatelessWidget {
  final TaskList group;
  final AsyncValue<List<Task>> tasksAsync;

  const _TrashGroupDetails({required this.group, required this.tasksAsync});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          group.deletedAt == null
              ? '已移至回收站'
              : '删除于 ${_formatDeletedAt(group.deletedAt!)}',
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
        ),
        const SizedBox(height: 8),
        tasksAsync.maybeWhen(
          data: (tasks) => TrashTaskSummary(tasks: tasks),
          orElse: () => Text(
            '正在加载待办',
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class TrashTaskSummary extends StatelessWidget {
  final List<Task> tasks;

  const TrashTaskSummary({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (tasks.isEmpty) {
      return Text(
        '无待办',
        style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
      );
    }

    final completed = tasks
        .where((task) => task.state == AppConstants.taskStateCompleted)
        .length;
    final previews = tasks.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${tasks.length} 项待办 · 已完成 $completed 项',
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
        ),
        const SizedBox(height: 4),
        ...previews.map((task) {
          final done = task.state == AppConstants.taskStateCompleted;
          return Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              children: [
                Icon(
                  done
                      ? Icons.check_circle_outline
                      : Icons.radio_button_unchecked,
                  size: 14,
                  color: done ? colorScheme.outline : colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: done
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSurface,
                      decoration: done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
