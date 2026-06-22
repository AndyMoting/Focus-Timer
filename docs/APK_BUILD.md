# APK 构建

## 环境

Flutter 3.x / Android minSdk 30 / targetSdk 35

## 构建

```bash
flutter build apk --debug
flutter build apk --release
```

## 脚本

```powershell
.\tools\build_apk.ps1 -Mode release
.\tools\build_apk.ps1 -Mode release -SkipAnalyze -SkipTests
.\tools\build_apk.ps1 -Mode release -Install -Launch
```

## 产物

`build\app\outputs\flutter-apk\app-release.apk`

## 限制

Release 用 debug keystore，正式发布需替换。Web/Windows 不支持（SQLite FFI）。
