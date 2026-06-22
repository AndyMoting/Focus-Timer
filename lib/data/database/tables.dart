import 'package:drift/drift.dart';

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
  TextColumn get note => text().nullable()();
  IntColumn get taskId => integer().nullable()();
  IntColumn get listId => integer().nullable()();
  IntColumn get planId => integer().nullable()();
  TextColumn get evidenceUri => text().nullable()();
  TextColumn get evidenceDisplayName => text().nullable()();
  TextColumn get evidenceRelativePath => text().nullable()();
  TextColumn get evidenceMimeType => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

class ActiveTimerSession extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get type => integer()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get startTimeMs => integer()();
  IntColumn get pauseStartMs => integer().nullable()();
  IntColumn get pauseTotalMs => integer().withDefault(const Constant(0))();
  IntColumn get targetDurationMs => integer().withDefault(const Constant(0))();
  IntColumn get state => integer()();
  TextColumn get note => text().nullable()();
  IntColumn get taskId => integer().nullable()();
  IntColumn get listId => integer().nullable()();
  IntColumn get planId => integer().nullable()();
  TextColumn get evidenceUri => text().nullable()();
  TextColumn get evidenceDisplayName => text().nullable()();
  TextColumn get evidenceRelativePath => text().nullable()();
  TextColumn get evidenceMimeType => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class DailyLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().withDefault(const Constant(1))();
  IntColumn get dayNum => integer()();
  IntColumn get type => integer()();
  IntColumn get loggedAt => integer()();
  TextColumn get note => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

class TaskLists extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().withDefault(const Constant(1))();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get color => integer().withDefault(const Constant(0xFF4CAF50))();
  IntColumn get iconCodePoint =>
      integer().withDefault(const Constant(0xf428))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
  IntColumn get isDailyReset => integer().withDefault(const Constant(0))();
  IntColumn get deletedAt => integer().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().withDefault(const Constant(1))();
  IntColumn get listId => integer()();
  IntColumn get dayNum => integer()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  IntColumn get color => integer().nullable()();
  IntColumn get state => integer().withDefault(const Constant(0))();
  IntColumn get priority => integer().withDefault(const Constant(0))();
  IntColumn get dueDayNum => integer().nullable()();
  IntColumn get estimatedMinutes => integer().withDefault(const Constant(0))();
  IntColumn get isFocus => integer().withDefault(const Constant(0))();
  IntColumn get isPinned => integer().withDefault(const Constant(0))();
  IntColumn get pinnedAt => integer().nullable()();
  IntColumn get reminderAt => integer().nullable()();
  TextColumn get repeatRule => text().withDefault(const Constant('none'))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get completedAt => integer().nullable()();
}

class TaskPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().withDefault(const Constant(1))();
  IntColumn get listId => integer()();
  IntColumn get taskId => integer()();
  IntColumn get dayNum => integer()();
  IntColumn get startHour => integer()();
  IntColumn get startMinute => integer().nullable()();
  IntColumn get durationMinutes => integer().withDefault(const Constant(60))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

class TaskPlanSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get startMinute => integer().withDefault(const Constant(0))();
  IntColumn get endMinute => integer().withDefault(const Constant(1440))();
  IntColumn get slotMinutes => integer().withDefault(const Constant(60))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class StatsSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get visibleCharts =>
      text().withDefault(const Constant('heatmap,pie,dailyLog,timeline'))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
