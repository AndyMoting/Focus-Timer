# Focus Timer Maintenance Playbook

## Canonical commands

- Build release APK: `./tools/build_apk.ps1 -Mode release`
- Focused rebuild: `./tools/build_apk.ps1 -Mode release -SkipAnalyze -SkipTests`
- Build, install, and launch on one connected device: `./tools/build_apk.ps1 -Mode release -Install -Launch`
- Hash the APK: `Get-FileHash build/app/outputs/flutter-apk/app-release.apk -Algorithm SHA256`
- List devices: `adb devices -l`
- Capture logs: `adb logcat -d`

## Workflow

1. Reproduce the issue on the smallest reliable surface.
2. Prefer targeted tests first, then widen only if needed.
3. Use the release APK for Android behavior checks unless a debug-only issue is suspected.
4. Record the device id, APK hash, and evidence path for every ADB run.
5. Update both test guides after a confirmed fix:
   - `docs/ANDROID_MANUAL_TEST.md`
   - `docs/ANDROID_USER_TEST_GUIDE.md`

## Test record template

```text
日期:
设备:
APK:
SHA256:
步骤:
期望:
实际:
结论:
```