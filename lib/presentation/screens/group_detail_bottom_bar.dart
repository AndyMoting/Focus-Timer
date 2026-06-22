part of 'group_detail_screen.dart';

class _GroupDetailBottomBar extends ConsumerWidget {
  final TaskList group;
  final TextEditingController inputController;
  final FocusNode inputFocusNode;
  final ValueNotifier<Set<int>> selectedTaskIds;
  final bool selectionMode;

  const _GroupDetailBottomBar({
    required this.group,
    required this.inputController,
    required this.inputFocusNode,
    required this.selectedTaskIds,
    required this.selectionMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: selectionMode ? 0 : MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SafeArea(
        top: false,
        child: selectionMode
            ? _BatchActionBar(
                selectedCount: selectedTaskIds.value.length,
                onComplete: () => _completeSelectedTasks(
                  context,
                  ref,
                  group,
                  selectedTaskIds,
                ),
                onMove: () => _showMoveSelectedTasksSheet(
                  context,
                  ref,
                  group,
                  selectedTaskIds,
                ),
                onDelete: () => _confirmDeleteSelectedTasks(
                  context,
                  ref,
                  group,
                  selectedTaskIds,
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border(
                    top: BorderSide(color: colorScheme.outlineVariant),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: inputController,
                        focusNode: inputFocusNode,
                        decoration: const InputDecoration(
                          hintText: '输入待办',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onTapOutside: (_) => inputFocusNode.unfocus(),
                        onSubmitted: (v) =>
                            _submitTask(v, ref, group, inputController),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => _submitTask(
                        inputController.text,
                        ref,
                        group,
                        inputController,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
