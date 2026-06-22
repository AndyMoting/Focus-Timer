part of 'group_list_screen.dart';

Widget _completedTaskActionHeader({
  required BuildContext context,
  required ColorScheme colorScheme,
  required Task task,
  required TaskList? group,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        task.title,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
      if (task.completedAt != null) ...[
        const SizedBox(height: 8),
        Text(
          '完成时间：${_formatDateTime(task.completedAt!)}',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
        ),
      ],
      if (group != null) ...[
        const SizedBox(height: 4),
        Text(
          group.name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
        ),
      ],
    ],
  );
}

Widget _completedTaskQuickActionGrid({
  required BuildContext context,
  required BuildContext sheetContext,
  required WidgetRef ref,
  required Task task,
  required ColorScheme colorScheme,
}) {
  return GridView.count(
    crossAxisCount: 4,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: 14,
    crossAxisSpacing: 8,
    childAspectRatio: 0.82,
    children: [
      _DoneActionButton(
        icon: Icons.timer_outlined,
        label: '自由计时',
        onTap: () {
          Navigator.pop(sheetContext);
          _startTaskTimerFromHome(
            context,
            ref,
            task,
            type: AppConstants.typeFreeCount,
            targetDurationMs: 0,
          );
        },
      ),
      _DoneActionButton(
        icon: Icons.spa_outlined,
        label: '番茄计时',
        onTap: () {
          Navigator.pop(sheetContext);
          _startTaskTimerFromHome(
            context,
            ref,
            task,
            type: AppConstants.typePomodoro,
            targetDurationMs: AppConstants.defaultPomodoroMs,
          );
        },
      ),
      _DoneActionButton(
        icon: Icons.videocam_outlined,
        label: '视频打卡',
        onTap: () {
          Navigator.pop(sheetContext);
          _startTaskTimerFromHome(
            context,
            ref,
            task,
            type: AppConstants.typeVideoStudy,
            targetDurationMs: 0,
          );
        },
      ),
      _DoneActionButton(
        icon: Icons.undo,
        label: '取消完成',
        tone: colorScheme.error,
        onTap: () async {
          Navigator.pop(sheetContext);
          await _toggleTaskCompleteFromHome(context, ref, task);
        },
      ),
      _DoneActionButton(
        icon: Icons.track_changes_outlined,
        label: '设定目标',
        onTap: () {
          Navigator.pop(sheetContext);
          _showTaskTargetSheet(context, ref, task);
        },
      ),
      _DoneActionButton(
        icon: Icons.event_outlined,
        label: '计划日期',
        onTap: () {
          Navigator.pop(sheetContext);
          _pickTaskDueDate(context, ref, task);
        },
      ),
      _DoneActionButton(
        icon: Icons.delete_outline,
        label: '删除',
        tone: colorScheme.error,
        onTap: () async {
          Navigator.pop(sheetContext);
          await _confirmDeleteTaskFromHome(context, ref, task);
        },
      ),
      _DoneActionButton(
        icon: Icons.bar_chart_outlined,
        label: '统计',
        onTap: () {
          Navigator.pop(sheetContext);
          _openStatsFromHome(context, ref);
        },
      ),
    ],
  );
}

List<Widget> _completedTaskMoreActionTiles({
  required BuildContext context,
  required BuildContext sheetContext,
  required WidgetRef ref,
  required Task task,
}) {
  return [
    ListTile(
      leading: const Icon(Icons.subject_outlined),
      title: const Text('详情'),
      onTap: () {
        Navigator.pop(sheetContext);
        _showCompletedTaskDetailSheet(context, ref, task);
      },
    ),
    ListTile(
      leading: const Icon(Icons.edit_outlined),
      title: const Text('重命名'),
      onTap: () {
        Navigator.pop(sheetContext);
        _showRenameCompletedTaskSheet(context, ref, task);
      },
    ),
    ListTile(
      leading: const Icon(Icons.copy_outlined),
      title: const Text('复制待办'),
      onTap: () async {
        Navigator.pop(sheetContext);
        await ref
            .read(taskListProvider(task.listId).notifier)
            .duplicateTask(task.id);
        ref.invalidate(allTaskListProvider);
        if (context.mounted) _showTodoSnack(context, '已复制待办');
      },
    ),
    ListTile(
      leading: const Icon(Icons.drive_file_move_outline),
      title: const Text('移动到分组'),
      onTap: () {
        Navigator.pop(sheetContext);
        _showMoveCompletedTaskSheet(context, ref, task);
      },
    ),
    ListTile(
      leading: Icon(task.isFocus == 1 ? Icons.star : Icons.star_border),
      title: Text(task.isFocus == 1 ? '取消重点' : '设为重点'),
      onTap: () async {
        Navigator.pop(sheetContext);
        await ref
            .read(taskListProvider(task.listId).notifier)
            .toggleFocus(task.id);
        ref.invalidate(allTaskListProvider);
      },
    ),
    ListTile(
      leading: Icon(
        task.isPinned == 1 ? Icons.push_pin : Icons.push_pin_outlined,
      ),
      title: Text(task.isPinned == 1 ? '取消置顶' : '置顶待办'),
      onTap: () async {
        Navigator.pop(sheetContext);
        await ref
            .read(taskListProvider(task.listId).notifier)
            .togglePinned(task.id);
        ref.invalidate(allTaskListProvider);
      },
    ),
  ];
}

class _DoneActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? tone;
  final VoidCallback onTap;

  const _DoneActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveTone = tone ?? colorScheme.primary;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: effectiveTone.withValues(alpha: 0.16),
            child: Icon(icon, color: effectiveTone),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
