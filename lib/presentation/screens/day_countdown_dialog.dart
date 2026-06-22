part of 'day_countdown_screen.dart';

void _showCountdownEditDialog(
  BuildContext context,
  WidgetRef ref,
  DayCountdownState current,
) {
  final nameController = TextEditingController(text: current.eventName);
  DateTime pickedDate =
      current.targetDate ?? DateTime.now().add(const Duration(days: 30));

  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text('设置倒计时'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '事件名称',
                hintText: '例如：考试、生日',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('目标日期: '),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: pickedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => pickedDate = picked);
                  },
                  child: Text(_formatCountdownDate(pickedDate)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (current.targetDate != null)
            TextButton(
              onPressed: () {
                ref.read(countdownProvider.notifier).clear();
                Navigator.pop(ctx);
              },
              child: const Text('删除', style: TextStyle(color: Colors.red)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                ref.read(countdownProvider.notifier).setEvent(name, pickedDate);
                Navigator.pop(ctx);
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    ),
  );
}

String _formatCountdownDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}
