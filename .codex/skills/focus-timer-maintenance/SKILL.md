---
name: focus-timer-maintenance
description: Focus Timer 仓库的 Android 构建、测试、ADB 复测、logcat 排查和文档回写。用于需要构建 APK、运行 Flutter 测试、连接模拟器或真机复现、检查通知/计时/撤销链路，或更新测试文档的场景。
---

# Focus Timer Maintenance

Use this skill for Focus Timer repo work that needs a repeatable Android validation loop.

## Workflow

1. Inspect the current change set and identify the surface being changed.
2. Prefer the repo's existing automation:
   - `./tools/build_apk.ps1 -Mode release`
   - add `-SkipAnalyze` or `-SkipTests` only for a focused rebuild
   - use `-Install` and `-Launch` when an ADB device is connected
3. Run targeted Flutter tests before broad ones when the change is narrow.
4. Reproduce on emulator or device when the issue is user-facing:
   - verify `adb devices`
   - install the latest APK
   - launch the app
   - capture `adb logcat` and any UI evidence
5. Re-check the exact bug path twice when the user asks for confirmation, especially for:
   - delete / undo / notification interactions
   - timer start / stop / save flows
   - reminder / repeat / schedule edits
6. Update docs after the behavior is confirmed:
   - `docs/ANDROID_MANUAL_TEST.md`
   - `docs/ANDROID_USER_TEST_GUIDE.md`
   - record the APK hash, device id, steps, expected result, and actual result
7. Keep the writeup concrete and short: steps, expected result, actual result, pass/fail, retest.

## References

Read [references/maintenance-playbook.md](references/maintenance-playbook.md) for the canonical build, ADB, and documentation checklist.

## Notes

- Treat `.tmp/adb_test_*` as evidence folders.
- Prefer repo scripts and existing docs over inventing new commands.