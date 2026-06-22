# Codex Plan

## Workspace Naming

- Clean/public workspace name: `Focus_Timer`
- Legacy working workspace name: `focus_timer`
- See `docs/WORKSPACE_NAMING.md` for the rule to keep them separate.

## 2026-06-19 Current Direction

This project is now treated as an Android-first local local-first app:

- Local only: no cloud sync, no login, no membership wall.
- Main structure: `待办 / 计时 / 统计 / 我的`.
- Near-term goal: make the APK feel usable locally before adding richer charts or extra platforms.
- Reference use: learn interaction structure from reference app, but do not copy code, assets, or commercial/cloud features.

## Inputs I Am Using

- Claude memory:
  - `D:\Claude\config\projects\D--Projects-Focus-Timer\memory\MEMORY.md`
  - `D:\Claude\config\projects\D--Projects-Focus-Timer\memory\project_overview.md`
  - `D:\Claude\config\projects\D--Projects-Focus-Timer\memory\w3_plan.md`
- Claude detailed plan:
  - `D:\Claude\config\plans\prancy-crafting-pebble.md`
- Codex records:
  - `docs/AGENT_HANDOFF.md`
  - `docs/NEW_ROADMAP_CN.md`
  - `docs/Codexlog.md`
  - `docs/Codex观察记录.md`
  - public reference/license extraction notes have been removed from repo docs
- Current code state:
  - Existing local changes already include Android permission cleanup, timer fixes, default blue theme, group/recycle-bin work, tests, and documentation.

## Immediate Plan

### 1. Stabilize Git State

Goal: make the current work easy to review and safe to push.

- Keep ignored local artifacts out of Git:
  - `tmp_reference*`
  - local screenshot/XML captures
  - temporary APK notice extraction files
- Do not delete local observation files unless the user explicitly asks.
- Split commits by intent instead of making one huge commit:
  1. `.gitignore` cleanup for local artifacts.
  2. Android permission, MethodChannel, and timer-state fixes.
  3. Todo groups, recycle bin, global menu, and related tests.
  4. Documentation: reference app observations, roadmap, build notes, and Codex logs.
- Before each code commit, run at least:
  - `flutter analyze`
  - `flutter test`

### 2. Finish The Local Data Loop

Goal: todo groups and recycle bin should feel dependable.

- Review the current recycle-bin implementation.
- Verify restore and permanent delete from UI on emulator.
- Make sure permanent delete removes child tasks.
- Improve feedback for:
  - move group to recycle bin
  - restore group
  - permanent delete
  - complete all active tasks
  - hide/show completed tasks
- Replace placeholder menu results with either real behavior or clear feedback.

### 3. Rework Timer Entry Toward reference app Flow

Goal: move from a settings-like timer page to a start-action page.

- Keep the current `计时` Tab, but reshape it toward card entry:
  - today timing summary
  - `自由计时`
  - `番茄计时`
  - `视频打卡`
  - 起床/睡觉不再作为计时入口，改走每日打卡/习惯数据模型
  - quick rests: `5分钟 / 10分钟 / 20分钟`
- Use bottom sheets for start flows:
  - free timer: name confirmation, then start
  - pomodoro: name + duration, then start
  - rest: quick start
- Runtime rules:
  - free timer stops and saves directly
  - pomodoro stop while paused should offer discard vs finish-and-save
  - rest records should be separated from focus stats unless explicitly included
- For pomodoro and countdown modes, make the main running number the remaining time.

### 4. Improve My Page And Settings

Goal: make `我` page a real local control center.

- Keep only useful local entries at first:
  - theme color
  - dark mode/system mode
  - recycle bin
  - day countdown
  - timer statistics
  - export data
  - about
- Move theme color to this area as the single source of truth.
- Add simple, honest feedback for unfinished entries instead of silent taps.
- Avoid login/member/cloud concepts in the current APK.

### 5. Build The First Stats Skeleton

Goal: enough statistics to make records visible without overbuilding charts.

- Start with:
  - today summary
  - week summary
  - month heatmap
  - timeline/recent records
- Add day/week/month/year segmented control as structure.
- Later add chart management inspired by reference app:
  - visible/hidden built-in charts
  - simple reorder
  - no VIP/chart market behavior.

## Current Priority Order

1. Keep APK-first manual testing on emulator and real devices.
2. Keep the product boundary in this plan and feature docs:
   - reuse open-source dependencies and interaction structure
   - rewrite Flutter UI/state/data/native services in this repo
   - do not copy cloud/login/member/payment/bypass/resource identity pieces
3. Todo plan mode follow-up:
   - manual drag test with real tasks
   - verify moving an arranged item between slots
   - verify drag-back deletion
   - verify 15/30/60/120 minute segment settings
   - verify keyboard layout on iQOO A15 and Xiaomi A16
   - next polish: decide whether single tasks need independent colors or whether group color is enough
   - next polish: tune long-bar widths on narrow devices after real-device screenshots
   - latest polish: drag preview now changes width dynamically from left to right; retest hand feel on phone screenshots
4. Todo polish:
   - done: replace misleading group-card subtitle with task counts
   - done: convert create-group dialog to a bottom sheet
   - done: add a basic task action sheet
   - done: add todo home layout switch between list mode and two/three-column grid mode
   - done: improve empty-state create CTA
   - done: show task previews in group cards and deleted-group summaries in trash
   - done: connect task action sheet to free timer and pomodoro starts
   - done: add manual task sorting using existing `sortOrder`
   - done: soften left-swipe delete visual in dark mode
   - done: add undo for task delete and restore related plan records
   - done: task detail fields: note, priority, due date, estimated duration
   - done: task more actions: duplicate task, move to another group, mark as focus
   - done: plan item edit: duration, delete, start timer from plan
   - done: plan helper: copy yesterday
   - done: group sorting by long-press drag in list mode
   - done: search/filter todo tasks from todo home
   - done: todo home title switches between `待办` and `已办`
   - done: todo home completed list shows finished tasks, group names, and completed time
   - done: todo home completed view now has overview stats, group aggregation, date timeline, group-level done page, and completed-task action sheet
   - done: plan mode allows multiple different tasks in one time slot and deduplicates the same task in the same slot
   - done: planned item three-dot action grid: timers, complete/cancel, target, date, delete, stats
   - done: batch actions for selected tasks in group detail: complete, move, delete with undo
   - done: completed-task action sheet now includes detail, rename, duplicate, move, and focus actions
   - next: real-device pass on todo detail sheet, move-task sheet, and plan item edit sheet
   - next: retest planned item three-dot menu on vertical emulator and real phone
   - done: single-task custom color with group-color fallback
   - done: daily-reset groups now reopen old completed tasks on app entry
   - next: plan templates beyond copy-yesterday
5. Stats chart skeleton and timeline polish:
   - first pass implemented: day/week/month/year, heatmap, pie, timeline, chart visibility, manual record makeup
   - done: daily wake/sleep check-in moved out of timer records into `daily_logs`
   - done: stats page can show daily check-in panel and merge check-ins into timeline
   - next polish: real-device layout check, daily-log edit/delete, richer chart types, custom date range
6. Timer card-entry redesign:
   - done: card-style timer entry surface
   - done: bottom-sheet start flows for free timer, pomodoro, countdown, video, sleep, and quick rests
   - done: running display uses remaining time for target timers
   - done: free timer saves directly on stop
   - done: pomodoro/countdown can discard or save after pause
   - done: recent timer feedback card on timer home
   - done: recent/today timer records can continue, rename, and delete
   - done: timer records can edit duration
   - done: timer screen split into record widgets, setup sheets, and UI helpers
   - next: real-device pass for keyboard, pause/stop dialog, auto-complete notification, and background service
   - next: add fuller record edit fields, such as note, start/end time correction, and type correction
7. My page local settings/data entries.
   - done: data export page split into all/todo/timer/daily-log JSON exports
   - next: add import/restore design before relying on export as a real backup workflow
8. Later optional public API extensions:
   - keep Android APK local-first as the core; do not add these before todo/timer/stats are stable
   - calendar/holiday APIs are the best fit for day countdown, plan mode, due dates, and holiday/workday hints
   - Todoist/Notion/Clockify/WakaTime-style integrations can be optional import/export/sync later, not required core features
   - weather APIs can support plan-day context for outdoor/exercise tasks, but should stay lightweight and optional
   - quote/inspiration APIs are low priority and only suitable as small completion/empty-state polish
   - avoid login, cloud sync, third-party auth, finance/news/social APIs, or external services that store user data during APK core stabilization
9. Visual polish later: iOS 26-style Liquid Glass direction.
   - Treat Gaussian blur as only one layer of the material, combined with translucency, border highlights, subtle shadow, contrast control, and motion response.
   - Use glass only on floating controls, bottom navigation, bottom sheets, compact toolbars, and small overlays; avoid full-page blur.
   - Prefer constrained `BackdropFilter` regions, shared/grouped filters where possible, and static translucent fallbacks on low-end or janky devices.
   - Verify only with release APK frame behavior; debug jank is not enough to judge the final feel.

## Testing Plan

For each implementation round:

- Static checks:
  - `flutter analyze`
  - `flutter test`
- Android build:
  - `flutter build apk --debug`
  - release build when testing startup/size: `flutter build apk --release`
- Emulator checks:
  - fresh install
  - first launch has no storage permission prompt
  - todo group create/task create/complete/recycle/restore/permanent delete
- free timer start/pause/stop/save
- pomodoro start/pause/stop confirmation
- theme color persists visually
- liquid-glass polish, when added, must be checked on release APK for scroll, keyboard, drag, and tab switching jank

## Do Not Do Yet

- Do not continue broad reference app clicking or static scanning unless a specific interaction is needed.
- Do not start decorative Liquid Glass/animation work before the APK core flows are stable.
- Do not add discovery/community features.
- Do not add login, membership, cloud sync, QR/social flows, or third-party auth.
- Do not spend time on Web/Windows until Android APK is stable.
- Do not commit reference APKs, extracted APK trees, screenshots, or temporary UIAutomator XML.

## Next Action

Focus on user-side APK testing for the latest release build:

- Install and test latest APK:
  - `D:\Projects\Focus Timer\build\app\outputs\flutter-apk\app-release.apk`
  - build time: `2026-06-21 20:47:27`
  - SHA256: `675D97D1A00EF140EB3B5C33E5746B48F05799034292271E5EE42AB2F2ECE5F4`
- Dependency note:
  - `wakelock_plus` was removed because it pulled `package_info_plus`, which attempted to download AGP `8.12.1` from `dl.google.com` during release builds.
  - Keep-screen-on is now handled through the existing Android MethodChannel and `FLAG_KEEP_SCREEN_ON`.

Timer manual testing and close obvious timer rough edges:

- Test free timer:
  - start from timer tab
  - pause
  - continue
  - stop and verify it saves
  - verify `上次计时` appears on timer home
- Test pomodoro and countdown:
  - start with custom name/duration
  - verify main number is remaining time
  - pause
  - stop and choose `放弃`, verify no record appears
  - repeat and choose `保存`, verify record appears
  - edit a timer record duration and verify today's focus duration updates
  - rename and delete a record from `上次计时` and `今日记录`
- Test quick rests:
  - 5/10/20 minute rest starts directly
  - stopping rest does not increase today's focus duration
- Test Android behavior:
  - background notification/foreground service starts without crash
  - auto-complete sends notification and saves at target duration
  - keyboard in start sheets can be dismissed by tapping blank space
- After timer testing, decide next timer item:
   - fuller record edit fields
   - record note/心得
   - timer settings page
   - stricter background/notification handling

Current product boundary after research:

- Reference pages:
  - Todoist official features: `https://www.todoist.com/features`
  - public productivity-app feature references: `https://www.ticktick.com/features`
- Todo module should prioritize capture, projects/groups, priority, due date, reminders, labels/filters, completed history, and plan mode.
- Timer module should stay focused on duration records: free timer, pomodoro, countdown, rests, video evidence.
- Daily wake/sleep belongs to daily check-in/habit logging, not timer records.
- Statistics should aggregate across tasks, timer records, daily logs, and countdowns without mixing their raw data models.

Next implementation candidates:

- Daily log polish:
  - edit/delete wake/sleep records from timeline
  - add custom habit templates after wake/sleep stabilizes
  - show daily log trend in stats rather than only today's status
- Todo core:
  - labels/filters
  - reminders
  - recurring tasks
  - priority and due-date views
- Stats:
  - custom date range
  - weekly grid / hour distribution
  - completed-task trend
  - timer type comparison with better legend interaction

## 2026-06-21 Updated Next Queue

After the 1/2/3/4/5 optimization round:

- Stats next:
  - make day detail records tappable into edit sheets, if nested sheet behavior feels okay on device
  - add custom date range
  - add completed-task trend and daily-log trend
- Timer next:
  - test the three clock styles in release APK and choose the default
  - improve evidence picker/clear flow instead of raw URI editing
- Todo next:
  - add real filters for priority/due/focus/completed after search result UX is verified
  - design reminders and recurring tasks before implementation
- Daily log next:
  - add custom habit templates after wake/sleep edit/delete is verified
  - add streak/trend card in stats
- Data next:
  - design JSON import rules: overwrite, append, deduplicate, video path validation
  - implement import only after a sample exported JSON is tested

## 2026-06-21 Next Queue After 1-5 Round 2

- Stats:
  - test custom range on phone, especially bottom floating control width
  - make pie chart slices themselves tappable, not only legend rows
  - add completed-task trend
- Timer:
  - replace raw video URI input with file picker / camera evidence manager
  - add evidence preview from stored URI when Android grants access
- Todo:
  - promote search hints into real filters: focus, priority, due date, completed, planned
  - design reminders and recurrence data model before coding
- Daily log:
  - add custom habit templates after wake/sleep trend is stable
  - add streak and missed-day logic
- Data:
  - implement import only after deciding merge strategy
  - support dry-run preview from selected JSON file instead of pasted text

## 2026-06-22 Current Queue

Done in code:

- JSON restore dry-run now uses Android file picker with multi-select instead of clipboard paste.
- Video evidence supports camera capture, selecting an existing video, storing/copying into `Download/Focus Timer/Videos`, and in-app playback through native `VideoPlayerActivity`.
- Todo tasks now have task-level pinning, reminder time, and repeat rule fields.
- Todo detail sheet exposes pin/reminder/repeat; completing a repeated task creates the next occurrence and schedules its reminder.
- Timer clock styles now include five choices: ring, digital, flip, progress bar, minimal.
- Android manifest now declares only the relevant new permissions/features for these flows: camera, exact alarm, legacy read external storage for Android <= 12, plus existing notifications/foreground/wake/vibrate.

Needs next verification:

- Fresh APK has been built on the user's machine.
- Current APKs:
  - Debug: `D:\Projects\Focus Timer\build\app\outputs\flutter-apk\app-debug.apk`
  - Release: `D:\Projects\Focus Timer\build\app\outputs\flutter-apk\app-release.apk`
- On device, test:
  - data export -> restore data -> multi-select JSON precheck
  - video check-in -> camera capture -> playback in app
  - video check-in -> select existing video -> playback in app
  - stats record edit -> choose/play video
  - todo detail -> set reminder -> receive notification
  - todo repeat daily/weekly/monthly -> complete -> next task appears
  - pin/unpin task -> pinned task sorts to top
  - timer settings -> switch all 5 clock styles while running

Known follow-up:

- Full JSON import is still dry-run only. Decide merge mode before writing to DB:
  - recommended default: append with ID remap and duplicate warning
  - optional later: destructive restore after explicit confirmation
- Reminder exact-alarm behavior may vary by Android version/vendor. If notification does not fire, add an in-app permission/status page for exact alarm settings.
- In-app video player is native Android `VideoView`; if codec/device issues appear, decide whether to add Flutter `video_player` dependency later.

## 2026-06-22 Linkage Queue: Todo / Timer / Stats

Done in code:

- Database linkage:
  - `FocusTime` and `ActiveTimerSession` now carry nullable `taskId/listId/planId`.
  - Drift schema is now version `15`; old records keep null linkage and remain readable.
- Todo -> Timer:
  - Timer creation supports task/list/plan linkage.
  - Todo detail timer entries and plan-mode timer entries pass real linkage into active session and saved records.
  - Timer home has a `从待办开始` entry, prioritized by today planned tasks, today/overdue tasks, focus, pinned, priority, reminder, and estimated duration.
- Timer stop flow:
  - Linked focus timers ask whether to `仅保存` or `保存并完成待办`.
  - Completing from timer calls `completeIfActive`, preserving repeated-task follow-up behavior.
- Timer records:
  - Record cards and action sheets show source linkage.
  - Records with a live `listId` can open the source group from the source action.
- Todo smart views:
  - Todo home now exposes smart views: 今日、逾期、重点、置顶、提醒、重复、已计划.
  - These are derived from existing task fields and today plan data; no new table yet.
- Todo detail:
  - Detail sheet shows linked focus total, estimate, plan count, latest linked timer record, and latest plan.
- Stats:
  - `StatsSnapshot` aggregates timers, tasks, lists, plans, and daily logs together.
  - Stats now shows completion count/rate, overdue count, linked focus time, focus-task completions, planned record count, estimate vs actual, duration by task, and duration by group.
  - Timeline rows show source labels for linked timer records.
- Export:
  - JSON export includes new linkage fields through Drift JSON output.
  - Video evidence index includes `taskId/listId/planId`.
  - Restore precheck counts linked timer records; restore is still dry-run only.

Verified:

- `dart analyze --format=machine` passes with empty output.
- `flutter test test\database_test.dart test\task_provider_test.dart test\task_repository_test.dart test\timer_provider_test.dart` passes: 31 tests.

Next manual APK test:

- From a todo detail, start free timer, stop with `仅保存`, then verify stats and todo detail show linked time.
- From a todo detail, start timer, stop with `保存并完成待办`, verify task completes and repeat-task behavior still works.
- From plan mode, start a timer from a planned block, verify stats planned count increases and timeline shows source.
- On timer home, verify `从待办开始` prioritizes today planned/focus/pinned tasks.
- In timer record actions, tap source and verify it opens the correct group when the group still exists.
- Export JSON and verify `focusTimes` plus `videoEvidence` contain `taskId/listId/planId`.

Known follow-up:

- JSON restore now supports append/import with ID remap and duplicate checks. Remaining data work:
  - add destructive full restore only behind a very explicit second confirmation, if ever needed
  - validate video URI availability after cross-device restore and show missing-file status
  - theme settings and todo layout preference are now persisted and included in export/import
- Stats chart drill-down currently shows attribution and source labels, but task/group attribution rows are not yet tappable into filtered record managers.
- Timer source jump opens the source group; it does not yet deep-open the exact task detail sheet.
- Smart views are home-level derived filters; they are not yet configurable saved filters/tags.

## 2026-06-22 Non-UI Function Round

Done in code:

- Data restore is no longer dry-run only:
  - selected JSON files can be previewed and then appended into the local database
  - imported list/task/plan IDs are remapped so timer linkage stays valid
  - duplicate task lists, tasks, plans, timer records, and daily logs are skipped
  - day countdown and timer settings are restored into their local JSON files
- Export now includes `timerSettings` and `appearanceSettings`.
- Theme color, theme mode, and todo list/grid layout are now persisted in `appearance_settings.json`.
- Permission behavior is cleaner:
  - startup prompt covers notification, exact reminder, and camera
  - no storage permission prompt is shown for Download/SAF based export/import
  - Android channel can open exact alarm settings
- Reminder consistency:
  - app startup reschedules future active task reminders
  - trash/permanent delete cancels reminders
  - restore reschedules future reminders
- Task/plan consistency:
  - moving a task to another group also moves its plans
  - task changes refresh all-task data used by timer start and stats
- Stats:
  - plan hit calculation now checks real plan windows, not only `planId`
  - stats linkage panel includes plan-hit ratio

Verified:

- `dart analyze --format=machine` passes with empty output.
- `flutter test test\data_restore_service_test.dart test\database_test.dart test\task_repository_test.dart test\task_provider_test.dart test\timer_provider_test.dart` passes: 34 tests.

Next non-UI candidates:

- Deep link timer record source to exact task detail, not just group.
- Make stats attribution rows open filtered record managers.
- Add configurable saved filters/tags after smart views are stable.
- Add video missing-file detection for restored JSON on another device.
- Rebuild release APK and let user test restore/reminder/video flows on device.
