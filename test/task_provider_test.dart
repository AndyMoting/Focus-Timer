import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_timer/data/database/database.dart';
import 'package:focus_timer/presentation/providers/database_provider.dart';
import 'package:focus_timer/presentation/providers/task_provider.dart';
import 'package:focus_timer/shared/constants/app_constants.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  test(
    'moving groups to trash refreshes an already loaded trash provider',
    () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final repo = container.read(taskRepositoryProvider);
      final groupId = await repo.createList(
        TaskListsCompanion.insert(
          name: '空分组',
          color: const Value(0xFF4F6FA8),
          createdAt: now,
          updatedAt: now,
        ),
      );

      await container.read(groupListProvider.notifier).loadGroups();
      await container.read(trashProvider.notifier).loadDeletedGroups();
      expect(container.read(trashProvider).valueOrNull, isEmpty);

      await container.read(groupListProvider.notifier).moveEmptyGroupsToTrash();

      final deletedGroups = container.read(trashProvider).valueOrNull;
      expect(deletedGroups, isNotNull);
      expect(deletedGroups, hasLength(1));
      expect(deletedGroups!.single.id, groupId);
    },
  );

  test('group notifier restores groups from undo ids', () async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final repo = container.read(taskRepositoryProvider);
    final firstId = await repo.createList(
      TaskListsCompanion.insert(
        name: '第一组',
        color: const Value(0xFF4F6FA8),
        createdAt: now,
        updatedAt: now,
      ),
    );
    final secondId = await repo.createList(
      TaskListsCompanion.insert(
        name: '第二组',
        color: const Value(0xFF6A8F4F),
        createdAt: now,
        updatedAt: now,
      ),
    );

    final notifier = container.read(groupListProvider.notifier);
    await notifier.loadGroups();

    final deletedIds = await notifier.moveAllGroupsToTrash();
    expect(deletedIds, containsAll([firstId, secondId]));
    expect(container.read(groupListProvider).valueOrNull, isEmpty);

    await notifier.restoreGroups(deletedIds);

    final restoredGroups = container.read(groupListProvider).valueOrNull;
    expect(restoredGroups, isNotNull);
    expect(
      restoredGroups!.map((group) => group.id),
      containsAll([firstId, secondId]),
    );
    expect(container.read(trashProvider).valueOrNull, isEmpty);
  });

  test('task provider appends new tasks and reorders visible tasks', () async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final repo = container.read(taskRepositoryProvider);
    final groupId = await repo.createList(
      TaskListsCompanion.insert(
        name: '排序分组',
        color: const Value(0xFF4F6FA8),
        createdAt: now,
        updatedAt: now,
      ),
    );

    final notifier = container.read(taskListProvider(groupId).notifier);
    await notifier.createTask('第一项');
    await notifier.createTask('第二项');
    await notifier.createTask('第三项');

    var tasks = container.read(taskListProvider(groupId)).valueOrNull;
    expect(tasks?.map((task) => task.title), ['第一项', '第二项', '第三项']);
    expect(tasks?.map((task) => task.sortOrder), [0, 1, 2]);

    final secondTask = tasks!.firstWhere((task) => task.title == '第二项');
    await repo.updateTask(
      TasksCompanion(
        id: Value(secondTask.id),
        state: const Value(AppConstants.taskStateCompleted),
        updatedAt: Value(now + 1),
      ),
    );
    await notifier.loadTasks();

    await notifier.reorderTasks(oldIndex: 1, newIndex: 0, hideCompleted: true);

    tasks = container.read(taskListProvider(groupId)).valueOrNull;
    expect(tasks?.map((task) => task.title), ['第三项', '第一项', '第二项']);

    await notifier.reorderTasks(oldIndex: 0, newIndex: 2, hideCompleted: false);

    tasks = container.read(taskListProvider(groupId)).valueOrNull;
    expect(tasks?.map((task) => task.title), ['第一项', '第二项', '第三项']);
  });

  test('task provider can restore a deleted task', () async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final repo = container.read(taskRepositoryProvider);
    final groupId = await repo.createList(
      TaskListsCompanion.insert(
        name: '撤销分组',
        color: const Value(0xFF4F6FA8),
        createdAt: now,
        updatedAt: now,
      ),
    );
    final notifier = container.read(taskListProvider(groupId).notifier);
    await notifier.createTask('误删任务');

    var tasks = container.read(taskListProvider(groupId)).valueOrNull;
    final taskId = tasks!.single.id;

    final snapshot = await notifier.deleteTask(taskId);
    expect(snapshot, isNotNull);
    tasks = container.read(taskListProvider(groupId)).valueOrNull;
    expect(tasks, isEmpty);

    await notifier.restoreDeletedTask(snapshot!);
    tasks = container.read(taskListProvider(groupId)).valueOrNull;
    expect(tasks?.single.title, '误删任务');
    expect(tasks?.single.id, taskId);
  });

  test('task provider updates details, duplicates, and moves tasks', () async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final repo = container.read(taskRepositoryProvider);
    final sourceId = await repo.createList(
      TaskListsCompanion.insert(
        name: '来源',
        color: const Value(0xFF4F6FA8),
        createdAt: now,
        updatedAt: now,
      ),
    );
    final targetId = await repo.createList(
      TaskListsCompanion.insert(
        name: '目标',
        color: const Value(0xFF6A8F4F),
        createdAt: now,
        updatedAt: now,
      ),
    );
    final notifier = container.read(taskListProvider(sourceId).notifier);
    await notifier.createTask('任务');
    var tasks = container.read(taskListProvider(sourceId)).valueOrNull!;
    final taskId = tasks.single.id;

    await notifier.updateTaskDetails(
      taskId,
      title: '任务详情',
      description: '备注',
      priority: 2,
      dueDayNum: 12,
      estimatedMinutes: 50,
      isFocus: true,
      isPinned: false,
      color: 0xFF8E3B46,
    );
    await notifier.duplicateTask(taskId);
    await notifier.moveTaskToGroup(taskId, targetId);

    tasks = container.read(taskListProvider(sourceId)).valueOrNull!;
    final targetTasks = await repo.getTasksByList(targetId);
    expect(tasks.single.title, '任务详情 副本');
    expect(tasks.single.description, '备注');
    expect(tasks.single.color, 0xFF8E3B46);
    expect(tasks.single.priority, 2);
    expect(tasks.single.dueDayNum, 12);
    expect(tasks.single.estimatedMinutes, 50);
    expect(tasks.single.isFocus, 1);
    expect(targetTasks.single.id, taskId);
  });
}
