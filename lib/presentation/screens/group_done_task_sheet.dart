part of 'group_list_screen.dart';

void _showCompletedTaskActionSheet(
  BuildContext context,
  WidgetRef ref,
  Task task,
  TaskList? group,
) {
  final colorScheme = Theme.of(context).colorScheme;
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _completedTaskActionHeader(
                context: context,
                colorScheme: colorScheme,
                task: task,
                group: group,
              ),
              const SizedBox(height: 18),
              _completedTaskQuickActionGrid(
                context: context,
                sheetContext: sheetContext,
                ref: ref,
                task: task,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              ..._completedTaskMoreActionTiles(
                context: context,
                sheetContext: sheetContext,
                ref: ref,
                task: task,
              ),
            ],
          ),
        ),
      );
    },
  );
}
