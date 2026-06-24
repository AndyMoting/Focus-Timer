part of 'group_list_screen.dart';

extension _GroupCardActions on _GroupCard {
  void _showActionSheet(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 8),
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('添加待办'),
              onTap: () => _selectAction(sheetContext, context, ref, 'add'),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('重命名'),
              onTap: () => _selectAction(sheetContext, context, ref, 'rename'),
            ),
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text('分组颜色'),
              onTap: () => _selectAction(sheetContext, context, ref, 'color'),
            ),
            ListTile(
              leading: const Icon(Icons.category_outlined),
              title: const Text('分组图标'),
              onTap: () => _selectAction(sheetContext, context, ref, 'icon'),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart_outlined),
              title: const Text('查看统计'),
              onTap: () => _selectAction(sheetContext, context, ref, 'stats'),
            ),
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: const Text('复制内容'),
              onTap: () => _selectAction(sheetContext, context, ref, 'copy'),
            ),
            ListTile(
              leading: const Icon(Icons.today_outlined),
              title: Text(group.isDailyReset == 1 ? '关闭每日重置' : '开启每日重置'),
              onTap: () =>
                  _selectAction(sheetContext, context, ref, 'daily_reset'),
            ),
            ListTile(
              leading: const Icon(Icons.control_point_duplicate_outlined),
              title: const Text('克隆'),
              onTap: () => _selectAction(sheetContext, context, ref, 'clone'),
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: colorScheme.error),
              title: Text('移至回收站', style: TextStyle(color: colorScheme.error)),
              onTap: () => _selectAction(sheetContext, context, ref, 'trash'),
            ),
          ],
        ),
      ),
    );
  }

  void _selectAction(
    BuildContext sheetContext,
    BuildContext pageContext,
    WidgetRef ref,
    String value,
  ) {
    Navigator.pop(sheetContext);
    _handleMenu(value, ref, pageContext);
  }

  Future<void> _handleMenu(
    String value,
    WidgetRef ref,
    BuildContext context,
  ) async {
    final notifier = ref.read(groupListProvider.notifier);
    switch (value) {
      case 'add':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GroupDetailScreen(group: group)),
        );
      case 'rename':
        _showRenameDialog(context, notifier);
      case 'color':
        _showColorPicker(context, notifier);
      case 'icon':
        _showIconPicker(context, notifier);
      case 'stats':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StatsScreen(title: '专注热力图')),
        );
      case 'daily_reset':
        await notifier.toggleDailyReset(group.id, group.isDailyReset == 0);
        if (!context.mounted) return;
        _showSnack(context, group.isDailyReset == 0 ? '每日重置已开启' : '每日重置已关闭');
      case 'copy':
        _copyGroupContent(ref, context);
      case 'clone':
        await notifier.cloneGroup(group);
        if (!context.mounted) return;
        _showSnack(context, '已克隆分组');
      case 'trash':
        final deletedIds = await notifier.moveToTrash(group.id);
        if (!context.mounted) return;
        _showTrashSnack(context, '已移至回收站', ref: ref, deletedIds: deletedIds);
    }
  }

  String _buildSubtitle(List<Task> tasks) {
    if (tasks.isEmpty) return '暂无待办';
    final remaining = tasks
        .where((task) => task.state != AppConstants.taskStateCompleted)
        .length;
    final completed = tasks.length - remaining;
    if (completed == 0) return '$remaining 项未完成';
    if (remaining == 0) return '全部完成 · 含已完成 $completed 项';
    return '$remaining 项未完成 · 含已完成 $completed 项';
  }
}
