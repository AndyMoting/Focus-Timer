import 'package:drift/drift.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/domain/models/task_plan_settings.dart';
import 'package:focus_timer/domain/repositories/task_repository.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';

class TaskRepositoryImpl implements TaskRepository {
  final AppDatabase _db;

  TaskRepositoryImpl(this._db);

  @override
  Future<int> createTask(TasksCompanion task) async {
    return await _db.into(_db.tasks).insert(task);
  }

  @override
  Future<List<Task>> getTasksByList(int listId) async {
    return await (_db.select(_db.tasks)
          ..where((t) => t.listId.equals(listId))
          ..orderBy([
            (t) => OrderingTerm.desc(t.isPinned),
            (t) => OrderingTerm.desc(t.pinnedAt),
            (t) => OrderingTerm.desc(t.priority),
            (t) => OrderingTerm.asc(t.sortOrder),
          ]))
        .get();
  }

  @override
  Future<List<Task>> getTasksByActiveLists() async {
    final activeListIds = _db.selectOnly(_db.taskLists)
      ..addColumns([_db.taskLists.id])
      ..where(_db.taskLists.isDeleted.equals(0));
    return await (_db.select(_db.tasks)
          ..where((t) => t.listId.isInQuery(activeListIds))
          ..orderBy([
            (t) => OrderingTerm.desc(t.isPinned),
            (t) => OrderingTerm.desc(t.pinnedAt),
            (t) => OrderingTerm.desc(t.priority),
            (t) => OrderingTerm.asc(t.listId),
            (t) => OrderingTerm.asc(t.sortOrder),
          ]))
        .get();
  }

  @override
  Future<void> updateTask(TasksCompanion task) async {
    final id = task.id.present ? task.id.value : null;
    if (id == null) return;
    await (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(task);
  }

  @override
  Future<int> cloneTask(int id, {int? targetListId}) async {
    final source = await (_db.select(
      _db.tasks,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (source == null) return 0;

    final now = DateTime.now().millisecondsSinceEpoch;
    final listId = targetListId ?? source.listId;
    final sortOrder = await _nextTaskSortOrder(listId);
    return await _db
        .into(_db.tasks)
        .insert(
          TasksCompanion.insert(
            listId: listId,
            dayNum: source.dayNum,
            title: targetListId == null ? '${source.title} 副本' : source.title,
            description: Value(source.description),
            color: Value(source.color),
            state: Value(AppConstants.taskStateNormal),
            priority: Value(source.priority),
            dueDayNum: Value(source.dueDayNum),
            estimatedMinutes: Value(source.estimatedMinutes),
            isFocus: Value(source.isFocus),
            isPinned: const Value(0),
            pinnedAt: const Value(null),
            reminderAt: Value(source.reminderAt),
            repeatRule: Value(source.repeatRule),
            sortOrder: Value(sortOrder),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  @override
  Future<void> moveTaskToList(int id, int targetListId, int sortOrder) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.transaction(() async {
      await (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
        TasksCompanion(
          listId: Value(targetListId),
          sortOrder: Value(sortOrder),
          updatedAt: Value(now),
        ),
      );
      await (_db.update(_db.taskPlans)..where((p) => p.taskId.equals(id)))
          .write(
        TaskPlansCompanion(
          listId: Value(targetListId),
          updatedAt: Value(now),
        ),
      );
    });
  }

  @override
  Future<List<Task>> getFutureReminderTasks({int? nowMs}) async {
    final activeListIds = _db.selectOnly(_db.taskLists)
      ..addColumns([_db.taskLists.id])
      ..where(_db.taskLists.isDeleted.equals(0));
    return await (_db.select(_db.tasks)
          ..where(
            (t) =>
                t.state.equals(AppConstants.taskStateNormal) &
                t.listId.isInQuery(activeListIds) &
                t.reminderAt.isNotNull() &
                t.reminderAt.isBiggerThanValue(
                  nowMs ?? DateTime.now().millisecondsSinceEpoch,
                ),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.reminderAt)]))
        .get();
  }

  @override
  Future<DeletedTaskSnapshot?> deleteTask(int id) async {
    return await _db.transaction(() async {
      final task = await (_db.select(
        _db.tasks,
      )..where((t) => t.id.equals(id))).getSingleOrNull();
      if (task == null) return null;

      final plans = await (_db.select(
        _db.taskPlans,
      )..where((p) => p.taskId.equals(id))).get();

      await (_db.delete(_db.taskPlans)..where((p) => p.taskId.equals(id))).go();
      await (_db.delete(_db.tasks)..where((t) => t.id.equals(id))).go();
      return DeletedTaskSnapshot(task: task, plans: plans);
    });
  }

  @override
  Future<void> restoreDeletedTask(DeletedTaskSnapshot snapshot) async {
    await _db.transaction(() async {
      await _db.into(_db.tasks).insert(snapshot.task.toCompanion(true));
      for (final plan in snapshot.plans) {
        final duplicate = await _duplicatePlanAt(
          dayNum: plan.dayNum,
          taskId: plan.taskId,
          startMinute: _planStartMinute(plan),
        );
        if (duplicate != null) continue;
        await _db.into(_db.taskPlans).insert(plan.toCompanion(true));
      }
    });
  }

  @override
  Future<void> completeTask(int id) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        state: const Value(AppConstants.taskStateCompleted),
        completedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<void> uncompleteTask(int id) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        state: const Value(AppConstants.taskStateNormal),
        completedAt: const Value(null),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<void> completeAllActiveTasks() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final activeListIds = _db.selectOnly(_db.taskLists)
      ..addColumns([_db.taskLists.id])
      ..where(_db.taskLists.isDeleted.equals(0));
    await (_db.update(_db.tasks)..where(
          (t) =>
              t.state.equals(AppConstants.taskStateNormal) &
              t.listId.isInQuery(activeListIds),
        ))
        .write(
          TasksCompanion(
            state: const Value(AppConstants.taskStateCompleted),
            completedAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  @override
  Future<int> applyDailyReset(int todayDayNum) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final dailyListIds = _db.selectOnly(_db.taskLists)
      ..addColumns([_db.taskLists.id])
      ..where(
        _db.taskLists.isDeleted.equals(0) &
            _db.taskLists.isDailyReset.equals(1),
      );
    return await (_db.update(_db.tasks)..where(
          (t) =>
              t.listId.isInQuery(dailyListIds) &
              t.state.equals(AppConstants.taskStateCompleted) &
              t.dayNum.isSmallerThanValue(todayDayNum),
        ))
        .write(
          TasksCompanion(
            state: const Value(AppConstants.taskStateNormal),
            dayNum: Value(todayDayNum),
            completedAt: const Value(null),
            updatedAt: Value(now),
          ),
        );
  }

  @override
  Future<void> reorderTasks(int listId, List<int> taskIdsInOrder) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.transaction(() async {
      for (var index = 0; index < taskIdsInOrder.length; index++) {
        await (_db.update(_db.tasks)..where(
              (t) =>
                  t.id.equals(taskIdsInOrder[index]) & t.listId.equals(listId),
            ))
            .write(
              TasksCompanion(sortOrder: Value(index), updatedAt: Value(now)),
            );
      }
    });
  }

  Future<int> _nextTaskSortOrder(int listId) async {
    final tasks = await getTasksByList(listId);
    var next = 0;
    for (final task in tasks) {
      if (task.sortOrder >= next) next = task.sortOrder + 1;
    }
    return next;
  }

  // 分组管理
  @override
  Future<int> createList(TaskListsCompanion list) async {
    return await _db.into(_db.taskLists).insert(list);
  }

  @override
  Future<List<TaskList>> getActiveLists() async {
    return await (_db.select(_db.taskLists)
          ..where((t) => t.isDeleted.equals(0))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  @override
  Future<List<TaskList>> getDeletedLists() async {
    return await (_db.select(_db.taskLists)
          ..where((t) => t.isDeleted.equals(1))
          ..orderBy([(t) => OrderingTerm.desc(t.deletedAt)]))
        .get();
  }

  @override
  Future<int> countTasksByList(int listId) async {
    final count = _db.tasks.id.count();
    final query = _db.selectOnly(_db.tasks)
      ..addColumns([count])
      ..where(_db.tasks.listId.equals(listId));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  @override
  Future<void> updateList(TaskListsCompanion list) async {
    final id = list.id.present ? list.id.value : null;
    if (id == null) return;
    await (_db.update(
      _db.taskLists,
    )..where((t) => t.id.equals(id))).write(list);
  }

  @override
  Future<void> reorderLists(List<int> listIdsInOrder) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.transaction(() async {
      for (var index = 0; index < listIdsInOrder.length; index++) {
        await (_db.update(_db.taskLists)..where(
              (t) => t.id.equals(listIdsInOrder[index]) & t.isDeleted.equals(0),
            ))
            .write(
              TaskListsCompanion(
                sortOrder: Value(index),
                updatedAt: Value(now),
              ),
            );
      }
    });
  }

  @override
  Future<void> softDeleteList(int id) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(_db.taskLists)..where((t) => t.id.equals(id))).write(
      TaskListsCompanion(
        isDeleted: const Value(1),
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<List<int>> softDeleteEmptyLists() async {
    final lists = await getActiveLists();
    final deletedIds = <int>[];
    for (final list in lists) {
      final taskCount = await countTasksByList(list.id);
      if (taskCount == 0) {
        await softDeleteList(list.id);
        deletedIds.add(list.id);
      }
    }
    return deletedIds;
  }

  @override
  Future<List<int>> softDeleteAllLists() async {
    final lists = await getActiveLists();
    if (lists.isEmpty) return const [];
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(
      _db.taskLists,
    )..where((t) => t.isDeleted.equals(0))).write(
      TaskListsCompanion(
        isDeleted: const Value(1),
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    return [for (final list in lists) list.id];
  }

  @override
  Future<void> restoreList(int id) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(_db.taskLists)..where((t) => t.id.equals(id))).write(
      TaskListsCompanion(
        isDeleted: const Value(0),
        deletedAt: const Value(null),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<void> permanentDeleteList(int id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.taskPlans)..where((p) => p.listId.equals(id))).go();
      await (_db.delete(_db.tasks)..where((t) => t.listId.equals(id))).go();
      await (_db.delete(_db.taskLists)..where((t) => t.id.equals(id))).go();
    });
  }

  @override
  Future<int> createPlan(TaskPlansCompanion plan) async {
    final dayNum = plan.dayNum.value;
    final taskId = plan.taskId.value;
    final startMinute = _planCompanionStartMinute(plan);
    return await _db.transaction(() async {
      final duplicate = await _duplicatePlanAt(
        dayNum: dayNum,
        taskId: taskId,
        startMinute: startMinute,
      );
      if (duplicate != null) return duplicate.id;
      final sortOrder = await _nextPlanSortOrderAtStart(dayNum, startMinute);
      return await _db
          .into(_db.taskPlans)
          .insert(
            plan.copyWith(
              startHour: Value(startMinute ~/ 60),
              startMinute: Value(startMinute),
              sortOrder: Value(sortOrder),
            ),
          );
    });
  }

  @override
  Future<List<TaskPlan>> getPlansByListAndDay(int listId, int dayNum) async {
    final plans = await (_db.select(
      _db.taskPlans,
    )..where((p) => p.listId.equals(listId) & p.dayNum.equals(dayNum))).get();
    plans.sort(_comparePlansByMinute);
    return plans;
  }

  @override
  Future<List<TaskPlan>> getPlansByDay(int dayNum) async {
    final activeListIds = _db.selectOnly(_db.taskLists)
      ..addColumns([_db.taskLists.id])
      ..where(_db.taskLists.isDeleted.equals(0));
    final plans =
        await (_db.select(_db.taskPlans)..where(
              (p) =>
                  p.dayNum.equals(dayNum) & p.listId.isInQuery(activeListIds),
            ))
            .get();
    plans.sort(_comparePlansByMinute);
    return plans;
  }

  @override
  Future<List<TaskPlan>> getPlansByTask(int taskId, {int limit = 20}) async {
    final plans =
        await (_db.select(_db.taskPlans)
              ..where((p) => p.taskId.equals(taskId))
              ..orderBy([
                (p) => OrderingTerm.desc(p.dayNum),
                (p) => OrderingTerm.asc(p.startHour),
                (p) => OrderingTerm.asc(p.startMinute),
              ])
              ..limit(limit))
            .get();
    plans.sort((a, b) {
      final dayCompare = b.dayNum.compareTo(a.dayNum);
      if (dayCompare != 0) return dayCompare;
      return _comparePlansByMinute(a, b);
    });
    return plans;
  }

  @override
  Future<void> movePlan(int id, int startMinute, int sortOrder) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.transaction(() async {
      final current = await (_db.select(
        _db.taskPlans,
      )..where((p) => p.id.equals(id))).getSingleOrNull();
      if (current == null) return;
      final duplicate = await _duplicatePlanAt(
        dayNum: current.dayNum,
        taskId: current.taskId,
        startMinute: startMinute,
        exceptId: id,
      );
      if (duplicate != null) return;
      final nextSortOrder = await _nextPlanSortOrderAtStart(
        current.dayNum,
        startMinute,
        exceptId: id,
      );
      await (_db.update(_db.taskPlans)..where((p) => p.id.equals(id))).write(
        TaskPlansCompanion(
          startHour: Value(startMinute ~/ 60),
          startMinute: Value(startMinute),
          sortOrder: Value(nextSortOrder),
          updatedAt: Value(now),
        ),
      );
    });
  }

  @override
  Future<void> updatePlan(TaskPlansCompanion plan) async {
    final id = plan.id.present ? plan.id.value : null;
    if (id == null) return;
    await _db.transaction(() async {
      final current = await (_db.select(
        _db.taskPlans,
      )..where((p) => p.id.equals(id))).getSingleOrNull();
      if (current == null) return;
      final targetDayNum = plan.dayNum.present
          ? plan.dayNum.value
          : current.dayNum;
      final targetTaskId = plan.taskId.present
          ? plan.taskId.value
          : current.taskId;
      final targetStartMinute = _planCompanionTargetStartMinute(plan, current);
      final targetChanged =
          targetDayNum != current.dayNum ||
          targetTaskId != current.taskId ||
          targetStartMinute != _planStartMinute(current);
      if (targetChanged) {
        final duplicate = await _duplicatePlanAt(
          dayNum: targetDayNum,
          taskId: targetTaskId,
          startMinute: targetStartMinute,
          exceptId: id,
        );
        if (duplicate != null) return;
      }
      await (_db.update(
        _db.taskPlans,
      )..where((p) => p.id.equals(id))).write(plan);
    });
  }

  @override
  Future<void> deletePlan(int id) async {
    await (_db.delete(_db.taskPlans)..where((p) => p.id.equals(id))).go();
  }

  @override
  Future<void> clearPlansByListAndDay(int listId, int dayNum) async {
    await (_db.delete(
      _db.taskPlans,
    )..where((p) => p.listId.equals(listId) & p.dayNum.equals(dayNum))).go();
  }

  @override
  Future<void> clearPlansByDay(int dayNum) async {
    final activeListIds = _db.selectOnly(_db.taskLists)
      ..addColumns([_db.taskLists.id])
      ..where(_db.taskLists.isDeleted.equals(0));
    await (_db.delete(_db.taskPlans)..where(
          (p) => p.dayNum.equals(dayNum) & p.listId.isInQuery(activeListIds),
        ))
        .go();
  }

  @override
  Future<void> copyPlans({
    int? listId,
    required int fromDayNum,
    required int toDayNum,
  }) async {
    if (fromDayNum == toDayNum) return;
    final sourcePlans = listId == null
        ? await getPlansByDay(fromDayNum)
        : await getPlansByListAndDay(listId, fromDayNum);
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.transaction(() async {
      if (listId == null) {
        await clearPlansByDay(toDayNum);
      } else {
        await clearPlansByListAndDay(listId, toDayNum);
      }
      for (final plan in sourcePlans) {
        final startMinute = _planStartMinute(plan);
        final duplicate = await _duplicatePlanAt(
          dayNum: toDayNum,
          taskId: plan.taskId,
          startMinute: startMinute,
        );
        if (duplicate != null) continue;
        final sortOrder = await _nextPlanSortOrderAtStart(
          toDayNum,
          startMinute,
        );
        await _db
            .into(_db.taskPlans)
            .insert(
              TaskPlansCompanion.insert(
                listId: plan.listId,
                taskId: plan.taskId,
                dayNum: toDayNum,
                startHour: plan.startHour,
                startMinute: Value(plan.startMinute),
                durationMinutes: Value(plan.durationMinutes),
                sortOrder: Value(sortOrder),
                createdAt: now,
                updatedAt: now,
              ),
            );
      }
    });
  }

  @override
  Future<TaskPlanSettingsValue> getPlanSettings() async {
    final row = await (_db.select(
      _db.taskPlanSettings,
    )..where((s) => s.id.equals(1))).getSingleOrNull();
    if (row == null) return TaskPlanSettingsValue.defaults;
    return TaskPlanSettingsValue(
      startMinute: row.startMinute,
      endMinute: row.endMinute,
      slotMinutes: row.slotMinutes,
    ).normalized();
  }

  @override
  Future<void> savePlanSettings(TaskPlanSettingsValue settings) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final value = settings.normalized();
    await _db
        .into(_db.taskPlanSettings)
        .insertOnConflictUpdate(
          TaskPlanSettingsCompanion.insert(
            id: const Value(1),
            startMinute: Value(value.startMinute),
            endMinute: Value(value.endMinute),
            slotMinutes: Value(value.slotMinutes),
            updatedAt: now,
          ),
        );
  }

  int _comparePlansByMinute(TaskPlan a, TaskPlan b) {
    final startCompare = _planStartMinute(a).compareTo(_planStartMinute(b));
    if (startCompare != 0) return startCompare;
    return a.sortOrder.compareTo(b.sortOrder);
  }

  Future<int> _nextPlanSortOrderAtStart(
    int dayNum,
    int startMinute, {
    int? exceptId,
  }) async {
    final plans = await (_db.select(
      _db.taskPlans,
    )..where((p) => p.dayNum.equals(dayNum))).get();
    var next = 0;
    for (final plan in plans) {
      if (plan.id == exceptId) continue;
      if (_planStartMinute(plan) != startMinute) continue;
      if (plan.sortOrder >= next) next = plan.sortOrder + 1;
    }
    return next;
  }

  int _planCompanionStartMinute(TaskPlansCompanion plan) {
    final explicitMinute = plan.startMinute.present
        ? plan.startMinute.value
        : null;
    if (explicitMinute != null) return explicitMinute;
    return plan.startHour.value * 60;
  }

  int _planCompanionTargetStartMinute(
    TaskPlansCompanion plan,
    TaskPlan current,
  ) {
    if (plan.startMinute.present && plan.startMinute.value != null) {
      return plan.startMinute.value!;
    }
    if (plan.startHour.present) return plan.startHour.value * 60;
    return _planStartMinute(current);
  }

  int _planStartMinute(TaskPlan plan) {
    return plan.startMinute ?? plan.startHour * 60;
  }

  Future<TaskPlan?> _duplicatePlanAt({
    required int dayNum,
    required int taskId,
    required int startMinute,
    int? exceptId,
  }) async {
    final sameTaskPlans = await (_db.select(
      _db.taskPlans,
    )..where((p) => p.dayNum.equals(dayNum) & p.taskId.equals(taskId))).get();
    for (final plan in sameTaskPlans) {
      if (plan.id == exceptId) continue;
      if (_planStartMinute(plan) == startMinute) return plan;
    }
    return null;
  }
}
