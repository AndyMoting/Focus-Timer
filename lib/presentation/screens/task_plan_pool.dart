part of 'task_plan_screen.dart';

class _TaskPool extends StatelessWidget {
  final String title;
  final List<Task> tasks;
  final Map<int, Color> taskColorsByListId;
  final Future<void> Function(TaskPlan plan) onAcceptPlan;
  final ValueNotifier<double> dragX;

  const _TaskPool({
    required this.title,
    required this.tasks,
    required this.taskColorsByListId,
    required this.onAcceptPlan,
    required this.dragX,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DragTarget<TaskPlan>(
      onAcceptWithDetails: (details) => onAcceptPlan(details.data),
      builder: (context, candidatePlans, _) {
        final isDeleting = candidatePlans.isNotEmpty;
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            border: Border(
              right: BorderSide(
                color: isDeleting
                    ? colorScheme.error
                    : colorScheme.outlineVariant,
                width: isDeleting ? 1.2 : 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 2),
                child: Text(
                  isDeleting ? '松手删除' : title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isDeleting
                        ? colorScheme.error
                        : colorScheme.onSurface,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
                child: Text(
                  isDeleting ? '把任务拖回来，只删计划' : '按住拎出，右移添加，左移删除',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDeleting
                        ? colorScheme.error
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (isDeleting)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '松手删除',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: tasks.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            '暂无待办',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
                        itemCount: tasks.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          final taskColor = _effectiveTaskColor(
                            task,
                            taskColorsByListId[task.listId] ??
                                colorScheme.primary,
                          );
                          return _DraggableTaskChip(
                            task: task,
                            color: taskColor,
                            dragX: dragX,
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DraggableTaskChip extends StatelessWidget {
  final Task task;
  final Color color;
  final ValueNotifier<double> dragX;

  const _DraggableTaskChip({
    required this.task,
    required this.color,
    required this.dragX,
  });

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<Task>(
      data: task,
      dragAnchorStrategy: childDragAnchorStrategy,
      onDragStarted: () {
        dragX.value = MediaQuery.sizeOf(context).width * 0.18;
      },
      onDragUpdate: (details) {
        dragX.value = details.globalPosition.dx;
      },
      onDragEnd: (_) {
        dragX.value = 0;
      },
      onDraggableCanceled: (_, _) {
        dragX.value = 0;
      },
      feedback: _DragFeedback(label: task.title, color: color, dragX: dragX),
      childWhenDragging: Opacity(
        opacity: 0.45,
        child: _TaskChip(task: task, color: color),
      ),
      child: _TaskChip(task: task, color: color),
    );
  }
}

class _TaskChip extends StatelessWidget {
  final Task task;
  final Color color;

  const _TaskChip({required this.task, required this.color});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final todayNum = DateTime.now().difference(DateTime(1970)).inDays;
    final dueNum = task.dueDayNum;
    final isOverdue = dueNum != null && dueNum < todayNum;
    final isDueToday = dueNum != null && dueNum == todayNum;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.38)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 34,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (isOverdue)
                  Text(
                    '逾期',
                    style: TextStyle(fontSize: 11, color: colorScheme.error),
                  )
                else if (isDueToday)
                  Text(
                    '今日截止',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
