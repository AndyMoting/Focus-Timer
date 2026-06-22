import 'package:flutter/material.dart';

class _IconOption {
  final String name;
  final IconData icon;

  const _IconOption(this.name, this.icon);
}

const defaultGroupIconCodePoint = 0xf428;

const _groupIconOptions = [
  _IconOption('待办', Icons.task_alt_outlined),
  _IconOption('清单', Icons.checklist_outlined),
  _IconOption('学习', Icons.school_outlined),
  _IconOption('工作', Icons.work_outline),
  _IconOption('日程', Icons.event_note_outlined),
  _IconOption('目标', Icons.track_changes_outlined),
  _IconOption('书籍', Icons.menu_book_outlined),
  _IconOption('健身', Icons.fitness_center_outlined),
  _IconOption('生活', Icons.home_outlined),
  _IconOption('收藏', Icons.star_border),
  _IconOption('灵感', Icons.lightbulb_outline),
  _IconOption('文件', Icons.folder_outlined),
];

IconData groupIconData(int codePoint) {
  for (final option in _groupIconOptions) {
    if (option.icon.codePoint == codePoint) return option.icon;
  }
  return Icons.task_alt_outlined;
}

class IconSwatches extends StatelessWidget {
  final int selectedIcon;
  final int selectedColor;
  final ValueChanged<int> onChanged;

  const IconSwatches({
    super.key,
    required this.selectedIcon,
    required this.selectedColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tone = Color(selectedColor);
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _groupIconOptions.map((option) {
        final codePoint = option.icon.codePoint;
        final selected = selectedIcon == codePoint;
        return Tooltip(
          message: option.name,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onChanged(codePoint),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected
                    ? tone.withValues(alpha: 0.18)
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? tone : colorScheme.outlineVariant,
                  width: selected ? 2 : 1,
                ),
              ),
              child: Icon(
                option.icon,
                color: selected ? tone : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
