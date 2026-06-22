part of 'group_list_screen.dart';

void _showRenameCompletedTaskSheet(
  BuildContext context,
  WidgetRef ref,
  Task task,
) {
  final controller = TextEditingController(text: task.title);
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
                  '重命名待办',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _renameCompletedTaskFromSheet(
                    sheetContext,
                    context,
                    ref,
                    task,
                    controller,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () => _renameCompletedTaskFromSheet(
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

void _renameCompletedTaskFromSheet(
  BuildContext sheetContext,
  BuildContext pageContext,
  WidgetRef ref,
  Task task,
  TextEditingController controller,
) {
  final title = controller.text.trim();
  if (title.isEmpty) return;
  ref.read(taskListProvider(task.listId).notifier).renameTask(task.id, title);
  ref.invalidate(allTaskListProvider);
  Navigator.pop(sheetContext);
  _showTodoSnack(pageContext, '已重命名');
}
