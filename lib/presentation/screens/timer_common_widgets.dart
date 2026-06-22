import 'package:flutter/material.dart';

class TimerSectionHeader extends StatelessWidget {
  final String title;

  const TimerSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class TimerStatItem extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colorScheme;

  const TimerStatItem({
    super.key,
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
