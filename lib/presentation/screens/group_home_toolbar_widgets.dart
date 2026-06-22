part of 'group_list_screen.dart';

class _QuietIconButton extends StatelessWidget {
  final String tooltip;
  final Widget icon;
  final VoidCallback onPressed;

  const _QuietIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: icon,
        splashRadius: 22,
        highlightColor: colorScheme.onSurface.withValues(alpha: 0.08),
        hoverColor: colorScheme.onSurface.withValues(alpha: 0.04),
        focusColor: colorScheme.onSurface.withValues(alpha: 0.06),
        onPressed: onPressed,
      ),
    );
  }
}
