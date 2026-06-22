import 'package:flutter/material.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/presentation/providers/theme_provider.dart';

Color effectiveTaskColor(Task task, Color fallback) {
  return task.color == null ? fallback : Color(task.color!);
}

class ColorSwatches extends StatelessWidget {
  final int selectedColor;
  final ValueChanged<int> onChanged;

  const ColorSwatches({
    super.key,
    required this.selectedColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: ThemeColors.presets.map((option) {
        final color = option.color.toARGB32();
        final selected = selectedColor == color;
        return Tooltip(
          message: option.name,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => onChanged(color),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: option.color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? colorScheme.onSurface
                      : colorScheme.outlineVariant,
                  width: selected ? 3 : 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: option.color.withValues(alpha: 0.35),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: selected
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class TaskColorSwatches extends StatelessWidget {
  final int? selectedColor;
  final int fallbackColor;
  final ValueChanged<int?> onChanged;

  const TaskColorSwatches({
    super.key,
    required this.selectedColor,
    required this.fallbackColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _TaskColorChip(
          label: '跟随分组',
          color: Color(fallbackColor),
          selected: selectedColor == null,
          onTap: () => onChanged(null),
        ),
        ...ThemeColors.presets.map((option) {
          final color = option.color.toARGB32();
          return _TaskColorChip(
            label: option.name,
            color: option.color,
            selected: selectedColor == color,
            onTap: () => onChanged(color),
          );
        }),
      ],
    );
  }
}

class _TaskColorChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _TaskColorChip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: label,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected
                  ? colorScheme.onSurface
                  : colorScheme.outlineVariant,
              width: selected ? 3 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.32),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: selected
              ? const Icon(Icons.check, size: 18, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}
