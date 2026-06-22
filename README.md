# Focus Timer

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![Status](https://img.shields.io/badge/Status-Alpha-orange.svg)](#roadmap)

开源生产力应用 — 计时、待办、分析，全在本地。当前优先打磨 Android APK。

- ⏱️ 计时器（7 种模式：番茄钟、自由计时、倒计时等）
- 📝 待办列表（多列表、优先级、分类、归档）
- 🔥 热力图分析（GitHub 风格的专注时长分布）
- 📱 Android-first（Web / Windows 计划后续适配）
- 💾 本地优先（所有数据在本地 SQLite，无云同步）
- 🔓 100% 开源（MIT License）

---

## 快速开始

### 环境要求
- Flutter 3.x
- Dart 3.0+
- Android 11+（minSdk 30）
- Web / Windows 目前不是主发布目标，数据库平台适配完成后再恢复支持声明

### 安装
```bash
git clone https://github.com/yourname/focus-timer.git
cd focus-timer
flutter pub get
flutter pub run build_runner build
```

### 运行
```bash
# Android
flutter run -d android

# 当前 APK 主线
flutter build apk --debug
```

---

## 文档

- **[架构设计](docs/ARCHITECTURE.md)** — 四层分解、Riverpod、Drift 数据库
- **[功能规划](docs/IMPLEMENTATION_PLAN.md)** — 优先级表、MVP vs 完整版
- **[发布路线](docs/RELEASE_ROADMAP.md)** — 13 周时间表（Alpha → Beta → Stable）
- **[数据模型](docs/DATA_MODELS.md)** — 表结构、Drift entities、dayNum 计算
- **[UI 设计](docs/UI_ARCHITECTURE.md)** — 交互分析、7 种计时模式
- **[W2 实现](docs/W2_IMPLEMENTATION.md)** — 计时器核心功能实现记录
- **[小组件方案](docs/ANDROID_WIDGET_PLAN.md)** — 可交互的 Android 小组件（可选）

---

## 项目状态

| 阶段 | 时间 | 目标 | 状态 |
|------|------|------|------|
| **Alpha** | W1-4 | 计时器 MVP | 🔄 进行中 |
| **Beta** | W5-8 | v1.0.0 GitHub 发布 | ⏳ 计划中 |
| **Stable** | W9-13 | 应用商店上线 | ⏳ 计划中 |

**当前**: Android APK Alpha - 计时器 + 通知 + 后台计时服务 + 待办分组 + 热力图基础能力。

---

## 开发流程

### 任务追踪
项目使用 GitHub Projects 追踪进度。详见 [Tasks](https://github.com/yourname/focus-timer/projects)。

### 代码风格
- Dart: 遵循 [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Flutter: Material Design 3
- Commit: 使用 conventional commits (`feat:`, `fix:`, `docs:`, etc.)

### 测试
```bash
# 运行单元测试
flutter test

# 生成覆盖率报告
flutter test --coverage
```

---

## 贡献指南

我们欢迎 Bug 报告、功能建议、代码贡献。

### 报告 Bug
[创建 Issue](https://github.com/yourname/focus-timer/issues/new)

### 提交 PR
1. Fork 仓库
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. Commit 更改 (`git commit -m 'feat: add amazing feature'`)
4. Push 分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

---

## 开源协议

MIT License - 详见 [LICENSE](LICENSE)

---

## 致谢

- **技术**: [Flutter](https://flutter.dev), [Riverpod](https://riverpod.dev), [Drift](https://drift.simonbinder.eu)
- **社区**: 感谢所有贡献者和用户反馈

---

## 联系方式

- 📧 Email: [your-email]
- 🐦 Twitter: [@your-twitter]
- 💬 Discord: [link]

---

**项目开始**: 2026-06-16  
**现在 Alpha Phase**: 预计 W8（2026-08-10）发布 v1.0.0
