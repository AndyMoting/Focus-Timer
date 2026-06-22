part of 'trash_screen.dart';

String _formatDeletedAt(int milliseconds) {
  final date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
  return '${date.year}/${date.month}/${date.day}';
}

void _confirmDeleteForever(BuildContext context, WidgetRef ref, int id) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('彻底删除'),
      content: const Text('彻底删除后无法恢复，确定继续吗？'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            ref.read(trashProvider.notifier).deleteGroupForever(id);
            Navigator.pop(ctx);
          },
          child: const Text('删除'),
        ),
      ],
    ),
  );
}
