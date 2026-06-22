# Agent Handoff

Date: 2026-06-19

Repo: `D:\Projects\Focus Timer`

Branch: `codex/android-Focus_Timer`

Latest APK:

- `D:\Projects\Focus Timer\build\app\outputs\flutter-apk\app-release.apk`
- Last release build size: about `57.4MB`

Latest validation:

- `flutter analyze`: passed
- `flutter test`: passed, 16 tests
- `flutter build apk --release`: passed
- `dart format`: currently hangs/timeouts on touched files, so do not treat formatting as a reliable check until the local toolchain issue is understood

## Current Direction

Android-first local Focus Timer app inspired by reference app:

- Local only.
- No login.
- No cloud sync.
- No membership/VIP wall.
- No discovery/community module for now.
- Learn interaction structure from reference app, but do not copy reference APK assets, proprietary code, signing identity, cloud/payment/login behavior, or bypass logic.

Current bottom tabs:

1. `待办`
2. `计时`
3. `统计`
4. `我的`

## Important Current Docs

- `docs/Codexplan.md`: active plan and next action.
- `docs/NEW_ROADMAP_CN.md`: current Chinese roadmap that summarizes old phases and the new route.
- `docs/Codexlog.md`: chronological work log.
- `docs/Codex观察记录.md`: reference-app observations only.
- Product boundary is documented in `docs/Codexplan.md` and `docs/Focus_Timer功能介绍.md`.
- Reference APK/license extraction notes were removed from the public-facing docs.
- `docs/AGENT_HANDOFF.md`: this file.

## Current Worktree Situation

The worktree is intentionally dirty because several feature rounds are still uncommitted together:

- Android permission cleanup and theme/runtime fixes.
- Todo group/recycle-bin/global menu work.
- Todo plan mode with 24h timeline, adjustable slot size, drag-to-slot, move, clear, and drag-back delete.
- Timer entry redesign and keyboard/runtime fixes.
- Profile page settings/export/about fixes.
- Stats page first rebuild.
- Documentation updates.

Untracked but meaningful files:

- `docs/Codexplan.md`
- `lib/domain/models/task_plan_settings.dart`
- `lib/presentation/screens/task_plan_screen.dart`

Ignored local artifacts should stay untracked:

- `tmp_reference*`
- root screenshot/XML captures such as `focus_home*.xml`, `latest_plan_*.png`, `latest_plan_*.xml`
- `analysis/`
- `releases/reference/`

Do not run destructive Git cleanup. Do not reset or checkout files unless the user explicitly asks.

## Implemented Recently

### Todo Plan Mode

- Home page has a global plan-mode entry.
- Group detail has group-scoped plan-mode entry.
- Plan mode supports:
  - all active tasks or one group
  - 24h timeline by default
  - configurable start/end and `15 / 30 / 60 / 120` minute slots
  - drag task from left pool to timeline
  - repeat scheduling of the same task
  - move scheduled item between slots
  - drag scheduled item back left to remove it from the plan
  - clear all plans
  - group colors in task pool and scheduled bars
- Latest user-confirmed fix: right-side bars are embedded in slots and drag starts from the bar head as desired.

### Timer

- Timer page is now a start surface rather than a settings-like page.
- Supports cards for free timer, pomodoro, countdown, video study, sleep/wake, and quick rests.
- Bottom sheets are used for naming/configuration.
- Free timer saves directly on stop.
- Pomodoro stop while paused can ask whether to save or discard.
- Keyboard red-screen issue around timer name input was fixed.
- Debug-package keyboard jank was reduced by removing autofocus.

### Stats

- Stats page now supports:
  - `日 / 周 / 月 / 年`
  - previous/next range navigation
  - summary: total focus, record count, daily average
  - self-painted heatmap
  - custom-painted pie chart by timer type
  - timeline records
  - manual record makeup via `补录`
  - chart visibility via `图表管理`
- Stats records come from `focus_time` through `TimerRepository.getRecordsInRange`.
- Focus aggregates exclude rest and sleep/wake types.

### Profile / Settings

- Theme color and display mode are handled locally.
- Display mode supports system/light/dark.
- Export writes local JSON without storage permission.
- About dialog works.
- Notification permission entry falls back to app settings when the system dialog is unavailable.

## Current Highest-Value Manual Test

Install the latest release APK and test the stats page first:

1. Open `统计`.
2. Switch `日 / 周 / 月 / 年`.
3. Navigate previous/next ranges.
4. Use `补录` to add a focus record.
5. Confirm summary, heatmap, pie chart, and timeline update.
6. Use `图表管理` to hide/show charts.
7. Check narrow phone layout for:
   - pie legend overflow
   - timeline row overflow
   - year heatmap density
   - bottom navigation overlap

Then retest plan mode:

1. Create multiple tasks in multiple groups.
2. Enter global plan mode from todo home.
3. Drag tasks into different slots.
4. Move scheduled items.
5. Drag scheduled items back left to remove.
6. Change slot size to 30 minutes and verify slots like `08:30`.

## Suggested Agent Split

If opening multiple agents, keep them read-only for now.

### Agent 1: APK/UI Observation

Role: install and visually test the current release APK.

Allowed:

- Use emulator/ADB/screenshots.
- Record concrete UI issues with screen, action, expected, actual.
- Update no code.

Targets:

- Stats page first.
- Plan mode second.
- Timer start/stop third.

### Agent 2: Code Review

Role: inspect changed code for bugs and missing tests.

Allowed:

- Read code and tests.
- Report findings with file/line references.
- Do not edit files.

Targets:

- `lib/presentation/screens/stats_screen.dart`
- `lib/presentation/providers/heatmap_provider.dart`
- `lib/presentation/screens/task_plan_screen.dart`
- `lib/presentation/screens/timer_screen.dart`
- repository/database changes

### Main Agent

Role: keep write access and perform fixes after observations are collected.

Do not let multiple agents edit the same Flutter files in parallel.

## Next Implementation Candidates

1. Stats polish:
   - timeline record edit/delete
   - persistent chart visibility/order
   - weekly trend chart
   - focus-time distribution chart
2. Todo polish:
   - create-group bottom sheet
   - task action sheet
   - decide whether individual tasks need independent color
3. Timer polish:
   - recent record feedback after stop
   - runtime page tool actions
   - stricter pomodoro/rest save rules
4. Profile/data:
   - independent export page
   - todo export and timer export split
   - countdown entry polish

## Cautions

- Do not continue broad reference app scanning unless a specific interaction needs reference.
- Do not copy assets or decompiled proprietary code from the reference APK.
- Do not add cloud/login/member/payment/social flows.
- Do not push or overwrite `origin/main` without user confirmation.
- Do not commit local screenshots/XML/reference APK/extracted analysis trees.
