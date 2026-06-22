import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/data/repositories/task_repository_impl.dart';
import 'package:focus_timer/domain/models/task_plan_settings.dart';
import 'package:focus_timer/domain/repositories/task_repository.dart';
import 'package:focus_timer/presentation/providers/database_provider.dart';
import 'package:focus_timer/presentation/providers/theme_provider.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';
import 'package:focus_timer/shared/services/background_timer_service.dart';
import 'package:focus_timer/shared/utils/date_utils.dart' as app_date;

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final db = ref.read(databaseProvider);
  return TaskRepositoryImpl(db);
});

final hideCompletedTasksProvider = StateProvider<bool>((ref) => true);

enum TodoHomeLayout { list, grid }

final todoHomeLayoutProvider = StateProvider<TodoHomeLayout>(
  (ref) {
    final appearance = ref.watch(appAppearanceProvider).valueOrNull;
    return appearance?.todoLayout == 'grid'
        ? TodoHomeLayout.grid
        : TodoHomeLayout.list;
  },
);

const _preserveTaskColor = Object();

class GroupNotifier extends StateNotifier<AsyncValue<List<TaskList>>> {
  final TaskRepository _repo;
  final Ref _ref;

  GroupNotifier(this._repo, this._ref) : super(const AsyncValue.loading()) {
    loadGroups();
  }

  Future<void> loadGroups() async {
    state = await AsyncValue.guard(() => _repo.getActiveLists());
  }

  Future<int> rescheduleFutureReminders() async {
    final tasks = await _repo.getFutureReminderTasks();
    var scheduled = 0;
    for (final task in tasks) {
      final reminderAt = task.reminderAt;
      if (reminderAt == null) continue;
      await BackgroundTimerService().scheduleTaskReminder(
        taskId: task.id,
        title: task.title,
        reminderAtMs: reminderAt,
      );
      scheduled++;
    }
    return scheduled;
  }

  Future<int> applyDailyReset() async {
    final resetCount = await _repo.applyDailyReset(
      app_date.DateUtils.todayDayNum,
    );
    if (resetCount > 0) {
      await loadGroups();
      _ref.invalidate(taskListProvider);
      _ref.invalidate(allTaskListProvider);
    }
    return resetCount;
  }

  Future<void> createGroup(
    String name, {
    int color = 0xFF4F6FA8,
    int iconCodePoint = 0xf428,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _repo.createList(
      TaskListsCompanion.insert(
        name: name,
        color: Value(color),
        iconCodePoint: Value(iconCodePoint),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await loadGroups();
  }

  Future<void> renameGroup(int id, String name) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _repo.updateList(
      TaskListsCompanion(
        id: Value(id),
        name: Value(name),
        updatedAt: Value(now),
      ),
    );
    await loadGroups();
  }

  Future<void> changeColor(int id, int color) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _repo.updateList(
      TaskListsCompanion(
        id: Value(id),
        color: Value(color),
        updatedAt: Value(now),
      ),
    );
    await loadGroups();
  }

  Future<void> changeIcon(int id, int iconCodePoint) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _repo.updateList(
      TaskListsCompanion(
        id: Value(id),
        iconCodePoint: Value(iconCodePoint),
        updatedAt: Value(now),
      ),
    );
    await loadGroups();
  }

  Future<void> toggleDailyReset(int id, bool enable) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _repo.updateList(
      TaskListsCompanion(
        id: Value(id),
        isDailyReset: Value(enable ? 1 : 0),
        updatedAt: Value(now),
      ),
    );
    await loadGroups();
  }

  Future<void> completeAllTasks() async {
    await _repo.completeAllActiveTasks();
    await loadGroups();
  }

  Future<List<int>> moveEmptyGroupsToTrash() async {
    final deletedIds = await _repo.softDeleteEmptyLists();
    await _cancelRemindersForGroupIds(deletedIds);
    await loadGroups();
    await _ref.read(trashProvider.notifier).loadDeletedGroups();
    return deletedIds;
  }

  Future<List<int>> moveAllGroupsToTrash() async {
    final deletedIds = await _repo.softDeleteAllLists();
    await _cancelRemindersForGroupIds(deletedIds);
    await loadGroups();
    await _ref.read(trashProvider.notifier).loadDeletedGroups();
    return deletedIds;
  }

  Future<List<int>> moveToTrash(int id) async {
    await _repo.softDeleteList(id);
    await _cancelRemindersForGroupIds([id]);
    await loadGroups();
    await _ref.read(trashProvider.notifier).loadDeletedGroups();
    return [id];
  }

  Future<void> restoreGroups(List<int> ids) async {
    for (final id in ids) {
      await _repo.restoreList(id);
    }
    await rescheduleFutureReminders();
    await loadGroups();
    await _ref.read(trashProvider.notifier).loadDeletedGroups();
  }

  Future<void> cloneGroup(TaskList group) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final newId = await _repo.createList(
      TaskListsCompanion.insert(
        name: '${group.name} 副本',
        color: Value(group.color),
        iconCodePoint: Value(group.iconCodePoint),
        sortOrder: Value(group.sortOrder + 1),
        isDailyReset: Value(group.isDailyReset),
        createdAt: now,
        updatedAt: now,
      ),
    );
    final tasks = await _repo.getTasksByList(group.id);
    for (final task in tasks) {
      await _repo.createTask(
        TasksCompanion.insert(
          listId: newId,
          dayNum: task.dayNum,
          title: task.title,
          description: Value(task.description),
          color: Value(task.color),
          state: Value(task.state),
          priority: Value(task.priority),
          dueDayNum: Value(task.dueDayNum),
          estimatedMinutes: Value(task.estimatedMinutes),
          isFocus: Value(task.isFocus),
          isPinned: Value(task.isPinned),
          pinnedAt: Value(task.pinnedAt),
          reminderAt: Value(task.reminderAt),
          repeatRule: Value(task.repeatRule),
          sortOrder: Value(task.sortOrder),
          createdAt: now,
          updatedAt: now,
          completedAt: Value(task.completedAt),
        ),
      );
    }
    await loadGroups();
  }

  Future<void> reorderGroups(int oldIndex, int newIndex) async {
    final groups = state.valueOrNull;
    if (groups == null) return;
    if (oldIndex < 0 ||
        oldIndex >= groups.length ||
        newIndex < 0 ||
        newIndex > groups.length) {
      return;
    }
    final draft = [...groups];
    final moved = draft.removeAt(oldIndex);
    draft.insert(newIndex, moved);
    await _repo.reorderLists([for (final group in draft) group.id]);
    await loadGroups();
  }

  Future<void> _cancelRemindersForGroupIds(List<int> groupIds) async {
    for (final groupId in groupIds) {
      final tasks = await _repo.getTasksByList(groupId);
      for (final task in tasks) {
        await BackgroundTimerService().cancelTaskReminder(task.id);
      }
    }
  }
}

final groupListProvider =
    StateNotifierProvider<GroupNotifier, AsyncValue<List<TaskList>>>((ref) {
      final repo = ref.watch(taskRepositoryProvider);
      return GroupNotifier(repo, ref);
    });

class TrashNotifier extends StateNotifier<AsyncValue<List<TaskList>>> {
  final TaskRepository _repo;
  final Ref _ref;

  TrashNotifier(this._repo, this._ref) : super(const AsyncValue.loading()) {
    loadDeletedGroups();
  }

  Future<void> loadDeletedGroups() async {
    state = await AsyncValue.guard(() => _repo.getDeletedLists());
  }

  Future<void> restoreGroup(int id) async {
    await _repo.restoreList(id);
    await _ref.read(groupListProvider.notifier).rescheduleFutureReminders();
    await loadDeletedGroups();
    await _ref.read(groupListProvider.notifier).loadGroups();
    await _ref.read(allTaskListProvider.notifier).loadTasks();
  }

  Future<void> deleteGroupForever(int id) async {
    final tasks = await _repo.getTasksByList(id);
    for (final task in tasks) {
      await BackgroundTimerService().cancelTaskReminder(task.id);
    }
    await _repo.permanentDeleteList(id);
    await loadDeletedGroups();
    await _ref.read(groupListProvider.notifier).loadGroups();
    await _ref.read(allTaskListProvider.notifier).loadTasks();
    _ref.invalidate(taskPlanProvider);
  }
}

final trashProvider =
    StateNotifierProvider<TrashNotifier, AsyncValue<List<TaskList>>>((ref) {
      final repo = ref.watch(taskRepositoryProvider);
      return TrashNotifier(repo, ref);
    });

class TaskNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final TaskRepository _repo;
  final Ref _ref;
  final int _listId;

  TaskNotifier(this._repo, this._ref, this._listId)
    : super(const AsyncValue.loading()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    state = await AsyncValue.guard(() => _repo.getTasksByList(_listId));
  }

  Future<void> createTask(String title) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final existingTasks =
        state.valueOrNull ?? await _repo.getTasksByList(_listId);
    var nextSortOrder = 0;
    for (final task in existingTasks) {
      if (task.sortOrder >= nextSortOrder) {
        nextSortOrder = task.sortOrder + 1;
      }
    }
    final task = TasksCompanion.insert(
      listId: _listId,
      dayNum: DateTime.now().difference(DateTime(1970)).inDays,
      title: title,
      sortOrder: Value(nextSortOrder),
      createdAt: now,
      updatedAt: now,
    );
    await _repo.createTask(task);
    await _refreshTaskViews();
  }

  Future<void> toggleComplete(int id) async {
    final tasks = state.valueOrNull ?? await _repo.getTasksByList(_listId);
    try {
      final task = tasks.firstWhere((t) => t.id == id);
      if (task.state == AppConstants.taskStateCompleted) {
        await _repo.uncompleteTask(id);
        await _scheduleTaskReminderIfNeeded(
          task.copyWith(state: AppConstants.taskStateNormal),
        );
      } else {
        await _repo.completeTask(id);
        await BackgroundTimerService().cancelTaskReminder(id);
        await _createNextRepeatedTask(task);
      }
      await _refreshTaskViews();
    } catch (_) {}
  }

  Future<void> completeIfActive(int id) async {
    final tasks = state.valueOrNull ?? await _repo.getTasksByList(_listId);
    final task = tasks.where((item) => item.id == id).firstOrNull;
    if (task == null || task.state == AppConstants.taskStateCompleted) return;
    await _repo.completeTask(id);
    await BackgroundTimerService().cancelTaskReminder(id);
    await _createNextRepeatedTask(task);
    await _refreshTaskViews();
  }

  Future<void> renameTask(int id, String title) async {
    final normalized = title.trim();
    if (normalized.isEmpty) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    await _repo.updateTask(
      TasksCompanion(
        id: Value(id),
        title: Value(normalized),
        updatedAt: Value(now),
      ),
    );
    await _refreshTaskViews();
  }

  Future<void> updateTaskDetails(
    int id, {
    required String title,
    String? description,
    required int priority,
    int? dueDayNum,
    required int estimatedMinutes,
    required bool isFocus,
    required bool isPinned,
    int? reminderAt,
    String repeatRule = 'none',
    Object? color = _preserveTaskColor,
  }) async {
    final normalized = title.trim();
    if (normalized.isEmpty) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    await _repo.updateTask(
      TasksCompanion(
        id: Value(id),
        title: Value(normalized),
        description: Value(
          description == null || description.trim().isEmpty
              ? null
              : description.trim(),
        ),
        priority: Value(priority),
        dueDayNum: Value(dueDayNum),
        estimatedMinutes: Value(estimatedMinutes),
        isFocus: Value(isFocus ? 1 : 0),
        isPinned: Value(isPinned ? 1 : 0),
        pinnedAt: Value(isPinned ? now : null),
        reminderAt: Value(reminderAt),
        repeatRule: Value(_normalizeRepeatRule(repeatRule)),
        color: color == _preserveTaskColor
            ? const Value.absent()
            : Value(color as int?),
        updatedAt: Value(now),
      ),
    );
    if (reminderAt == null) {
      await BackgroundTimerService().cancelTaskReminder(id);
    } else {
      await BackgroundTimerService().scheduleTaskReminder(
        taskId: id,
        title: normalized,
        reminderAtMs: reminderAt,
      );
    }
    await _refreshTaskViews();
  }

  Future<void> changeTaskColor(int id, int? color) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _repo.updateTask(
      TasksCompanion(id: Value(id), color: Value(color), updatedAt: Value(now)),
    );
    await _refreshTaskViews();
  }

  Future<void> toggleFocus(int id) async {
    final tasks = state.valueOrNull;
    if (tasks == null) return;
    final task = tasks.where((item) => item.id == id).firstOrNull;
    if (task == null) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    await _repo.updateTask(
      TasksCompanion(
        id: Value(id),
        isFocus: Value(task.isFocus == 1 ? 0 : 1),
        updatedAt: Value(now),
      ),
    );
    await _refreshTaskViews();
  }

  Future<void> togglePinned(int id) async {
    final tasks = state.valueOrNull ?? await _repo.getTasksByList(_listId);
    final task = tasks.where((item) => item.id == id).firstOrNull;
    if (task == null) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    final pinned = task.isPinned != 1;
    await _repo.updateTask(
      TasksCompanion(
        id: Value(id),
        isPinned: Value(pinned ? 1 : 0),
        pinnedAt: Value(pinned ? now : null),
        updatedAt: Value(now),
      ),
    );
    await _refreshTaskViews();
  }

  Future<void> duplicateTask(int id) async {
    await _repo.cloneTask(id);
    await _refreshTaskViews();
  }

  Future<void> moveTaskToGroup(int id, int targetListId) async {
    final targetTasks = await _repo.getTasksByList(targetListId);
    var sortOrder = 0;
    for (final task in targetTasks) {
      if (task.sortOrder >= sortOrder) sortOrder = task.sortOrder + 1;
    }
    await _repo.moveTaskToList(id, targetListId, sortOrder);
    await _refreshTaskViews();
    _ref.invalidate(taskPlanProvider);
  }

  Future<DeletedTaskSnapshot?> deleteTask(int id) async {
    final snapshot = await _repo.deleteTask(id);
    if (snapshot != null) {
      await BackgroundTimerService().cancelTaskReminder(id);
    }
    await _refreshTaskViews();
    _ref.invalidate(taskPlanProvider);
    return snapshot;
  }

  Future<void> restoreDeletedTask(DeletedTaskSnapshot snapshot) async {
    await _repo.restoreDeletedTask(snapshot);
    await _scheduleTaskReminderIfNeeded(snapshot.task);
    await _refreshTaskViews();
    _ref.invalidate(taskPlanProvider);
  }

  Future<void> reorderTasks({
    required int oldIndex,
    required int newIndex,
    required bool hideCompleted,
  }) async {
    final currentTasks = state.valueOrNull;
    if (currentTasks == null) return;

    final visibleTasks = hideCompleted
        ? currentTasks
              .where((t) => t.state != AppConstants.taskStateCompleted)
              .toList()
        : [...currentTasks];
    if (oldIndex < 0 ||
        oldIndex >= visibleTasks.length ||
        newIndex < 0 ||
        newIndex > visibleTasks.length) {
      return;
    }

    final movedTask = visibleTasks.removeAt(oldIndex);
    visibleTasks.insert(newIndex, movedTask);

    final hiddenCompletedTasks = hideCompleted
        ? currentTasks
              .where((t) => t.state == AppConstants.taskStateCompleted)
              .toList()
        : const <Task>[];
    await _repo.reorderTasks(_listId, [
      for (final task in visibleTasks) task.id,
      for (final task in hiddenCompletedTasks) task.id,
    ]);
    await _refreshTaskViews();
  }

  Future<void> _refreshTaskViews() async {
    await loadTasks();
    await _ref.read(allTaskListProvider.notifier).loadTasks();
  }

  Future<void> _createNextRepeatedTask(Task source) async {
    if (source.repeatRule == 'none') return;
    final nextDueDayNum = _nextRepeatDayNum(source);
    if (nextDueDayNum == null) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    final currentTasks =
        state.valueOrNull ?? await _repo.getTasksByList(_listId);
    var nextSortOrder = 0;
    for (final task in currentTasks) {
      if (task.sortOrder >= nextSortOrder) nextSortOrder = task.sortOrder + 1;
    }
    final reminderAt = _nextReminderAt(source, nextDueDayNum);
    final newTaskId = await _repo.createTask(
      TasksCompanion.insert(
        listId: source.listId,
        dayNum: nextDueDayNum,
        title: source.title,
        description: Value(source.description),
        color: Value(source.color),
        priority: Value(source.priority),
        dueDayNum: Value(nextDueDayNum),
        estimatedMinutes: Value(source.estimatedMinutes),
        isFocus: Value(source.isFocus),
        isPinned: const Value(0),
        pinnedAt: const Value(null),
        reminderAt: Value(reminderAt),
        repeatRule: Value(source.repeatRule),
        sortOrder: Value(nextSortOrder),
        createdAt: now,
        updatedAt: now,
      ),
    );
    if (reminderAt != null) {
      await BackgroundTimerService().scheduleTaskReminder(
        taskId: newTaskId,
        title: source.title,
        reminderAtMs: reminderAt,
      );
    }
  }

  int? _nextRepeatDayNum(Task source) {
    final base = source.dueDayNum ?? source.dayNum;
    return switch (source.repeatRule) {
      'daily' => base + 1,
      'weekly' => base + 7,
      'monthly' => _addMonthDayNum(base),
      _ => null,
    };
  }

  int _addMonthDayNum(int dayNum) {
    final date = DateTime(1970).add(Duration(days: dayNum));
    final next = DateTime(date.year, date.month + 1, date.day);
    return next.difference(DateTime(1970)).inDays;
  }

  int? _nextReminderAt(Task source, int nextDueDayNum) {
    final reminderAt = source.reminderAt;
    final dueDayNum = source.dueDayNum;
    if (reminderAt == null || dueDayNum == null) return null;
    final oldDue = DateTime(1970).add(Duration(days: dueDayNum));
    final oldReminder = DateTime.fromMillisecondsSinceEpoch(reminderAt);
    final oldAnchor = DateTime(
      oldDue.year,
      oldDue.month,
      oldDue.day,
      oldReminder.hour,
      oldReminder.minute,
    );
    final offset = oldReminder.difference(oldAnchor);
    final nextDue = DateTime(1970).add(Duration(days: nextDueDayNum));
    final nextAnchor = DateTime(
      nextDue.year,
      nextDue.month,
      nextDue.day,
      oldReminder.hour,
      oldReminder.minute,
    );
    return nextAnchor.add(offset).millisecondsSinceEpoch;
  }

  Future<void> _scheduleTaskReminderIfNeeded(Task task) async {
    final reminderAt = task.reminderAt;
    if (reminderAt == null || task.state == AppConstants.taskStateCompleted) {
      await BackgroundTimerService().cancelTaskReminder(task.id);
      return;
    }
    await BackgroundTimerService().scheduleTaskReminder(
      taskId: task.id,
      title: task.title,
      reminderAtMs: reminderAt,
    );
  }

  String _normalizeRepeatRule(String repeatRule) {
    return switch (repeatRule) {
      'daily' || 'weekly' || 'monthly' => repeatRule,
      _ => 'none',
    };
  }
}

final taskListProvider =
    StateNotifierProvider.family<TaskNotifier, AsyncValue<List<Task>>, int>((
      ref,
      listId,
    ) {
      final repo = ref.watch(taskRepositoryProvider);
      return TaskNotifier(repo, ref, listId);
    });

class AllTaskNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final TaskRepository _repo;

  AllTaskNotifier(this._repo) : super(const AsyncValue.loading()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    state = await AsyncValue.guard(() => _repo.getTasksByActiveLists());
  }
}

final allTaskListProvider =
    StateNotifierProvider<AllTaskNotifier, AsyncValue<List<Task>>>((ref) {
      final repo = ref.watch(taskRepositoryProvider);
      return AllTaskNotifier(repo);
    });

class TaskPlanKey {
  final int? listId;
  final int dayNum;

  const TaskPlanKey({this.listId, required this.dayNum});

  @override
  bool operator ==(Object other) {
    return other is TaskPlanKey &&
        other.listId == listId &&
        other.dayNum == dayNum;
  }

  @override
  int get hashCode => Object.hash(listId, dayNum);
}

class TaskPlanNotifier extends StateNotifier<AsyncValue<List<TaskPlan>>> {
  final TaskRepository _repo;
  final TaskPlanKey _key;

  TaskPlanNotifier(this._repo, this._key) : super(const AsyncValue.loading()) {
    loadPlans();
  }

  Future<void> loadPlans() async {
    state = await AsyncValue.guard(() async {
      final listId = _key.listId;
      final plans = listId == null
          ? await _repo.getPlansByDay(_key.dayNum)
          : await _repo.getPlansByListAndDay(listId, _key.dayNum);
      return _deduplicateSameTaskSlots(plans);
    });
  }

  Future<void> addPlan(Task task, int startMinute) async {
    if (_hasTaskAt(task.id, startMinute)) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    await _repo.createPlan(
      TaskPlansCompanion.insert(
        listId: task.listId,
        taskId: task.id,
        dayNum: _key.dayNum,
        startHour: startMinute ~/ 60,
        startMinute: Value(startMinute),
        durationMinutes: Value(_defaultPlanDuration(task)),
        sortOrder: const Value(0),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await loadPlans();
  }

  Future<void> movePlan(TaskPlan plan, int startMinute) async {
    if (_hasTaskAt(plan.taskId, startMinute, exceptId: plan.id)) {
      return;
    }
    await _repo.movePlan(plan.id, startMinute, 0);
    await loadPlans();
  }

  Future<void> movePlanToDay(TaskPlan plan, int dayNum) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _repo.updatePlan(
      TaskPlansCompanion(
        id: Value(plan.id),
        dayNum: Value(dayNum),
        sortOrder: const Value(0),
        updatedAt: Value(now),
      ),
    );
    await loadPlans();
  }

  Future<void> updatePlanDuration(TaskPlan plan, int durationMinutes) async {
    final normalized = durationMinutes.clamp(15, 24 * 60).toInt();
    final now = DateTime.now().millisecondsSinceEpoch;
    await _repo.updatePlan(
      TaskPlansCompanion(
        id: Value(plan.id),
        durationMinutes: Value(normalized),
        updatedAt: Value(now),
      ),
    );
    await loadPlans();
  }

  Future<void> deletePlan(int id) async {
    await _repo.deletePlan(id);
    await loadPlans();
  }

  Future<void> clearPlans() async {
    final listId = _key.listId;
    if (listId == null) {
      await _repo.clearPlansByDay(_key.dayNum);
    } else {
      await _repo.clearPlansByListAndDay(listId, _key.dayNum);
    }
    await loadPlans();
  }

  Future<void> copyPlansFromPreviousDay() async {
    await _repo.copyPlans(
      listId: _key.listId,
      fromDayNum: _key.dayNum - 1,
      toDayNum: _key.dayNum,
    );
    await loadPlans();
  }

  Future<void> copyPlansFromLastWeekSameDay() async {
    await _repo.copyPlans(
      listId: _key.listId,
      fromDayNum: _key.dayNum - 7,
      toDayNum: _key.dayNum,
    );
    await loadPlans();
  }

  int _defaultPlanDuration(Task task) {
    final estimated = task.estimatedMinutes;
    if (estimated > 0) return estimated.clamp(15, 24 * 60).toInt();
    return 60;
  }

  bool _hasTaskAt(int taskId, int startMinute, {int? exceptId}) {
    final plans = state.valueOrNull ?? const <TaskPlan>[];
    for (final plan in plans) {
      if (plan.id == exceptId) continue;
      if (plan.taskId == taskId && _planStartMinute(plan) == startMinute) {
        return true;
      }
    }
    return false;
  }

  List<TaskPlan> _deduplicateSameTaskSlots(List<TaskPlan> plans) {
    final seen = <String>{};
    final visible = <TaskPlan>[];
    for (final plan in plans) {
      final key = '${plan.dayNum}:${_planStartMinute(plan)}:${plan.taskId}';
      if (seen.add(key)) visible.add(plan);
    }
    return visible;
  }

  int _planStartMinute(TaskPlan plan) {
    return plan.startMinute ?? plan.startHour * 60;
  }
}

final taskPlanProvider =
    StateNotifierProvider.family<
      TaskPlanNotifier,
      AsyncValue<List<TaskPlan>>,
      TaskPlanKey
    >((ref, key) {
      final repo = ref.watch(taskRepositoryProvider);
      return TaskPlanNotifier(repo, key);
    });

class TaskPlanSettingsNotifier
    extends StateNotifier<AsyncValue<TaskPlanSettingsValue>> {
  final TaskRepository _repo;

  TaskPlanSettingsNotifier(this._repo) : super(const AsyncValue.loading()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    state = await AsyncValue.guard(_repo.getPlanSettings);
  }

  Future<void> save(TaskPlanSettingsValue settings) async {
    await _repo.savePlanSettings(settings.normalized());
    await loadSettings();
  }
}

final taskPlanSettingsProvider =
    StateNotifierProvider<
      TaskPlanSettingsNotifier,
      AsyncValue<TaskPlanSettingsValue>
    >((ref) {
      final repo = ref.watch(taskRepositoryProvider);
      return TaskPlanSettingsNotifier(repo);
    });
