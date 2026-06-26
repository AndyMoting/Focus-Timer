import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/presentation/providers/countdown_provider.dart';
import 'package:focus_timer/presentation/providers/task_provider.dart';
import 'package:focus_timer/presentation/providers/theme_provider.dart';
import 'package:focus_timer/presentation/screens/day_countdown_screen.dart';
import 'package:focus_timer/presentation/screens/group_detail_screen.dart';
import 'package:focus_timer/presentation/screens/home_screen.dart';
import 'package:focus_timer/presentation/screens/stats_screen.dart';
import 'package:focus_timer/presentation/screens/task_plan_screen.dart';
import 'package:focus_timer/presentation/screens/task_undo_snackbar.dart';
import 'package:focus_timer/presentation/screens/todo_color_picker.dart';
import 'package:focus_timer/presentation/screens/trash_screen.dart';
import 'package:focus_timer/presentation/providers/timer_provider.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';
import 'package:focus_timer/shared/utils/date_utils.dart' as app_date;

part 'group_cards.dart';
part 'group_card_actions.dart';
part 'group_card_edit_sheets.dart';
part 'group_card_data_actions.dart';
part 'group_search_view.dart';
part 'group_done_view.dart';
part 'group_done_actions.dart';
part 'group_done_formatters.dart';
part 'group_done_edit_sheets.dart';
part 'group_done_rename_sheet.dart';
part 'group_done_detail_sheet.dart';
part 'group_done_move_sheet.dart';
part 'group_done_task_sheet.dart';
part 'group_done_task_action_sections.dart';
part 'group_done_timeline.dart';
part 'group_done_groups.dart';
part 'group_done_overview.dart';
part 'group_home_layouts.dart';
part 'group_countdown_card.dart';
part 'group_home_toolbar_widgets.dart';
part 'group_smart_views.dart';
part 'group_navigation_actions.dart';
part 'group_feedback_actions.dart';
part 'group_global_actions.dart';
part 'group_create_sheet.dart';

enum _TodoHomeMode { todo, done }

class GroupListScreen extends HookConsumerWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupListProvider);
    final hideCompleted = ref.watch(hideCompletedTasksProvider);
    final layout = ref.watch(todoHomeLayoutProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final searching = useState(false);
    final mode = useState(_TodoHomeMode.todo);
    final searchController = useTextEditingController();
    final searchQuery = useState('');
    final showingDone = mode.value == _TodoHomeMode.done;
    void closeSearch() {
      if (!searching.value) return;
      FocusManager.instance.primaryFocus?.unfocus();
      searching.value = false;
      searchController.clear();
      searchQuery.value = '';
    }

    useEffect(() {
      Future.microtask(() {
        if (!context.mounted) return;
        ref.read(groupListProvider.notifier).applyDailyReset();
      });
      return null;
    }, const []);

    return PopScope(
      canPop: !searching.value,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) closeSearch();
      },
      child: Scaffold(
        appBar: AppBar(
          title: searching.value
              ? TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: '搜索待办',
                    border: InputBorder.none,
                  ),
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  onChanged: (value) => searchQuery.value = value.trim(),
                )
              : _TodoHomeTitle(
                  mode: mode.value,
                  onChanged: (value) => mode.value = value,
                ),
          centerTitle: false,
          actions: [
            _QuietIconButton(
              tooltip: searching.value ? '关闭搜索' : '搜索',
              icon: Icon(searching.value ? Icons.close : Icons.search),
              onPressed: () {
                if (searching.value) {
                  closeSearch();
                } else {
                  searching.value = true;
                }
              },
            ),
            _QuietIconButton(
              tooltip: '计划模式',
              icon: const Icon(Icons.calendar_view_day_outlined),
              onPressed: () => _openPlanMode(context),
            ),
            _QuietIconButton(
              tooltip: '回收站',
              icon: const Icon(Icons.restore_from_trash_outlined),
              onPressed: () => _openTrash(context),
            ),
            _QuietIconButton(
              tooltip: layout == TodoHomeLayout.list ? '切换宫格模式' : '切换列表模式',
              icon: Icon(
                layout == TodoHomeLayout.list
                    ? Icons.view_module_outlined
                    : Icons.view_agenda_outlined,
              ),
              onPressed: () {
                final nextLayout = layout == TodoHomeLayout.list
                    ? TodoHomeLayout.grid
                    : TodoHomeLayout.list;
                ref.read(todoHomeLayoutProvider.notifier).state = nextLayout;
                final currentAppearance =
                    ref.read(appAppearanceProvider).valueOrNull ??
                    AppAppearanceSettings.defaults;
                ref
                    .read(appAppearanceProvider.notifier)
                    .save(
                      AppAppearanceSettings(
                        themeColor: currentAppearance.themeColor,
                        themeModeIndex: currentAppearance.themeModeIndex,
                        todoLayout: nextLayout == TodoHomeLayout.grid
                            ? 'grid'
                            : 'list',
                      ),
                    );
              },
            ),
            _QuietIconButton(
              tooltip: '更多',
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showGlobalActionSheet(
                context,
                ref,
                hideCompleted: hideCompleted,
              ),
            ),
          ],
        ),
        body: groupsAsync.when(
          data: (groups) {
            final query = searchQuery.value;
            if (searching.value) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: closeSearch,
                child: _TodoSearchResults(
                  query: query,
                  groups: groups,
                  tasksAsync: ref.watch(allTaskListProvider),
                ),
              );
            }

            if (showingDone) {
              return _CompletedTodoHomeList(
                groups: groups,
                tasksAsync: ref.watch(allTaskListProvider),
              );
            }

            if (groups.isEmpty) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 96),
                children: [
                  _CountdownHomeCard(
                    state: ref.watch(countdownProvider),
                    onTap: () => _openCountdown(context),
                  ),
                  const SizedBox(height: 72),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 64,
                          color: colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '还没有分组',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '先建一个分组，再往里面放待办',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: () => _showCreateSheet(context, ref),
                          icon: const Icon(Icons.add),
                          label: const Text('创建分组'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: _CountdownHomeCard(
                    state: ref.watch(countdownProvider),
                    onTap: () => _openCountdown(context),
                  ),
                ),
                _SmartViewsStrip(
                  groups: groups,
                  tasksAsync: ref.watch(allTaskListProvider),
                  plansAsync: ref.watch(
                    taskPlanProvider(
                      TaskPlanKey(dayNum: app_date.DateUtils.todayDayNum),
                    ),
                  ),
                ),
                Expanded(
                  child: _TodoHomeLayouts(
                    layout: layout,
                    groups: groups,
                    onReorder: (oldIndex, newIndex) => ref
                        .read(groupListProvider.notifier)
                        .reorderGroups(oldIndex, newIndex),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => const Center(child: Text('加载失败')),
        ),
        floatingActionButton: showingDone
            ? null
            : FloatingActionButton(
                onPressed: () => _showCreateSheet(context, ref),
                child: const Icon(Icons.add),
              ),
      ),
    );
  }
}
