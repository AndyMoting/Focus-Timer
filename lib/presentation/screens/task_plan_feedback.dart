part of 'task_plan_screen.dart';

class _DragFeedback extends StatelessWidget {
  final String label;
  final Color color;
  final ValueNotifier<double> dragX;

  const _DragFeedback({
    required this.label,
    required this.color,
    required this.dragX,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Material(
      color: Colors.transparent,
      child: ValueListenableBuilder<double>(
        valueListenable: dragX,
        builder: (context, x, child) {
          final progress = (x / screenWidth).clamp(0.0, 1.0);
          final width = 118 + (82 * progress);
          return AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOutCubic,
            width: width,
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.22),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 28,
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TimePickTile extends StatelessWidget {
  final String label;
  final int minute;
  final VoidCallback onPick;

  const _TimePickTile({
    required this.label,
    required this.minute,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onPick,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _formatMinute(minute),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Icon(Icons.expand_more, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  String _formatMinute(int minute) {
    if (minute == 24 * 60) return '24:00';
    final hour = minute ~/ 60;
    final rest = minute % 60;
    return '${hour.toString().padLeft(2, '0')}:'
        '${rest.toString().padLeft(2, '0')}';
  }
}
