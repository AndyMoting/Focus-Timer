part of 'task_plan_screen.dart';

class _PlanActionData {
  final IconData icon;
  final String label;
  final Color color;
  final FutureOr<void> Function()? onTap;

  const _PlanActionData({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class _PlanActionGrid extends StatelessWidget {
  final List<_PlanActionData> actions;

  const _PlanActionGrid({required this.actions});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 18,
        crossAxisSpacing: 10,
        mainAxisExtent: 82,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        final disabled = action.onTap == null;
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: action.onTap,
          child: Opacity(
            opacity: disabled ? 0.38 : 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: action.color.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(action.icon, color: action.color),
                ),
                const SizedBox(height: 7),
                Text(
                  action.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
