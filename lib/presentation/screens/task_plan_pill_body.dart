part of 'task_plan_screen.dart';

class _PlannedPillBody extends StatelessWidget {
  final TaskPlan plan;
  final String title;
  final Task? task;
  final Color color;
  final VoidCallback? onMore;

  const _PlannedPillBody({
    required this.plan,
    required this.title,
    required this.task,
    required this.color,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.46)),
        ),
        child: ClipRect(
          child: Row(
            children: [
              Container(
                width: 4,
                height: 28,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 8),
              if (task?.state == AppConstants.taskStateCompleted) ...[
                Icon(Icons.check_circle, size: 18, color: colorScheme.primary),
                const SizedBox(width: 7),
              ],
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              if (plan.durationMinutes > 0) ...[
                const SizedBox(width: 6),
                Text(
                  '${plan.durationMinutes}m',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(width: 2),
              IconButton(
                tooltip: '更多',
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 36,
                  height: 36,
                ),
                onPressed: onMore,
                icon: Icon(
                  Icons.more_horiz,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
