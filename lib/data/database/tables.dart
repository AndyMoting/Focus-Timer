import 'package:drift/drift.dart';

/// 计时记录表
class FocusTime extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().withDefault(const Constant(1))();
  IntColumn get dayNum => integer()();
  IntColumn get type => integer()();
  IntColumn get state => integer()();
  IntColumn get startTime => integer()();
  IntColumn get endTime => integer().nullable()();
  IntColumn get durationMs => integer().withDefault(const Constant(0))();
  IntColumn get scheduledTime => integer().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

/// 待办列表表
class TaskLists extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().withDefault(const Constant(1))();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

/// 任务表
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().withDefault(const Constant(1))();
  IntColumn get listId => integer()();
  IntColumn get dayNum => integer()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  IntColumn get state => integer().withDefault(const Constant(0))();
  IntColumn get priority => integer().withDefault(const Constant(0))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get completedAt => integer().nullable()();
}
