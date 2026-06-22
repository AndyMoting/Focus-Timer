# Focus Timer 应用架构设计文档

**版本**: 1.0  
**日期**: 2026-06-16  
**技术栈**: Flutter 3.x + Riverpod 2.x + Drift 2.x + Freezed + Riverpod Hooks

---

## 1. 架构概览

### 1.1 核心原则

- **关注点分离**: 将业务逻辑、数据访问、UI 表现严格分层
- **依赖反向**: 上层依赖抽象（Repository 接口），下层实现接口
- **可测试性**: 每层独立可测，通过依赖注入替换实现
- **可维护性**: 清晰的目录结构，职责单一

### 1.2 四层架构

```
┌─────────────────────────────────────┐
│   Presentation (UI)                 │ ← Screens, Widgets, Providers
│   - HookConsumerWidget / StatefulWidget
│   - Riverpod StateNotifierProvider
│   - 状态驱动重建
├─────────────────────────────────────┤
│   Domain (业务逻辑)                 │ ← Models, Repositories (接口), UseCases
│   - 纯 Dart，无 Flutter 依赖
│   - 定义业务规则和数据契约
├─────────────────────────────────────┤
│   Data (数据访问)                   │ ← DAO, Mappers, Repository 实现
│   - SQLite (Drift) 操作
│   - 实现 Domain 中的 Repository 接口
├─────────────────────────────────────┤
│   Shared (基础设施)                 │ ← Constants, Extensions, Utils
└─────────────────────────────────────┘
```

---

## 2. 分层设计详解

### 2.1 Domain 层（业务逻辑）

**职责**：
- 定义纯业务模型（不依赖任何框架）
- 定义 Repository 接口（数据契约）
- 定义 UseCase（业务操作）
- 定义 Exceptions 和 Enums

**目录结构**：
```
domain/
├── entities/
│   ├── focus_time.dart          # FocusTimeInfo 模型
│   ├── task.dart                # TaskInfo 模型
│   ├── task_list.dart           # TaskList 模型
│   ├── heatmap_data.dart        # HeatmapData 模型（派生）
│   └── monthly_stats.dart       # MonthlyStats 模型（派生）
├── repositories/
│   ├── focus_time_repository.dart
│   ├── task_repository.dart
│   ├── task_list_repository.dart
│   └── heatmap_repository.dart  # 只读接口
├── usecases/
│   ├── focus_time/
│   │   ├── start_focus_use_case.dart
│   │   ├── pause_focus_use_case.dart
│   │   ├── resume_focus_use_case.dart
│   │   ├── stop_focus_use_case.dart
│   │   └── get_current_focus_use_case.dart
│   ├── task/
│   │   ├── create_task_use_case.dart
│   │   ├── update_task_use_case.dart
│   │   ├── delete_task_use_case.dart
│   │   └── list_tasks_use_case.dart
│   └── heatmap/
│       ├── get_monthly_heatmap_use_case.dart
│       └── get_monthly_stats_use_case.dart
├── failures/
│   └── failure.dart             # 异常基类
└── constants/
    └── focus_constants.dart     # 常量定义
```

**示例代码**：
```dart
// domain/entities/focus_time.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'focus_time.freezed.dart';
part 'focus_time.g.dart';

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
    required int state,        // 0-3
    required int type,         // 0-10
    required DateTime createTime,
    required DateTime updateTime,
    int? isSync,
    required int isDeleted,
    String? comment,
  }) = _FocusTimeInfo;

  int get durationMs {
    if (startTime == null || endTime == null) return 0;
    final total = endTime!.difference(startTime!).inMilliseconds;
    final paused = pauseTotalTime ?? 0;
    return total - paused;
  }

  String get stateText {
    switch (state) {
      case 1: return '正在专注';
      case 2: return '已暂停';
      case 3: return '倒计时';
      default: return '已停止';
    }
  }

  factory FocusTimeInfo.fromJson(Map<String, dynamic> json) =>
      _$FocusTimeInfoFromJson(json);
}

// domain/repositories/focus_time_repository.dart
abstract class FocusTimeRepository {
  Future<FocusTimeInfo> startFocus({
    required String name,
    required int type,
    required int scheduledMs,
  });

  Future<void> pauseFocus(String uuid);
  Future<void> resumeFocus(String uuid);
  Future<void> stopFocus(String uuid);

  Future<FocusTimeInfo?> getCurrentFocus(int userId);
  Future<List<FocusTimeInfo>> getDayFocusRecords(int userId, DateTime date);
  Future<void> deleteFocus(String uuid);
}

// domain/usecases/focus_time/start_focus_use_case.dart
class StartFocusUseCase {
  final FocusTimeRepository _repository;

  StartFocusUseCase(this._repository);

  Future<FocusTimeInfo> call({
    required String name,
    required int type,
    required int scheduledMs,
  }) {
    if (name.isEmpty) {
      throw const FormatException('计时名称不能为空');
    }
    if (scheduledMs <= 0 && type != FocusTimeConstants.TYPE_FREEDOM) {
      throw const FormatException('预定时长必须大于 0');
    }
    return _repository.startFocus(
      name: name,
      type: type,
      scheduledMs: scheduledMs,
    );
  }
}
```

---

### 2.2 Data 层（数据访问）

**职责**：
- 实现 Domain Repository 接口
- 数据库操作 (Drift DAO)
- Entity ↔ Domain Model 映射 (Mapper)
- 缓存策略（可选）

**目录结构**：
```
data/
├── database/
│   ├── database.dart            # Drift database 主体
│   ├── tables/
│   │   ├── focus_time_table.dart
│   │   ├── task_table.dart
│   │   ├── task_list_table.dart
│   │   └── heatmap_cache_table.dart
│   ├── daos/
│   │   ├── focus_time_dao.dart
│   │   ├── task_dao.dart
│   │   └── heatmap_dao.dart
│   └── migrations/
│       └── migration_v1.dart
├── models/
│   ├── focus_time_entity.dart
│   ├── task_entity.dart
│   └── task_list_entity.dart
├── mappers/
│   ├── focus_time_mapper.dart
│   ├── task_mapper.dart
│   └── base_mapper.dart
└── repositories/
    ├── focus_time_repository_impl.dart
    ├── task_repository_impl.dart
    └── heatmap_repository_impl.dart
```

**Drift 数据库定义**：
```dart
// data/database/tables/focus_time_table.dart
import 'package:drift/drift.dart';

@DataClassName('FocusTimeEntity')
class FocusTimeTable extends Table {
  TextColumn get uuid => text()();
  TextColumn get name => text()();
  IntColumn get userId => integer()();
  IntColumn get startTime => integer()();      // ms since epoch
  IntColumn get endTime => integer().nullable()();
  IntColumn get scheduledTime => integer().nullable()();
  IntColumn get pauseStartTime => integer().nullable()();
  IntColumn get pauseEndTime => integer().nullable()();
  IntColumn get pauseTotalTime => integer().nullable()();  // ms
  IntColumn get timeZone => integer().nullable()();
  IntColumn get dayNum => integer()();         // 日期编号
  IntColumn get state => integer()();          // 0-3
  IntColumn get type => integer()();           // 0-10
  IntColumn get createTime => integer()();
  IntColumn get updateTime => integer()();
  IntColumn get isSync => integer().nullable()();
  IntColumn get isDeleted => integer()();
  TextColumn get comment => text().nullable()();

  @override
  Set<Column> get primaryKey => {uuid};
}

// data/database/daos/focus_time_dao.dart
part 'focus_time_dao.g.dart';

@DriftAccessor(tables: [FocusTimeTable])
class FocusTimeDao extends DatabaseAccessor<Database>
    with _$FocusTimeDaoDrift {
  FocusTimeDao(super.db);

  Future<FocusTimeEntity> insertFocusTime(FocusTimeEntity entity) {
    return into(focusTimeTable).insertReturning(entity);
  }

  Future<void> updateFocusTime(FocusTimeEntity entity) {
    return update(focusTimeTable).replace(entity);
  }

  Future<void> deleteFocusTime(String uuid) async {
    await (update(focusTimeTable)
        ..where((t) => t.uuid.equals(uuid)))
        .write(const FocusTimeTableCompanion(isDeleted: Value(1)));
  }

  Future<FocusTimeEntity?> getFocusTimeByUuid(String uuid) {
    return (select(focusTimeTable)
        ..where((t) => t.uuid.equals(uuid) & t.isDeleted.equals(0)))
        .getSingleOrNull();
  }

  Future<List<FocusTimeEntity>> getCurrentFocusTime(int userId) {
    return (select(focusTimeTable)
        ..where((t) =>
            t.userId.equals(userId) &
            t.state.notEquals(0) &
            t.isDeleted.equals(0))
        ..orderBy([(t) => OrderingTerm(
            expression: t.updateTime, mode: OrderingMode.desc)])
        ..limit(1))
        .get();
  }

  Future<List<FocusTimeEntity>> getDayFocusRecords(int userId, int dayNum) {
    return (select(focusTimeTable)
        ..where((t) =>
            t.userId.equals(userId) &
            t.dayNum.equals(dayNum) &
            t.isDeleted.equals(0))
        ..orderBy([(t) => OrderingTerm(expression: t.startTime)]))
        .get();
  }

  Future<Map<int, int>> getMonthlyHeatmapData(
      int userId, int startDayNum, int endDayNum) async {
    final records = await (select(focusTimeTable)
        ..where((t) =>
            t.userId.equals(userId) &
            t.dayNum.isBetweenValues(startDayNum, endDayNum) &
            t.isDeleted.equals(0) &
            (t.type.equals(0) | t.type.equals(2) | t.type.equals(4)))
        ..orderBy([(t) => OrderingTerm(expression: t.dayNum)]))
        .get();

    final result = <int, int>{};
    for (final record in records) {
      final duration = record.durationMs ~/ 60000;  // 转换为分钟
      if (duration > 0) {
        result[record.dayNum] = (result[record.dayNum] ?? 0) + duration;
      }
    }
    return result;
  }

  int get durationMs {
    if (endTime == null) return 0;
    final total = endTime! - startTime;
    final paused = pauseTotalTime ?? 0;
    return total - paused;
  }
}

// data/database/database.dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    FocusTimeTable,
    TaskTable,
    TaskListTable,
  ],
  daos: [
    FocusTimeDao,
    TaskDao,
    TaskListDao,
  ],
)
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'focus_timer_app');
  }
}
```

**Mapper**：
```dart
// data/mappers/focus_time_mapper.dart
class FocusTimeMapper {
  static FocusTimeInfo toDomain(FocusTimeEntity entity) {
    return FocusTimeInfo(
      uuid: entity.uuid,
      name: entity.name,
      userId: entity.userId,
      startTime: DateTime.fromMillisecondsSinceEpoch(entity.startTime),
      endTime: entity.endTime != null
          ? DateTime.fromMillisecondsSinceEpoch(entity.endTime!)
          : null,
      scheduledTime: entity.scheduledTime,
      pauseStartTime: entity.pauseStartTime != null
          ? DateTime.fromMillisecondsSinceEpoch(entity.pauseStartTime!)
          : null,
      pauseEndTime: entity.pauseEndTime != null
          ? DateTime.fromMillisecondsSinceEpoch(entity.pauseEndTime!)
          : null,
      pauseTotalTime: entity.pauseTotalTime,
      timeZone: entity.timeZone,
      dayNum: entity.dayNum,
      state: entity.state,
      type: entity.type,
      createTime: DateTime.fromMillisecondsSinceEpoch(entity.createTime),
      updateTime: DateTime.fromMillisecondsSinceEpoch(entity.updateTime),
      isSync: entity.isSync,
      isDeleted: entity.isDeleted,
      comment: entity.comment,
    );
  }

  static FocusTimeEntity toEntity(FocusTimeInfo domain) {
    return FocusTimeEntity(
      uuid: domain.uuid,
      name: domain.name,
      userId: domain.userId,
      startTime: domain.startTime.millisecondsSinceEpoch,
      endTime: domain.endTime?.millisecondsSinceEpoch,
      scheduledTime: domain.scheduledTime,
      pauseStartTime: domain.pauseStartTime?.millisecondsSinceEpoch,
      pauseEndTime: domain.pauseEndTime?.millisecondsSinceEpoch,
      pauseTotalTime: domain.pauseTotalTime,
      timeZone: domain.timeZone,
      dayNum: domain.dayNum,
      state: domain.state,
      type: domain.type,
      createTime: domain.createTime.millisecondsSinceEpoch,
      updateTime: domain.updateTime.millisecondsSinceEpoch,
      isSync: domain.isSync,
      isDeleted: domain.isDeleted,
      comment: domain.comment,
    );
  }
}
```

**Repository 实现**：
```dart
// data/repositories/focus_time_repository_impl.dart
class FocusTimeRepositoryImpl implements FocusTimeRepository {
  final FocusTimeDao _dao;

  FocusTimeRepositoryImpl(this._dao);

  @override
  Future<FocusTimeInfo> startFocus({
    required String name,
    required int type,
    required int scheduledMs,
  }) async {
    final entity = FocusTimeEntity(
      uuid: const Uuid().v4(),
      name: name,
      userId: 1,  // TODO: 从用户上下文获取
      startTime: DateTime.now().millisecondsSinceEpoch,
      type: type,
      scheduledTime: scheduledMs,
      state: FocusTimeConstants.STATE_FOCUSING,
      dayNum: _calculateDayNum(DateTime.now()),
      createTime: DateTime.now().millisecondsSinceEpoch,
      updateTime: DateTime.now().millisecondsSinceEpoch,
      isDeleted: 0,
    );

    final inserted = await _dao.insertFocusTime(entity);
    return FocusTimeMapper.toDomain(inserted);
  }

  @override
  Future<FocusTimeInfo?> getCurrentFocus(int userId) async {
    final records = await _dao.getCurrentFocusTime(userId);
    if (records.isEmpty) return null;
    return FocusTimeMapper.toDomain(records.first);
  }

  int _calculateDayNum(DateTime date) {
    final epoch = DateTime.utc(1970, 1, 1);
    final normalized = DateTime.utc(date.year, date.month, date.day);
    return normalized.difference(epoch).inDays + 1;
  }
}
```

---

### 2.3 Presentation 层（UI）

**职责**：
- 构建 Widget 树
- 通过 Riverpod 连接状态
- 响应用户交互
- 显示数据

**Riverpod 状态管理设计**：

```dart
// presentation/providers/database_provider.dart
final databaseProvider = Provider((ref) {
  return Database();
});

// presentation/providers/focus_time_provider.dart
final focusTimeRepositoryProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  return FocusTimeRepositoryImpl(db.focusTimeDao);
});

// StateNotifierProvider for focus time state management
final focusTimeNotifierProvider = StateNotifierProvider<
    FocusTimeNotifier,
    AsyncValue<FocusTimeInfo?>>((ref) {
  final repository = ref.watch(focusTimeRepositoryProvider);
  return FocusTimeNotifier(repository);
});

// class FocusTimeNotifier extends StateNotifier<AsyncValue<FocusTimeInfo?>> {
//   final FocusTimeRepository _repository;
//
//   FocusTimeNotifier(this._repository)
//       : super(const AsyncValue.data(null));
//
//   Future<void> startFocus({
//     required String name,
//     required int type,
//     required int scheduledMs,
//   }) async {
//     state = const AsyncValue.loading();
//     state = await AsyncValue.guard(() => _repository.startFocus(
//       name: name,
//       type: type,
//       scheduledMs: scheduledMs,
//     ));
//   }
//
//   Future<void> pauseFocus(String uuid) async {
//     await _repository.pauseFocus(uuid);
//     // 重新加载当前状态
//     await _loadCurrentFocus();
//   }
//
//   Future<void> _loadCurrentFocus() async {
//     state = const AsyncValue.loading();
//     state = await AsyncValue.guard(
//       () => _repository.getCurrentFocus(1),
//     );
//   }
// }

// 派生 Provider：计算进度、显示时间等
final focusProgressProvider = Provider.autoDispose((ref) {
  final focusState = ref.watch(focusTimeNotifierProvider);
  return focusState.whenData((focus) {
    if (focus == null) return 0.0;
    if (focus.scheduledTime == null || focus.scheduledTime! <= 0) {
      return 0.0;
    }
    return focus.durationMs / focus.scheduledTime!;
  }).asData?.value ?? 0.0;
});

// 显示文本 Provider
final focusDisplayProvider = Provider.autoDispose((ref) {
  final focusState = ref.watch(focusTimeNotifierProvider);
  return focusState.whenData((focus) {
    if (focus == null) return '00:00:00';
    final seconds = focus.durationMs ~/ 1000;
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }).asData?.value ?? '00:00:00';
});

// 分页 Tasks Provider
final taskListProvider = StateNotifierProvider.autoDispose
    .family<TaskListNotifier, AsyncValue<List<TaskInfo>>, int>(
  (ref, listId) {
    final repo = ref.watch(taskRepositoryProvider);
    return TaskListNotifier(repo, listId);
  },
);
```

**Screen 示例**：
```dart
// presentation/screens/timer_screen.dart
class TimerScreen extends HookConsumerWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听计时状态
    final focusState = ref.watch(focusTimeNotifierProvider);
    final focusNotifier = ref.read(focusTimeNotifierProvider.notifier);
    
    // 衍生状态
    final progress = ref.watch(focusProgressProvider);
    final timeDisplay = ref.watch(focusDisplayProvider);

    // Hook：处理定时更新（每秒刷新显示）
    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (_) {
        ref.refresh(focusDisplayProvider);
      });
      return () => timer.cancel();
    }, []);

    return Scaffold(
      appBar: AppBar(title: const Text('专注计时')),
      body: focusState.when(
        data: (focus) => _buildTimerUI(
          context,
          focus,
          focusNotifier,
          progress,
          timeDisplay,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('加载失败: $err'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerUI(
    BuildContext context,
    FocusTimeInfo? focus,
    FocusTimeNotifier notifier,
    double progress,
    String timeDisplay,
  ) {
    if (focus == null) {
      return _buildStartForm(context, notifier);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 大时间显示
        Text(
          timeDisplay,
          style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // 进度条
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: LinearProgressIndicator(value: progress),
        ),
        const SizedBox(height: 32),

        // 控制按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (focus.state == FocusTimeConstants.STATE_FOCUSING)
              FloatingActionButton(
                onPressed: () => notifier.pauseFocus(focus.uuid),
                child: const Icon(Icons.pause),
              ),
            if (focus.state == FocusTimeConstants.STATE_PAUSE)
              FloatingActionButton(
                onPressed: () => notifier.resumeFocus(focus.uuid),
                child: const Icon(Icons.play_arrow),
              ),
            const SizedBox(width: 16),
            FloatingActionButton(
              onPressed: () => notifier.stopFocus(focus.uuid),
              backgroundColor: Colors.red,
              child: const Icon(Icons.stop),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStartForm(
    BuildContext context,
    FocusTimeNotifier notifier,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TODO: 表单输入（名称、类型、预定时长）
          ElevatedButton(
            onPressed: () => notifier.startFocus(
              name: '学习',
              type: FocusTimeConstants.TYPE_TOMATO,
              scheduledMs: 25 * 60 * 1000,  // 25分钟番茄
            ),
            child: const Text('开始计时'),
          ),
        ],
      ),
    );
  }
}
```

---

### 2.4 Shared 层（基础设施）

**职责**：
- 常量定义
- 工具函数 (Extensions)
- 通用 Widget
- 日志、配置等

```
shared/
├── constants/
│   ├── focus_constants.dart
│   ├── strings.dart
│   └── sizes.dart
├── extensions/
│   ├── datetime_extensions.dart
│   ├── duration_extensions.dart
│   └── int_extensions.dart
├── widgets/
│   ├── loading_widget.dart
│   ├── error_widget.dart
│   └── custom_button.dart
└── utils/
    ├── logger.dart
    ├── validators.dart
    └── formatters.dart
```

```dart
// shared/extensions/datetime_extensions.dart
extension DateTimeExt on DateTime {
  int toDayNum() {
    final epoch = DateTime.utc(1970, 1, 1);
    final normalized = DateTime.utc(year, month, day);
    return normalized.difference(epoch).inDays + 1;
  }

  String toDateString() => '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}

// shared/extensions/duration_extensions.dart
extension DurationExt on Duration {
  String toHHMMSS() {
    final h = inHours;
    final m = inMinutes % 60;
    final s = inSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
```

---

## 3. Riverpod 状态管理深入

### 3.1 Provider 类型选择

| Provider 类型 | 用途 | 示例 |
|---|---|---|
| `Provider` | 计算值，无副作用 | `focusProgressProvider` |
| `StateNotifierProvider` | 有状态，可修改 | `focusTimeNotifierProvider` |
| `FutureProvider` | 异步操作（单次） | `getMonthlyStatsProvider` |
| `StreamProvider` | 实时流（连续监听） | `focusTimeStreamProvider` |
| `.autoDispose` | 未使用时释放资源 | 分页列表、临时数据 |
| `.family` | 参数化 Provider | `taskListProvider(listId)` |

### 3.2 选择优化

```dart
// ❌ 不推荐：每次返回新对象，导致不必要重建
final taskListProvider = Provider((ref) {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getTasks();  // ← 每次都返回新 List，无法比较相等性
});

// ✅ 推荐：使用 select() 只监听必要部分
final taskCountProvider = Provider.autoDispose((ref) {
  final tasks = ref.watch(taskListProvider);
  return tasks.length;
});

// ✅ 推荐：异步操作用 FutureProvider
final monthlyStatsProvider = FutureProvider.autoDispose
    .family<MonthlyStats, (int, int)>((ref, (year, month)) async {
  final repo = ref.watch(heatmapRepositoryProvider);
  return repo.getMonthlyStats(year, month);
});

// ✅ 推荐：UI 事件通过 StateNotifier
class FocusTimeNotifier extends StateNotifier<AsyncValue<FocusTimeInfo?>> {
  // ...
  Future<void> startFocus({...}) async { ... }
}

final focusTimeProvider = StateNotifierProvider<
    FocusTimeNotifier,
    AsyncValue<FocusTimeInfo?>>((ref) {
  final repo = ref.watch(focusTimeRepositoryProvider);
  return FocusTimeNotifier(repo);
});
```

### 3.3 重建优化

```dart
// ❌ 不推荐：频繁重建整个列表
final allTasksProvider = StateNotifierProvider<TaskListNotifier, List<TaskInfo>>((ref) {
  // 任何变化都重建整个列表
  return TaskListNotifier(ref.watch(taskRepositoryProvider));
});

class TaskListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTasks = ref.watch(allTasksProvider);  // ← 整体重建
    return ListView.builder(
      itemCount: allTasks.length,
      itemBuilder: (_, i) => TaskTile(allTasks[i]),
    );
  }
}

// ✅ 推荐：监听单个任务的变化
final taskProvider = StateNotifierProvider.family<
    TaskNotifier,
    AsyncValue<TaskInfo>,
    String>((ref, taskId) {
  final repo = ref.watch(taskRepositoryProvider);
  return TaskNotifier(repo, taskId);
});

class TaskTile extends ConsumerWidget {
  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskProvider(taskId));  // ← 只监听这个任务
    return taskState.when(
      data: (task) => ListTile(title: Text(task.title)),
      loading: () => const Skeleton(),
      error: (err, st) => ErrorText(err),
    );
  }
}
```

---

## 4. 数据流设计

### 4.1 计时流程

```
用户点击"开始" 
  ↓
TimerScreen 调用 focusTimeNotifier.startFocus()
  ↓
FocusTimeNotifier.startFocus() → 调用 UseCase
  ↓
StartFocusUseCase → 验证输入
  ↓
FocusTimeRepository.startFocus() → 实现
  ↓
FocusTimeRepositoryImpl → 创建 Entity
  ↓
FocusTimeDao.insertFocusTime() → Drift 操作
  ↓
数据库存储
  ↓
返回 FocusTimeInfo 到 StateNotifier
  ↓
state = AsyncValue.data(focusTimeInfo)
  ↓
HookConsumerWidget 监听 focusTimeNotifierProvider 自动重建
  ↓
使用 Hook 的 Timer 每秒刷新显示时间
```

### 4.2 热力图查询流程

```
用户打开 AnalyticsScreen(year=2026, month=6)
  ↓
Widget 监听 monthlyStatsProvider(2026, 6)
  ↓
FutureProvider 异步执行：
  ├─ heatmapRepository.getMonthlyStats(2026, 6)
  ├─ 转换 startDayNum = dateToDayNum(2026-06-01)
  ├─ 转换 endDayNum = dateToDayNum(2026-06-30)
  └─ 调用 DAO 查询
  ↓
HeatmapDao.getMonthlyHeatmapData()
  ├─ SQL: SELECT dayNum, startTime, endTime, pauseTotalTime
  │        WHERE userId=1 AND dayNum BETWEEN startDayNum AND endDayNum
  │        AND type IN (0, 2, 4) AND isDeleted=0
  └─ 返回 Map<dayNum, minutes>
  ↓
Mapper 转换为 MonthlyStats 对象
  ↓
返回 AsyncValue.data(monthlyStats)
  ↓
Widget 收到数据，渲染热力图
```

---

## 5. 错误处理策略

### 5.1 三层异常处理

```dart
// Domain 层：定义业务异常
abstract class Failure {
  final String message;
  Failure(this.message);
}

class FocusTimeFailure extends Failure {
  FocusTimeFailure(String message) : super(message);
}

class DatabaseFailure extends Failure {
  DatabaseFailure(String message) : super(message);
}

// Data 层：捕获、转换异常
Future<FocusTimeInfo> startFocus({...}) async {
  try {
    final entity = FocusTimeEntity(...);
    final inserted = await _dao.insertFocusTime(entity);
    return FocusTimeMapper.toDomain(inserted);
  } catch (e) {
    throw DatabaseFailure('计时启动失败: $e');
  }
}

// Presentation 层：使用 AsyncValue 包装
final focusTimeProvider = StateNotifierProvider<
    FocusTimeNotifier,
    AsyncValue<FocusTimeInfo?>>((ref) {
  final repo = ref.watch(focusTimeRepositoryProvider);
  return FocusTimeNotifier(repo);
});

// Widget 中的错误显示
class TimerScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusState = ref.watch(focusTimeProvider);
    
    return focusState.when(
      data: (focus) => _buildUI(focus),
      loading: () => LoadingWidget(),
      error: (error, stackTrace) => ErrorWidget(
        error: error.toString(),
        onRetry: () => ref.refresh(focusTimeProvider),
      ),
    );
  }
}
```

---

## 6. 依赖注入

### 6.1 Provider 链

```dart
// 基础 Provider
final databaseProvider = Provider((ref) => Database());

final focusTimeDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).focusTimeDao;
});

// Repository Provider
final focusTimeRepositoryProvider = Provider<FocusTimeRepository>((ref) {
  final dao = ref.watch(focusTimeDaoProvider);
  return FocusTimeRepositoryImpl(dao);
});

// UseCase Provider（可选）
final startFocusUseCaseProvider = Provider((ref) {
  final repo = ref.watch(focusTimeRepositoryProvider);
  return StartFocusUseCase(repo);
});

// 状态 Provider
final focusTimeNotifierProvider = StateNotifierProvider<
    FocusTimeNotifier,
    AsyncValue<FocusTimeInfo?>>((ref) {
  final repo = ref.watch(focusTimeRepositoryProvider);
  return FocusTimeNotifier(repo);
});
```

### 6.2 测试时替换

```dart
test('Start focus updates state', () async {
  // 模拟 Repository
  final mockRepo = MockFocusTimeRepository();
  when(mockRepo.startFocus(...)).thenAnswer((_) async => testFocusInfo);

  // 创建容器并注入 mock
  final container = ProviderContainer(
    overrides: [
      focusTimeRepositoryProvider.overrideWithValue(mockRepo),
    ],
  );

  // 获取 Notifier 并测试
  final notifier = container.read(focusTimeNotifierProvider.notifier);
  await notifier.startFocus(...);

  // 验证状态
  expect(
    container.read(focusTimeNotifierProvider),
    isA<AsyncData>().having(
      (state) => state.value,
      'value',
      testFocusInfo,
    ),
  );
});
```

---

## 7. 构建和部署

### 7.1 项目结构检查清单

```
lib/
├── main.dart                          ✓ 应用入口
├── app/
│   ├── app.dart                       ✓ MaterialApp 配置
│   ├── theme/
│   │   ├── app_theme.dart             ✓ 主题配置
│   │   └── colors.dart                ✓ 颜色常量
│   └── routes/
│       └── app_router.dart            ✓ 导航配置
├── domain/
│   ├── entities/                      ✓ 业务模型
│   ├── repositories/                  ✓ Repository 接口
│   ├── usecases/                      ✓ UseCase（可选）
│   ├── failures/                      ✓ 异常定义
│   └── constants/                     ✓ 业务常量
├── data/
│   ├── database/                      ✓ Drift 数据库
│   ├── models/                        ✓ Entity 模型
│   ├── mappers/                       ✓ Entity ↔ Domain 映射
│   └── repositories/                  ✓ Repository 实现
├── presentation/
│   ├── screens/                       ✓ 页面
│   ├── widgets/                       ✓ 组件
│   ├── providers/                     ✓ Riverpod Provider
│   └── notifiers/                     ✓ StateNotifier 实现
└── shared/
    ├── constants/                     ✓ 应用常量
    ├── extensions/                    ✓ 扩展方法
    ├── widgets/                       ✓ 通用组件
    └── utils/                         ✓ 工具函数
```

---

## 8. 性能优化建议

### 8.1 计时器精度

```dart
// ❌ 不推荐：使用 Timer 每秒，精度低
Timer.periodic(Duration(seconds: 1), (_) {
  setState(() => _elapsedSeconds++);
});

// ✅ 推荐：记录开始时间，实时计算
useEffect(() {
  final focusState = ref.watch(focusTimeProvider);
  focusState.whenData((focus) {
    if (focus != null && focus.state == STATE_FOCUSING) {
      final timer = Timer.periodic(Duration(milliseconds: 100), (_) {
        final now = DateTime.now();
        final elapsed = now.difference(focus.startTime).inMilliseconds;
        ref.read(focusDisplayProvider.notifier).update(elapsed);
      });
      return () => timer.cancel();
    }
  });
}, []);
```

### 8.2 列表优化

```dart
// 使用 ListView.builder 而非 ListView
ListView.builder(
  itemCount: tasks.length,
  itemBuilder: (_, i) => TaskTile(tasks[i]),
)

// 虚拟化长列表
PagedListView.separated(
  pagingController: _pagingController,
  builderDelegate: PagedChildBuilderDelegate<TaskInfo>(
    itemBuilder: (_, task, __) => TaskTile(task),
  ),
)
```

### 8.3 Widget 重建避免

```dart
// ❌ 不推荐：子 Widget 监听无关 Provider
Widget _buildList(WidgetRef ref) {
  final items = ref.watch(itemsProvider);
  return ListView(
    children: [
      Header(),  // ← 无关，但会重建
      ItemsList(items),
    ],
  );
}

// ✅ 推荐：分离逻辑，使用 autoDispose
Widget _buildList(WidgetRef ref) {
  return ListView(
    children: [
      const _Header(),        // ← 不监听任何状态
      _ItemsList(),           // ← 单独的 Widget，单独监听
    ],
  );
}

class _ItemsList extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemsProvider);  // ← 只在这里监听
    return ListView(children: ...);
  }
}
```

---

## 9. 测试策略

### 9.1 单元测试（Domain + Data）

```dart
// test/domain/usecases/start_focus_use_case_test.dart
void main() {
  group('StartFocusUseCase', () {
    late MockFocusTimeRepository mockRepo;
    late StartFocusUseCase useCase;

    setUp(() {
      mockRepo = MockFocusTimeRepository();
      useCase = StartFocusUseCase(mockRepo);
    });

    test('should call repository when inputs are valid', () async {
      when(mockRepo.startFocus(...))
          .thenAnswer((_) async => testFocusInfo);

      final result = await useCase(...);

      expect(result, testFocusInfo);
      verify(mockRepo.startFocus(...)).called(1);
    });

    test('should throw FormatException when name is empty', () async {
      expect(
        () => useCase(name: '', type: 0, scheduledMs: 1000),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
```

### 9.2 Widget 测试

```dart
// test/presentation/screens/timer_screen_test.dart
void main() {
  group('TimerScreen', () {
    testWidgets('displays loading state initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            focusTimeProvider.overrideWithValue(
              const AsyncValue.loading(),
            ),
          ],
          child: const MyApp(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('starts focus when button is tapped', (WidgetTester tester) async {
      final mockNotifier = MockFocusTimeNotifier();
      when(mockNotifier.startFocus(...)).thenAnswer((_) async {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            focusTimeProvider.overrideWithValue(AsyncValue.data(null)),
          ],
          child: const MyApp(),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(mockNotifier.startFocus(...)).called(greaterThan(0));
    });
  });
}
```

---

## 10. 发布清单

- [ ] 所有依赖版本锁定在 pubspec.yaml
- [ ] 运行 `flutter pub get`
- [ ] 运行 `flutter analyze`（无 lint 错误）
- [ ] 运行 `flutter test`（覆盖 > 80%）
- [ ] 运行 `flutter build apk` / `flutter build ios`
- [ ] 签名配置（release key）
- [ ] 隐私政策和用户协议
- [ ] 应用描述、图标、截图
- [ ] 版本号与 build number
- [ ] 测试设备验证
- [ ] 性能分析（DevTools）

---

## 参考资源

- **Riverpod 官方文档**: https://riverpod.dev
- **Drift 官方文档**: https://drift.simonbinder.eu
- **Flutter 架构参考**: https://flutter.dev/docs/app-architecture
- **Clean Architecture**: https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
