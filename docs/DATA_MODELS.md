# 数据模型

## FocusTime — 计时记录

| 字段 | 说明 |
|------|------|
| `id` PK auto | 自增 |
| `dayNum` | UTC 天数 +1 |
| `type` | 0=番茄 2=自由 4=视频 10=倒计时 |
| `state` | 0=停止 1=计时中 2=暂停 3=等待 |
| `startTime` / `endTime` / `durationMs` | 时间戳 |
| `name` / `note` | 名称 / 备注 |
| `taskId` / `listId` / `planId` | 关联 |
| `evidenceUri` 等 | 视频证据 |

## ActiveTimerSession

单行表，当前计时会话。停止后转入 FocusTime。

## DailyLogs

`id` / `dayNum` / `type` / `loggedAt` / `note`

## TaskLists

`id` / `name` / `color` / `iconCodePoint` / `sortOrder` / `isDeleted` / `isDailyReset`

## Tasks

`id` / `listId` / `title` / `note` / `priority` / `isCompleted` / `isPinned` / `isHighlighted`
`dueAt` / `remindAt` / `estimatedMinutes` / `repeatRule` / `sortOrder` / `color`

## TaskPlans

`id` / `taskId` / `listId` / `dayNum` / `startMinute` / `durationMinutes` / `sortOrder`

## dayNum

```dart
int dateToDayNum(DateTime date) {
  final epoch = DateTime.utc(1970, 1, 1);
  final normalized = DateTime.utc(date.year, date.month, date.day);
  return normalized.difference(epoch).inDays + 1;
}
```
