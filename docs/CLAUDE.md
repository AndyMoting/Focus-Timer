# Focus Timer

**项目**: 本地优先效率工具 — 待办分组 + 专注计时 + 统计  
**状态**: V5 reference app Phase 1-3 完成 ✅（Phase 4-6 待做）  
**发布目标**: v1.0.0 在 W8（13 周）

---

## 核心决策

- **定位**: 本地优先版（无云端、无登录、无会员）
- **平台**: Flutter 跨平台（Android / Web）
- **架构**: Riverpod + Drift SQLite + Clean Architecture
- **底部导航**: 3 Tab（待办 / 计时 / 我）
- **数据库**: schemaVersion=2，TaskLists 表支持分组管理（color/isDeleted/isDailyReset）
- **开源**: MIT License

---

## V5 进度（2026-06-18）

✅ **Phase 1**: 数据库迁移 v2 + 分组 Repository + typeSleep=9  
✅ **Phase 2**: 3 Tab 底部导航（待办|计时|我）  
✅ **Phase 3**: 分组列表 + 分组内待办 + 分组统计  
✅ 计时中切换类型即时生效  
✅ 本地通知 + 后台计时 + 权限提权  
✅ 热力图（heatmap_calendar_plus）  
✅ 日倒计时 + 8 色主题  
✅ APK: 54.7 MB | 8/8 测试通过  

⏳ Phase 4: 计时页 4 卡片重设计  
⏳ Phase 5: 回收站页面  
⏳ Phase 6: 我的页面完善  

---

## 项目结构

```
lib/
├── domain/repositories/
│   ├── timer_repository.dart
│   └── task_repository.dart
├── data/
│   ├── database/
│   │   ├── database.dart          # AppDatabase v2
│   │   └── tables.dart            # FocusTime/Tasks/TaskLists
│   └── repositories/
│       ├── timer_repository_impl.dart
│       └── task_repository_impl.dart
├── presentation/
│   ├── providers/
│   │   ├── timer_provider.dart     # 计时器（通知+后台集成）
│   │   ├── task_provider.dart      # GroupNotifier + TaskNotifier(family)
│   │   ├── theme_provider.dart     # 8色主题
│   │   ├── heatmap_provider.dart   # 热力图数据
│   │   └── countdown_provider.dart # 日倒计时（文件存储）
│   └── screens/
│       ├── home_screen.dart        # 3 Tab 主框架
│       ├── group_list_screen.dart  # 分组列表
│       ├── group_detail_screen.dart# 分组内待办
│       ├── timer_screen.dart       # 计时器
│       ├── heatmap_screen.dart     # 热力图
│       ├── stats_screen.dart       # 分组统计
│       ├── day_countdown_screen.dart
│       └── profile_screen.dart     # 我的
└── shared/
    ├── constants/app_constants.dart
    ├── services/
    │   ├── notification_service.dart
    │   ├── background_timer_service.dart
    │   └── permission_service.dart
    ├── utils/date_utils.dart
    └── widgets/permission_gate.dart
```

---

## 开发命令

```bash
dart run build_runner build --delete-conflicting-outputs
flutter run -d android
flutter build apk --release
flutter test
```

---

## 踩坑记录

- Drift 表名单数化：`Tasks` → `Task`，`TaskLists` → `TaskList`
- `showDialog` 内禁用 Hook（useTextEditingController）
- 切换主题前 `FocusScope.unfocus()` 防输入法弹出
- `flutter_local_notifications` 需启用 coreLibraryDesugaring
- `permission_handler` + `shared_preferences` 有 Kotlin 编译冲突 → 改用 dart:io 文件存储
- `heatmap_calendar_plus` v2.3 API: `colorsets`(Map) 替代 `colorSet`(ColorSet)
