part of 'group_list_screen.dart';

void _showGlobalActionSheet(
  BuildContext context,
  WidgetRef ref, {
  required bool hideCompleted,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 8),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Text('待办操作', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
          ListTile(
            leading: const Icon(Icons.done_all_outlined),
            title: const Text('全部完成'),
            onTap: () =>
                _selectGlobalAction(sheetContext, context, ref, 'complete_all'),
          ),
          ListTile(
            leading: const Icon(Icons.cleaning_services_outlined),
            title: const Text('回收空的分组'),
            onTap: () =>
                _selectGlobalAction(sheetContext, context, ref, 'trash_empty'),
          ),
          ListTile(
            leading: Icon(
              Icons.delete_sweep_outlined,
              color: colorScheme.error,
            ),
            title: Text('回收所有分组', style: TextStyle(color: colorScheme.error)),
            onTap: () =>
                _selectGlobalAction(sheetContext, context, ref, 'trash_all'),
          ),
          ListTile(
            leading: Icon(
              hideCompleted
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
            title: Text(hideCompleted ? '显示已完成的待办' : '隐藏已完成的待办'),
            onTap: () =>
                _selectGlobalAction(sheetContext, context, ref, 'hide_done'),
          ),
          ListTile(
            leading: const Icon(Icons.restore_from_trash_outlined),
            title: const Text('回收站'),
            onTap: () =>
                _selectGlobalAction(sheetContext, context, ref, 'trash'),
          ),
        ],
      ),
    ),
  );
}

void _selectGlobalAction(
  BuildContext sheetContext,
  BuildContext pageContext,
  WidgetRef ref,
  String value,
) {
  Navigator.pop(sheetContext);
  _handleGlobalMenu(value, ref, pageContext);
}

Future<void> _handleGlobalMenu(
  String value,
  WidgetRef ref,
  BuildContext context,
) async {
  final notifier = ref.read(groupListProvider.notifier);
  switch (value) {
    case 'complete_all':
      await notifier.completeAllTasks();
      _invalidateVisibleTaskLists(ref);
      if (!context.mounted) return;
      _showSnack(context, '已全部完成');
    case 'trash_empty':
      final deletedIds = await notifier.moveEmptyGroupsToTrash();
      _invalidateVisibleTaskLists(ref);
      if (!context.mounted) return;
      _showTrashSnack(
        context,
        deletedIds.isEmpty ? '没有空分组可回收' : '已回收 ${deletedIds.length} 个空分组',
        ref: ref,
        deletedIds: deletedIds,
      );
    case 'trash_all':
      _confirmTrashAll(context, ref, notifier);
    case 'hide_done':
      final current = ref.read(hideCompletedTasksProvider);
      ref.read(hideCompletedTasksProvider.notifier).state = !current;
      _showSnack(context, current ? '已显示完成待办' : '已隐藏完成待办');
    case 'trash':
      _openTrash(context);
  }
}

void _confirmTrashAll(
  BuildContext context,
  WidgetRef ref,
  GroupNotifier notifier,
) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('回收所有分组'),
      content: const Text('所有分组会移至回收站，可在回收站恢复。'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () async {
            final deletedIds = await notifier.moveAllGroupsToTrash();
            _invalidateVisibleTaskLists(ref);
            if (!ctx.mounted || !context.mounted) return;
            Navigator.pop(ctx);
            _showTrashSnack(
              context,
              deletedIds.isEmpty ? '没有可回收的分组' : '已回收 ${deletedIds.length} 个分组',
              ref: ref,
              deletedIds: deletedIds,
            );
          },
          child: const Text('确定'),
        ),
      ],
    ),
  );
}
