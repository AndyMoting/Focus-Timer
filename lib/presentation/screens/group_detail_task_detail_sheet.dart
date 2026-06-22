part of 'group_detail_screen.dart';

void _showTaskDetailSheet(
  BuildContext context,
  WidgetRef ref,
  TaskList group,
  Task task,
) {
  final titleController = TextEditingController(text: task.title);
  final descController = TextEditingController(text: task.description ?? '');
  final estimateController = TextEditingController(
    text: task.estimatedMinutes > 0 ? task.estimatedMinutes.toString() : '',
  );
  var priority = task.priority;
  var dueDayNum = task.dueDayNum;
  var isFocus = task.isFocus == 1;
  var isPinned = task.isPinned == 1;
  var reminderAt = task.reminderAt;
  var repeatRule = task.repeatRule;
  var taskColor = task.color;

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
          return AnimatedPadding(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: bottomInset),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '待办详情',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _TaskLinkSummaryPanel(
                      future: _loadTaskLinkSummary(ref, task.id),
                      estimatedMinutes: task.estimatedMinutes,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: '标题',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descController,
                      minLines: 2,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: '备注',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      initialValue: priority,
                      decoration: const InputDecoration(
                        labelText: '优先级',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 0, child: Text('普通')),
                        DropdownMenuItem(value: 1, child: Text('重要')),
                        DropdownMenuItem(value: 2, child: Text('很重要')),
                      ],
                      onChanged: (value) {
                        if (value != null) setState(() => priority = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: estimateController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: '预计时长（分钟）',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('重点待办'),
                      value: isFocus,
                      onChanged: (value) => setState(() => isFocus = value),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('置顶待办'),
                      value: isPinned,
                      onChanged: (value) => setState(() => isPinned = value),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '待办颜色',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TaskColorSwatches(
                      selectedColor: taskColor,
                      fallbackColor: group.color,
                      onChanged: (value) => setState(() => taskColor = value),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: dueDayNum == null
                                    ? DateTime.now()
                                    : DateTime(
                                        1970,
                                      ).add(Duration(days: dueDayNum!)),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (picked == null) return;
                              setState(() {
                                dueDayNum = picked
                                    .difference(DateTime(1970))
                                    .inDays;
                              });
                            },
                            icon: const Icon(Icons.event_outlined),
                            label: Text(
                              dueDayNum == null
                                  ? '设置截止日期'
                                  : '截止 ${_formatDayNum(dueDayNum!)}',
                            ),
                          ),
                        ),
                        if (dueDayNum != null) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            tooltip: '清除截止日期',
                            onPressed: () => setState(() => dueDayNum = null),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: reminderAt == null
                                    ? DateTime.now()
                                    : DateTime.fromMillisecondsSinceEpoch(
                                        reminderAt!,
                                      ),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (picked == null || !context.mounted) return;
                              final time = await showTimePicker(
                                context: context,
                                initialTime: reminderAt == null
                                    ? TimeOfDay.now()
                                    : TimeOfDay.fromDateTime(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          reminderAt!,
                                        ),
                                      ),
                              );
                              if (time == null) return;
                              setState(() {
                                reminderAt = DateTime(
                                  picked.year,
                                  picked.month,
                                  picked.day,
                                  time.hour,
                                  time.minute,
                                ).millisecondsSinceEpoch;
                                dueDayNum ??= picked
                                    .difference(DateTime(1970))
                                    .inDays;
                              });
                            },
                            icon: const Icon(Icons.notifications_outlined),
                            label: Text(
                              reminderAt == null
                                  ? '设置提醒'
                                  : '提醒 ${_formatReminderTime(reminderAt!)}',
                            ),
                          ),
                        ),
                        if (reminderAt != null) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            tooltip: '清除提醒',
                            onPressed: () => setState(() => reminderAt = null),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _normalizeRepeatRule(repeatRule),
                      decoration: const InputDecoration(
                        labelText: '重复',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'none', child: Text('不重复')),
                        DropdownMenuItem(value: 'daily', child: Text('每天')),
                        DropdownMenuItem(value: 'weekly', child: Text('每周')),
                        DropdownMenuItem(value: 'monthly', child: Text('每月')),
                      ],
                      onChanged: (value) {
                        if (value != null) setState(() => repeatRule = value);
                      },
                    ),
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      onPressed: () {
                        final estimated =
                            int.tryParse(estimateController.text.trim()) ?? 0;
                        ref
                            .read(taskListProvider(group.id).notifier)
                            .updateTaskDetails(
                              task.id,
                              title: titleController.text,
                              description: descController.text,
                              priority: priority,
                              dueDayNum: dueDayNum,
                              estimatedMinutes: estimated < 0 ? 0 : estimated,
                              isFocus: isFocus,
                              isPinned: isPinned,
                              reminderAt: reminderAt,
                              repeatRule: repeatRule,
                              color: taskColor,
                            );
                        Navigator.pop(sheetContext);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('保存'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  ).whenComplete(() {
    titleController.dispose();
    descController.dispose();
    estimateController.dispose();
  });
}

Future<_TaskLinkSummaryData> _loadTaskLinkSummary(
  WidgetRef ref,
  int taskId,
) async {
  final records = await ref
      .read(timerRepositoryProvider)
      .getRecordsByTask(taskId, limit: 5);
  final plans = await ref.read(taskRepositoryProvider).getPlansByTask(taskId);
  return _TaskLinkSummaryData(records: records, plans: plans);
}

class _TaskLinkSummaryData {
  final List<FocusTimeData> records;
  final List<TaskPlan> plans;

  const _TaskLinkSummaryData({required this.records, required this.plans});

  int get focusMs => records
      .where((record) => isFocusTimerType(record.type))
      .fold<int>(0, (sum, record) => sum + _recordDurationMs(record));
}

class _TaskLinkSummaryPanel extends StatelessWidget {
  final Future<_TaskLinkSummaryData> future;
  final int estimatedMinutes;

  const _TaskLinkSummaryPanel({
    required this.future,
    required this.estimatedMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder<_TaskLinkSummaryData>(
      future: future,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return Container(
            height: 86,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        final latestRecord = data.records.isEmpty ? null : data.records.first;
        final latestPlan = data.plans.isEmpty ? null : data.plans.first;
        final estimatedMs = estimatedMinutes <= 0
            ? 0
            : estimatedMinutes * 60 * 1000;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _TaskLinkMetric(
                      label: '已专注',
                      value: formatShortDuration(data.focusMs),
                    ),
                  ),
                  Expanded(
                    child: _TaskLinkMetric(
                      label: '预计',
                      value: estimatedMs <= 0
                          ? '未设置'
                          : formatShortDuration(estimatedMs),
                    ),
                  ),
                  Expanded(
                    child: _TaskLinkMetric(
                      label: '计划',
                      value: '${data.plans.length} 条',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _TaskLinkLine(
                icon: Icons.timer_outlined,
                text: latestRecord == null
                    ? '暂无关联计时记录'
                    : '最近 ${_formatRecordDateTime(latestRecord.startTime)} · '
                          '${timerLabelForType(latestRecord.type)} · '
                          '${formatShortDuration(_recordDurationMs(latestRecord))}',
              ),
              const SizedBox(height: 6),
              _TaskLinkLine(
                icon: Icons.calendar_view_day_outlined,
                text: latestPlan == null
                    ? '暂无计划记录'
                    : '最近计划 ${_formatPlanTime(latestPlan)} · '
                          '${latestPlan.durationMinutes} 分钟',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TaskLinkMetric extends StatelessWidget {
  final String label;
  final String value;

  const _TaskLinkMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _TaskLinkLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TaskLinkLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}

int _recordDurationMs(FocusTimeData record) {
  if (record.durationMs > 0) return record.durationMs;
  final endTime = record.endTime;
  if (endTime == null || endTime <= record.startTime) return 0;
  return endTime - record.startTime;
}

String _formatRecordDateTime(int timestampMs) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestampMs);
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '${date.month}/${date.day} $hour:$minute';
}

String _formatPlanTime(TaskPlan plan) {
  final date = DateTime(1970).add(Duration(days: plan.dayNum));
  final startMinute = plan.startMinute ?? plan.startHour * 60;
  final hour = (startMinute ~/ 60).toString().padLeft(2, '0');
  final minute = (startMinute % 60).toString().padLeft(2, '0');
  return '${date.month}/${date.day} $hour:$minute';
}

String _formatReminderTime(int timestampMs) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestampMs);
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '${date.month}/${date.day} $hour:$minute';
}

String _normalizeRepeatRule(String repeatRule) {
  return switch (repeatRule) {
    'daily' || 'weekly' || 'monthly' => repeatRule,
    _ => 'none',
  };
}
