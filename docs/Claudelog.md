# Claude 工作日志

## 2026-06-20 待办体验四项改进

### 背景

对照 Super Productivity / Timety 等开源项目审查待办功能，定位4个可改点并实施。同时在此之前新增了计划模板"复制上周同日"。

### 改动明细

**1. "计划日期"直接开日期选择器**（`group_detail_screen.dart`）

- 原来"计划日期"和"设定目标"都调同一个 `_showTaskDetailSheet`，两个选项体验完全一样。
- 现在点"计划日期"直接弹系统 `showDatePicker`，选完即更新 `dueDayNum`；"设定目标"仍走详情 sheet。
- ListTile subtitle 同步显示当前截止日期。

**2. 计时入口加 setup sheet**（`group_detail_screen.dart`）

- 原来点视频打卡/自由计时/番茄计时直接 `createTimer + startTimer`，无法修改名称/时长，和计时 Tab 的体验不一致。
- 现在每个入口先弹 `TimerSetupSheet`（预填任务标题），用户确认后再开始。
- 旧 `_startTaskTimer(task, type, targetMs)` 替换为 `_startFromRequest(TimerStartRequest)`，逻辑更简洁。
- 番茄计时的 `initialMinutes` 优先使用任务的 `estimatedMinutes`，否则默认 25 分钟。

**3. 首页分组卡片预览任务行可点击**（`group_list_screen.dart`）

- `_TaskPreviewLine` 新增 `onTap` / `onLongPress` 可选回调，内部用 `InkWell` 包裹。
- `_GroupCard` 传入：`onTap` → `toggleComplete(task.id)`（直接完成），`onLongPress` → 导航进 `GroupDetailScreen`。

**4. 计划模式待办池逾期/今日截止标记**（`task_plan_screen.dart`）

- `_TaskChip` 根据 `task.dueDayNum` 与当日比较：逾期显示红色"逾期"，当日截止显示"今日截止"。
- 在 widget 内用 `DateTime.now().difference(DateTime(1970)).inDays` 计算 todayNum，无需从外部传参。

**5. 计划模板新增"复制上周同日"**（`task_provider.dart` + `task_plan_screen.dart`）

- `TaskPlanNotifier` 新增 `copyPlansFromLastWeekSameDay()`，底层复用已有 `copyPlans(fromDayNum: dayNum - 7, ...)`.
- 工具栏复制按钮改为 `PopupMenuButton`，提供"复制昨日计划"和"复制上周同日"两个选项。

### 验证

- `flutter analyze`：通过，`No issues found`。
- `flutter test`：通过，32 个测试全部通过。
- APK 未重新构建（纯 UI 逻辑改动，无 DB schema 变更）。

### 下一步建议

- 真机测试：日期选择器在键盘弹起时的布局；计时 setup sheet 从任务入口打开的手感。
- 逾期任务标记还可以扩展到主页分组卡片 subtitle（"X项逾期"）。
- `group_detail_screen.dart` 的任务动作面板仍是长 ListView，可参考 Super Productivity 的 grid 布局改成更紧凑的操作网格。
