# APK 构建说明

**日期**: 2026-06-18  
**版本**: 0.1.0+1 Alpha
**当前策略**: Android APK 优先，Web / Windows 暂不作为发布目标

---

## 当前验证结果

| 命令 | 结果 |
|------|------|
| `flutter analyze` | 通过，无静态检查问题 |
| `flutter test` | 通过，10 个测试全部通过 |
| `flutter build apk --debug` | 通过，产物位于 `build/app/outputs/flutter-apk/app-debug.apk` |
| `flutter build web` | 暂不支持，当前 Drift/SQLite 入口依赖 `dart:ffi` |
| `flutter build windows` | 当前机器缺少 Visual Studio toolchain，未验证 |

---

## Android 版本支持

- **minSdk**: 30 (Android 11)
- **targetSdk**: 35 (Android 15)
- **数据库**: SQLite / Drift，本地存储
- **通知**: `flutter_local_notifications`
- **后台计时**: Android ForegroundService

---

## APK 构建命令

推荐使用脚本：

```powershell
powershell -ExecutionPolicy Bypass -File tools\build_apk.ps1
```

常用参数：

```powershell
# 构建 release，并跑 analyze/test
powershell -ExecutionPolicy Bypass -File tools\build_apk.ps1 -Mode release

# 构建后安装并启动到指定手机
powershell -ExecutionPolicy Bypass -File tools\build_apk.ps1 -Mode release -Install -Launch -DeviceId 769d76ab

# 只快速构建，不跑 analyze/test
powershell -ExecutionPolicy Bypass -File tools\build_apk.ps1 -Mode release -SkipAnalyze -SkipTests
```

### Debug APK

```bash
flutter build apk --debug
```

输出：

```text
build/app/outputs/flutter-apk/app-debug.apk
```

### Release APK

```bash
flutter build apk --release
```

注意：当前 `android/app/build.gradle.kts` 的 release 配置仍使用 debug signing config，只适合本地测试；正式发布前必须配置 release keystore。

---

## 当前已实现

- 计时器：番茄钟、自由计时、倒计时、休息、视频打卡等模式。
- 计时控制：开始、暂停、恢复、停止、重置。
- 计时记录：停止后写入本地 SQLite。
- 暂停时长：保存记录时排除暂停时间。
- 今日统计：统计非休息类型的专注时长。
- 热力图：按月聚合非休息类型计时记录。
- 通知：计时完成系统通知。
- 后台计时：Android ForegroundService 显示进行中通知。
- 待办：分组、创建任务、勾选完成、滑动删除。
- 分组：重命名、改色、每日重置标记、软删除。
- 主题：8 种主题色，跟随系统深色模式。

---

## 已知限制

- Web 当前无法构建，原因是数据库入口依赖 `drift/native.dart` / `sqlite3` FFI。
- Windows 当前未验证，需要先安装合适的 Visual Studio toolchain。
- Release 签名尚未配置正式 keystore。
- Android `foregroundServiceType="specialUse"` 发布前需要确认 Android 14/15 策略和应用商店审核要求。
- 回收站、导出数据、深色模式手动开关、全部完成、隐藏已完成待办等入口仍需后续补齐。
- 分组统计暂未实现真正按分组统计；当前 APK 仅保留全局热力图。

---

## 手动测试清单

1. 安装 `app-debug.apk` 到 Android 设备。
2. 首次启动检查通知权限弹窗。
3. 开始自由计时，暂停数秒后停止，确认今日专注时长没有把暂停时间算进去。
4. 开始倒计时，等待完成，确认系统通知出现并写入记录。
5. 创建待办分组，添加任务，勾选完成，滑动删除任务。
6. 修改分组颜色，返回列表确认颜色保存。
7. 打开全局热力图，确认当月记录能显示。
8. 杀掉应用后重新打开，确认历史统计仍存在。
