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

## 项目结构

```
lib/
├── main.dart                      # 应用入口
├── app/
│   ├── app.dart                   # MaterialApp 配置
│   └── theme/
├── domain/                        # 业务逻辑（纯 Dart，无 Flutter 依赖）
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── data/                          # 数据访问（Drift DB + Mapper）
│   ├── database/
│   ├── repositories/
│   └── mappers/
├── presentation/                  # UI + Riverpod
│   ├── screens/
│   ├── providers/
│   └── widgets/
└── shared/                        # Constants / Extensions / Utils
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
