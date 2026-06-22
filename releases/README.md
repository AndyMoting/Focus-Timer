# Releases

此目录存放项目构建产物（不提交到 Git）。

## 目录结构

```
releases/
├── v0.1.0/
│   ├── focus-timer-v0.1.0-debug.apk
│   └── build-info.txt
├── v0.2.0/
│   └── ...
└── README.md (本文件)
```

## 构建命令

### Android APK (Debug)
```bash
flutter build apk --debug
cp build/app/outputs/flutter-apk/app-debug.apk releases/v0.1.0/focus-timer-v0.1.0-debug.apk
```

### Android APK (Release)
```bash
flutter build apk --release
cp build/app/outputs/flutter-apk/app-release.apk releases/v0.1.0/focus-timer-v0.1.0-release.apk
```

### Android App Bundle
```bash
flutter build appbundle --release
cp build/app/outputs/bundle/release/app-release.aab releases/v0.1.0/focus-timer-v0.1.0-release.aab
```

## 版本历史

| 版本 | 日期 | 说明 |
|------|------|------|
| v0.1.0 | 2026-06-16 | 初始版本 - 项目骨架 |
