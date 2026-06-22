part of 'group_detail_screen.dart';

void _submitTask(
  String value,
  WidgetRef ref,
  TaskList group,
  TextEditingController controller,
) {
  final text = value.trim();
  if (text.isEmpty) return;
  ref.read(taskListProvider(group.id).notifier).createTask(text);
  controller.clear();
}

void _toggleSelectedTask(ValueNotifier<Set<int>> selectedTaskIds, int id) {
  final next = {...selectedTaskIds.value};
  if (!next.add(id)) {
    next.remove(id);
  }
  selectedTaskIds.value = next;
}

Future<void> _completeSelectedTasks(
  BuildContext context,
  WidgetRef ref,
  TaskList group,
  ValueNotifier<Set<int>> selectedTaskIds,
) async {
  final ids = selectedTaskIds.value.toList();
  if (ids.isEmpty) return;
  final notifier = ref.read(taskListProvider(group.id).notifier);
  for (final id in ids) {
    await notifier.toggleComplete(id);
  }
  selectedTaskIds.value = <int>{};
  ref.invalidate(allTaskListProvider);
  if (context.mounted) _showSnack(context, '已完成 ${ids.length} 项');
}
