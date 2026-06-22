part of 'group_detail_screen.dart';

void _showTaskActionSheet(
  BuildContext context,
  WidgetRef ref,
  TaskList group,
  Task task,
) {
  final colorScheme = Theme.of(context).colorScheme;
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      return SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 8),
          children: [
            _taskActionHeader(
              task: task,
              colorScheme: colorScheme,
              textTheme: Theme.of(context).textTheme,
            ),
            ..._taskStateActionTiles(
              sheetContext: sheetContext,
              ref: ref,
              group: group,
              task: task,
            ),
            const Divider(height: 8),
            ..._taskPlanningActionTiles(
              context: context,
              sheetContext: sheetContext,
              ref: ref,
              group: group,
              task: task,
            ),
            const Divider(height: 8),
            ..._taskTimerActionTiles(
              context: context,
              sheetContext: sheetContext,
              ref: ref,
              task: task,
            ),
            const Divider(height: 8),
            ..._taskMoreActionTiles(
              context: context,
              sheetContext: sheetContext,
              ref: ref,
              group: group,
              task: task,
              colorScheme: colorScheme,
            ),
          ],
        ),
      );
    },
  );
}
