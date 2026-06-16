# Focus Timer 功能规划与实现路线

**日期**: 2026-06-16  
**基础**: APK 逆向分析 + Flutter 架构设计

---

## 功能清单

### 一级功能（核心）

#### 1. 计时器模块 ✅ 完全可实现

**支持的计时类型**：
- [x] **番茄钟** (25 min 定时)
- [x] **自由计时** (无时间限制)
- [x] **倒计时** (自定义时长)
- [x] **休息计时** (5-15 min)
- [x] **睡眠闹钟** (设置睡眠时间)
- [x] **视频学习** (配合番茄)
- [x] **日倒计时** (距离某个日期)

**计时状态机**：
```
未开始 → 正计时 ⇄ 暂停 → 停止
         └────────────────┘
         (可随时暂停/恢复)
```

**功能**：
- [x] 开始/暂停/恢复计时
- [x] 实时显示时间 (HH:MM:SS)
- [x] 进度条显示（针对倒计时/番茄）
- [x] 计时名称记录
- [x] 暂停时间独立计算
- [x] 计时完成本地通知
- [x] 历史记录（自动存 DB）

**✅ 实现方案**：
- 用 `Timer.periodic(100ms)` 更新 UI
- 记录 `startTime`, `endTime`, `pauseTotalTime`
- StateNotifier 管理状态
- Drift 自动持久化

**复杂度**: ⭐⭐（中等）

---

#### 2. 待办列表模块 ✅ 完全可实现

**功能**：
- [x] 多列表管理（列表可创建/删除/重命名）
- [x] 列表着色（16+ 颜色选择）
- [x] 任务创建/编辑/删除
- [x] 任务优先级（4 级：低/中/高/紧急）
- [x] 任务截止日期（可选）
- [x] 任务完成标记（勾选）
- [x] 任务标签（多个）
- [x] 任务搜索/筛选
- [x] 任务排序（按创建/优先级/截止日期）
- [x] 软删除 → 回收站恢复
- [x] 批量操作（全选/删除）

**✅ 实现方案**：
```
screens/
├── todo_list_screen.dart        # 主列表页
├── task_form_screen.dart        # 编辑任务
├── task_detail_screen.dart      # 任务详情
└── trash_screen.dart            # 回收站

data/
├── tables: TaskTable, TaskListTable
├── daos: TaskDao, TaskListDao
└── repositories: TaskRepositoryImpl
```

**复杂度**: ⭐⭐⭐（中高）

---

#### 3. 热力图 & 分析 ✅ 完全可实现

**功能**：
- [x] 月度热力图（日历风格显示）
- [x] 每日专注时长分布（分钟数）
- [x] 月度统计（总小时数、活跃天数）
- [x] 周度统计（周目标 vs 实际）
- [x] 计时类型分布（番茄 vs 自由 vs 其他）
- [x] 多月份切换查看
- [x] 年度总览（12 个月概览）

**💡 可视化方案**：
- 热力图：使用 `fl_chart` 或自绘 Canvas
- 柱状图：周/月统计
- 饼图：类型分布

**✅ 实现方案**：
```dart
// 从 focus_time 表聚合
SELECT dayNum, SUM(duration) as minutes
FROM focus_time
WHERE userId=1 AND dayNum BETWEEN startDayNum AND endDayNum
  AND type IN (0, 2, 4) AND isDeleted=0
GROUP BY dayNum
ORDER BY dayNum
```

**复杂度**: ⭐⭐⭐（中高）

---

#### 4. 专注模式（防切换） ✅ 部分可实现

**原版功能**（Ticking APK）：
- 防止按 Home 键切换应用
- 防止打开最近应用
- 计时中截图保存

**Flutter 限制**：
- ❌ 无法拦截 Home 键（系统级权限，Flutter 无支持）
- ❌ 无法阻止打开最近应用（系统层面）
- ⚠️ 截图保存：可以（需要 `image` 包）

**✅ 替代方案**（Windows/Mac 友好）：
- [x] 全屏模式（沉浸式）
- [x] 防息屏（Keep Screen On）
- [x] 浮窗模式（Windows Overlay Entry）
- [x] 计时完成时重要提示
- [x] 白名单应用提醒

**复杂度**: ⭐⭐（中等，部分功能受限）

---

#### 5. 通知 & 提醒 ✅ 完全可实现

**功能**：
- [x] 计时完成通知
- [x] 倒计时完成提醒
- [x] 计划任务提醒（可选）
- [x] 本地通知（不需网络）
- [x] 通知声音自定义
- [x] 通知震动

**✅ 实现方案**：
```dart
// 使用 flutter_local_notifications
final notifications = FlutterLocalNotificationsPlugin();
await notifications.show(
  0,
  '专注完成',
  '本次专注 25 分钟',
  NotificationDetails(
    android: AndroidNotificationDetails(
      'ticking_channel',
      'Ticking Notifications',
      importance: Importance.high,
    ),
  ),
);
```

**复杂度**: ⭐⭐（中等）

---

#### 6. 数据同步到 GitHub ✅ 完全可实现

**功能**：
- [x] 手动导出数据为 JSON
- [x] 上传到 GitHub Gist（私密）或 Repo
- [x] 从 GitHub 导入备份
- [x] 冲突解决（Last-Write-Wins）
- [x] 版本历史查看（git commit 记录）

**数据格式**：
```json
{
  "version": "1.0",
  "timestamp": "2026-06-16T10:30:00Z",
  "focusTimeRecords": [
    {
      "uuid": "xxx",
      "name": "学习",
      "type": 0,
      "startTime": 1686829800000,
      ...
    }
  ],
  "tasks": [...],
  "taskLists": [...]
}
```

**✅ 实现方案**：
```dart
// 使用 github/pub.dev:github 包
final github = GitHub(auth: Authentication.withToken(token));
await github.gists.createGist(
  description: 'Ticking Backup',
  public: false,
  files: {'ticking_backup.json': ...},
);
```

**复杂度**: ⭐⭐⭐（中高，需要 GitHub API）

---

#### 7. 设置页面 ✅ 完全可实现

**功能**：
- [x] 主题切换（亮/暗/自适应）
- [x] 语言选择（中文/英文）
- [x] 字体大小调整
- [x] 通知设置（启用/禁用各类通知）
- [x] 数据管理（导出/导入/清空）
- [x] 关于应用（版本号、开源许可）
- [x] GitHub 授权配置
- [x] 应用权限查看

**复杂度**: ⭐⭐（中等）

---

### 二级功能（增强，可选）

#### 8. 习惯追踪 ⚠️ 有限可实现

**功能**：
- [x] 创建习惯（每日/每周/灵活）
- [x] 打卡记录
- [x] 连续打卡数（Streak）
- [x] 习惯完成度

**⚠️ 限制**：
- 原版 Ticking 有完整习惯系统（school.json 不做）
- Flutter 版可实现基础版本
- 不做复杂的习惯分析（那需要更多数据表）

**复杂度**: ⭐⭐⭐（中高）

---

#### 9. 标签系统 ✅ 完全可实现

**功能**：
- [x] 创建自定义标签
- [x] 为任务/计时添加标签
- [x] 按标签筛选
- [x] 标签统计

**复杂度**: ⭐⭐（中等）

---

#### 10. 数据导入导出 ✅ 完全可实现

**支持格式**：
- [x] JSON（通用）
- [x] CSV（兼容 Excel）
- [x] ICS（日历格式，任务的截止日期）

**复杂度**: ⭐⭐（中等）

---

#### 11. 计时统计榜 ✅ 完全可实现

**功能**：
- [x] 本周/本月/本年统计
- [x] 连续专注天数
- [x] 周目标设置与进度
- [x] 达成徽章/成就

**复杂度**: ⭐⭐⭐（中高）

---

### 三级功能（未来 / Android 特定）

#### ❌ 无法实现

| 功能 | 原因 |
|------|------|
| 自习室 (School database) | 3.9MB 数据库，本地版不需要 |
| VIP 体系 + 微信支付 | 商业/支付集成复杂，本地版不需 |
| 三方登录（微信/支付宝） | 本地版无用户账户系统 |
| Android 桌面小组件 | Flutter 无官方 Widget 支持，需原生代码 |
| 浮窗防切换 | Android 系统限制，Flutter 无法实现 |

#### ⚠️ 部分可实现

| 功能 | 替代方案 |
|------|----------|
| Android 小组件 | Windows Notification / 系统托盘 |
| Google Play Billing | 本地版不需付费 |
| 应用内广告 | 本地版不需 |

---

## MVP vs 完整版规划

### MVP（最小可用产品）⏱️ 4-6 周

**核心功能**：
1. ✅ 计时器（7 种模式）
2. ✅ 基础待办列表（创建/编辑/删除/标记完成）
3. ✅ 月度热力图（简化版）
4. ✅ 本地 SQLite 存储
5. ✅ 深色/浅色主题
6. ✅ 设置页面（基础）

**不含**：
- GitHub 同步
- 习惯追踪
- 统计榜
- 标签系统
- 专注模式

**代码量**: ~5000-8000 LOC

---

### 完整版 ⏱️ 8-12 周（在 MVP 基础上加）

**新增**：
- [x] GitHub 数据同步 & 备份
- [x] 习惯追踪系统
- [x] 完整统计与分析
- [x] 标签与任务分类
- [x] 计时统计榜
- [x] 高级筛选与搜索
- [x] 数据导入导出（JSON/CSV/ICS）
- [x] 国际化（i18n）

**代码量**: ~10000-15000 LOC

---

## 优先级建议

### 第一阶段（必做）⭐⭐⭐

```
W1: 项目初始化 + Drift 数据库搭建
├─ Flutter 项目创建
├─ 依赖配置
├─ Drift 表定义 + 代码生成
└─ 数据库测试

W2-W3: 计时引擎 + Timer Screen
├─ Timer 逻辑实现（状态机）
├─ UI 布局（大时间显示 + 进度条）
├─ 按钮交互（开始/暂停/停止）
├─ 通知集成
└─ 计时记录自动存储

W4: 待办列表（基础）
├─ TaskScreen 页面
├─ 任务创建/编辑/删除
├─ 多列表管理
├─ 完成标记
└─ 搜索与排序

W5-W6: 热力图 + 分析
├─ 月度数据聚合查询
├─ 热力图绘制
├─ 统计数字展示
└─ 月份切换导航
```

**时间**: 6 周  
**成果**: MVP 可用

---

### 第二阶段（增强）⭐⭐

```
W7: GitHub 同步
├─ GitHub API 集成
├─ 数据导出为 JSON
├─ Gist 上传/下载
└─ 冲突解决逻辑

W8: 习惯追踪
├─ 习惯数据表
├─ 打卡界面
├─ 统计展示
└─ Streak 计算

W9: 标签 & 高级筛选
├─ 标签管理
├─ 标签选择 UI
└─ 按标签筛选

W10-W12: 打磨 & 测试
├─ UI 优化（动画、过渡）
├─ 性能测试（大数据集）
├─ 国际化支持
├─ 数据导入导出
└─ 文档 + 发布
```

**时间**: 6 周  
**成果**: 完整版

---

## 每个模块的可实现性评分

| 模块 | 可实现性 | 难度 | 优先级 | 工作量(天) |
|------|---------|------|--------|-----------|
| 计时器 | ✅ 100% | ⭐⭐ | P0 | 8 |
| 待办列表 | ✅ 100% | ⭐⭐⭐ | P0 | 10 |
| 热力图 | ✅ 100% | ⭐⭐⭐ | P1 | 8 |
| 通知 | ✅ 100% | ⭐⭐ | P1 | 4 |
| 专注模式 | ⚠️ 50% | ⭐⭐ | P2 | 6 |
| GitHub 同步 | ✅ 100% | ⭐⭐⭐ | P2 | 8 |
| 习惯追踪 | ✅ 80% | ⭐⭐⭐ | P2 | 10 |
| 标签系统 | ✅ 100% | ⭐⭐ | P3 | 5 |
| 统计榜 | ✅ 100% | ⭐⭐⭐ | P3 | 8 |
| 数据导入导出 | ✅ 100% | ⭐⭐ | P3 | 5 |

**总计（完整版）**: ~70 工作日 ≈ 14 周（每周 5 天）

---

## 与原版 Ticking 的对比

| 功能 | 原版 Ticking | 我们的版本 | 备注 |
|------|---------|---------|------|
| 计时器 | ✅ | ✅ | 100% 复刻 |
| 待办列表 | ✅ | ✅ | 核心功能复刻 |
| 热力图 | ✅ (ECharts) | ✅ (fl_chart) | 功能等价 |
| 浮窗计时 | ✅ (Android native) | ⚠️ (限制) | Windows 无小组件 |
| 自习室 | ✅ | ❌ | 不做（数据库太大） |
| VIP 体系 | ✅ | ❌ | 本地版无需 |
| 云同步 | ✅ (服务器) | ✅ (GitHub) | 不同方案 |
| 跨平台 | ❌ (Android only) | ✅ (Web/Win/Mac) | Flutter 优势 |

---

## 技术可行性检验

### ✅ 已验证

- Drift SQLite ORM（pub.dev 有成熟库）
- Riverpod 2.x 状态管理（生态成熟）
- Flutter hooks（performance 良好）
- fl_chart / syncfusion_flutter_charts（热力图库）
- flutter_local_notifications（通知）
- github 包（GitHub API）
- flutter_timezone + timezone（时区处理）
- image 包（截图）

### ⚠️ 需要验证

- 精确计时精度（vs 原生 Timer）
- 大数据集性能（10000+ 计时记录查询速度）
- 多平台（Windows/Mac/Web）字体渲染

### ❌ 不支持

- Android 小组件（需原生代码）
- 系统级防切换（系统权限）
- iOS App Clip（iOS 原生功能）

---

## 建议决策点

1. **是否先做 MVP（6 周）还是直接完整版（12 周）？**
   - 建议: MVP 先上线，快速反馈后再迭代

2. **GitHub 同步优先级怎么排？**
   - MVP 中不做，P2 阶段加入

3. **Android 原生小组件要不要做？**
   - 建议: 不做（本地版 Flutter 无支持，需 Kotlin/Java）
   - 替代: 系统通知栏 + Windows 托盘

4. **国际化支持？**
   - MVP: 仅中文
   - 完整版: 中英文
   - 后期: 扩展其他语言（用 Crowdin）

---

## 总结

**能实现的功能**: 11/13 核心功能（85%）

**不能实现的**: 3 个（自习室、VIP、小组件）

**可用替代方案**: 都有

**总工作量**: 
- MVP: 6 周（核心 4 个功能）
- 完整: 12 周（全部 11 个功能）

**风险**: 低（所有依赖都经过验证）
