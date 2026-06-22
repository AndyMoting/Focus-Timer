part of 'group_list_screen.dart';

void _showCreateSheet(BuildContext context, WidgetRef ref) {
  final controller = TextEditingController();
  var selectedColor = Theme.of(context).colorScheme.primary.toARGB32();
  var selectedIcon = defaultGroupIconCodePoint;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
          return AnimatedPadding(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: bottomInset),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '创建分组',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        hintText: '如：数学',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _createGroupFromSheet(
                        sheetContext,
                        ref,
                        controller,
                        selectedColor,
                        selectedIcon,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ColorSwatches(
                      selectedColor: selectedColor,
                      onChanged: (color) =>
                          setState(() => selectedColor = color),
                    ),
                    const SizedBox(height: 14),
                    IconSwatches(
                      selectedIcon: selectedIcon,
                      selectedColor: selectedColor,
                      onChanged: (icon) => setState(() => selectedIcon = icon),
                    ),
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      onPressed: () => _createGroupFromSheet(
                        sheetContext,
                        ref,
                        controller,
                        selectedColor,
                        selectedIcon,
                      ),
                      icon: const Icon(Icons.check),
                      label: const Text('创建'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  ).whenComplete(controller.dispose);
}

void _createGroupFromSheet(
  BuildContext sheetContext,
  WidgetRef ref,
  TextEditingController controller,
  int color,
  int iconCodePoint,
) {
  final name = controller.text.trim();
  if (name.isEmpty) return;
  ref
      .read(groupListProvider.notifier)
      .createGroup(name, color: color, iconCodePoint: iconCodePoint);
  Navigator.pop(sheetContext);
}
