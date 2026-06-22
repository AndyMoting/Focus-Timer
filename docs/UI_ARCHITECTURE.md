# UI 结构

## 导航

4 Tab：待办 → 计时 → 统计 → 我的

## 主要页面

- **GroupListScreen** → GroupDetailScreen（任务管理）→ TaskPlanScreen（计划时间线）
- **TimerScreen** → 模式选择 → 计时中 → 停止记录
- **StatsScreen** → 热力图 / 饼图 / 时间线 / 打卡 / 导出
- **ProfileScreen** → 主题色 / 深色模式 / 回收站 / 数据恢复

## 弹窗

DayCountdownScreen / VideoEvidenceScreen / TrashScreen / DataExportScreen / 各类 Action Sheet

## 拆分原则

同页面按功能拆文件，职责单一。
