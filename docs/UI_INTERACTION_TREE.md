# UI Interaction Tree

## Purpose

This tree reorganizes the app UI around the intended local local-first flow. It is based on:

- `docs/Codex观察记录.md`
- `docs/Codexplan.md`
- Current Flutter screens under `lib/presentation/screens`

Legend:

- `[now]` currently exists in code.
- `[next]` should be changed or added soon.
- `[later]` useful but not part of the next APK pass.

## App Root

```text
Focus Timer
├─ First launch / permission gate [now]
│  ├─ Notification permission explanation [now]
│  ├─ No storage permission prompt [now]
│  └─ Enter Home [now]
│
└─ Home: bottom navigation [now]
   ├─ 待办 [now]
   ├─ 计时 [now]
   └─ 我 [now]
```

## 待办 Tab

```text
待办 [now]
├─ Top bar [now]
│  ├─ Title: 待办 [now]
│  ├─ 日倒计时 shortcut [now]
│  │  └─ 日倒计时 page [now]
│  │     ├─ Empty/list state [now]
│  │     └─ Add countdown dialog [now]
│  ├─ 回收站 shortcut [now]
│  │  └─ 回收站 page [now]
│  │     ├─ Empty deleted groups [now]
│  │     ├─ Deleted group row [now]
│  │     │  ├─ Restore [now]
│  │     │  └─ Permanent delete confirmation [now]
│  │     └─ Delete child tasks on permanent delete [now]
│  └─ More menu [now]
│     ├─ 全部完成 [now]
│     ├─ 回收空的分组 [now]
│     ├─ 回收所有分组 [now]
│     │  └─ Confirmation dialog [now]
│     ├─ 显示/隐藏已完成的待办 [now]
│     ├─ 回收站 [now]
│     ├─ 次日重置待办状态 [next]
│     ├─ 排序 [next]
│     └─ 立即同步 / 云端恢复 [do not add]
│
├─ Empty state [now]
│  └─ Create group CTA/FAB [now]
│
├─ Group list [now]
│  └─ Group card [now]
│     ├─ Tap card -> Group detail [now]
│     ├─ Color strip [now]
│     ├─ Name [now]
│     ├─ Daily reset badge [now]
│     ├─ Subtitle / task summary [next]
│     │  ├─ Replace misleading `点击空白处添加` [next]
│     │  └─ Show active/completed task summary [next]
│     └─ More button -> bottom action sheet [now]
│        ├─ 添加 -> Group detail [now]
│        ├─ 重命名 -> dialog [now]
│        ├─ 颜色 -> bottom color sheet [now]
│        ├─ 全局热力图 -> Stats/Heatmap [now]
│        ├─ 复制内容 -> clipboard [now]
│        ├─ 每日重置 toggle [now]
│        ├─ 克隆 [now]
│        ├─ 排序 [placeholder now, improve next]
│        ├─ 分享 [placeholder now, improve later]
│        └─ 移至回收站 [now]
│
└─ Create group [now]
   ├─ Current: dialog [now]
   └─ Target: bottom sheet with title + input + create action [next]
```

## 分组详情

```text
Group detail [now]
├─ Top bar [now]
│  ├─ Back [now]
│  ├─ Group name [now]
│  └─ Edit/settings action [next]
│
├─ Task list [now]
│  ├─ Empty state: 还没有待办哦 [now]
│  └─ Task row [now]
│     ├─ Checkbox complete/uncomplete [now]
│     ├─ Task title [now]
│     ├─ Hide completed controlled by global state [now]
│     ├─ Swipe delete [now]
│     └─ Tap task -> task action sheet [next]
│        ├─ 自由计时 [next]
│        ├─ 番茄计时 [next]
│        ├─ 视频打卡 [later]
│        ├─ 取消完成 [next]
│        ├─ 设定目标 [later]
│        ├─ 计划日期 [later]
│        ├─ 删除 [next]
│        └─ 统计 [later]
│
└─ Bottom input bar [now]
   ├─ Text field: 输入待办 [now]
   └─ Add button [now]
```

## 计时 Tab

Current code is still closer to a timer tool page. Target interaction should become a timer action entry page.

```text
计时 [now -> next]
├─ Current top-left type menu [now]
│  ├─ 番茄钟 [now]
│  ├─ 自由计时 [now]
│  ├─ 倒计时 [now]
│  ├─ 短休息 [now]
│  ├─ 长休息 [now]
│  ├─ 视频打卡 [now as type]
│  └─ 起床睡觉 [now as type]
│
├─ Target overview card [next]
│  ├─ 今日计时 count [next]
│  ├─ 今日专注 duration [next]
│  ├─ 起床时间 / 睡觉状态 [next]
│  └─ 今日数据 -> Stats summary [next]
│
├─ Target action cards [next]
│  ├─ 自由计时 [next]
│  │  └─ Bottom sheet: name input + confirm [next]
│  │     └─ Running page/state [now, restyle next]
│  ├─ 番茄计时 [next]
│  │  └─ Bottom sheet: name + duration + start [next]
│  │     └─ Running countdown [next]
│  ├─ 视频打卡 [next as local placeholder]
│  │  └─ Business permission explanation before system camera permission [later]
│  └─ 起床睡觉 [next]
│     └─ Bottom sheet: 起床 / 睡觉 / 取消 [next]
│
├─ Quick rest [next]
│  ├─ 5分钟 [next]
│  ├─ 10分钟 [next]
│  └─ 20分钟 [next]
│     └─ Running rest countdown [next]
│
└─ Running timer state [now -> next]
   ├─ Immersive running surface [next]
   ├─ Main number [now]
   │  ├─ Free timer: elapsed focus time [now]
   │  └─ Pomodoro/countdown/rest: remaining time [next]
   ├─ Name/type label [now]
   ├─ Tools row [later]
   │  ├─ 讨论 [do not add now]
   │  ├─ 翻页时钟 [later]
   │  ├─ 白噪音 [later]
   │  ├─ 屏幕常亮 [later]
   │  └─ strict/lock mode [later]
   └─ Controls [now -> next]
      ├─ Running free timer: pause button [now]
      ├─ Paused free timer: resume + stop [next]
      ├─ Stop free timer: save directly [now]
      ├─ Paused pomodoro stop: discard / finish and save / cancel [next]
      └─ Rest stop: finish feedback, separate from focus stats [next]
```

## 我 Tab

```text
我 [now -> next]
├─ Profile header [now]
│  ├─ App/avatar identity [now]
│  └─ Version [now]
│
├─ Local settings [now -> next]
│  ├─ 主题色 [now]
│  │  └─ Bottom color picker [now]
│  ├─ 深色模式 [placeholder now]
│  │  └─ Auto / on / off single-choice dialog [next]
│  ├─ 卡片透明度 slider [later]
│  ├─ 低配置模式 [later]
│  └─ 关于 [next]
│
├─ Local data [now -> next]
│  ├─ 回收站 [now]
│  ├─ 日倒计时 [next]
│  ├─ 计时统计 [next]
│  ├─ 导出数据 [placeholder now]
│  │  ├─ Export todos [next]
│  │  └─ Export timer records [next]
│  └─ 数据备份/导入 [later]
│
├─ Timeline [next]
│  ├─ Recent focus records [next]
│  ├─ Rest records separated or clearly labeled [next]
│  └─ Tap record -> edit timer record [later]
│
└─ Do not add now
   ├─ login/account security
   ├─ membership center
   ├─ QR/social scanning
   ├─ cloud sync
   └─ discovery/community shortcuts
```

## 统计 / Data Review

Stats should not be a bottom tab right now. It should be reachable from group actions and `我`.

```text
Stats [now -> next]
├─ Entry points [now -> next]
│  ├─ Group card action: 全局热力图 [now]
│  ├─ 我 -> 计时统计 [next]
│  └─ Timer overview -> 今日数据 [next]
│
├─ Date/range control [next]
│  ├─ Today / current range chip [next]
│  ├─ Custom range [later]
│  └─ Day / week / month / year segmented control [next]
│
├─ Cards [next]
│  ├─ Today summary [next]
│  ├─ Week summary [next]
│  ├─ Month heatmap [now]
│  ├─ Recent timeline [next]
│  └─ Pie chart / chart style toggle [later]
│
├─ Record actions [next]
│  ├─ 补录数据 [later]
│  └─ Edit record / 心得 [later]
│
└─ Chart management [later]
   ├─ Built-in chart list [later]
   ├─ Visibility toggle [later]
   ├─ Reorder handle [later]
   └─ No VIP chart marketplace [do not add]
```

## Cross-Flow Rules

```text
Create / start actions
├─ Create group: bottom sheet preferred [next]
├─ Add task: fixed bottom input in group detail [now]
├─ Start timer: timer card -> bottom sheet -> running state [next]
└─ Quick rest: direct start [next]

Permissions
├─ No storage prompt on startup [now]
├─ Notification permission only when useful [now]
├─ Camera permission only after video business explanation [later]
└─ Export should use platform save/share feedback, not startup permission [next]

Theme
├─ Single source of truth: 我 -> 主题色 [now]
├─ Timer page should not expose duplicate theme entry [now]
└─ Default theme: mist blue, not green [now]

Record saving
├─ Free timer stop saves directly [now]
├─ Pomodoro stop should confirm discard/finish [next]
├─ Rest should not inflate focus stats [now for stats exclusion, improve UI next]
└─ Recent record feedback after stop [next]
```

## Priority UI Refactor Path

```text
1. Timer tab redesign [next]
   ├─ Add overview card
   ├─ Add action cards
   ├─ Add bottom-sheet starts
   └─ Fix remaining-time primary display for pomodoro/countdown

2. Todo polish [next]
   ├─ Replace misleading card subtitle
   ├─ Convert create group dialog to bottom sheet
   ├─ Verify recycle-bin UI
   └─ Add task action sheet

3. My page redesign [next]
   ├─ Local settings section
   ├─ Local data section
   ├─ Timer statistics entry
   └─ Export feedback

4. Stats skeleton [next]
   ├─ Day/week/month/year segmented shell
   ├─ Summary cards
   ├─ Heatmap
   └─ Timeline
```
