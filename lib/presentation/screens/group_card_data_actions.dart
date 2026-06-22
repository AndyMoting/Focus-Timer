part of 'group_list_screen.dart';

extension _GroupCardDataActions on _GroupCard {
  Future<void> _copyGroupContent(WidgetRef ref, BuildContext context) async {
    final repo = ref.read(taskRepositoryProvider);
    final tasks = await repo.getTasksByList(group.id);
    final buffer = StringBuffer(group.name);
    for (final task in tasks) {
      buffer.writeln();
      buffer.write('- ${task.title}');
    }
    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    if (context.mounted) {
      _showSnack(context, '复制成功');
    }
  }
}
