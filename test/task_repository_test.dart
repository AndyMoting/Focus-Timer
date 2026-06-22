import 'package:drift/native.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/data/repositories/task_repository_impl.dart';
import 'package:focus_timer/domain/models/task_plan_settings.dart';

void main() {
  late AppDatabase db;
  late TaskRepositoryImpl repo;
  final now = DateTime.now().millisecondsSinceEpoch;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = TaskRepositoryImpl(db);
  });

  tearDown(() => db.close());

  test('restore and permanently delete trashed group', () async {
    final listId = await repo.createList(
      TaskListsCompanion.insert(name: '分组1', createdAt: now, updatedAt: now),
    );
    await repo.createTask(
      TasksCompanion.insert(
        listId: listId,
        dayNum: 1,
        title: '待办1',
        createdAt: now,
        updatedAt: now,
      ),
    );

    await repo.softDeleteList(listId);
    expect(await repo.getActiveLists(), isEmpty);
    expect(await repo.getDeletedLists(), hasLength(1));

    await repo.restoreList(listId);
    expect(await repo.getActiveLists(), hasLength(1));
    expect(await repo.getDeletedLists(), isEmpty);

    await repo.softDeleteList(listId);
    await repo.permanentDeleteList(listId);
    expect(await repo.getDeletedLists(), isEmpty);
    expect(await repo.getTasksByList(listId), isEmpty);
  });

  test(
    'completeAllActiveTasks only completes tasks in active groups',
    () async {
      final activeId = await repo.createList(
        TaskListsCompanion.insert(name: '活动分组', createdAt: now, updatedAt: now),
      );
      final deletedId = await repo.createList(
        TaskListsCompanion.insert(name: '删除分组', createdAt: now, updatedAt: now),
      );
      await repo.softDeleteList(deletedId);

      await repo.createTask(
        TasksCompanion.insert(
          listId: activeId,
          dayNum: 1,
          title: '会完成',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await repo.createTask(
        TasksCompanion.insert(
          listId: deletedId,
          dayNum: 1,
          title: '不会完成',
          createdAt: now,
          updatedAt: now,
        ),
      );

      await repo.completeAllActiveTasks();

      final activeTasks = await repo.getTasksByList(activeId);
      final deletedTasks = await repo.getTasksByList(deletedId);
      expect(activeTasks.single.state, 1);
      expect(deletedTasks.single.state, 0);
    },
  );

  test(
    'applyDailyReset reopens old completed tasks in daily groups only',
    () async {
      final dailyId = await repo.createList(
        TaskListsCompanion.insert(
          name: '每日重置',
          isDailyReset: const Value(1),
          createdAt: now,
          updatedAt: now,
        ),
      );
      final normalId = await repo.createList(
        TaskListsCompanion.insert(name: '普通分组', createdAt: now, updatedAt: now),
      );
      final oldDailyTaskId = await repo.createTask(
        TasksCompanion.insert(
          listId: dailyId,
          dayNum: 9,
          title: '昨天完成',
          state: const Value(1),
          completedAt: Value(now - 24 * 60 * 60 * 1000),
          createdAt: now,
          updatedAt: now,
        ),
      );
      final todayDailyTaskId = await repo.createTask(
        TasksCompanion.insert(
          listId: dailyId,
          dayNum: 10,
          title: '今天完成',
          state: const Value(1),
          completedAt: Value(now),
          createdAt: now,
          updatedAt: now,
        ),
      );
      final oldNormalTaskId = await repo.createTask(
        TasksCompanion.insert(
          listId: normalId,
          dayNum: 9,
          title: '普通完成',
          state: const Value(1),
          completedAt: Value(now - 24 * 60 * 60 * 1000),
          createdAt: now,
          updatedAt: now,
        ),
      );

      final resetCount = await repo.applyDailyReset(10);

      final dailyTasks = await repo.getTasksByList(dailyId);
      final normalTasks = await repo.getTasksByList(normalId);
      final oldDailyTask = dailyTasks.singleWhere(
        (task) => task.id == oldDailyTaskId,
      );
      final todayDailyTask = dailyTasks.singleWhere(
        (task) => task.id == todayDailyTaskId,
      );
      final oldNormalTask = normalTasks.singleWhere(
        (task) => task.id == oldNormalTaskId,
      );
      expect(resetCount, 1);
      expect(oldDailyTask.state, 0);
      expect(oldDailyTask.dayNum, 10);
      expect(oldDailyTask.completedAt, isNull);
      expect(todayDailyTask.state, 1);
      expect(oldNormalTask.state, 1);
    },
  );

  test('reorderTasks persists task order inside one group', () async {
    final listId = await repo.createList(
      TaskListsCompanion.insert(name: '排序分组', createdAt: now, updatedAt: now),
    );
    final firstId = await repo.createTask(
      TasksCompanion.insert(
        listId: listId,
        dayNum: 1,
        title: '第一项',
        sortOrder: const Value(0),
        createdAt: now,
        updatedAt: now,
      ),
    );
    final secondId = await repo.createTask(
      TasksCompanion.insert(
        listId: listId,
        dayNum: 1,
        title: '第二项',
        sortOrder: const Value(1),
        createdAt: now,
        updatedAt: now,
      ),
    );
    final thirdId = await repo.createTask(
      TasksCompanion.insert(
        listId: listId,
        dayNum: 1,
        title: '第三项',
        sortOrder: const Value(2),
        createdAt: now,
        updatedAt: now,
      ),
    );

    await repo.reorderTasks(listId, [thirdId, firstId, secondId]);

    final tasks = await repo.getTasksByList(listId);
    expect(tasks.map((task) => task.id), [thirdId, firstId, secondId]);
    expect(tasks.map((task) => task.sortOrder), [0, 1, 2]);
  });

  test(
    'deleteTask returns snapshot and restore brings task plans back',
    () async {
      final listId = await repo.createList(
        TaskListsCompanion.insert(name: '撤销分组', createdAt: now, updatedAt: now),
      );
      final taskId = await repo.createTask(
        TasksCompanion.insert(
          listId: listId,
          dayNum: 1,
          title: '可撤销',
          sortOrder: const Value(3),
          createdAt: now,
          updatedAt: now,
        ),
      );
      await repo.createPlan(
        TaskPlansCompanion.insert(
          listId: listId,
          taskId: taskId,
          dayNum: 2,
          startHour: 9,
          startMinute: const Value(9 * 60),
          createdAt: now,
          updatedAt: now,
        ),
      );

      final snapshot = await repo.deleteTask(taskId);

      expect(snapshot, isNotNull);
      expect(snapshot!.task.title, '可撤销');
      expect(snapshot.plans, hasLength(1));
      expect(await repo.getTasksByList(listId), isEmpty);
      expect(await repo.getPlansByListAndDay(listId, 2), isEmpty);

      await repo.restoreDeletedTask(snapshot);

      final tasks = await repo.getTasksByList(listId);
      final plans = await repo.getPlansByListAndDay(listId, 2);
      expect(tasks.single.id, taskId);
      expect(tasks.single.sortOrder, 3);
      expect(plans.single.taskId, taskId);
      expect(plans.single.startMinute, 9 * 60);
    },
  );

  test('clone and move task preserve details', () async {
    final firstListId = await repo.createList(
      TaskListsCompanion.insert(name: '第一组', createdAt: now, updatedAt: now),
    );
    final secondListId = await repo.createList(
      TaskListsCompanion.insert(name: '第二组', createdAt: now, updatedAt: now),
    );
    final taskId = await repo.createTask(
      TasksCompanion.insert(
        listId: firstListId,
        dayNum: 1,
        title: '重点任务',
        description: const Value('备注'),
        color: const Value(0xFF8E3B46),
        priority: const Value(2),
        dueDayNum: const Value(10),
        estimatedMinutes: const Value(45),
        isFocus: const Value(1),
        createdAt: now,
        updatedAt: now,
      ),
    );

    final cloneId = await repo.cloneTask(taskId);
    await repo.moveTaskToList(taskId, secondListId, 0);

    final firstTasks = await repo.getTasksByList(firstListId);
    final secondTasks = await repo.getTasksByList(secondListId);
    expect(firstTasks.single.id, cloneId);
    expect(firstTasks.single.title, '重点任务 副本');
    expect(firstTasks.single.description, '备注');
    expect(firstTasks.single.color, 0xFF8E3B46);
    expect(firstTasks.single.priority, 2);
    expect(firstTasks.single.dueDayNum, 10);
    expect(firstTasks.single.estimatedMinutes, 45);
    expect(firstTasks.single.isFocus, 1);
    expect(secondTasks.single.id, taskId);
  });

  test('create, query, delete, and clear task plans', () async {
    final listId = await repo.createList(
      TaskListsCompanion.insert(name: '计划分组', createdAt: now, updatedAt: now),
    );
    final taskId = await repo.createTask(
      TasksCompanion.insert(
        listId: listId,
        dayNum: 1,
        title: '高数',
        createdAt: now,
        updatedAt: now,
      ),
    );

    final firstPlanId = await repo.createPlan(
      TaskPlansCompanion.insert(
        listId: listId,
        taskId: taskId,
        dayNum: 1,
        startHour: 10,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await repo.createPlan(
      TaskPlansCompanion.insert(
        listId: listId,
        taskId: taskId,
        dayNum: 1,
        startHour: 21,
        createdAt: now,
        updatedAt: now,
      ),
    );

    var plans = await repo.getPlansByListAndDay(listId, 1);
    expect(plans.map((p) => p.startHour), [10, 21]);

    await repo.deletePlan(firstPlanId);
    plans = await repo.getPlansByListAndDay(listId, 1);
    expect(plans.single.startHour, 21);

    await repo.clearPlansByListAndDay(listId, 1);
    expect(await repo.getPlansByListAndDay(listId, 1), isEmpty);
  });

  test(
    'task plans allow multiple different items in the same time slot',
    () async {
      final listId = await repo.createList(
        TaskListsCompanion.insert(name: '单格计划', createdAt: now, updatedAt: now),
      );
      final firstTaskId = await repo.createTask(
        TasksCompanion.insert(
          listId: listId,
          dayNum: 1,
          title: '第一项',
          createdAt: now,
          updatedAt: now,
        ),
      );
      final secondTaskId = await repo.createTask(
        TasksCompanion.insert(
          listId: listId,
          dayNum: 1,
          title: '第二项',
          createdAt: now,
          updatedAt: now,
        ),
      );

      final firstPlanId = await repo.createPlan(
        TaskPlansCompanion.insert(
          listId: listId,
          taskId: firstTaskId,
          dayNum: 1,
          startHour: 9,
          startMinute: const Value(9 * 60),
          createdAt: now,
          updatedAt: now,
        ),
      );
      final duplicateFirstPlanId = await repo.createPlan(
        TaskPlansCompanion.insert(
          listId: listId,
          taskId: firstTaskId,
          dayNum: 1,
          startHour: 9,
          startMinute: const Value(9 * 60),
          createdAt: now,
          updatedAt: now,
        ),
      );
      await repo.createPlan(
        TaskPlansCompanion.insert(
          listId: listId,
          taskId: secondTaskId,
          dayNum: 1,
          startHour: 9,
          startMinute: const Value(9 * 60),
          createdAt: now,
          updatedAt: now,
        ),
      );

      var plans = await repo.getPlansByListAndDay(listId, 1);
      expect(duplicateFirstPlanId, firstPlanId);
      expect(plans, hasLength(2));
      expect(plans.map((plan) => plan.taskId), [firstTaskId, secondTaskId]);
      expect(plans.map((plan) => plan.sortOrder), [0, 1]);

      final thirdPlanId = await repo.createPlan(
        TaskPlansCompanion.insert(
          listId: listId,
          taskId: firstTaskId,
          dayNum: 1,
          startHour: 10,
          startMinute: const Value(10 * 60),
          createdAt: now,
          updatedAt: now,
        ),
      );

      await repo.movePlan(thirdPlanId, 9 * 60, 0);
      plans = await repo.getPlansByListAndDay(listId, 1);
      expect(plans, hasLength(3));
      expect(plans.first.id, firstPlanId);
      expect(plans[1].taskId, secondTaskId);
      expect(plans.last.id, thirdPlanId);
      expect(plans.last.startMinute, 10 * 60);
      expect(plans.last.sortOrder, 0);
    },
  );

  test('global plan mode reads active tasks and active plans only', () async {
    final activeId = await repo.createList(
      TaskListsCompanion.insert(name: '活动分组', createdAt: now, updatedAt: now),
    );
    final anotherActiveId = await repo.createList(
      TaskListsCompanion.insert(name: '另一个分组', createdAt: now, updatedAt: now),
    );
    final deletedId = await repo.createList(
      TaskListsCompanion.insert(name: '回收分组', createdAt: now, updatedAt: now),
    );
    await repo.softDeleteList(deletedId);

    final activeTaskId = await repo.createTask(
      TasksCompanion.insert(
        listId: activeId,
        dayNum: 1,
        title: '高数',
        createdAt: now,
        updatedAt: now,
      ),
    );
    final anotherTaskId = await repo.createTask(
      TasksCompanion.insert(
        listId: anotherActiveId,
        dayNum: 1,
        title: '单词',
        createdAt: now,
        updatedAt: now,
      ),
    );
    final deletedTaskId = await repo.createTask(
      TasksCompanion.insert(
        listId: deletedId,
        dayNum: 1,
        title: '不显示',
        createdAt: now,
        updatedAt: now,
      ),
    );

    await repo.createPlan(
      TaskPlansCompanion.insert(
        listId: activeId,
        taskId: activeTaskId,
        dayNum: 2,
        startHour: 8,
        startMinute: const Value(8 * 60 + 30),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await repo.createPlan(
      TaskPlansCompanion.insert(
        listId: anotherActiveId,
        taskId: anotherTaskId,
        dayNum: 2,
        startHour: 7,
        startMinute: const Value(7 * 60),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await repo.createPlan(
      TaskPlansCompanion.insert(
        listId: deletedId,
        taskId: deletedTaskId,
        dayNum: 2,
        startHour: 6,
        startMinute: const Value(6 * 60),
        createdAt: now,
        updatedAt: now,
      ),
    );

    final tasks = await repo.getTasksByActiveLists();
    expect(tasks.map((task) => task.title), ['高数', '单词']);

    final plans = await repo.getPlansByDay(2);
    expect(plans.map((plan) => plan.startMinute), [420, 510]);
  });

  test('move, clear global plans, and persist plan settings', () async {
    final firstListId = await repo.createList(
      TaskListsCompanion.insert(name: '第一组', createdAt: now, updatedAt: now),
    );
    final secondListId = await repo.createList(
      TaskListsCompanion.insert(name: '第二组', createdAt: now, updatedAt: now),
    );
    final firstTaskId = await repo.createTask(
      TasksCompanion.insert(
        listId: firstListId,
        dayNum: 1,
        title: '精听',
        createdAt: now,
        updatedAt: now,
      ),
    );
    final secondTaskId = await repo.createTask(
      TasksCompanion.insert(
        listId: secondListId,
        dayNum: 1,
        title: '核心',
        createdAt: now,
        updatedAt: now,
      ),
    );

    final planId = await repo.createPlan(
      TaskPlansCompanion.insert(
        listId: firstListId,
        taskId: firstTaskId,
        dayNum: 3,
        startHour: 9,
        startMinute: const Value(9 * 60),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await repo.createPlan(
      TaskPlansCompanion.insert(
        listId: secondListId,
        taskId: secondTaskId,
        dayNum: 3,
        startHour: 11,
        startMinute: const Value(11 * 60),
        createdAt: now,
        updatedAt: now,
      ),
    );

    await repo.movePlan(planId, 13 * 60 + 30, 0);
    var plans = await repo.getPlansByListAndDay(firstListId, 3);
    expect(plans.single.startHour, 13);
    expect(plans.single.startMinute, 13 * 60 + 30);

    await repo.updatePlan(
      TaskPlansCompanion(
        id: Value(planId),
        durationMinutes: const Value(90),
        updatedAt: Value(now + 1),
      ),
    );
    plans = await repo.getPlansByListAndDay(firstListId, 3);
    expect(plans.single.durationMinutes, 90);

    await repo.clearPlansByListAndDay(firstListId, 3);
    expect(await repo.getPlansByListAndDay(firstListId, 3), isEmpty);
    expect(await repo.getPlansByListAndDay(secondListId, 3), hasLength(1));

    await repo.clearPlansByDay(3);
    expect(await repo.getPlansByDay(3), isEmpty);

    expect(await repo.getPlanSettings(), TaskPlanSettingsValue.defaults);
    await repo.savePlanSettings(
      const TaskPlanSettingsValue(
        startMinute: 6 * 60,
        endMinute: 23 * 60,
        slotMinutes: 30,
      ),
    );
    final settings = await repo.getPlanSettings();
    expect(settings.startMinute, 6 * 60);
    expect(settings.endMinute, 23 * 60);
    expect(settings.slotMinutes, 30);
  });

  test('copyPlans replaces target day with source day plans', () async {
    final listId = await repo.createList(
      TaskListsCompanion.insert(name: '复制计划', createdAt: now, updatedAt: now),
    );
    final taskId = await repo.createTask(
      TasksCompanion.insert(
        listId: listId,
        dayNum: 1,
        title: '计划任务',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await repo.createPlan(
      TaskPlansCompanion.insert(
        listId: listId,
        taskId: taskId,
        dayNum: 4,
        startHour: 8,
        startMinute: const Value(8 * 60),
        durationMinutes: const Value(45),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await repo.createPlan(
      TaskPlansCompanion.insert(
        listId: listId,
        taskId: taskId,
        dayNum: 5,
        startHour: 20,
        startMinute: const Value(20 * 60),
        createdAt: now,
        updatedAt: now,
      ),
    );

    await repo.copyPlans(listId: listId, fromDayNum: 4, toDayNum: 5);

    final plans = await repo.getPlansByListAndDay(listId, 5);
    expect(plans, hasLength(1));
    expect(plans.single.startMinute, 8 * 60);
    expect(plans.single.durationMinutes, 45);
  });

  test('permanently deleting group also deletes task plans', () async {
    final listId = await repo.createList(
      TaskListsCompanion.insert(name: '要删除', createdAt: now, updatedAt: now),
    );
    final taskId = await repo.createTask(
      TasksCompanion.insert(
        listId: listId,
        dayNum: 1,
        title: '计划任务',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await repo.createPlan(
      TaskPlansCompanion.insert(
        listId: listId,
        taskId: taskId,
        dayNum: 1,
        startHour: 13,
        createdAt: now,
        updatedAt: now,
      ),
    );

    await repo.softDeleteList(listId);
    await repo.permanentDeleteList(listId);

    expect(await repo.getTasksByList(listId), isEmpty);
    expect(await repo.getPlansByListAndDay(listId, 1), isEmpty);
  });

  test('moving task to another group also moves its plans', () async {
    final sourceListId = await repo.createList(
      TaskListsCompanion.insert(name: '来源组', createdAt: now, updatedAt: now),
    );
    final targetListId = await repo.createList(
      TaskListsCompanion.insert(name: '目标组', createdAt: now, updatedAt: now),
    );
    final taskId = await repo.createTask(
      TasksCompanion.insert(
        listId: sourceListId,
        dayNum: 1,
        title: '带计划任务',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await repo.createPlan(
      TaskPlansCompanion.insert(
        listId: sourceListId,
        taskId: taskId,
        dayNum: 1,
        startHour: 9,
        startMinute: const Value(9 * 60),
        createdAt: now,
        updatedAt: now,
      ),
    );

    await repo.moveTaskToList(taskId, targetListId, 0);

    expect(await repo.getPlansByListAndDay(sourceListId, 1), isEmpty);
    final targetPlans = await repo.getPlansByListAndDay(targetListId, 1);
    expect(targetPlans, hasLength(1));
    expect(targetPlans.single.taskId, taskId);
  });
}
