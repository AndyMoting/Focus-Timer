import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/domain/repositories/task_repository.dart';
import 'package:focus_timer/presentation/providers/task_provider.dart';
import 'package:focus_timer/presentation/providers/timer_provider.dart';
import 'package:focus_timer/presentation/screens/home_screen.dart';
import 'package:focus_timer/presentation/screens/task_plan_screen.dart';
import 'package:focus_timer/presentation/screens/timer_setup_sheets.dart';
import 'package:focus_timer/presentation/screens/timer_ui_helpers.dart';
import 'package:focus_timer/presentation/screens/todo_color_picker.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';

part 'group_detail_widgets.dart';
part 'group_detail_task_list.dart';
part 'group_detail_bottom_bar.dart';
part 'group_detail_basic_actions.dart';
part 'group_detail_batch_actions.dart';
part 'group_detail_task_actions.dart';
part 'group_detail_task_action_sections.dart';
part 'group_detail_timer_actions.dart';
part 'group_detail_task_sheets.dart';
part 'group_detail_task_detail_sheet.dart';
part 'group_detail_task_color_sheet.dart';
part 'group_detail_task_move_sheet.dart';
part 'group_detail_task_delete_actions.dart';
part 'group_detail_task_formatters.dart';

class GroupDetailScreen extends HookConsumerWidget {
  final TaskList group;
  const GroupDetailScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskListProvider(group.id));
    final inputController = useTextEditingController();
    final inputFocusNode = useFocusNode();
    useListenable(inputFocusNode);
    final selectedTaskIds = useState<Set<int>>(<int>{});
    final selectionMode = selectedTaskIds.value.isNotEmpty;

    return PopScope(
      canPop: !selectionMode && !inputFocusNode.hasFocus,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (inputFocusNode.hasFocus) {
          inputFocusNode.unfocus();
          return;
        }
        if (selectionMode) {
          selectedTaskIds.value = <int>{};
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            selectionMode ? '${selectedTaskIds.value.length} 已选' : group.name,
          ),
          centerTitle: false,
          leading: IconButton(
            icon: Icon(selectionMode ? Icons.close : Icons.arrow_back),
            onPressed: () {
              if (inputFocusNode.hasFocus) {
                inputFocusNode.unfocus();
                return;
              }
              if (selectionMode) {
                selectedTaskIds.value = <int>{};
              } else {
                Navigator.pop(context);
              }
            },
          ),
          actions: selectionMode
              ? [
                  IconButton(
                    tooltip: '全选',
                    icon: const Icon(Icons.select_all),
                    onPressed: () {
                      final tasks = tasksAsync.valueOrNull ?? const <Task>[];
                      selectedTaskIds.value = tasks
                          .where(
                            (task) =>
                                task.state != AppConstants.taskStateCompleted,
                          )
                          .map((task) => task.id)
                          .toSet();
                    },
                  ),
                ]
              : [
                  IconButton(
                    tooltip: '计划模式',
                    icon: const Icon(Icons.calendar_view_day_outlined),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskPlanScreen.forGroup(group: group),
                      ),
                    ),
                  ),
                ],
        ),
        body: _GroupDetailTaskList(
          tasksAsync: tasksAsync,
          group: group,
          selectedTaskIds: selectedTaskIds,
          selectionMode: selectionMode,
        ),
        bottomNavigationBar: _GroupDetailBottomBar(
          group: group,
          inputController: inputController,
          inputFocusNode: inputFocusNode,
          selectedTaskIds: selectedTaskIds,
          selectionMode: selectionMode,
        ),
      ),
    );
  }
}
