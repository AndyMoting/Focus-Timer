part of 'group_list_screen.dart';

class _CompletedTodoHomeList extends ConsumerWidget {
  final List<TaskList> groups;
  final AsyncValue<List<Task>> tasksAsync;

  const _CompletedTodoHomeList({
    required this.groups,
    required this.tasksAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final groupsById = {for (final group in groups) group.id: group};
    return tasksAsync.when(
      data: (tasks) {
        final completedTasks =
            tasks
                .where((task) => task.state == AppConstants.taskStateCompleted)
                .toList()
              ..sort(
                (a, b) => (b.completedAt ?? 0).compareTo(a.completedAt ?? 0),
              );

        if (completedTasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.task_alt, size: 64, color: colorScheme.outline),
                const SizedBox(height: 16),
                Text(
                  '还没有已办待办',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        final countsByGroup = <int, int>{};
        for (final task in completedTasks) {
          countsByGroup.update(
            task.listId,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          children: [
            _CompletedOverviewCard(tasks: completedTasks),
            const SizedBox(height: 16),
            _CompletedGroupGrid(
              groups: groups,
              countsByGroup: countsByGroup,
              onOpenGroup: (group) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => _CompletedGroupScreen(group: group),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _SectionLabel(
              title: '完成记录',
              trailing: '${completedTasks.length} 项',
            ),
            const SizedBox(height: 8),
            _CompletedTimeline(
              tasks: completedTasks,
              groupsById: groupsById,
              onOpenTask: (task) => _showCompletedTaskActionSheet(
                context,
                ref,
                task,
                groupsById[task.listId],
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const Center(child: Text('已办加载失败')),
    );
  }
}

class _CompletedGroupScreen extends ConsumerWidget {
  final TaskList group;

  const _CompletedGroupScreen({required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(allTaskListProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: '添加待办',
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GroupDetailScreen(group: group),
              ),
            ),
          ),
        ],
      ),
      body: tasksAsync.when(
        data: (tasks) {
          final completedTasks =
              tasks
                  .where(
                    (task) =>
                        task.listId == group.id &&
                        task.state == AppConstants.taskStateCompleted,
                  )
                  .toList()
                ..sort(
                  (a, b) => (b.completedAt ?? 0).compareTo(a.completedAt ?? 0),
                );

          if (completedTasks.isEmpty) {
            return Center(
              child: Text(
                '这个分组还没有已办记录',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
            children: [
              _SectionLabel(
                title: '完成记录',
                trailing: '${completedTasks.length} 项',
              ),
              const SizedBox(height: 8),
              _CompletedTimeline(
                tasks: completedTasks,
                groupsById: {group.id: group},
                onOpenTask: (task) =>
                    _showCompletedTaskActionSheet(context, ref, task, group),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text('已办加载失败')),
      ),
    );
  }
}
