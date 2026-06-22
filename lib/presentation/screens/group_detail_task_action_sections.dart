part of 'group_detail_screen.dart';

Widget _taskActionHeader({
  required Task task,
  required ColorScheme colorScheme,
  required TextTheme textTheme,
}) {
  final completed = task.state == AppConstants.taskStateCompleted;
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        if (completed && task.completedAt != null) ...[
          const SizedBox(height: 8),
          Text(
            '完成时间：${_formatDateTime(task.completedAt!)}',
            style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ],
    ),
  );
}

List<Widget> _taskStateActionTiles({
  required BuildContext sheetContext,
  required WidgetRef ref,
  required TaskList group,
  required Task task,
}) {
  final completed = task.state == AppConstants.taskStateCompleted;
  return [
    ListTile(
      leading: Icon(completed ? Icons.undo : Icons.check_circle_outline),
      title: Text(completed ? '取消完成' : '标记为完成'),
      onTap: () {
        Navigator.pop(sheetContext);
        ref.read(taskListProvider(group.id).notifier).toggleComplete(task.id);
      },
    ),
  ];
}

List<Widget> _taskPlanningActionTiles({
  required BuildContext context,
  required BuildContext sheetContext,
  required WidgetRef ref,
  required TaskList group,
  required Task task,
}) {
  return [
    ListTile(
      leading: const Icon(Icons.track_changes_outlined),
      title: const Text('设定目标'),
      onTap: () {
        Navigator.pop(sheetContext);
        _showTaskDetailSheet(context, ref, group, task);
      },
    ),
    ListTile(
      leading: const Icon(Icons.event_outlined),
      title: const Text('计划日期'),
      subtitle: task.dueDayNum != null
          ? Text(_formatDayNum(task.dueDayNum!))
          : null,
      onTap: () async {
        Navigator.pop(sheetContext);
        final picked = await showDatePicker(
          context: context,
          initialDate: task.dueDayNum == null
              ? DateTime.now()
              : DateTime(1970).add(Duration(days: task.dueDayNum!)),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (picked == null || !context.mounted) return;
        ref
            .read(taskListProvider(group.id).notifier)
            .updateTaskDetails(
              task.id,
              title: task.title,
              description: task.description ?? '',
              priority: task.priority,
              dueDayNum: picked.difference(DateTime(1970)).inDays,
              estimatedMinutes: task.estimatedMinutes,
              isFocus: task.isFocus == 1,
              isPinned: task.isPinned == 1,
              reminderAt: task.reminderAt,
              repeatRule: task.repeatRule,
              color: task.color,
            );
      },
    ),
    ListTile(
      leading: const Icon(Icons.bar_chart_outlined),
      title: const Text('统计'),
      onTap: () {
        Navigator.pop(sheetContext);
        ref.read(homeTabIndexProvider.notifier).state = 2;
        _showSnack(context, '已切到统计');
      },
    ),
  ];
}

List<Widget> _taskTimerActionTiles({
  required BuildContext context,
  required BuildContext sheetContext,
  required WidgetRef ref,
  required Task task,
}) {
  return [
    _TaskTimerActionTile(
      icon: Icons.videocam_outlined,
      title: '视频打卡',
      type: AppConstants.typeVideoStudy,
      defaultName: task.title,
      onRequest: (req) => _startFromRequest(context, ref, req, task),
      sheetContext: sheetContext,
    ),
    _TaskTimerActionTile(
      icon: Icons.timer_outlined,
      title: '自由计时',
      type: AppConstants.typeFreeCount,
      defaultName: task.title,
      onRequest: (req) => _startFromRequest(context, ref, req, task),
      sheetContext: sheetContext,
    ),
    _TaskTimerActionTile(
      icon: Icons.spa_outlined,
      title: '番茄计时',
      type: AppConstants.typePomodoro,
      defaultName: task.title,
      initialMinutes: task.estimatedMinutes > 0 ? task.estimatedMinutes : 25,
      durationPresets: const [25, 30, 45, 60],
      onRequest: (req) => _startFromRequest(context, ref, req, task),
      sheetContext: sheetContext,
    ),
  ];
}

List<Widget> _taskMoreActionTiles({
  required BuildContext context,
  required BuildContext sheetContext,
  required WidgetRef ref,
  required TaskList group,
  required Task task,
  required ColorScheme colorScheme,
}) {
  return [
    ListTile(
      leading: const Icon(Icons.subject_outlined),
      title: const Text('详情'),
      onTap: () {
        Navigator.pop(sheetContext);
        _showTaskDetailSheet(context, ref, group, task);
      },
    ),
    ListTile(
      leading: Icon(task.isFocus == 1 ? Icons.star : Icons.star_border),
      title: Text(task.isFocus == 1 ? '取消重点' : '设为重点'),
      onTap: () {
        Navigator.pop(sheetContext);
        ref.read(taskListProvider(group.id).notifier).toggleFocus(task.id);
      },
    ),
    ListTile(
      leading: Icon(
        task.isPinned == 1 ? Icons.push_pin : Icons.push_pin_outlined,
      ),
      title: Text(task.isPinned == 1 ? '取消置顶' : '置顶待办'),
      onTap: () {
        Navigator.pop(sheetContext);
        ref.read(taskListProvider(group.id).notifier).togglePinned(task.id);
      },
    ),
    ListTile(
      leading: Icon(
        Icons.palette_outlined,
        color: effectiveTaskColor(task, Color(group.color)),
      ),
      title: const Text('待办颜色'),
      subtitle: Text(task.color == null ? '跟随分组颜色' : '使用独立颜色'),
      onTap: () {
        Navigator.pop(sheetContext);
        _showTaskColorSheet(context, ref, group, task);
      },
    ),
    ListTile(
      leading: const Icon(Icons.copy_outlined),
      title: const Text('复制待办'),
      onTap: () {
        Navigator.pop(sheetContext);
        ref.read(taskListProvider(group.id).notifier).duplicateTask(task.id);
      },
    ),
    ListTile(
      leading: const Icon(Icons.drive_file_move_outline),
      title: const Text('移动到分组'),
      onTap: () {
        Navigator.pop(sheetContext);
        _showMoveTaskSheet(context, ref, group, task);
      },
    ),
    ListTile(
      leading: const Icon(Icons.edit_outlined),
      title: const Text('重命名'),
      onTap: () {
        Navigator.pop(sheetContext);
        _showRenameTaskSheet(context, ref, group, task);
      },
    ),
    ListTile(
      leading: Icon(Icons.delete_outline, color: colorScheme.error),
      title: Text('删除', style: TextStyle(color: colorScheme.error)),
      onTap: () async {
        Navigator.pop(sheetContext);
        await _confirmDeleteTask(context, ref, group, task);
      },
    ),
  ];
}

class _TaskTimerActionTile extends StatelessWidget {
  const _TaskTimerActionTile({
    required this.icon,
    required this.title,
    required this.type,
    required this.defaultName,
    required this.onRequest,
    required this.sheetContext,
    this.initialMinutes,
    this.durationPresets = const [],
  });

  final IconData icon;
  final String title;
  final int type;
  final String defaultName;
  final int? initialMinutes;
  final List<int> durationPresets;
  final ValueChanged<TimerStartRequest> onRequest;
  final BuildContext sheetContext;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () async {
        Navigator.pop(sheetContext);
        final req = await showModalBottomSheet<TimerStartRequest>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (_) => TimerSetupSheet(
            type: type,
            title: title,
            defaultName: defaultName,
            initialMinutes: initialMinutes,
            durationPresets: durationPresets,
            onDurationChanged: null,
          ),
        );
        if (req == null || !context.mounted) return;
        onRequest(req);
      },
    );
  }
}
