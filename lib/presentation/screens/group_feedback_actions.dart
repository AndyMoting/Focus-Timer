part of 'group_list_screen.dart';

void _invalidateVisibleTaskLists(WidgetRef ref) {
  final groups = ref.read(groupListProvider).valueOrNull ?? const <TaskList>[];
  for (final group in groups) {
    ref.invalidate(taskListProvider(group.id));
  }
}

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
  );
}

void _showTrashSnack(
  BuildContext context,
  String message, {
  WidgetRef? ref,
  List<int> deletedIds = const [],
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      action: ref != null && deletedIds.isNotEmpty
          ? SnackBarAction(
              label: '撤回',
              onPressed: () async {
                await ref
                    .read(groupListProvider.notifier)
                    .restoreGroups(deletedIds);
                if (context.mounted) _showSnack(context, '已撤回');
              },
            )
          : SnackBarAction(label: '查看', onPressed: () => _openTrash(context)),
    ),
  );
}
