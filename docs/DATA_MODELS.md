# Focus Timer 数据模型与数据库架构

> **注意**：本文档描述的是参考 APK（v1.18.13）的字段结构，用于架构学习。**实际实现的 Drift 表（`lib/data/database/tables.dart`）是简化版**，主要差异：PK 改为 integer autoIncrement、去掉 uuid/isDeleted/pauseTime/timeZone 字段、durationMs 直接存表中。

## 核心表结构

### 1. focus_time 表（计时记录）

**SQL 结构推断**：
```sql
CREATE TABLE focus_time (
  uuid TEXT PRIMARY KEY,
  name TEXT,
  userId INTEGER,
  startTime INTEGER,
  endTime INTEGER,
  scheduledTime INTEGER,      -- 用于倒计时，预计时长
  pauseStartTime INTEGER,
  pauseEndTime INTEGER,
  pauseTotalTime INTEGER,     -- 暂停时间累计
  timeZone INTEGER,           -- 时区
  dayNum INTEGER,             -- 日期编号（从1970-01-01起的天数）
  state INTEGER,              -- 0=停止, 1=正计时, 2=暂停, 3=等待开始
  type INTEGER,               -- 0=番茄, 1=休息, 2=自由, 3=睡眠, 4=视频, 10=倒计时
  createTime INTEGER,
  updateTime INTEGER,
  isSync INTEGER,
  isDeleted INTEGER,          -- 0=正常, 1=已删除（软删除）
  comment TEXT
);

CREATE INDEX idx_focus_time_userId_dayNum ON focus_time(userId, dayNum);
CREATE INDEX idx_focus_time_type_isDeleted ON focus_time(type, isDeleted);
```

**关键查询**（从反编译代码提取）：
```sql
-- 热力图月度数据
SELECT dayNum, startTime, endTime, pauseTotalTime 
FROM focus_time 
WHERE userId = ? AND dayNum >= ? AND dayNum <= ? 
  AND isDeleted < 1 
  AND (type = 0 OR type = 2 OR type = 4)  -- 番茄、自由、视频
ORDER BY dayNum, startTime;

-- 待办任务（推断）
SELECT * FROM tasks
WHERE userId = ? AND isDeleted = 0
ORDER BY createTime DESC;
```

---

## Dart 数据模型

### FocusTimeInfo（计时记录）

```dart
@DataClassName("FocusTimeInfo")
class FocusTimeTable extends Table {
  TextColumn get uuid => text()();                    // PK
  TextColumn get name => text()();                    // 计时名称
  IntColumn get userId => integer()();
  IntColumn get startTime => integer().nullable()();  // ms
  IntColumn get endTime => integer().nullable()();    // ms
  IntColumn get scheduledTime => integer().nullable()();  // 预定时长
  IntColumn get pauseStartTime => integer().nullable()();
  IntColumn get pauseEndTime => integer().nullable()();
  IntColumn get pauseTotalTime => integer().nullable()();  // 暂停累计
  IntColumn get timeZone => integer().nullable()();
  IntColumn get dayNum => integer()();                // 日期编号
  IntColumn get state => integer()();                 // 0-3
  IntColumn get type => integer()();                  // 0-10
  IntColumn get createTime => integer()();
  IntColumn get updateTime => integer()();
  IntColumn get isSync => integer().nullable()();     // 0/1
  IntColumn get isDeleted => integer()();             // 0/1（软删除）
  TextColumn get comment => text().nullable()();

  @override
  Set<Column> get primaryKey => {uuid};
}

// 生成的 Freezed/JSON 模型
@freezed
class FocusTimeInfo with _$FocusTimeInfo {
  const FocusTimeInfo._();

  const factory FocusTimeInfo({
    required String uuid,
    required String name,
    required int userId,
    required DateTime startTime,
    DateTime? endTime,
    int? scheduledTime,        // ms
    DateTime? pauseStartTime,
    DateTime? pauseEndTime,
    int? pauseTotalTime,       // ms
    int? timeZone,
    required int dayNum,
    required int state,        // 0=STOP, 1=FOCUSING, 2=PAUSE, 3=WAITING
    required int type,         // 0=TOMATO, 1=REST, 2=FREEDOM, ...
    required DateTime createTime,
    required DateTime updateTime,
    int? isSync,
    required int isDeleted,
    String? comment,
  }) = _FocusTimeInfo;

  // 计算实际专注时长（排除暂停）
  int get durationMs {
    if (startTime == null || endTime == null) return 0;
    final total = endTime!.difference(startTime!).inMilliseconds;
    final paused = pauseTotalTime ?? 0;
    return total - paused;
  }

  // 状态文本
  String get stateText {
    switch (state) {
      case 1: return '正在专注';
      case 2: return '已暂停';
      case 3: return '倒计时';
      default: return '已停止';
    }
  }

  // 类型文本
  String get typeText {
    switch (type) {
      case 0: return '番茄计时';
      case 1: return '休息';
      case 2: return '自由计时';
      case 3: return '睡眠';
      case 4: return '视频学习';
      case 10: return '倒计时';
      default: return '其他';
    }
  }
}

// 常量
class FocusTimeConstants {
  // 状态
  static const int STATE_STOP = 0;
  static const int STATE_FOCUSING = 1;
  static const int STATE_PAUSE = 2;
  static const int STATE_WAITING_FOR_START = 3;

  // 类型
  static const int TYPE_TOMATO = 0;
  static const int TYPE_REST = 1;
  static const int TYPE_FREEDOM = 2;
  static const int TYPE_SLEEP = 3;
  static const int TYPE_VIDEO = 4;
  static const int TYPE_GET_UP = 5;
  static const int TYPE_COUNT_DOWN_DAY = 10;
}
```

### TaskInfo（待办任务，推断）

从原版 UI 分析推断的待办结构：

```dart
@DataClassName("TaskInfo")
class TaskTable extends Table {
  TextColumn get uuid => text()();                    // PK
  TextColumn get title => text()();                   // 任务标题
  TextColumn get description => text().nullable()();
  IntColumn get userId => integer()();
  IntColumn get listId => integer()();                // 所属列表
  IntColumn get priority => integer()();              // 优先级 (0-3)
  IntColumn get state => integer()();                 // 0=TODO, 1=DONE
  IntColumn get effort => integer().nullable()();     // 预估工时（分钟）
  IntColumn get remindTime => integer().nullable()(); // 提醒时间 (ms)
  IntColumn get dueTime => integer().nullable()();    // 截止时间 (ms)
  IntColumn get createTime => integer()();
  IntColumn get updateTime => integer()();
  IntColumn get isDeleted => integer()();             // 软删除
  TextColumn get tags => text().nullable()();         // JSON: ["tag1", "tag2"]

  @override
  Set<Column> get primaryKey => {uuid};
}

@freezed
class TaskInfo with _$TaskInfo {
  const TaskInfo._();

  const factory TaskInfo({
    required String uuid,
    required String title,
    String? description,
    required int userId,
    required int listId,
    required int priority,     // 0-3
    required int state,        // 0=TODO, 1=DONE
    int? effort,               // 分钟
    DateTime? remindTime,
    DateTime? dueTime,
    required DateTime createTime,
    required DateTime updateTime,
    required int isDeleted,
    List<String>? tags,
  }) = _TaskInfo;
}
```

### TaskList（待办列表）

```dart
@DataClassName("TaskList")
class TaskListTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get name => text()();                    // 列表名称
  IntColumn get color => integer()();                 // ARGB 颜色
  IntColumn get order => integer()();                 // 排序序号
  IntColumn get createTime => integer()();
  IntColumn get isDeleted => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@freezed
class TaskList with _$TaskList {
  const TaskList._();

  const factory TaskList({
    required int id,
    required int userId,
    required String name,
    required int color,        // 0xFFRRGGBB
    required int order,
    required DateTime createTime,
    required int isDeleted,
  }) = _TaskList;
}
```

### HeatmapData（热力图数据，派生）

```dart
@freezed
class HeatmapData with _$HeatmapData {
  const HeatmapData._();

  const factory HeatmapData({
    required int dayNum,       // 日期编号
    required int minutes,      // 该日期专注分钟数
  }) = _HeatmapData;

  // 将日期编号转换回日期
  DateTime get date {
    final epochMilestones = DateTime.utc(1970, 1, 1);
    return epochMilestones.add(Duration(days: dayNum - 1));
  }
}

// 月度统计
@freezed
class MonthlyStats with _$MonthlyStats {
  const MonthlyStats._();

  const factory MonthlyStats({
    required int totalHours,       // 该月总专注小时数
    required int activeDays,       // 有记录的天数
    required Map<int, int> dailyData,  // day -> minutes
  }) = _MonthlyStats;
}
```

### FocusWidgetData（Widget 显示数据，派生）

```dart
@freezed
class FocusWidgetData with _$FocusWidgetData {
  const FocusWidgetData._();

  const factory FocusWidgetData({
    required bool isActive,        // 是否有活跃计时
    required String currentTime,   // 显示时间字符串 "HH:MM:SS"
    required String statusText,    // "正在专注" / "已暂停" / "倒计时" / ...
    required double progressValue, // 0.0-1.0
    required String name,          // 计时名称
  }) = _FocusWidgetData;
}
```

---

## dayNum 计算方式

从反编译代码 `HeatmapWidgetData.dateToDayNum()` 推断：

```kotlin
fun dateToDayNum(year: Int, month: Int, day: Int): Int {
    val targetDate = Calendar.getInstance().apply {
        set(year, month - 1, day, 0, 0, 0)
        set(Calendar.MILLISECOND, 0)
    }
    val epoch = Calendar.getInstance().apply {
        set(1970, 0, 1, 0, 0, 0)
        set(Calendar.MILLISECOND, 0)
    }
    return ((targetDate.timeInMillis - epoch.timeInMillis) / 86400000L).toInt() + 1
}
```

**Dart 实现**：
```dart
int dateToDayNum(DateTime date) {
  final epoch = DateTime.utc(1970, 1, 1);
  final normalized = DateTime.utc(date.year, date.month, date.day);
  final diff = normalized.difference(epoch);
  return diff.inDays + 1;
}

DateTime dayNumToDate(int dayNum) {
  final epoch = DateTime.utc(1970, 1, 1);
  return epoch.add(Duration(days: dayNum - 1));
}
```

---

## 数据库访问模式

### Drift 查询示例

```dart
// 获取某月热力图数据
Future<Map<int, int>> getMonthlyHeatmap(int userId, int year, int month) async {
  final startDay = dateToDayNum(DateTime(year, month, 1));
  final endDay = dateToDayNum(DateTime(year, month + 1, 0));
  
  final records = await (select(focusTimeTable)
    ..where((t) =>
      t.userId.equals(userId) &
      t.dayNum.isBetweenValues(startDay, endDay) &
      t.isDeleted.equals(0) &
      (t.type.equals(0) | t.type.equals(2) | t.type.equals(4))
    )
  ).get();

  final result = <int, int>{};
  for (int day = startDay; day <= endDay; day++) {
    result[day] = 0;
  }
  
  for (final record in records) {
    final duration = record.durationMs ~/ 60000;
    if (duration > 0) {
      result[record.dayNum] = (result[record.dayNum] ?? 0) + duration;
    }
  }
  
  return result;
}

// 获取当前活跃计时
Future<FocusTimeInfo?> getCurrentFocusTime(int userId) async {
  return (select(focusTimeTable)
    ..where((t) =>
      t.userId.equals(userId) &
      t.state.notEquals(0) &
      t.isDeleted.equals(0)
    )
    ..orderBy([(t) => OrderingTerm(expression: t.updateTime, mode: OrderingMode.desc)])
    ..limit(1)
  ).getSingleOrNull();
}

// 分页获取当日任务
Future<List<TaskInfo>> getDayTasks(int userId, int listId, {int page = 0, int pageSize = 20}) async {
  return (select(taskTable)
    ..where((t) =>
      t.userId.equals(userId) &
      t.listId.equals(listId) &
      t.isDeleted.equals(0)
    )
    ..orderBy([(t) => OrderingTerm(expression: t.createTime, mode: OrderingMode.desc)])
    ..limit(pageSize, offset: page * pageSize)
  ).get();
}
```

---

## 待做数据表（推断）

基于原版分析，还需要以下表：

| 表名 | 用途 | 关键字段 |
|------|------|----------|
| `focus_time` | ✅ 计时记录（已解析） | uuid, userId, dayNum, type, state, startTime |
| `tasks` | 待办任务 | uuid, userId, listId, title, priority, state |
| `task_lists` | 待办列表 | id, userId, name, order |
| `habits` | 习惯追踪 | uuid, userId, name, frequency, lastDate |
| `notifications` | 提醒配置 | id, userId, type, time, enabled |
| `user_settings` | 用户设置 | userId, theme, language, notifications |
| `focus_session_backup` | 云端备份元数据 | uuid, lastSync, checksum |

---

## 数据同步策略（GitHub）

### 同步字段
- `isSync`: 0=本地未同步, 1=已同步到云端
- `updateTime`: 最后修改时间（用于冲突解决）
- `uuid`: 全局唯一ID（用于去重）

### 冲突解决
Last-Write-Wins: 比较 `updateTime`，保留较晚的版本。

### 同步格式
GitHub Gist / Repo 存储 JSON：
```json
{
  "version": "1.0",
  "timestamp": "2026-06-15T10:30:00Z",
  "focusTimeRecords": [
    {
      "uuid": "...",
      "name": "Math Homework",
      "userId": 1,
      "startTime": 1686829800000,
      "endTime": 1686833400000,
      ...
    }
  ],
  "tasks": [...],
  "taskLists": [...]
}
```
