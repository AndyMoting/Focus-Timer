part of 'group_detail_screen.dart';

class _GroupDetailTaskList extends ConsumerWidget {
  final AsyncValue<List<Task>> tasksAsync;
  final TaskList group;
  final ValueNotifier<Set<int>> selectedTaskIds;
  final bool selectionMode;

  const _GroupDetailTaskList({
    required this.tasksAsync,
    required this.group,
    required this.selectedTaskIds,
    required this.selectionMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final groupColor = Color(group.color);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (!selectionMode) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: tasksAsync.when(
        data: (tasks) {
          final visibleTasks = tasks
              .where((t) => t.state != AppConstants.taskStateCompleted)
              .toList();
          final visibleIds = visibleTasks.map((task) => task.id).toSet();
          final cleanedSelection = selectedTaskIds.value
              .where(visibleIds.contains)
              .toSet();
          if (cleanedSelection.length != selectedTaskIds.value.length) {
            selectedTaskIds.value = cleanedSelection;
          }

          if (visibleTasks.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 88),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.task_alt, size: 64, color: colorScheme.outline),
                    const SizedBox(height: 16),
                    Text(
                      '还没有待办哦',
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ReorderableListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 104),
            itemCount: visibleTasks.length,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            buildDefaultDragHandles: false,
            onReorderItem: (oldIndex, newIndex) {
              if (selectionMode) return;
              ref
                  .read(taskListProvider(group.id).notifier)
                  .reorderTasks(
                    oldIndex: oldIndex,
                    newIndex: newIndex,
                    hideCompleted: true,
                  );
            },
            proxyDecorator: (child, index, animation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  final elevation = Tween<double>(
                    begin: 0,
                    end: 8,
                  ).evaluate(animation);
                  return Material(
                    elevation: elevation,
                    color: Colors.transparent,
                    child: child,
                  );
                },
                child: child,
              );
            },
            itemBuilder: (_, i) {
              final task = visibleTasks[i];
              final selected = selectedTaskIds.value.contains(task.id);
              final taskColor = effectiveTaskColor(task, groupColor);
              final tile = ListTile(
                selected: selected,
                leading: Checkbox(
                  value: selectionMode
                      ? selected
                      : task.state == AppConstants.taskStateCompleted,
                  activeColor: taskColor,
                  onChanged: (_) {
                    if (selectionMode) {
                      _toggleSelectedTask(selectedTaskIds, task.id);
                    } else {
                      ref
                          .read(taskListProvider(group.id).notifier)
                          .toggleComplete(task.id);
                    }
                  },
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    color: taskColor,
                    decoration: task.state == AppConstants.taskStateCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                subtitle: _TaskMetaLine(task: task),
                trailing: selectionMode
                    ? null
                    : IconButton(
                        tooltip: '更多',
                        icon: Icon(
                          Icons.more_horiz,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () =>
                            _showTaskActionSheet(context, ref, group, task),
                      ),
                onTap: () {
                  if (selectionMode) {
                    _toggleSelectedTask(selectedTaskIds, task.id);
                  } else {
                    _showTaskActionSheet(context, ref, group, task);
                  }
                },
                onLongPress: () =>
                    _toggleSelectedTask(selectedTaskIds, task.id),
              );
              final child = selectionMode
                  ? tile
                  : ReorderableDelayedDragStartListener(index: i, child: tile);
              return Dismissible(
                key: Key('task-${task.id}'),
                direction: selectionMode
                    ? DismissDirection.none
                    : DismissDirection.endToStart,
                onDismissed: (_) =>
                    _deleteTaskWithUndo(context, ref, group, task),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.transparent,
                  child: Container(
                    width: 54,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: colorScheme.error.withValues(alpha: 0.28),
                      ),
                    ),
                    child: Icon(Icons.delete_outline, color: colorScheme.error),
                  ),
                ),
                child: child,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text('加载失败')),
      ),
    );
  }
}
