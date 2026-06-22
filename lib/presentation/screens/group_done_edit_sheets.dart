part of 'group_list_screen.dart';

void _showTaskTargetSheet(BuildContext context, WidgetRef ref, Task task) {
  final controller = TextEditingController(
    text: task.estimatedMinutes > 0 ? task.estimatedMinutes.toString() : '',
  );
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      final bottomInset = MediaQuery.viewInsetsOf(sheetContext).bottom;
      return AnimatedPadding(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '设定目标',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: '预计时长（分钟）',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _saveTaskTarget(
                    sheetContext,
                    context,
                    ref,
                    task,
                    controller,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () => _saveTaskTarget(
                    sheetContext,
                    context,
                    ref,
                    task,
                    controller,
                  ),
                  icon: const Icon(Icons.check),
                  label: const Text('保存'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  ).whenComplete(controller.dispose);
}

void _saveTaskTarget(
  BuildContext sheetContext,
  BuildContext pageContext,
  WidgetRef ref,
  Task task,
  TextEditingController controller,
) {
  final estimated = int.tryParse(controller.text.trim()) ?? 0;
  ref
      .read(taskListProvider(task.listId).notifier)
      .updateTaskDetails(
        task.id,
        title: task.title,
        description: task.description,
        priority: task.priority,
        dueDayNum: task.dueDayNum,
        estimatedMinutes: estimated < 0 ? 0 : estimated,
        isFocus: task.isFocus == 1,
        isPinned: task.isPinned == 1,
        reminderAt: task.reminderAt,
        repeatRule: task.repeatRule,
      );
  ref.invalidate(allTaskListProvider);
  Navigator.pop(sheetContext);
  _showTodoSnack(pageContext, '目标已保存');
}
