# Focus Timer

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)

开源生产力应用 — 计时、待办、分析，全在本地。

- ⏱️ 计时器（番茄钟、自由计时、倒计时等）
- 📝 待办列表（多列表、优先级、分组、回收站）
- 🔥 热力图分析（GitHub 风格专注时长分布）
- 📱 Android APK
- 💾 本地优先（SQLite，无云同步）
- 🔓 100% 开源（MIT License）

---

## 快速开始

### 环境要求
- Flutter 3.x
- Dart 3.0+
- Android 11+（minSdk 30）

### 安装
```bash
git clone https://github.com/AndyMoting/Focus-Timer.git
cd Focus-Timer
flutter pub get
flutter pub run build_runner build
```

### 构建 APK
```bash
flutter build apk --release
# 或使用构建脚本
.\tools\build_apk.ps1 -Mode release
```

---

## 文档

- **[架构设计](docs/ARCHITECTURE.md)** — 四层分解、Riverpod、Drift 数据库
- **[功能规划](docs/IMPLEMENTATION_PLAN.md)** — 优先级表、MVP vs 完整版
- **[数据模型](docs/DATA_MODELS.md)** — 表结构、Drift entities
- **[UI 设计](docs/UI_ARCHITECTURE.md)** — 交互分析
- **[UI 交互树](docs/UI_INTERACTION_TREE.md)** — 页面结构
- **[新路线图](docs/NEW_ROADMAP_CN.md)** — 最新计划
- **[功能介绍](docs/Focus_Timer功能介绍.md)** — 功能说明

---

## 开发

### 测试
```bash
flutter test
```

### 代码风格
- Dart: [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Commit: conventional commits (`feat:`, `fix:`, `docs:`, etc.)

---

## 开源协议

MIT License

---

**项目开始**: 2026-06
