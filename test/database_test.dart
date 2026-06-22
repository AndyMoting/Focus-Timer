import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_timer/data/database/database.dart';

AppDatabase _buildTestDb() {
  return AppDatabase.forTesting(NativeDatabase.memory());
}

void main() {
  late AppDatabase db;
  final now = DateTime.now().millisecondsSinceEpoch;
  final dayNum = DateTime.now().difference(DateTime.utc(1970)).inDays + 1;

  setUp(() => db = _buildTestDb());
  tearDown(() => db.close());

  group('FocusTime', () {
    test('insert and query', () async {
      final id = await db
          .into(db.focusTime)
          .insert(
            FocusTimeCompanion.insert(
              dayNum: dayNum,
              type: 0,
              state: 1,
              startTime: now,
              name: '学习',
              createdAt: now,
              updatedAt: now,
            ),
          );

      final rows = await db.select(db.focusTime).get();
      expect(rows.length, 1);
      expect(rows.first.id, id);
      expect(rows.first.name, '学习');
      expect(rows.first.durationMs, 0); // 默认值
      expect(rows.first.userId, 1); // 默认值
    });

    test('update endTime and durationMs', () async {
      final id = await db
          .into(db.focusTime)
          .insert(
            FocusTimeCompanion.insert(
              dayNum: dayNum,
              type: 0,
              state: 1,
              startTime: now,
              name: '学习',
              createdAt: now,
              updatedAt: now,
            ),
          );

      final endTime = now + 25 * 60 * 1000;
      await (db.update(db.focusTime)..where((t) => t.id.equals(id))).write(
        FocusTimeCompanion(
          endTime: Value(endTime),
          durationMs: Value(25 * 60 * 1000),
          state: const Value(0),
          updatedAt: Value(endTime),
        ),
      );

      final row = await (db.select(
        db.focusTime,
      )..where((t) => t.id.equals(id))).getSingle();
      expect(row.state, 0);
      expect(row.durationMs, 25 * 60 * 1000);
      expect(row.endTime, endTime);
    });

    test('delete row', () async {
      final id = await db
          .into(db.focusTime)
          .insert(
            FocusTimeCompanion.insert(
              dayNum: dayNum,
              type: 0,
              state: 0,
              startTime: now,
              name: '测试',
              createdAt: now,
              updatedAt: now,
            ),
          );

      await (db.delete(db.focusTime)..where((t) => t.id.equals(id))).go();
      final rows = await db.select(db.focusTime).get();
      expect(rows, isEmpty);
    });
  });

  group('TaskLists', () {
    test('insert and query', () async {
      await db
          .into(db.taskLists)
          .insert(
            TaskListsCompanion.insert(
              name: '工作',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db
          .into(db.taskLists)
          .insert(
            TaskListsCompanion.insert(
              name: '生活',
              createdAt: now,
              updatedAt: now,
            ),
          );

      final rows = await db.select(db.taskLists).get();
      expect(rows.length, 2);
      expect(rows.map((r) => r.name), containsAll(['工作', '生活']));
    });

    test('delete list', () async {
      final id = await db
          .into(db.taskLists)
          .insert(
            TaskListsCompanion.insert(
              name: '临时',
              createdAt: now,
              updatedAt: now,
            ),
          );

      await (db.delete(db.taskLists)..where((t) => t.id.equals(id))).go();
      final rows = await db.select(db.taskLists).get();
      expect(rows, isEmpty);
    });
  });

  group('Tasks', () {
    late int listId;

    setUp(() async {
      listId = await db
          .into(db.taskLists)
          .insert(
            TaskListsCompanion.insert(
              name: '默认列表',
              createdAt: now,
              updatedAt: now,
            ),
          );
    });

    test('insert and query by listId', () async {
      await db
          .into(db.tasks)
          .insert(
            TasksCompanion.insert(
              listId: listId,
              dayNum: dayNum,
              title: '写代码',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db
          .into(db.tasks)
          .insert(
            TasksCompanion.insert(
              listId: listId,
              dayNum: dayNum,
              title: '写测试',
              createdAt: now,
              updatedAt: now,
            ),
          );

      final rows = await (db.select(
        db.tasks,
      )..where((t) => t.listId.equals(listId))).get();
      expect(rows.length, 2);
      expect(rows.first.state, 0); // 默认未完成
      expect(rows.first.priority, 0); // 默认优先级
    });

    test('mark task complete', () async {
      final id = await db
          .into(db.tasks)
          .insert(
            TasksCompanion.insert(
              listId: listId,
              dayNum: dayNum,
              title: '完成我',
              createdAt: now,
              updatedAt: now,
            ),
          );

      await (db.update(db.tasks)..where((t) => t.id.equals(id))).write(
        TasksCompanion(
          state: const Value(1),
          completedAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      final row = await (db.select(
        db.tasks,
      )..where((t) => t.id.equals(id))).getSingle();
      expect(row.state, 1);
      expect(row.completedAt, now);
    });
  });
}
