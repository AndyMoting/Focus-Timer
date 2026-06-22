part of 'group_list_screen.dart';

void _showCompletedTaskDetailSheet(
  BuildContext context,
  WidgetRef ref,
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
                      fallbackColor: 0xFF4F6FA8,
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
                                  : '截止 ${_formatShortDay(dueDayNum!)}',
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
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      onPressed: () {
                        final estimated =
                            int.tryParse(estimateController.text.trim()) ?? 0;
                        ref
                            .read(taskListProvider(task.listId).notifier)
                            .updateTaskDetails(
                              task.id,
                              title: titleController.text,
                              description: descController.text,
                              priority: priority,
                              dueDayNum: dueDayNum,
                              estimatedMinutes: estimated < 0 ? 0 : estimated,
                              isFocus: isFocus,
                              isPinned: isPinned,
                              reminderAt: task.reminderAt,
                              repeatRule: task.repeatRule,
                              color: taskColor,
                            );
                        ref.invalidate(allTaskListProvider);
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
