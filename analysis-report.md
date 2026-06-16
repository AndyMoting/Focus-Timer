# Ticking APK 分析报告

**分析日期**: 2026-06-15  
**APK**: 1.18.13.apk (versionCode=4250)  
**包名**: cn.oboard.todo  
**开发方**: 深圳九九云科技有限公司

---

## 1. 基本信息

| 属性 | 值 |
|------|-----|
| 应用名 | Ticking（待办/计时/自习室） |
| 版本 | 1.18.13 (code 4250) |
| 包名 | cn.oboard.todo |
| minSdk | 26 (Android 8.0) |
| targetSdk | 36 (Android 15) |
| compileSdk | 36 |
| 架构 | arm64-v8a only |
| 开发框架 | **Flutter** (Dart → libapp.so 17.4MB) |
| DEX | 2 个 (classes.dex 8MB + classes2.dex 3.5MB) |
| 签名 | CN=oboard, RSA 2048-bit, APK Sig v2 |
| 签名 SHA-256 | `b8af053e186b7a35792b3dab45a758d2d89571b4b7dfb234c9a62f1bfeb770ec` |
| 文件总数 | 1766 |

---

## 2. 权限分析

### 危险权限 (7 项)

| 权限 | 用途推测 | 风险 |
|------|----------|------|
| CAMERA | 拍照/扫码 | 中 |
| RECORD_AUDIO | 录音 | 高 |
| READ_PHONE_STATE | 读取设备信息 | 高 |
| READ_MEDIA_IMAGES | 读取相册 (Android 13+) | 中 |
| READ_MEDIA_VIDEO | 读取视频 (Android 13+) | 中 |
| SYSTEM_ALERT_WINDOW | 悬浮窗（计时器浮窗） | 中 |
| POST_NOTIFICATIONS | 推送通知 | 低 |

### 功能权限 (10 项)

INTERNET, ACCESS_NETWORK_STATE, ACCESS_WIFI_STATE, CHANGE_NETWORK_STATE, CHANGE_WIFI_STATE, VIBRATE, RECEIVE_BOOT_COMPLETED, SCHEDULE_EXACT_ALARM, USE_EXACT_ALARM, FOREGROUND_SERVICE

### 第三方权限

- `cn.oboard.todo.permission.MIPUSH_RECEIVE` (自定义，protectionLevel=2/signature)
- `com.google.android.gms.permission.AD_ID` (Google 广告 ID)
- `com.android.vending.BILLING` (Google Play 内购)

---

## 3. 组件暴露面

### exported=true 组件 (15 个)

| 组件 | 类型 | 风险 |
|------|------|------|
| MainActivity | Activity | 正常入口 |
| AgreementActivity | Activity (LAUNCHER) | 正常入口 |
| WebViewActivity | Activity | **中危** - 接受外部 URL 加载 |
| SignInWithAppleCallback | Activity | 正常 SSO 回调 |
| WXEntryActivity | Activity-Alias | 微信登录回调 |
| WXPayEntryActivity | Activity-Alias | 微信支付回调 |
| NotificationClickedActivity | Activity (小米推送) | SDK 组件 |
| MiPushMessageReceiver | Receiver | 小米推送接收器 |
| ScheduledNotificationBootReceiver | Receiver | 开机自启 |
| FocusWidgetProvider | Receiver | 桌面小组件 |
| HeatmapWidgetProvider | Receiver | 桌面小组件 |
| StudyWidgetProvider | Receiver | 桌面小组件 |
| PushMessageHandler | Service (小米推送) | SDK 组件 |
| ProfileInstallReceiver | Receiver | AndroidX Profiler |
| AssetPackExtractionService | Service | Google Play 组件 |

### 自定义 URL Scheme
- `wxbc358fac39c99598://` — 微信 SDK 回调
- `signinwithapple://callback` — Apple 登录回调
- `cn.oboard.todo.protocolWeb` — **内部协议，可被第三方调用唤起 WebView**

---

## 4. 网络通信端点

### 自有域名

| URL | 协议 | 用途 |
|-----|------|------|
| `http://todocdn.i99yun.com/doc/private_license.html` | **HTTP** | 隐私协议 |
| `http://todocdn.i99yun.com/doc/service_license.html` | **HTTP** | 服务协议 |

### 第三方 SDK 域名

| 域名 | 所属 | 用途 |
|------|------|------|
| `resolver.msg.xiaomi.net` | 小米 | 推送 DNS 解析 |
| `cn.register.xmpush.xiaomi.com` | 小米 | 推送注册 |
| `*.umeng.com` (8+ 子域) | 友盟 | 统计/推送/反作弊/日志 |
| `ulogs.umengcloud.com` | 友盟 | 日志 |
| `verify.cmpassport.com` | 中国移动 | 号码认证 |
| `wap.cmpassport.com` | 中国移动 | 协议页面 |
| `card.e.189.cn` | 中国电信 | 号码认证 |
| `id6.me` | 阿里云 | 号码认证 |
| `dypnsapi-dualstack.aliyuncs.com` | 阿里云 | 号码认证 API |
| `nisportal.10010.com:9001` | 中国联通 | 号码认证 |
| `enrichgw.10010.com` | 中国联通 | 号码认证（HTTP 白名单） |
| `onekey.cmpassport.com` | 中国移动 | 一键登录（HTTP 白名单） |
| `open.weixin.qq.com` | 微信 | 登录/支付 |
| `api-e189.21cn.com` | 中国电信 | API |
| `crbt.i139.cn:8143` | 中国移动 | 认证（**HTTP**） |

---

## 5. 第三方 SDK 清单

| SDK | 版本 | 用途 |
|-----|------|------|
| Flutter | 3.x (libflutter.so) | 跨平台框架 |
| 友盟+ (UMeng) | 多个模块 | 统计分析、推送、反作弊、崩溃收集 |
| 小米推送 (MiPush) | 6.0.1-C | 小米设备推送通道 |
| 阿里云号码认证 | SDK | 一键登录（移动/联通/电信） |
| 微信 OpenSDK (fluwx) | — | 微信登录 + 微信支付 |
| Google ML Kit | — | 条形码/二维码扫描 |
| Google Play Billing | 7.1.1 | 内购支付 |
| FFmpeg (ffmpegkit) | — | 音视频处理 |
| Sign in with Apple | — | Apple 登录 |
| Flutter Local Notifications | — | 本地通知 |
| ECharts | — | 数据图表 (JS 内嵌) |
| Shared Preferences | — | 本地 KV 存储 |
| Flutter Share Plus | — | 分享功能 |
| Flutter Image Picker | — | 图片选择 |
| Flutter URL Launcher | — | 打开外部链接 |
| Permission Handler | — | 权限管理 |
| DataStore | — | Google 新式 KV 存储 |

---

## 6. 数据存储

| 存储方式 | 路径/名称 | 内容 |
|----------|-----------|------|
| SharedPreferences | `FlutterSharedPreferences` | 首次启动标记 |
| SharedPreferences | `TickingWidgetPrefs` | userId, mTimer |
| SQLite | `data.db` | 小组件数据 (待办/计时/热力图/自习室) |
| 外部存储 | `Pictures/Ticking/` | 专注计时截图 (仅 Android 9-) |
| MediaStore | `Pictures/Ticking` | 专注计时截图 (Android 10+) |

---

## 7. 安全发现

### 严重

**无。**

### 高危

**H1: 明文传输 (HTTP) — 隐私协议和服务条款**

```
http://todocdn.i99yun.com/doc/private_license.html
http://todocdn.i99yun.com/doc/service_license.html
```
用户在 WebView 中阅读隐私政策和服务协议时走 HTTP，可被中间人篡改。
- `android:usesCleartextTraffic="true"` 全局开启
- `network_security_config.xml` 中 `<base-config cleartextTrafficPermitted="true"/>`

**H2: WebView JavaScript 开启 + 外部可控 URL**

`WebViewActivity` (exported=true) 接受自定义协议 `cn.oboard.todo.protocolWeb`，设置了 `setJavaScriptEnabled(true)` 和 `setDomStorageEnabled(true)`。任何第三方应用可发送 intent 让该 WebView 加载任意 URL 并执行 JS。虽然未发现 `addJavascriptInterface`（无 Native-JS 桥），但 JS 开启 + 外部可控 URL 仍存在钓鱼和数据泄露风险。

**H3: 小米推送 AppKey 硬编码**

`PlatformPlugin.java:37-38`:
```java
private final String MIPUSH_APP_ID = "2882303761520261803";
private final String MIPUSH_APP_KEY = "5202026130803";
```
攻击者可通过反编译 APK 获取密钥，伪造推送消息投递给所有用户。

### 中危

**M1: 无代码混淆**

DEX 中的 Java/Kotlin 代码未经 R8/ProGuard 混淆（类名 `TodoApplication`, `PlatformPlugin`, `WebViewActivity` 等完全可读）。核心业务逻辑在 `libapp.so` (Flutter 编译产物) 中，但 Android 原生层的实现完全暴露。

**M2: 无加固保护**

未使用任何加固方案（360加固/腾讯乐固/梆梆等），反编译门槛低。

**M3: 15 个导出组件**

大量组件 exported=true，其中 `WebViewActivity` 和自定义协议接收器增加了攻击面。

**M4: 友盟 SDK 收集大量数据**

友盟 SDK 会收集设备信息、位置、应用列表（可选），并将数据发送到多个端点。SDK `umeng-spy.so` (423KB) 为反作弊模块，具备一定检测能力。

### 低危

**L1: SharedPreferences 存储敏感数据**

`TickingWidgetPrefs` 以明文存储 `userId`，虽然 userId 本身不是敏感凭据，但偏好存储没有加密。

**L2: 小组件 SQLite 数据库无加密**

`data.db` 明文存储待办事项等用户数据。

---

## 8. 业务逻辑摘要

### 核心模块（从组件和资源推断）

1. **待办管理** — TodoWidgetProvider/Service + data.db
2. **番茄计时** — TomatoWidgetProvider + libapp.so (Flutter)
3. **专注模式** — FocusWidgetProvider, 生成截图分享
4. **自习室** — StudyWidgetProvider + school.json (3.9MB, 包含学校数据)
5. **热力图** — HeatmapWidgetProvider, 时间分布可视化 (ECharts)
6. **账号体系** — 手机号一键登录（阿里云号码认证）+ 微信登录 + Apple 登录 + 微博/淘宝/支付宝（资源中有对应图标）

### 应用入口
`AgreementActivity` (LAUNCHER) → 首次启动弹窗同意隐私协议 → `MainActivity` (Flutter)

### Flutter 通信桥
`MethodChannel("ticking")` — 11 个方法:
initMiPush, getMiPushRegId, showWindow, hideWindow, syncTimer, syncAlbum, share, isAlbumAuthorized, refreshWidget, refreshStudyWidget, switchToBackground, openAppSettings

---

## 9. 总结

Ticking 是一款功能完整的 Flutter 效率工具，集成了完善的国内第三方生态（友盟统计/小米推送/三大运营商一键登录/微信登录支付）。安全方面的主要问题是 **HTTP 明文传输** 和 **WebView 配置过于宽松**，以及 **推送密钥硬编码**。核心业务逻辑在 Flutter 层（libapp.so），Android 原生层主要做平台桥接。

**建议优先修复**:
1. 隐私政策/服务协议 URL 改为 HTTPS
2. 限制 `WebViewActivity` 的 URL 白名单
3. MiPush 密钥移到服务端或加密存储
