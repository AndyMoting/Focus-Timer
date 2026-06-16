# Focus Timer UI & 交互架构

## 核心架构

### 进程模型
- **单 Activity 模式** (`MainActivity extends FlutterActivity`)
- Flutter 处理所有 UI
- Java 层仅做平台桥接（30 个类）

### 平台通信通道
- **主通道**: `MethodChannel("ticking")` 
- 双向调用：Flutter ↔ Android

---

## 平台桥接方法清单 (PlatformPlugin)

### 计时器相关
| 方法 | 功能 | 参数 |
|------|------|------|
| `syncTimer` | 同步计时状态到 Widget | `mTimer` (JSON) |
| `refreshWidget` | 触发 Widget 更新 | — |
| `initMiPush` | 初始化小米推送 | — |

### UI 显示/隐藏（浮窗模式）
| 方法 | 功能 |
|------|------|
| `showWindow` | 显示浮窗（参数: `mTimer` JSON） |
| `hideWindow` | 隐藏浮窗 |
| `switchToBackground` | 应用切后台 |

### 文件与权限
| 方法 | 功能 | 权限 |
|------|------|------|
| `syncAlbum` | 保存截图到相册 | WRITE_EXTERNAL_STORAGE |
| `isAlbumAuthorized` | 检查相册权限 | — |
| `openAppSettings` | 打开应用设置 | — |

### 其他
| 方法 | 功能 |
|------|------|
| `share` | 分享文件 |
| `getMiPushRegId` | 获取推送 ID |

---

## 计时模式 (FocusTimeConstants)

### 类型 (TYPE_*)
```
0 = TYPE_TOMATO         → 番茄钟 (25 min)
1 = TYPE_REST           → 休息
2 = TYPE_FREEDOM        → 自由计时
3 = TYPE_SLEEP          → 睡眠闹钟
4 = TYPE_VIDEO          → 视频计时
5 = TYPE_GET_UP         → 起床闹钟
10 = TYPE_COUNT_DOWN_DAY → 日倒计时
```

### 状态 (STATE_*)
```
0 = STATE_STOP              → 停止
1 = STATE_FOCUSING          → 正在计时
2 = STATE_PAUSE             → 暂停
3 = STATE_WAITING_FOR_START → 等待开始
```

---

## 桌面小组件 (Widgets)

### 1. FocusTimeWidget（番茄钟/计时器）
**更新频率**: 1 秒（AlarmManager.setExact）

**显示内容**：
- 当前任务名称
- 当前计时时间
- 状态文本 ("正在专注" / "倒计时" / ...)

**尺寸适配**：< 150dp 时显示简洁版

**更新触发**：
- 系统 Broadcast (FOCUS_AUTO_UPDATE / FOCUS_REFRESH)
- Flutter 调用 `syncTimer`

### 2. TodoWidget（待办事项）
- 显示当日任务列表
- 实时更新

### 3. HeatmapWidget（热力图）
- 每日专注时长分布
- 使用 ECharts.js 渲染

### 4. StudyWidget（自习室）
- 学校数据（school.json 3.9MB）
- [个人版不实现]

---

## 数据存储

### SharedPreferences
**Key**: `TickingWidgetPrefs`

| Key | 类型 | 用途 |
|-----|------|------|
| `userId` | Long | 用户 ID (默认 1) |

### SQLite Database
- **工具类**: `MyDBHelper`
- 存储任务、计时记录、习惯数据
- [具体表结构需从 Dart 层推断]

---

## 资源清单

### 图片 & 资源
```
images/
├── svg/
│   ├── timer.svg           # 计时图标
│   ├── 1.svg, 2.svg, 3.svg # 背景/装饰
├── day-night.png           # 昼夜模式示意
├── geranium.jpg            # 背景素材
├── study.jpg, sea.jpg      # 自习室场景
└── vip.png                 # VIP 标记

login/
├── logo.png, a.png
├── btn_checked.png, btn_unchecked.png
├── login_btn_normal/press/unable.png
└── alipay.png, sina.png, taobao.png  # 三方登录

animations/
└── flip_phone.json         # 手机翻转动画 (Lottie)
```

### 自定义字体
```
fonts/
├── LazyTodoIcon.ttf        # 应用 Icon 字体（自定义）
└── MaterialIcons-Regular.otf
```

### 第三方资源
```
assets/
├── echarts.min.js          # 热力图绘制
└── school.json             # 3.9MB 学校数据库
```

---

## UI 导航结构（推断）

基于 Java 层代码，推断的主要页面：

```
首页
├── 计时器页
│   ├── 番茄钟模式
│   ├── 自由计时
│   ├── 正计时 / 倒计时
│   └── 浮窗模式 (showWindow/hideWindow)
├── 待办列表页
│   ├── 多列表管理
│   ├── 排序/筛选
│   └── 编辑/删除/恢复（回收站）
├── 专注分析页
│   ├── 热力图 (ECharts)
│   ├── 每日时长分布
│   └── 周/月统计
├── VIP 管理页
│   ├── Google Play Billing
│   └── 微信支付
├── 自习室页（不实现）
├── 登录页
│   ├── 微信登录
│   ├── 支付宝登录
│   ├── 新浪微博登录
│   └── Sign in with Apple
└── 设置页
    ├── 权限管理
    ├── 通知设置
    └── 主题（日/夜）

浮窗
├── 计时浮窗 (showWindow)
└── 覆盖窗口显示 (android.permission.SYSTEM_ALERT_WINDOW)
```

---

## 权限清单

### 必需权限
```
INTERNET                    # 网络请求
CAMERA                      # 拍照/QR 扫码
VIBRATE                     # 振动提醒
SCHEDULE_EXACT_ALARM        # 精确闹钟
RECEIVE_BOOT_COMPLETED      # 开机自启
FOREGROUND_SERVICE          # 前台服务
```

### 存储权限（分 API 级别）
```
API 33+  : READ_MEDIA_IMAGES / READ_MEDIA_VIDEO
API ≤32  : READ_EXTERNAL_STORAGE / WRITE_EXTERNAL_STORAGE
```

### 敏感权限
```
READ_PHONE_STATE            # 来电话挂断检测？
RECORD_AUDIO                # 录音？
SYSTEM_OVERLAY_WINDOW       # 浮窗权限
```

---

## 第三方 SDK 集成

| SDK | 功能 |
|-----|------|
| 友盟+ (UMeng) | 统计、推送、反作弊 |
| 小米推送 6.0.1-C | 消息推送 (AppKey 硬编码) |
| 微信 OpenSDK (fluwx) | 微信登录、支付 |
| Google ML Kit | QR 码扫描 |
| Google Play Billing 7.1.1 | 应用内购 |
| FFmpeg | 音视频处理？ |
| Sign in with Apple | iOS 适配 |
| 阿里云号码认证 | 一键登录？ |

---

## 特殊交互模式

### 1. 浮窗计时 (Overlay Window)
- 应用后台时显示计时浮窗
- 权限: `SYSTEM_ALERT_WINDOW` / `SYSTEM_OVERLAY_WINDOW`
- 控制方法: `showWindow()` / `hideWindow()`

### 2. 专注模式 (Focus Mode)
- 防止切换应用（拦截 home/recent）
- 截图保存（`syncAlbum` 权限）
- 参考原版 Java 代码的防切换逻辑

### 3. 桌面小组件自动更新
- 使用 `AlarmManager.setExact()` 每秒更新
- 广播通道: `FOCUS_AUTO_UPDATE` / `FOCUS_REFRESH`
- 轻量级 RemoteViews 渲染

---

## UI 设计线索

### 配色方案
- **昼/夜模式**: 资源分层 (`color/` vs `color-night/`)
- **深色对比**: `color-v31` (Material You 适配 API 31+)

### 动画
- Lottie 动画: `flip_phone.json` (手机翻转)
- 标准 Android 转场动画

### 字体
- 自定义 Icon 字体 `LazyTodoIcon.ttf`
- 用于任务分类、模式选择的 Icon

---

## 复刻重点

### ✅ 优先级高
1. **计时器引擎** (STATE / TYPE 管理)
2. **待办列表** (增删改查 + 回收站)
3. **热力图** (使用 Flutter ECharts 或原生图表库)
4. **浮窗模式** (Windows/Mac 上用 OverlayEntry)
5. **字体/Icon** (复用 LazyTodoIcon.ttf)

### 🟡 优先级中
- 桌面小组件 (Windows 没有，可做成通知栏)
- VIP 体系 (Google Play Billing 替换为自定义)
- 多语言 (Crowdin 集成可选)

### ⏸ 暂不做
- 自习室 (school.json 数据库太大)
- 三方登录 (本地版无需账户)

---

## 开发建议

### 数据库方案
- 用 **Drift** (SQLite 自动生成)，而非 Hive
- Schema 参考 Widget 类的数据结构

### 状态管理
- 建议用 Riverpod (推荐)、Provider 或 Bloc
- 计时器逻辑用 `Timer` / `Isolate` 实现

### 文件结构
```
lib/
├── main.dart
├── models/
│   ├── focus_time.dart
│   ├── todo_task.dart
│   └── heatmap_data.dart
├── screens/
│   ├── timer_screen.dart
│   ├── todo_screen.dart
│   ├── analytics_screen.dart
│   └── settings_screen.dart
├── widgets/
│   ├── timer_widget.dart
│   ├── task_card.dart
│   └── heatmap_chart.dart
├── services/
│   ├── database_service.dart
│   ├── timer_service.dart
│   └── notification_service.dart
└── utils/
    ├── constants.dart
    └── theme.dart
```

### 关键依赖
```yaml
dependencies:
  flutter:
    sdk: flutter
  drift: ^2.x
  sqlite3: ^3.x
  riverpod: ^2.x  # 状态管理
  fl_chart: ^0.x  # 热力图
  flutter_local_notifications: ^15.x
  
dev_dependencies:
  build_runner: ^2.x
  drift_dev: ^2.x
```
