# Focus Timer

**项目**: 开源、离线、跨平台的生产力计时应用  
**状态**: Alpha Phase (W1-W4 进行中)  
**发布目标**: v1.0.0 在 W8（13 周）

---

## 核心决策

- **定位**: 独立的标准生产力应用（计时器 + 待办 + 分析）
- **平台**: Flutter 跨平台（Android / Web 优先）
- **架构**: Riverpod + Drift SQLite + Clean Architecture 四层分解
- **开源**: MIT License，100% GitHub 开源（不商业化）
- **发布路线**: W8 GitHub v1.0.0 → W13 应用商店
- **W9-W10 选择**: Android 小组件 OR GitHub 同步（用户反馈决定）
- **不做**: 自习室、VIP、三方登录、iOS 小组件

---

## 设计原则

- 功能为行业标准（计时、待办、热力图）
- 代码从零编写（不是反编译 + 改包名）
- 坦诚做开源产品（无须过度法律考虑）

---

## 项目结构（实际）

```
Focus Timer/
├── docs/                          # 项目文档
│   ├── ARCHITECTURE.md
│   ├── IMPLEMENTATION_PLAN.md
│   ├── DATA_MODELS.md
│   └── ...
├── lib/
│   ├── main.dart                  # 应用入口（ProviderScope + MaterialApp）
│   ├── domain/                    # 业务逻辑（纯 Dart）
│   │   ├── entities/
│   │   ├── repositories/
│   │   └── usecases/
│   ├── data/                      # 数据访问层
│   │   ├── database/
│   │   │   ├── database.dart     # AppDatabase (Drift)
│   │   │   ├── database.g.dart   # 生成代码
│   │   │   └── tables.dart       # 表定义 (FocusTime/Tasks/TaskLists)
│   │   ├── repositories/
│   │   └── mappers/
│   ├── presentation/              # UI + Riverpod
│   │   ├── screens/
│   │   ├── providers/
│   │   └── widgets/
│   └── shared/                    # 工具类
│       ├── constants/app_constants.dart
│       └── utils/date_utils.dart  # dayNum 计算
├── releases/                      # 构建产物（.gitignore）
│   └── reference/1.18.13.apk
└── android/, web/, windows/       # 平台配置
```

---

## 依赖清单

```yaml
dependencies:
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0
  drift: ^2.15.0
  sqlite3_flutter_libs: ^0.5.0
  path_provider: ^2.1.0
  freezed_annotation: ^2.4.0
  json_annotation: ^4.8.0
  flutter_hooks: ^0.20.0
  hooks_riverpod: ^2.4.0

dev_dependencies:
  build_runner: ^2.4.0
  drift_dev: ^2.15.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0
  riverpod_generator: ^2.3.0
```

---

## 开发命令

```bash
# 代码生成（Drift + Riverpod + Freezed）
dart run build_runner build --delete-conflicting-outputs

# 运行（需要先安装 Android SDK）
flutter run -d android

# 构建 APK
flutter build apk --debug
```

---

## 路线图（13 周）

| 阶段 | 周数 | 里程碑 | 范围 |
|------|------|--------|------|
| Alpha | W1-4 | v0.3 | 计时器 MVP（内部用） |
| Beta | W5-8 | v1.0.0 | 待办 + 热力图（发布 GitHub） |
| Stable | W9-13 | v1.1+ | 小组件/GitHub 同步 + 应用商店 |

**关键验证点**:
- W4 末: 计时精度是否准确？
- W8 末: 功能足够用吗？（GitHub 发布）
- W13 末: 用户留存 > 30%？

---

## 反编译产物

`analysis/` 目录包含 v1.18.13 APK 完整反编译（apktool + jadx）— 仅用于架构学习参考，不用于代码复制。

---

## 版权与开源

- **开源协议**: MIT License
- **GitHub**: 待创建（初始化 W1 时创建）
