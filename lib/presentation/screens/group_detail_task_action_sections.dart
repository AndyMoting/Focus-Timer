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
      leading: const Icon(Icons.subject_outlined),
      title: const Text('待办详情'),
      onTap: () {
        Navigator.pop(sheetContext);
        _showTaskDetailSheet(context, ref, group, task);
      },
    ),
    ListTile(
      leading: const Icon(Icons.notifications_outlined),
      title: const Text('提醒'),
      subtitle: task.reminderAt == null
          ? const Text('未设置')
          : Text(_formatReminderTime(task.reminderAt!)),
      onTap: () async {
        Navigator.pop(sheetContext);
        await _pickTaskReminder(context, ref, group, task);
      },
    ),
    ListTile(
      leading: const Icon(Icons.repeat_outlined),
      title: const Text('重复'),
      subtitle: Text(_formatRepeatRule(task.repeatRule)),
      onTap: () {
        Navigator.pop(sheetContext);
        _showTaskRepeatSheet(context, ref, group, task);
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
        _showSnack(context, '已切到统计');
        _openHomeTabFromDetail(context, ref, 2);
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
      icon: Icons.timer_outlined,
      title: '自由计时',
      type: AppConstants.typeFreeCount,
      defaultName: task.title,
      onRequest: (req) => _startFromRequest(context, ref, req, task),
      parentContext: context,
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
      parentContext: context,
      sheetContext: sheetContext,
    ),
    _TaskTimerActionTile(
      icon: Icons.videocam_outlined,
      title: '视频打卡',
      type: AppConstants.typeVideoStudy,
      defaultName: task.title,
      onRequest: (req) => _startFromRequest(context, ref, req, task),
      parentContext: context,
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
    required this.parentContext,
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
  final BuildContext parentContext;
  final BuildContext sheetContext;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () async {
        Navigator.pop(sheetContext);
        await Future<void>.delayed(Duration.zero);
        if (!parentContext.mounted) return;
        final req = await showModalBottomSheet<TimerStartRequest>(
          context: parentContext,
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
        if (req == null || !parentContext.mounted) return;
        onRequest(req);
      },
    );
  }
}

Future<void> _pickTaskReminder(
  BuildContext context,
  WidgetRef ref,
  TaskList group,
  Task task,
) async {
  final picked = await showDatePicker(
    context: context,
    initialDate: task.reminderAt == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(task.reminderAt!),
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
  );
  if (picked == null || !context.mounted) return;

  final time = await showAppTimePicker(
    context: context,
    title: '提醒时间',
    initialTime: task.reminderAt == null
        ? TimeOfDay.now()
        : TimeOfDay.fromDateTime(
            DateTime.fromMillisecondsSinceEpoch(task.reminderAt!),
          ),
  );
  if (time == null || !context.mounted) return;

  final reminderAt = DateTime(
    picked.year,
    picked.month,
    picked.day,
    time.hour,
    time.minute,
  ).millisecondsSinceEpoch;
  await _updateTaskFromActionSheet(
    ref,
    group,
    task,
    dueDayNum: task.dueDayNum ?? picked.difference(DateTime(1970)).inDays,
    reminderAt: reminderAt,
  );
  if (!context.mounted) return;
  _showSnack(context, '已设置提醒');
}

void _showTaskRepeatSheet(
  BuildContext context,
  WidgetRef ref,
  TaskList group,
  Task task,
) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      final selected = _normalizeRepeatRule(task.repeatRule);
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '重复',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            ...const ['none', 'daily', 'weekly', 'monthly'].map(
              (value) => ListTile(
                leading: Icon(
                  value == selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                ),
                title: Text(_formatRepeatRule(value)),
                selected: value == selected,
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await _updateTaskFromActionSheet(
                    ref,
                    group,
                    task,
                    repeatRule: value,
                  );
                  if (context.mounted) _showSnack(context, '已更新重复');
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
}

Future<void> _updateTaskFromActionSheet(
  WidgetRef ref,
  TaskList group,
  Task task, {
  int? dueDayNum,
  int? reminderAt,
  String? repeatRule,
}) {
  return ref
      .read(taskListProvider(group.id).notifier)
      .updateTaskDetails(
        task.id,
        title: task.title,
        description: task.description ?? '',
        priority: task.priority,
        dueDayNum: dueDayNum ?? task.dueDayNum,
        estimatedMinutes: task.estimatedMinutes,
        isFocus: task.isFocus == 1,
        isPinned: task.isPinned == 1,
        reminderAt: reminderAt ?? task.reminderAt,
        repeatRule: repeatRule ?? task.repeatRule,
      );
}
