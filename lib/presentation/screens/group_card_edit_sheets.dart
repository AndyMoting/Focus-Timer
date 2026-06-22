part of 'group_list_screen.dart';

extension _GroupCardEditSheets on _GroupCard {
  void _showRenameDialog(BuildContext ctx, GroupNotifier notifier) {
    final c = TextEditingController(text: group.name);
    showDialog(
      context: ctx,
      builder: (ctx2) => AlertDialog(
        title: const Text('重命名'),
        content: TextField(
          controller: c,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx2),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              notifier.renameGroup(group.id, c.text.trim());
              Navigator.pop(ctx2);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    ).whenComplete(c.dispose);
  }

  void _showColorPicker(BuildContext ctx, GroupNotifier notifier) {
    showModalBottomSheet(
      context: ctx,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '选择颜色',
                style: Theme.of(
                  ctx,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              ColorSwatches(
                selectedColor: group.color,
                onChanged: (color) {
                  notifier.changeColor(group.id, color);
                  Navigator.pop(sheetContext);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showIconPicker(BuildContext ctx, GroupNotifier notifier) {
    showModalBottomSheet(
      context: ctx,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '选择图标',
                style: Theme.of(
                  ctx,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              IconSwatches(
                selectedIcon: group.iconCodePoint,
                selectedColor: group.color,
                onChanged: (icon) {
                  notifier.changeIcon(group.id, icon);
                  Navigator.pop(sheetContext);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
