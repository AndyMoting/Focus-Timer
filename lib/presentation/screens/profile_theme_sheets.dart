part of 'profile_screen.dart';

void _showThemePicker(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: ThemeColors.presets.map((option) {
            final current = ref.read(themeColorProvider);
            return ChoiceChip(
              label: Text(option.name),
              selected: current == option.color,
              onSelected: (_) {
                ref.read(themeColorProvider.notifier).state = option.color;
                final currentAppearance =
                    ref.read(appAppearanceProvider).valueOrNull ??
                    AppAppearanceSettings.defaults;
                ref.read(appAppearanceProvider.notifier).save(
                  AppAppearanceSettings(
                    themeColor: option.color.toARGB32(),
                    themeModeIndex: currentAppearance.themeModeIndex,
                    todoLayout: currentAppearance.todoLayout,
                  ),
                );
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    ),
  );
}

void _showThemeModePicker(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      final current = ref.read(themeModeProvider);
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((mode) {
            final selected = mode == current;
            return ListTile(
              title: Text(themeModeLabel(mode)),
              trailing: selected ? const Icon(Icons.check) : null,
              onTap: () {
                ref.read(themeModeProvider.notifier).state = mode;
                final currentAppearance =
                    ref.read(appAppearanceProvider).valueOrNull ??
                    AppAppearanceSettings.defaults;
                ref.read(appAppearanceProvider.notifier).save(
                  AppAppearanceSettings(
                    themeColor: currentAppearance.themeColor,
                    themeModeIndex: mode.index,
                    todoLayout: currentAppearance.todoLayout,
                  ),
                );
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      );
    },
  );
}
