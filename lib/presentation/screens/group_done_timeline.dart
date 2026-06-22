part of 'group_list_screen.dart';

class _CompletedTimeline extends StatelessWidget {
  final List<Task> tasks;
  final Map<int, TaskList> groupsById;
  final ValueChanged<Task> onOpenTask;

  const _CompletedTimeline({
    required this.tasks,
    required this.groupsById,
    required this.onOpenTask,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    var lastDayKey = '';
    for (final task in tasks) {
      final completedAt = task.completedAt;
      if (completedAt == null) continue;
      final dayKey = _formatTimelineDay(completedAt);
      if (dayKey != lastDayKey) {
        if (children.isNotEmpty) children.add(const SizedBox(height: 12));
        children.add(_TimelineDayHeader(label: dayKey));
        lastDayKey = dayKey;
      }
      children.add(
        _CompletedTimelineTile(
          task: task,
          group: groupsById[task.listId],
          onTap: () => onOpenTask(task),
        ),
      );
    }
    return Column(children: children);
  }
}

class _TimelineDayHeader extends StatelessWidget {
  final String label;

  const _TimelineDayHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 4),
        child: Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _CompletedTimelineTile extends StatelessWidget {
  final Task task;
  final TaskList? group;
  final VoidCallback onTap;

  const _CompletedTimelineTile({
    required this.task,
    required this.group,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final groupColor = Color(group?.color ?? colorScheme.primary.toARGB32());
    final accent = effectiveTaskColor(task, groupColor);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.assignment_turned_in_outlined, color: accent),
      title: Text(task.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: group == null
          ? null
          : Text(group!.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Wrap(
        spacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (task.completedAt != null)
            Chip(
              avatar: const Icon(Icons.schedule, size: 16),
              label: Text(_formatTime(task.completedAt!)),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          Icon(Icons.more_horiz, color: colorScheme.onSurfaceVariant),
        ],
      ),
      onTap: onTap,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  final String? trailing;

  const _SectionLabel({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
      ],
    );
  }
}
