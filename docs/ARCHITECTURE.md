# 架构设计

Flutter Android 应用，Riverpod 状态管理 + Drift (SQLite) 本地数据库。

## 分层

```
lib/
├── main.dart
├── domain/         — 模型 + Repository 接口
├── data/           — Drift 表 + Repository 实现
├── presentation/   — 页面 (screens) + 状态 (providers)
└── shared/         — 服务 / 主题 / 工具
```

## 数据流

```
Screen (HookConsumerWidget)
  → ref.watch(provider)
  → ref.read(provider.notifier)
  → Notifier → Repository → Drift → SQLite
```

## 状态管理

Riverpod 2.x + hooks_riverpod

## 后台计时

`TimerForegroundService.kt` — Android 前台服务，MethodChannel `focus_timer`

## 技术栈

Flutter 3.x / Riverpod 2.x / Drift 2.x (SQLite) / flutter_local_notifications / ForegroundService
