part of 'group_list_screen.dart';

class _CompletedGroupGrid extends StatelessWidget {
  final List<TaskList> groups;
  final Map<int, int> countsByGroup;
  final ValueChanged<TaskList> onOpenGroup;

  const _CompletedGroupGrid({
    required this.groups,
    required this.countsByGroup,
    required this.onOpenGroup,
  });

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) return const SizedBox.shrink();
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 720 ? 3 : 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(title: '分组', trailing: '${groups.length} 个'),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisExtent: 82,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            return _CompletedGroupTile(
              group: group,
              count: countsByGroup[group.id] ?? 0,
              onTap: () => onOpenGroup(group),
            );
          },
        ),
      ],
    );
  }
}

class _CompletedGroupTile extends StatelessWidget {
  final TaskList group;
  final int count;
  final VoidCallback onTap;

  const _CompletedGroupTile({
    required this.group,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final groupColor = Color(group.color);
    return Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: groupColor.withValues(alpha: 0.22),
                child: Icon(Icons.folder_outlined, color: groupColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  group.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$count',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
