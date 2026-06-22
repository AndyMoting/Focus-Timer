import 'package:flutter/material.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/presentation/screens/todo_color_swatches.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';

class TaskPreviewLine extends StatelessWidget {
  final Task task;
  final Color groupColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const TaskPreviewLine({
    super.key,
    required this.task,
    required this.groupColor,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final completed = task.state == AppConstants.taskStateCompleted;
    final accent = effectiveTaskColor(task, groupColor);
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Row(
          children: [
            Icon(
              completed
                  ? Icons.check_circle_outline
                  : Icons.radio_button_unchecked,
              size: 14,
              color: completed ? colorScheme.outline : accent,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                task.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: completed
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurface,
                  decoration: completed ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
