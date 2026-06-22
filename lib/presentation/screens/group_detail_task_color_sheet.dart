part of 'group_detail_screen.dart';

void _showTaskColorSheet(
  BuildContext context,
  WidgetRef ref,
  TaskList group,
  Task task,
) {
  var selected = task.color;
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '待办颜色',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TaskColorSwatches(
                    selectedColor: selected,
                    fallbackColor: group.color,
                    onChanged: (value) => setState(() => selected = value),
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: () async {
                      await ref
                          .read(taskListProvider(group.id).notifier)
                          .changeTaskColor(task.id, selected);
                      if (sheetContext.mounted) Navigator.pop(sheetContext);
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('保存'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
