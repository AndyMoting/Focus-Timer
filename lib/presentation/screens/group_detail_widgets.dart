part of 'group_detail_screen.dart';

class _BatchActionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onComplete;
  final VoidCallback onMove;
  final VoidCallback onDelete;

  const _BatchActionBar({
    required this.selectedCount,
    required this.onComplete,
    required this.onMove,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '已选 $selectedCount 项',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          IconButton(
            tooltip: '完成',
            onPressed: selectedCount == 0 ? null : onComplete,
            icon: const Icon(Icons.check_circle_outline),
          ),
          IconButton(
            tooltip: '移动',
            onPressed: selectedCount == 0 ? null : onMove,
            icon: const Icon(Icons.drive_file_move_outline),
          ),
          IconButton(
            tooltip: '删除',
            onPressed: selectedCount == 0 ? null : onDelete,
            icon: Icon(Icons.delete_outline, color: colorScheme.error),
          ),
        ],
      ),
    );
  }
}

class _TaskMetaLine extends StatelessWidget {
  final Task task;

  const _TaskMetaLine({required this.task});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final parts = <String>[];
    if (task.isPinned == 1) parts.add('置顶');
    if (task.isFocus == 1) parts.add('重点');
    if (task.priority > 0) parts.add(task.priority == 1 ? '重要' : '很重要');
    if (task.dueDayNum != null) {
      final date = DateTime(1970).add(Duration(days: task.dueDayNum!));
      parts.add('截止 ${date.month}/${date.day}');
    }
    if (task.estimatedMinutes > 0) {
      parts.add('预计 ${task.estimatedMinutes} 分钟');
    }
    if (task.reminderAt != null) {
      parts.add('提醒 ${_formatTaskMetaReminder(task.reminderAt!)}');
    }
    if (task.repeatRule != 'none') {
      parts.add(_repeatRuleLabel(task.repeatRule));
    }
    if ((task.description ?? '').trim().isNotEmpty) {
      parts.add(task.description!.trim());
    }
    if (parts.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        parts.join(' · '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}

String _formatTaskMetaReminder(int timestampMs) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestampMs);
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '${date.month}/${date.day} $hour:$minute';
}

String _repeatRuleLabel(String repeatRule) {
  return switch (repeatRule) {
    'daily' => '每天重复',
    'weekly' => '每周重复',
    'monthly' => '每月重复',
    _ => '不重复',
  };
}
