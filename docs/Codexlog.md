# Codex 工作日志

## 2026-06-18

### 本次接续情况

- 用户要求继续上次对话，但当前线程没有完整历史记录。
- 我检查了当前工作区状态，确认分支为 `main...origin/main [ahead 19]`。
- 工作区存在 10 个未提交改动文件，集中在数据库、任务仓库、热力图、统计页、计时页、权限服务和权限门组件。

### 已确认的改动方向

- 修复 Dart/Flutter 静态检查相关问题。
- 移除未使用的 import。
- 将 `Color.value` 用法替换为 `toARGB32()`。
- 调整 `AppDatabase.forTesting` 构造器写法。
- 在权限请求流程中补充 `context.mounted` 检查。
- 对多个 Flutter 页面文件执行并确认格式化结果。

### 验证结果

- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，8 个测试全部通过。
- 已运行 `dart format` 覆盖 10 个改动文件，结果为 `0 changed`。

### 当前状态

- 改动尚未提交。
- 当前本地分支仍领先远端 19 个提交。
- Git 提示部分文件下次被 Git 触碰时可能从 LF 转为 CRLF，这是 Windows 换行处理提示，不影响本次分析和测试结果。

### 全项目巡检

#### 已执行验证

- 重新扫描项目结构、依赖配置、Git 状态和最近提交。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，8 个测试全部通过。
- 已运行 `flutter pub outdated`，确认多个依赖已有可解析的大版本升级。
- 已运行 `flutter build apk --debug`，Android Debug APK 构建成功。
- 已运行 `flutter build web`，构建失败：当前数据库入口直接依赖 `drift/native.dart` / `sqlite3` FFI，Web 平台没有 `dart:ffi`。
- 已运行 `flutter build windows`，构建未完成：当前机器缺少合适的 Visual Studio toolchain，需先跑 `flutter doctor` 修复本机 Windows 构建环境。

#### 主要发现

- 计时停止逻辑存在风险：`TimerNotifier.stopTimer()` 没有检查是否真的已开始计时，理论上可能保存 `startTime=0` 的异常记录。
- 暂停后直接停止计时会把当前暂停中的时间计入 `focusDurationMs`，导致保存的专注时长偏大。
- 今日统计和月热力图统计口径不一致：今日总时长统计没有排除休息类型，月热力图排除了短休息和长休息。
- 分组统计页传入了 `groupId`，但实际仍读取全局 `heatmapDataProvider(currentMonth)`，因此显示的是全局计时热力图，不是分组统计。
- `TaskRepositoryImpl.permanentDeleteList()` 只删除分组，不处理该分组下的任务，未来接入回收站永久删除时会产生孤儿任务。
- README 宣称支持 Web，但当前 Web 构建失败；若要支持 Web，需要改造 Drift Web 连接或拆分平台数据库入口。
- Android `targetSdk=35` 且 ForegroundService 使用 `foregroundServiceType="specialUse"`，正式发布前需要确认 Android 14/15 前台服务策略和商店审核说明。
- Release 构建仍使用 debug signing config，正式发布前必须配置 release keystore。
- 多个 UI 入口目前是占位或未接逻辑，包括导出数据、回收站、深色模式开关、全部完成、隐藏已完成待办。
- 测试覆盖偏薄，目前主要覆盖数据库基础 CRUD 和 App 冒烟测试，缺少计时状态机、Provider、统计口径、权限/通知失败路径和平台边界测试。
- 多个文档与代码实现不同步：README、APK_BUILD 和 IMPLEMENTATION_PLAN 中的完成状态、后台计时、Web 支持等描述需要重新校准。

#### 建议优先级

1. 先修计时状态机保存逻辑，避免产生错误时长和异常记录。
2. 明确当前发布平台：若短期主打 Android，应更新 README/Web 文档；若要真跨平台，先改数据库平台入口。
3. 统一统计口径，并决定休息/视频打卡是否计入今日专注、热力图和分组统计。
4. 补齐或隐藏占位 UI 入口，避免用户点进没有反馈的功能。
5. 发布前处理 Android 前台服务类型、release 签名和权限策略。

### Android APK 优先修复

#### 已完成

- 将当前策略收窄为 Android APK 优先，Web / Windows 暂作为后续平台适配目标。
- 修复 `TimerNotifier.stopTimer()`：未开始计时时停止不再保存异常记录。
- 修复暂停期间停止计时的时长计算：当前暂停段不再计入专注时长。
- 计时名称保存前会 trim，空名称自动使用 `专注`。
- `TimerNotifier._loadTodayData()` 增加 `mounted` 检查，避免异步加载完成后写入已释放状态。
- 今日专注统计改为排除短休息和长休息，和月热力图口径保持一致。
- 分组永久删除改为事务内同时删除该分组下的任务，避免孤儿任务。
- 暂时移除误导性的分组统计语义：分组菜单中的统计入口改为 `全局热力图`，`StatsScreen` 不再接收未使用的 `groupId`。
- 新增 `test/timer_provider_test.dart`，覆盖未开始停止不保存、暂停后停止不计入暂停时长。
- 更新 `README.md` 为 Android-first 描述。
- 重写 `docs/APK_BUILD.md`，记录当前 APK 构建命令、验证结果、已知限制和手动测试清单。

#### 验证结果

- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，10 个测试全部通过。
- 已运行 `flutter build apk --debug`，构建成功，产物位于 `build/app/outputs/flutter-apk/app-debug.apk`。

### 本地效率工具目标

- 用户提供 `C:\Users\Andyxu\Desktop\reference_notes.txt`，描述希望复刻的 reference app 功能和操作路径。
- 已阅读该文件，内容覆盖分组、菜单、颜色、统计、回收站、计划模式、图表管理、登录、我的页、设置页、发现/计时页等模块。
- 判断当前 APK 应先做本地版 local-first 复刻：优先还原待办分组、回收站、计时发现页、基础统计和设置；登录、会员、云同步、喵喵机打印等服务器/商业能力暂不复刻。
- 新增路线文档，按 APK P0/P1/P2 拆分本地产品路线。
- 用户明确当前不需要发现页，先跑本地核心功能；已将路线调整为本地待办、计时、回收站和数据记录优先。

### 参考 APK

- 用户提供 `D:\Projects\Focus Timer\releases\reference\1.18.13.apk` 作为学习对象。
- 已确认参考 APK 大小为 104,618,943 bytes，约 99.8 MB。
- 参考 APK 也是 Flutter 应用，包内包含 `libflutter.so`、`libapp.so`、FFmpeg 相关 so、登录资源、背景图、`echarts.min.js`、`school.json` 等。
- 当前项目 Debug APK 大小约 180.8 MB，偏大属于 Debug 构建正常现象。
- 已运行 `flutter build apk --release`，生成 `build/app/outputs/flutter-apk/app-release.apk`，大小 57,444,200 bytes，约 54.8 MB。
- Release 包当前仍使用 debug signing config，仅适合本地测试，正式发布前需配置 release keystore。

### Android 12 虚拟机测试与本地 UI 调整

- 已通过 `adb devices` 连接到本机 Android 虚拟机：`127.0.0.1:16384` 和 `emulator-5554` 均在线。
- 已确认 `emulator-5554` 为 Android 12。
- 已构建并安装 Debug APK 到 `emulator-5554`，安装成功并启动到 `com.focustimer.focus_timer/.MainActivity`。
- 移除外部存储权限请求：当前应用数据位于应用私有目录，Android 12 上不再请求 `READ_EXTERNAL_STORAGE` / `WRITE_EXTERNAL_STORAGE`。
- `android/app/src/main/AndroidManifest.xml` 已删除外部存储权限声明。
- 计时页移除顶部 `专注计时` 标题和右上角主题色入口，主题色统一保留在 `我的` 页面。
- 计时类型收纳到计时页左上角菜单，可选择番茄钟、自由计时、倒计时、短休息、长休息、视频打卡、起床睡觉。
- 待办页顶部改为左对齐标题，并增加日倒计时和回收站快捷入口。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，12 个测试全部通过。

### 2026-06-19 Claude Memory 对照

- 已阅读用户提供的 Claude memory 文件：
  - `D:\Claude\config\projects\D--Projects-Focus-Timer\memory\MEMORY.md`
  - `D:\Claude\config\projects\D--Projects-Focus-Timer\memory\project_overview.md`
  - `D:\Claude\config\projects\D--Projects-Focus-Timer\memory\w3_plan.md`
- 关键信息：项目定位为 本地优先效率工具，MIT 开源，无云端、无登录、无会员；技术栈为 Flutter + Riverpod/hooks + Drift SQLite；底部导航目标为 3 Tab：待办、计时、我。
- Claude memory 记录 W3/W4 已完成通知、后台计时、待办、权限、热力图、视频打卡、日倒计时；V5 Phase 1-3 已完成数据库 v2、3Tab、分组系统。
- Claude memory 中剩余目标为 V5 Phase 4-6：计时页卡片重设计、回收站页面、我的页面完善。
- 已阅读更详细的计划文件 `D:\Claude\config\plans\prancy-crafting-pebble.md`。该计划说明核心方向从“计时器为主”切换为“待办分组为主，计时为辅助”，并把统计从底部 Tab 移到分组菜单和我的页入口。
- 该计划对后续实现的直接参考：
  1. 待办页继续保持分组列表 + 分组详情结构。
  2. 计时页后续应从当前工具式页面转向 卡片式卡片入口和底部 Sheet 启动流程。
  3. 我的页应补齐计时设置、颜色、卡片透明度、倒数日、统计、回收站、导出和关于。
  4. 回收站页面已经是 V5 Phase 6 的计划目标，目前代码已新增基础页面，可继续打磨。

### 2026-06-19 Codex Plan

- 已新增 `docs/Codexplan.md`，作为 Codex 后续执行计划。
- 计划内容对齐 Claude memory、Claude 详细计划、Codex 观察记录和当前 Git 状态。
- 近期顺序确定为：先 Git 分组提交，再验证回收站和待办分组闭环，然后改造计时页为卡片入口和底部 Sheet 启动流程，之后完善我的页和统计骨架。
- 计划明确不继续大范围扫描 reference app，不做发现/登录/会员/云同步，也不提交参考 APK、反编译树、截图或 UIAutomator XML。

- 已运行 `flutter build apk --debug`，构建成功并安装到虚拟机。
- 调试发现 Debug APK 在 Android 12 平板虚拟机清数据后冷启动约 17.6 秒；Release APK 冷启动约 961 ms，因此启动慢主要是 Debug 构建/虚拟机调试开销，不是业务卡死。
- 已重新构建并安装 `app-release.apk` 到虚拟机用于体验测试，启动正常。

### 当前 Release APK 手动测试

- 用户要求先测试完再修改；本轮只测试已安装的 `build/app/outputs/flutter-apk/app-release.apk`，未继续修改业务代码。
- 连接到竖屏 Android 12 虚拟机 `emulator-5556`，分辨率 `900x1600`，density `320`。
- 通过 `aapt dump badging` 和 `dumpsys package` 确认当前 APK 只有 `com.focustimer.focus_timer/.MainActivity` 一个 Android Activity；Flutter 内部页面不对应独立原生 Activity。
- 确认当前 APK 权限中没有 `READ_EXTERNAL_STORAGE`、`WRITE_EXTERNAL_STORAGE` 或 `MANAGE_EXTERNAL_STORAGE`；保留通知、振动、前台服务和唤醒锁相关权限。
- 竖屏清数据首启正常，未出现储存权限或通知权限弹窗；日志显示 `Displayed/Fully drawn` 约 1.57 秒。
- 待办竖屏主流程通过：创建分组 `phone_group`、进入分组、创建任务 `phone_task` 均成功。
- 平板横屏主流程通过：创建分组、添加任务、勾选完成、显示已完成、移入回收站、从回收站恢复均成功。
- 计时页竖屏布局可用：类型菜单在左上角，`专注计时` 标题已移除，主题色入口只保留在 `我的` 页面。
- 自由计时可以启动、暂停、停止；停止后今日专注和今日次数有更新。
- 番茄钟可以启动，启动后显示已用时间和剩余时间，例如 `00:00:03` / `剩余 00:24:56`。
- `我的` 页面打开正常，只看到一个主题色入口；回收站入口可进入，空回收站状态正常。
- 导出数据按钮点击后未触发储存权限，也未观察到明显导出成功或系统保存/分享反馈。

#### 本轮测试发现

- 计时启动时 Android 原生 MethodChannel 报错：`java.lang.ClassCastException: java.lang.Integer cannot be cast to java.lang.Long`，出现在 `MethodChannel#com.focustimer/timer`；UI 未崩溃，但前台服务/通知链路可能没有正常工作。
- 番茄钟未启动前主时间显示 `00:00:00`，启动后主时间向上计数，同时下方显示剩余时间；如果目标是更像倒计时，静止态和主数字应改为显示剩余时间。
- 分组卡片副标题仍显示 `点击空白处添加`，但实际点击卡片正文会进入分组，容易误导。
- 分组卡片三点菜单在横屏平板可滚动触达 `移至回收站`，但菜单过高且贴近底部，体验不顺。
- 导出数据入口目前没有明显反馈，后续需要补齐导出流程或临时隐藏。

### 参考 参考交互与主题调整

- 用户说明喜欢 参考应用的很多交互，希望以停更应用为学习对象做开源本地版本；确认学习重点是交互组织、信息密度和使用节奏，不复制参考 APK 代码或素材。
- 已安装参考 APK `releases/reference/1.18.13.apk` 到竖屏 Android 12 虚拟机，包名 `reference.app`，版本 `1.18.13`。
- 已观察 reference app 首次协议页、清单页和底部中间 `+` 入口；`+` 展开后包含自由计时、番茄计时、视频打卡、起床睡觉、休息快捷项，后续可作为本项目主动作入口参考。
- 将默认主题色从绿色/青绿改为雾蓝 `0xFF4F6FA8`，主题预设保留多色选择但默认避开绿色。
- 将新建分组默认颜色从 `0xFF4CAF50` 改为 `0xFF4F6FA8`，避免首页新建卡片仍呈现绿色。
- 移除计时页常驻的 `专注` 名称输入框，计时记录改为使用当前计时类型名作为默认名称，例如 `自由计时`、`番茄钟`。
- 修复 Android `MethodChannel#com.focustimer/timer` 数字类型兼容：Kotlin 侧将 `startTimeMs` / `targetDurationMs` 按 `Number` 读取后转 `Long`，避免 `Integer cannot be cast to Long`。

#### 验证结果

- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，12 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物大小约 `55.5MB`。
- 已安装新 Release APK 到 `emulator-5556` 并清数据首启，启动约 `1.45s`。
- 竖屏首屏默认强调色已变为蓝色系；计时页不再显示占位的 `专注` 输入框。
- 启动自由计时后日志未再出现 `MethodChannel#com.focustimer/timer` 或 `ClassCastException`。

### 参考应用自由计时补充验证

- 用户在模拟器中打开并启动了 参考应用自由计时，名称为 `CodexRun`。
- 已确认暂停态底部按钮为继续播放和停止结束两枚大圆按钮。
- 已点击停止结束按钮，reference app 未弹二次确认，直接返回全局 `+` 面板，并展示 `上次计时 8分钟36秒` 的最近记录。
- 已将具体交互细节追加到 `docs/Codex观察记录.md`，本日志仅记录本轮验证进度。

### 2026-06-19 文档整理与本地遍历

- 用户提醒 参考页面和静态解析路线“太烧 token”，已停止继续大范围观察和解析，改为只整理已有结果。
- 本轮只追加文档，没有修改业务代码。
- 已将 reference app 统计页、图表管理、番茄计时、休息计时、运行页工具和编辑计时等补充观察写入 `docs/Codex观察记录.md`。
- 已完成项目本地遍历摘要：项目根目录包含 Flutter 主工程、Android/Web/Windows 平台目录、`analysis` 反编译资料、`releases` 参考 APK、`docs` 文档、`tmp_reference_scan` 截图/XML 观察资料和 `tmp_reference_apk` 开源许可临时资料。
- 本地目录规模确认：`lib` 约 28 个 Dart 文件，`test` 4 个测试文件，`docs` 14 个 Markdown 文档，`analysis` 约 27184 个文件，`tmp_reference_scan` 约 414 个截图/XML/文本文件，`tmp_reference_apk` 3 个文件。
- `analysis` 下已有 `apktool_out` 和 `jadx_out`；`apktool_out/assets/flutter_assets` 包含 `AssetManifest.json`、`NOTICES.Z`、图片、声音、字体和 Flutter 资源目录；`jadx_out` 下有 `resources` 和 `sources`。
- `releases` 下有 `reference` 目录和说明文档，参考 APK 仍位于 `releases/reference/1.18.13.apk`。
- `.claude` 目录只发现 `settings.local.json`，没有额外 Claude 工作树；`docs/CLAUDE.md` 记录了此前项目阶段、结构和踩坑信息，可作为后续实现参考。
- Git 状态仍是脏工作区：包含 README、Android Manifest/Kotlin、多个 Dart 源文件、测试、文档和 reference app 临时资料的修改或新增；后续改代码时需要继续避免覆盖已有改动。

### 2026-06-19 Git 整理

- 已整理 `.gitignore`，新增忽略本地效率工具 截图/XML、`tmp_reference*` 临时目录、测试截图和 `group_menu.png`，保留本地文件但不纳入 Git。
- 整理后 `git status` 不再显示约 78MB 的 reference app 临时观察产物，剩余改动集中在源码、测试和文档。
- 已清理参考许可摘录草稿，后续不作为公开仓库文档维护。
- 当前适合后续分组提交的范围：
  1. `.gitignore` 临时产物忽略规则。
  2. Android 权限、MethodChannel 和计时状态机修复。
  3. 待办分组、回收站、全局菜单和相关测试。
  4. 参考交互文档、APK 文档和工作日志。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，12 个测试全部通过。

### 2026-06-19 Git 分组提交

- 已从本地 `main` 创建 Codex 工作分支，未推送远端。
- 已把未提交改动整理为 4 个本地提交：
  1. `accd370 chore: ignore local observation artifacts`
  2. `e757f04 fix: stabilize Android timer and permissions`
  3. `d4f87ce feat: add local todo recycle bin flows`
  4. `a49f548 docs: record local reference app roadmap and observations`
- 当前分支相对 GitHub `origin/main` 领先 23 个提交，其中前 19 个是本地已有 Claude/前序开发进度，后 4 个是本轮 Codex 整理提交。
- 分组提交后工作区曾确认干净。
- 分组提交后已运行 `flutter analyze`，结果为 `No issues found`。
- 分组提交后已运行 `flutter test`，12 个测试全部通过。
- 当前策略仍是不直接推送或覆盖远端 `main`；下一步建议推送当前 Codex 工作分支并开 PR 供用户审阅。

### 2026-06-19 计时页入口改造

- 按“先做 APK 本地版”的方向，开始实现计时页 UI 更新，范围控制在 `TimerScreen` 和计时统计口径。
- 计时页停止态已从单一计时器工具页改为入口页：
  - 顶部保留左上角计时类型菜单，去掉额外大标题。
  - 增加今日概览：今日专注、今日次数、最近记录。
  - 增加开始计时卡片：自由计时、番茄计时、倒计时、视频打卡、起床睡觉。
  - 增加快速休息入口：5 分钟、10 分钟、20 分钟。
- 计时启动流程改为底部弹层：
  - 自由计时：确认名称后开始。
  - 番茄计时：名称 + 时长后开始。
  - 倒计时：名称 + 时长后开始，支持预设和自定义分钟数。
  - 起床睡觉：底部弹层选择起床或睡觉。
- 运行态改为专门的运行页面：
  - 番茄、倒计时、休息等有目标时长的模式，主数字显示剩余时间。
  - 自由计时仍显示已专注时间。
  - 暂停中的番茄计时点击结束会询问保存或放弃。
- 调整统计口径：休息和起床睡觉记录不计入今日专注与热力图统计。
- 已在竖屏模拟器安装 debug APK 并打开计时页，确认新页面可见；发现底部导航遮挡最后一张卡片后已增加底部留白。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，12 个测试全部通过。
- 已运行 `flutter build apk --debug`，构建成功，产物为 `build\app\outputs\flutter-apk\app-debug.apk`。

### 2026-06-19 计时输入法红屏修复

- 用户反馈：计时页需要输入名称的位置拉起输入法后，点外部收起输入法会触发 Flutter debug 红屏，错误为 `_dependents.isEmpty` 断言失败。
- 问题集中在计时启动底部弹层的输入框焦点/弹层生命周期。
- 已将计时启动输入弹层改为独立 `_TimerSetupSheet`，由组件自身持有并释放 `TextEditingController`。
- 底部弹层现在禁止点暗背景/拖动直接关闭；点输入框外部只收起键盘，不销毁弹层。
- 自定义分钟输入也改为独立 `_MinuteInputDialog`，同样由组件管理输入控制器。
- 已重新验证自由计时：打开输入框、拉起键盘、点外部收键盘，不再红屏；随后点击开始可以进入运行态。
- 已重新验证倒计时启动路径未再出现红屏。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，12 个测试全部通过。
- 已重新运行 `flutter build apk --debug`，新的 APK 仍位于 `build\app\outputs\flutter-apk\app-debug.apk`。

### 2026-06-19 我的页入口与输入体验修正

- 用户反馈：上轮为了避免红屏，将计时输入弹层改得过于保守，导致只能点返回键退出输入框，体验很差。
- 已调整计时启动输入弹层：
  - 点输入框外或弹层内部空白区域会收起输入法。
  - 点暗背景或下滑仍可退出弹层。
  - 保留独立组件管理输入控制器，避免再次触发 `_dependents.isEmpty` 红屏。
- 用户反馈 `我的` 页面中深色模式、导出数据、关于均无效。
- 已将深色模式改为显示模式三态选择：
  - 跟随系统
  - 浅色
  - 深色
- 已接入全局 `themeModeProvider`，`MaterialApp.themeMode` 不再写死为 `ThemeMode.system`。
- 已实现导出数据：
  - 导出待办分组、待办、计时记录为 JSON。
  - 文件写入应用文档目录，不请求存储权限。
  - 导出完成后展示完整路径。
- 已实现关于弹窗，显示应用名、版本和当前本地优先开发说明。
- 用户反馈 iQOO Android 15 通知授权只显示解释框，不拉起系统授权；小米澎湃 OS 3 Android 16 可正常弹。
- 已增加通知权限兜底：
  - 请求通知权限后如果未授权，自动打开应用系统设置页。
  - `我的 -> 通知权限` 增加手动设置入口。
- 手动验证：
  - 计时输入弹层拉起键盘后，点空白可收起键盘且不红屏。
  - 显示模式可从跟随系统切换到浅色。
  - 导出数据成功生成 JSON 文件。
  - 关于弹窗可正常打开。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，12 个测试全部通过。
- 已运行 `flutter build apk --debug`，新的 APK 仍位于 `build\app\outputs\flutter-apk\app-debug.apk`。

### 2026-06-19 计时弹层流畅度处理

- 用户反馈：暂时测不出新 bug，但 debug 包明显卡顿掉帧，尤其是计时名称输入框拉起键盘时。
- 判断：
  - debug 包本身会有明显额外开销，不适合作为最终流畅度判断。
  - 计时弹层打开时自动拉起输入法，会让底部弹层动画和键盘动画叠在一起，确实容易卡顿。
- 已优化计时启动弹层：
  - 移除计时名称输入框的 `autofocus`，打开弹层时不再自动拉起输入法。
  - 自定义分钟输入框也不再自动抢焦点。
  - 键盘高度变化改为短 `AnimatedPadding` 过渡，降低突然重排。
  - 保留点空白收起输入法和点暗背景退出弹层的交互。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，12 个测试全部通过。
- 已构建 debug APK：`build\app\outputs\flutter-apk\app-debug.apk`。
- 已构建 release APK：`build\app\outputs\flutter-apk\app-release.apk`，大小约 `56.0MB`。
- 已在模拟器安装 release 包，确认计时弹层打开时不会自动弹出键盘。

### 2026-06-19 计时页今日概览精简

- 用户指出计时菜单/今日概览右侧继续显示“倒计时”一类信息在当前计时界面里显得多余。
- 判断：今日概览只应回答“今天已经做了多少”，当前计时类型交给左上角类型菜单和下方启动卡片承载，避免重复和误导。
- 已移除今日概览里的“最近”统计项。
- 今日概览现在只显示两个稳定指标：`今日专注` 和 `今日次数`。
- 已运行 `dart format lib\presentation\screens\timer_screen.dart`，格式化通过。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，12 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `56.0MB`。

### 2026-06-19 底部导航改为 4 Tab

- 和用户讨论后确认：热力图、饼图、趋势图、时间轴不适合藏在计时页菜单里，也不适合挤占计时启动主页面。
- 当前信息架构调整为 4 Tab：`待办 / 计时 / 统计 / 我的`。
- 新增底部一级 `统计` Tab，复用现有 `StatsScreen`，先承载当前热力图统计能力。
- 默认首屏保持为 `待办`，计时作为第二个 Tab，统计作为独立一级入口。
- 计时页左上角重复的计时类型展开菜单已移除，改为普通标题 `计时`。
- 计时页右上角统计按钮已移除，避免和新的 `统计` Tab 重复。
- 计时类型启动仍保留在计时页主面板卡片中；后续可继续改成更方便的固定操作条。
- 已运行 `dart format lib\presentation\screens\home_screen.dart lib\presentation\screens\timer_screen.dart`，格式化通过。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，12 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `56.0MB`。

### 2026-06-19 统计页 2026/6 热力图显示修复

- 用户反馈：模拟器统计 Tab 中 `2026年6月` 页面呈现一大片灰白区域；用户的 A16 真机和其他月份没有同样问题。
- 已通过 ADB 截图确认：页面没有崩溃，问题集中在旧 `HeatMap` 组件将可用区域整体铺成灰色，月份内容几乎不可见。
- 判断：这是第三方热力图组件在特定月份/设备/布局组合下的显示兼容问题，不适合作为新的一级统计 Tab 核心视图。
- 已将 `StatsScreen` 改为自绘月历热力图：
  - 顶部显示月份切换。
  - 增加本月专注、专注天数、日均专注概览。
  - 用 7 列月历格子直接渲染当月每天，空数据也能看到完整月份骨架。
  - 增加趋势图、饼图、时间轴的统计入口结构。
- 已运行 `dart format lib\presentation\screens\stats_screen.dart`，格式化通过。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，12 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `56.0MB`。
- 按用户要求将前两个 Tab 调整为 `待办 / 计时` 顺序，并重新完成 analyze、test 和 release APK 构建。

### 2026-06-19 待办计划模式启动实现

- 用户提供 reference app 计划模式视频的 AI 描述，并要求实现同类能力。
- 已重新阅读 `docs/Codex观察记录.md`，确认此前观察也记录了：计划视图是双栏模式，左侧待办列表，右侧按时间轴排列日程，并有退出计划模式。
- 本轮先在分组详情页实现本地版计划模式：
  - 右上角按钮进入/退出计划模式。
  - 左侧为当前分组的待办池。
  - 右侧为 `04:00` 到 `23:00` 的时间轴。
  - 长按左侧待办可拖拽到右侧小时格。
  - 同一个待办可以重复安排到多个时段。
  - 长按右侧已安排任务可拖回左侧待办池移除。
  - 顶部提供 `一键清空` 和 `退出`。
- 已新增持久化表 `TaskPlans`，记录 `listId`、`taskId`、`dayNum`、`startHour`、`durationMinutes`、排序和时间戳。
- 数据库 schemaVersion 从 `2` 升到 `3`，升级时创建 `taskPlans` 表。
- 已扩展 `TaskRepository` / `TaskRepositoryImpl`，支持创建、查询、删除和清空计划；永久删除分组时同步删除该分组计划。
- 已新增 `TaskPlanNotifier` 和 `taskPlanProvider` 管理当天分组计划。
- 已运行 `dart run build_runner build --delete-conflicting-outputs`，Drift 代码生成成功。
- 已新增测试覆盖计划创建/查询/删除/清空，以及永久删除分组时删除计划。
- 已运行 `flutter test`，14 个测试全部通过。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `56.2MB`。
- 已将 `AppConstants.databaseVersion` 同步为 `3`，与 Drift `schemaVersion` 保持一致，并重新完成 analyze、test、release APK 构建和模拟器安装。
- 用户反馈待办首页右上角没有计划模式入口；确认此前入口只放在分组详情页，不符合 reference app 观察记录里的首页右上角入口。
- 已抽出独立 `TaskPlanScreen`，并在待办首页右上角新增 `计划模式` 按钮。
- 首页计划入口当前进入第一个分组的计划页；没有分组时提示先创建分组。
- 分组详情页仍保留计划模式入口，复用同一个 `TaskPlanScreen`。
- 已重新运行 `flutter analyze` 和 `flutter test`，结果通过。

### 2026-06-19 待办计划模式 24 小时与输入框修复

- 用户反馈：当前计划模式虽然存在，但更像普通拖拽排序，没有明确时段、日期和自由落点；同时待办详情页输入框在键盘弹起时被顶得过高。
- 已将计划模式从固定 `04:00-23:00` 改为默认完整 24 小时：`00:00-24:00`。
- 已新增 `时段设置`：
  - 可设置开始时间。
  - 可设置结束时间。
  - 可设置分段为 `15 分钟 / 30 分钟 / 1 小时 / 2 小时`。
  - 设置持久化到本地数据库。
- 已将计划落点升级为分钟级：
  - 新增 `TaskPlans.startMinute`，旧计划仍可用 `startHour * 60` 回退显示。
  - 数据库 schemaVersion 从 `3` 升为 `4`。
  - `AppConstants.databaseVersion` 同步为 `4`。
- 已新增 `TaskPlanSettings` 表保存计划视图配置。
- 已调整计划入口：
  - 待办首页右上角进入全局 `全部待办` 计划页。
  - 分组详情页右上角进入当前分组计划页。
- 已完善计划操作：
  - 左侧待办拖到右侧任意分段槽位会创建计划。
  - 同一待办可重复安排。
  - 右侧已安排任务可拖到其他分段槽位移动。
  - 右侧已安排任务可拖回左侧删除。
  - 全局计划按当天全部活跃分组读取，回收站分组不会进入全局计划。
- 已修复待办详情输入框键盘布局：
  - 取消 `Scaffold` 自动避让和手动 `viewInsets` 双重计算。
  - 输入栏改为贴键盘上沿。
  - 列表底部保留空间，避免被输入栏遮挡。
  - 点空白处和拖动列表可收起键盘。
- 已运行 `dart run build_runner build --delete-conflicting-outputs`，Drift 代码生成成功。
- `dart format` 本轮出现进程超时/卡住现象，暂未作为验证依据；后续可在 Dart 工具链恢复正常后补跑。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，16 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `56.5MB`。

### 2026-06-19 计划模式拖拽条长度修正

- 用户反馈：计划模式拖动中的长条太长，视觉上明显不对。
- 已调整 `TaskPlanScreen`：
  - 拖动浮层不再使用固定 `240dp` 宽度。
  - 拖动浮层根据手指横向位置动态变化：左侧较短，向右拖动逐渐变长，往左拖回逐渐变短。
  - 宽度变化使用 `AnimatedContainer` 平滑过渡，避免突然跳变。
  - 右侧已安排任务条宽度同步收窄，避免落位后显得比时段槽更夸张。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，16 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `56.5MB`。

### 2026-06-19 待办计划模式拖拽视觉打磨

- 用户反馈计划模式已经能工作，但拖拽预览仍像小块，不像 reference app 里的长条；往左删除时整片红色区域过重；`X 退出` 与左上角返回重复。
- 已调整 `TaskPlanScreen`：
  - 左侧任务池仍需长按拎出才能拖动。
  - 左侧待办块改为按分组颜色渲染，带细色条和浅色背景。
  - 右侧已安排任务块改为长条卡片，并使用对应分组颜色。
  - 拖动中的浮层改为长条卡片，不再是小方块。
  - 往左拖回删除时，左侧只显示红色边线、红色文字和小型 `松手删除` 胶囊提示，不再铺满大红背景。
  - 移除顶部 `X 退出`，保留左上角系统返回作为唯一退出入口。
- 关于待办颜色：当前支持按分组自定义颜色，入口在分组卡片的更多菜单 `颜色`；本轮计划页已接入分组颜色。单条待办独立颜色还没有数据字段，后续如果需要可扩展 `Tasks` 表。
- 关于视频查看：当前做法是把视频拆成关键帧截图后观察交互状态；如果本机有可用的 ffmpeg/视频库，就抽帧查看，否则依赖用户提供的截图、AI 描述和模拟器复现。
- `dart format lib\presentation\screens\task_plan_screen.dart` 本轮再次超时，未作为验证依据。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，16 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `56.5MB`。

### 2026-06-19 计划条嵌入与拖拽锚点再修正

- 用户进一步反馈：右侧计划条应该像直接嵌进格子里，不要留出额外按钮感；按住拖动时，拖拽点也要更像从条头拎起，而不是整块方块被举起来。
- 已继续调整 `TaskPlanScreen`：
  - 右侧已安排任务条改为按当前槽位宽度铺满，去掉内部多余图标和尾部操作感。
  - 右侧计划条外层不再保留额外背景边距，视觉上更接近 参考应用的嵌槽效果。
  - 左右拖拽都改为 `childDragAnchorStrategy`，拖动反馈从条头开始，更接近“拎起”而不是“整块跟手”。
  - 拖动浮层继续保留动态长度，但不会再在右侧显示成额外的大按钮。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，16 个测试全部通过。

### 2026-06-19 参考实现边界整理

- 用户确认希望继续推进 reference app 代码/交互复用，并说明已有官方授权背景。
- 已再次核对本地资料：
  - reference/license extraction notes removed from public docs
  - `docs/analysis-report.md`
  - `analysis/jadx_out/sources/cn/reference/todo`
  - 当前 `pubspec.yaml` 与 Android 权限配置
- 结论：参考 APK 的核心 Flutter 业务逻辑主要在 `libapp.so` 中，不是可直接合并的 Dart 源码；可读 Java/Kotlin 层主要是 MethodChannel、平台服务和桌面小组件。
- 已整理参考实现边界草稿，将内容分为：
  - 可直接复用的开源依赖和许可注意事项。
  - 可复用行为但需要在本项目中重写的交互/数据/原生能力。
  - 不应复制的商业、云、登录、支付、资源、签名和绕过相关内容。
- 已更新 `docs/Codexplan.md`，把产品边界和开发约束写入后续计划。

### 2026-06-19 统计页第一轮重构

- 按用户确认的方向开始做统计页，而不是继续扩大 reference app 扫描。
- 已扩展 `TimerRepository`：
  - 新增 `getRecordsInRange(startDayNum, endDayNum)`，按日期范围读取 `focus_time` 记录。
  - 统计聚合继续排除休息和起床睡觉类记录。
- 已扩展统计 provider：
  - 新增 `日 / 周 / 月 / 年` 范围状态。
  - 新增当前统计锚点日期。
  - 新增 `StatsSnapshot`，从同一批记录派生每日专注分钟、总专注、记录数、日均和类型分布。
  - 新增图表可见性状态：热力图、饼图、时间轴。
- 已重构 `StatsScreen`：
  - 顶部支持 `日 / 周 / 月 / 年` 切换。
  - 支持上一段/下一段范围导航。
  - 摘要卡展示总专注、记录数、日均。
  - 自绘热力图，不再依赖旧 `heatmap_calendar_plus` 页面组件。
  - 新增本地 `CustomPainter` 饼图，按计时类型展示分布。
  - 新增时间轴，展示每条计时记录的日期、起止时间、类型和时长。
  - 新增 `补录` 底部弹层，可写入名称、类型、日期、时间和时长。
  - 新增 `图表管理` 底部弹层，可显示/隐藏热力图、饼图、时间轴。
- `dart format` 多次超时，未作为本轮验证依据。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，16 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `57.4MB`。

### 2026-06-19 多 Agent 前整理

- 用户询问是否需要开多个 agent；建议当前只开 1-2 个只读 agent，不并行改代码。
- 已整理当前交接：
  - 新增 `docs/AGENT_HANDOFF.md`，记录当前分支、APK、验证结果、已实现功能、手测重点、只读 agent 分工和注意事项。
  - 重写 `docs/CLAUDE_HANDOFF.md`，避免旧内容继续误导，例如“工作区已干净”和 3 Tab 信息。
- 已更新 `.gitignore`，补充忽略根目录临时截图/XML：
  - `focus_home*.xml`
  - `latest_plan_*.png`
  - `latest_plan_*.xml`

### 2026-06-19 新路线图整理

- 用户要求用中文做一份新的路线，梳理前面多个版本已经做过的内容。
- 已新增 `docs/NEW_ROADMAP_CN.md`：
  - 按 W1、W2、W3、W4、V5、Codex 当前改造梳理历史版本脉络。
  - 汇总计时、待办、计划模式、统计、我的页、文档边界等已完成能力和当前短板。
  - 重新规划 `R0-R6` 新路线：整理保护现场、统计页手测、计划模式收口、计时闭环、待办体验、我的页数据管理、发布前整理。
  - 明确暂时不做登录、会员、云同步、发现、支付、重 SDK 和直接搬参考 APK 代码。

### 2026-06-19 分支命名调整

- 用户提醒公开分支名不要包含参考应用名称，即使已有私下授权，也不应大张旗鼓展示授权来源。
- 已将当前本地分支改名为 `codex/android-Focus_Timer`。
- 后续推送应推送 `codex/android-Focus_Timer`，不要推送旧分支名。

### 2026-06-19 工作区决策回退

- 用户反馈双工作区/双对话上下文太麻烦，决定日常开发继续在 `D:\Projects\Focus Timer`。
- `D:\Projects\FT` 暂时只作为一次干净快照，不再日常维护。
- 已新增/更新 `docs/WORKSPACE_INDEX_CN.md` 记录该决定；后续需要公开仓库时再做一次干净导出。

### 2026-06-19 统计页记录管理

- 已为统计时间轴记录增加编辑/删除能力：点击时间轴记录可打开编辑弹层，修改名称、类型、日期、时间和时长，或确认删除。
- 已扩展 `TimerRepository`，新增 `updateRecord()`；删除后和编辑后会刷新统计快照和今日计时摘要。
- 已新增 `StatsSettings` 本地表，数据库 schema 升级到 v5，用于持久化统计图表显隐设置。
- `图表管理` 的热力图、饼图、时间轴开关现在会保存到本地数据库。
- 已运行 `dart run build_runner build --delete-conflicting-outputs`，Drift 代码生成成功。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，16 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `57.5MB`。

### 2026-06-19 待办体验收口

- 日常开发继续在 `D:\Projects\Focus Timer`，本轮推进待办主流程。
- 创建分组从弹窗改为底部抽屉，支持创建时直接选择分组颜色。
- 任务项新增动作面板：点击待办可标记完成/未完成、重命名或删除。
- 待办重命名已接入 `TaskNotifier.renameTask()` 和现有 `TaskRepository.updateTask()`。
- 左滑删除保留，但删除背景改为较轻的错误容器色，降低大片红色压迫感。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，16 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `57.6MB`。

### 2026-06-19 液态玻璃视觉目标记录

- 用户提出后续想要 iOS 26 风格的 Liquid Glass，并强调正式版不能卡。
- 已搜索 Apple Liquid Glass 设计资料和 Flutter `BackdropFilter` / 性能最佳实践资料。
- 结论：高斯模糊只是效果底层之一，真正的玻璃感还需要半透明材质、边缘高光、阴影、对比控制和轻微动态响应；不能把全屏 blur 当成方案。
- 已将该方向加入 `docs/Codexplan.md` 和 `docs/NEW_ROADMAP_CN.md`，定位为核心 APK 稳定后的 R7 视觉路线。
- 后续实现建议：封装统一 `GlassSurface`，只用于底部导航、底部抽屉、悬浮工具条、小菜单等小面积浮层；列表、热力图、时间轴主体不做大面积模糊。
- 性能验收以 release APK 为准，重点测试滚动、键盘弹起、计划模式拖拽和 Tab 切换。

### 2026-06-19 待办首页信息密度整理

- 继续推进 APK 本地核心体验，本轮只做低风险待办首页收口。
- 分组卡片副标题不再显示误导性的 `点击空白处添加`，改为显示 `暂无待办`、`全部完成 · 共 N 项` 或 `N 项未完成 · 共 M 项`。
- 分组名改为单行省略，避免长标题挤压右侧菜单。
- 分组操作面板移除 `排序`、`分享` 两个仍是占位的入口，避免用户点到“待完善”的假功能。
- `添加` 改名为 `添加待办`，`全局热力图` 改名为 `查看统计`，文案更贴近实际行为。
- 全局 `全部完成`、`回收空分组`、`回收所有分组` 后会刷新首页卡片里的待办数量。
- 已修复异步操作后继续使用 `BuildContext` 的 analyzer 提示。
- 已运行 `dart format lib\presentation\screens\group_list_screen.dart`。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，16 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `57.6MB`。

### 2026-06-19 回收站刷新与应用名修正

- 用户反馈：点击 `回收空的分组` 或 `回收所有分组` 后，分组从首页消失，但进入回收站找不到。
- 定位原因：从待办首页触发回收动作后只刷新了 `groupListProvider`，没有主动刷新已加载过的 `trashProvider`，导致回收站页面可能停在旧的空状态。
- 已调整 `GroupNotifier`：`moveEmptyGroupsToTrash()`、`moveAllGroupsToTrash()`、`moveToTrash()` 在刷新首页列表后同步刷新回收站列表。
- 已新增 `test/task_provider_test.dart`，覆盖“回收站先加载为空，然后首页回收空分组，回收站 provider 应立即出现该分组”的场景。
- 按用户要求将 Android 启动器显示名从 `focus_timer` 改为 `Focus Timer`，只改 `AndroidManifest.xml` 的 `android:label`，不改包名和数据库名。
- 已运行 `dart format lib\presentation\providers\task_provider.dart test\task_provider_test.dart`。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，17 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `57.6MB`。
- 已覆盖安装到竖屏模拟器 `emulator-5556` 并启动成功。
- 已用系统任务信息确认应用显示名为 `Focus Timer`。
- 已在竖屏模拟器做最小手测：创建空分组 `CodexTrash`，点击 `回收空的分组`，进入回收站可看到 `CodexTrash`；随后已将该测试分组彻底删除，回收站恢复空状态。

### 2026-06-19 回收操作反馈增强

- 继续减少手测成本：回收相关操作完成后不只显示文字提示，还提供 `查看` 按钮直达回收站。
- 已调整待办首页全局菜单：
  - `回收空的分组` 完成后显示 `已回收空分组`，SnackBar 里可点 `查看` 进入回收站。
  - `回收所有分组` 确认完成后显示 `已移至回收站`，SnackBar 里可点 `查看` 进入回收站。
- 已调整分组卡片操作面板：单个分组 `移至回收站` 后同样提供 `查看` 入口。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，17 个测试全部通过。
- `dart format lib\presentation\screens\group_list_screen.dart` 本轮超时；检查文件没有残留格式问题，且 analyze 通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `57.6MB`。

### 2026-06-19 待办主页布局和回收摘要

- 用户要求把前面整理的优先打磨、中优先级事项加入，并增加横竖排版切换。
- 已更新 `docs/Codexplan.md`：待办打磨路线新增横竖布局切换、空状态 CTA、分组任务预览、回收站摘要、任务接计时、手动排序、单条颜色等后续项。
- 已新增 `TodoHomeLayout` 和 `todoHomeLayoutProvider`，待办首页可在竖向列表和横向/紧凑卡片网格之间切换。
- 待办首页空状态新增 `创建分组` 主按钮，降低首次使用成本。
- 分组卡片新增最多 3 条待办预览：优先展示未完成任务；如果全部完成，则展示已完成任务并置灰/划线。
- 分组颜色选择面板补充标题 `选择颜色`，当前颜色有粗边框、勾选和轻微高亮。
- 回收站分组卡片新增任务摘要：待办总数、已完成数量和最多 3 条任务预览，便于确认回收内容。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，17 个测试全部通过。
- `dart format` 在本轮对目标文件持续超时；未发现残留进程，且 analyze/test/build 均通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `57.6MB`。

### 2026-06-19 待办列表/宫格切换修正

- 用户反馈上一轮切换没有成功：手机竖屏下自适应网格仍然只有一列，实际只是卡片向下变高。
- 用户进一步明确目标是 `列表模式` 和 `宫格模式`，不是横向滑动卡片。
- 已将待办首页切换逻辑改为：
  - 列表模式：单列全宽卡片。
  - 宫格模式：手机竖屏固定两列卡片；宽屏/平板使用三列。
- 宫格模式卡片高度固定为 190，预览任务数量限制为 2 条，避免卡片继续向下撑高。
- 顶部切换按钮 tooltip 改为 `切换宫格模式` / `切换列表模式`。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，17 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `57.6MB`。

### 2026-06-19 待办详情手动排序

- 继续推进待办模块的日常可用性，本轮补齐单个分组详情页里的任务手动排序。
- 已将待办详情列表改为 `ReorderableListView.builder`，右侧增加拖动手柄；长按手柄可调整任务顺序，点击任务仍打开动作面板，左滑删除仍保留。
- 已新增 `TaskRepository.reorderTasks()`，用事务批量写入同一分组内任务的 `sortOrder`。
- 新建任务现在会根据当前最大 `sortOrder` 追加到列表末尾，避免多条任务默认同为 0 导致顺序不稳定。
- `TaskNotifier.reorderTasks()` 支持在隐藏已完成任务时只调整可见任务，并把隐藏的已完成任务保持在后面。
- 已切换到当前 Flutter SDK 新接口 `onReorderItem`，避免旧 `onReorder` 的弃用警告和索引语义混乱。
- 已新增测试：
  - `test/task_repository_test.dart` 覆盖仓库层排序持久化。
  - `test/task_provider_test.dart` 覆盖新增任务追加、隐藏完成任务时排序、从上往下拖动的索引语义。
- 顺手移除 `home_screen.dart` 中未使用的 `flutter_hooks` import，清掉 analyzer 警告。
- `dart format` 本轮再次超时，未发现残留 `dart/flutter` 进程；后续仍以 analyze/test/build 作为本轮可用性判断。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，19 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `57.8MB`。

### 2026-06-19 待办详情更多/排序交互收紧

- 用户指出：任务动作面板里的 `计划日期` 和分组详情页右上角计划模式入口同质化；右侧同时出现 `...` 和拖动手柄也显得功能重复。
- 当前动作面板已不保留 `计划日期`，计划模式统一从页面右上角进入。
- 已调整待办详情行交互：
  - 长按整条待办即可拖动排序。
  - 右侧只保留 `...`，点按打开更多操作。
  - 移除独立拖动手柄，减少两个相邻图标的困惑。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，19 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `57.8MB`。

### 2026-06-19 待办左滑删除视觉减重

- 用户反馈待办详情页左滑删除时整块红色背景不好看，尤其深色模式里过于刺眼。
- 已将 `Dismissible` 删除背景从满宽红色块改为透明背景上的小型删除胶囊：
  - 只在右侧显示柔和 `errorContainer` 胶囊和删除图标。
  - 降低红色透明度，并增加低透明边框。
  - 删除逻辑不变，仍为左滑删除。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，19 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `57.8MB`。

### 2026-06-19 待办删除撤销与主线调整

- 用户确认接下来先把待办板块一个一个做完善，再做其他板块。
- 已将 `docs/Codexplan.md` 的 `Next Action` 从统计页改为待办模块主线：任务详情字段、更多操作、计划项编辑、复制昨日计划、分组排序、搜索筛选等按序推进。
- 已增强任务删除安全：
  - `TaskRepository.deleteTask()` 删除前返回 `DeletedTaskSnapshot`。
  - 删除任务时同步清理该任务关联的计划记录，避免计划页留下 `已删除待办`。
  - `restoreDeletedTask()` 可恢复任务和原有关联计划。
  - 详情页左滑删除和确认删除后都会显示 SnackBar `撤销`。
- 已新增测试：
  - 仓库层覆盖删除任务、清理计划、撤销后任务和计划恢复。
  - Provider 层覆盖删除后恢复原任务。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，21 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `57.8MB`。

### 2026-06-19 待办模块成包完善

- 用户要求待办板块一口气做完一包，便于集中测试。
- 已扩展任务数据字段：
  - `dueDayNum`：截止日期。
  - `estimatedMinutes`：预计时长。
  - `isFocus`：重点待办。
- 数据库 `schemaVersion` 从 `5` 升为 `6`，`AppConstants.databaseVersion` 同步为 `6`。
- 已运行 `dart run build_runner build --delete-conflicting-outputs`，Drift 代码生成成功。
- 待办首页：
  - 新增搜索入口，可按标题/备注搜索全部活跃分组里的待办。
  - 列表模式下可长按分组卡片拖动排序。
- 待办详情：
  - 更多菜单新增 `详情`、`设为重点/取消重点`、`复制待办`、`移动到分组`。
  - 详情弹层可编辑标题、备注、优先级、截止日期、预计时长和重点状态。
  - 任务列表会显示重点、优先级、截止日期、预计时长和备注摘要。
- 计划模式：
  - 新增顶部 `复制昨日计划`。
  - 新安排计划会优先使用任务预计时长作为计划时长。
  - 点击已安排计划可编辑计划时长、删除计划、从计划项直接开始自由计时。
  - 计划条显示当前计划时长。
- 数据层补充能力：
  - 复制任务、移动任务到其他分组。
  - 分组排序持久化。
  - 编辑计划时长。
  - 复制指定日期计划到当前日期。
- 已新增测试覆盖：
  - 任务详情字段在复制/移动时保留。
  - Provider 层保存详情、复制任务、移动任务。
  - 计划项时长编辑。
  - 复制计划会替换目标日并保留时长。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，24 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `57.9MB`。
- 已覆盖安装到模拟器并启动，前台确认为 `com.focustimer.focus_timer/.MainActivity`，未见 FATAL 崩溃日志。

### 2026-06-19 本地视频抽帧工具

- 用户建议在 D 盘准备一个视频读取工具，方便后续观察交互视频。
- 已确认系统 PATH 中没有 `ffmpeg/ffprobe`，常用 Python 视频库 `cv2/imageio/moviepy` 也不可用。
- 已发现本机已有：
  - `D:\Apps\Trae CN\resources\app\bin\ffmpeg.exe`
  - `D:\Apps\Trae CN\resources\app\bin\ffprobe.exe`
  - `C:\Program Files\Google\Chrome\Application\chrome.exe`
- Trae 附带的 ffmpeg 是裁剪版，能读取和转码常见视频，但不能直接输出 jpg/png 帧。
- 已新增工具：
  - `tools\extract_video_frames.ps1`
  - `tools\extract_video_frames_playwright.cjs`
- 工具实现：用完整 Chrome 加载本地视频并绘制到 canvas 导出 jpg；如果浏览器无法直接读，脚本保留 ffmpeg 转 H264 mp4 的兜底逻辑。
- 已用 `C:\Users\Andyxu\Desktop\微信视频2026-06-19_054752_256.mp4` 验证成功，抽帧输出到：
  - `D:\Projects\Focus Timer\video_frames\微信视频2026-06-19_054752_256_20260619155659`
- 后续使用示例：
  - `powershell -ExecutionPolicy Bypass -File tools\extract_video_frames.ps1 -VideoPath "视频路径.mp4" -Fps 1 -MaxWidth 720 -MaxFrames 160`

### 2026-06-20 待办/已办与计划三点菜单

- 用户提供新参考视频和截图，指出：
  - 分组内缺少已完成待办展示，左上角 `待办` 应可切换到 `已办`。
  - 计划模式同一时间格只能放一项。
  - 计划条末尾三点是功能键，应按参考图打开任务动作面板。
- 已用本地抽帧工具读取 `b947301a1e3cca94c92b1c814a4ba432.mp4`，确认参考交互：
  - 计划条右侧三点打开任务动作。
  - 已完成任务面板展示任务名、完成时间、自由计时、番茄计时、视频打卡、取消完成、设定目标、计划日期、删除、统计。
  - 首页右上角三点仍是全局待办菜单，和计划条三点不是同一个层级。
- 已调整分组详情页：
  - AppBar 标题改为可点击切换 `待办 / 已办`。
  - `待办` 只显示未完成任务，`已办` 只显示完成任务，并按完成时间倒序。
  - 已完成任务动作面板展示完成时间，提供取消完成、计时、设定目标、计划日期、删除、统计等入口。
  - 已办视图禁用拖动排序，避免完成时间排序和手动排序冲突。
- 已调整计划模式：
  - 左侧任务池仍可隐藏已完成任务，但右侧计划条会用全量任务索引显示已完成任务名称，避免变成 `已删除待办`。
  - 计划条普通点击不再打开编辑弹层，右侧三点按钮才打开动作面板。
  - 三点面板改为 4 列动作网格：自由计时、番茄计时、视频打卡、完成/取消完成、设定目标、计划日期、删除、统计。
  - `设定目标` 继续编辑计划时长；`计划日期` 可用日期选择器移动该计划到其他日期；`删除` 只删除计划，不删除待办。
- 已在数据层兜底同一时段只保留一项：
  - `createPlan()` 创建前会删除同一天同一分钟的旧计划。
  - `movePlan()` 移入已有时间格时会替换该格旧计划。
  - `updatePlan()` 修改日期/时间时也会清理目标格冲突。
  - 恢复已删除任务和复制计划时也会遵守同格唯一规则。
- 已新增测试 `task plans keep only one item in the same time slot`，覆盖同格新建替换和移动替换。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，25 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `58.1MB`。
- 已覆盖安装到 `emulator-5556` 并启动 `com.focustimer.focus_timer/.MainActivity`，未见 FATAL 崩溃日志，启动显示约 `+2s349ms`。
- 备注：本轮 `dart format` 多次超时，未作为阻塞项；代码已通过 analyze/test/build。后续可在 Dart 工具链恢复后单独跑格式化。

### 2026-06-20 主页面待办/已办切换修正

- 用户纠正：`待办 / 已办` 切换应在待办主页面左上角，而不是分组详情页。
- 已将分组详情页标题恢复为分组名，分组详情继续只展示未完成待办。
- 已在待办主页面 AppBar 标题新增可点击切换：
  - `待办`：展示原来的分组列表/宫格。
  - `已办`：展示所有活跃分组内已完成任务，按完成时间倒序。
- 主页面 `已办` 列表：
  - 显示任务标题、所属分组、完成时间。
  - 点击勾选图标可取消完成，并刷新全局已办列表。
  - 点击行进入所属分组。
  - 已办模式隐藏右下角创建分组按钮。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，25 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `58.1MB`。
- 已覆盖安装到 `emulator-5556` 并启动，未见 FATAL 崩溃日志，启动显示约 `+1s287ms`。

### 2026-06-20 已办主页结构补齐

- 用户确认 参考应用的 `已办` 确实存在，并要求实际操控研究。
- 已通过 ADB 操控参考 App `reference.app`：
  - 点击清单主页面左上角 `待办 ↔` 后会直接切到 `已办 ↔`。
  - 已办主页包含 `统计概览`、分组/类型聚合卡片、按日期分组的完成记录时间线。
  - 点击分组卡会进入该分组的已办二级页。
  - 点击完成记录会弹出 8 动作面板：自由计时、番茄计时、视频打卡、取消完成、设定目标、计划日期、删除、统计。
- 已调整本项目待办主页面 `已办`：
  - 顶部新增统计概览：今日、本周、本月、总计。
  - 中部新增分组聚合卡，显示每个分组的已办数量，点击进入分组已办二级页。
  - 下部完成记录改为按日期分组的时间线，展示任务名、分组名、完成时间。
  - 完成记录点击后弹出 8 动作面板，并接入现有计时器、取消完成、设定目标、计划日期、删除和统计 tab。
- 已修复一个状态同步点：`TaskNotifier.toggleComplete()` 在该分组 provider 未预加载时会从仓库读取任务，保证从全局已办页取消完成可用。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，25 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `58.2MB`。
- 已覆盖安装到 `emulator-5556` 并启动 `com.focustimer.focus_timer/.MainActivity`，未见 FATAL 崩溃日志，启动显示约 `+1s801ms`。
- 已用 ADB 截图验证：
  - 主页面左上 `待办 ↔` 可切到 `已办 ↔`。
  - 已办主页显示统计概览、分组聚合、完成记录。
  - 点击完成记录可弹出动作面板，布局未见明显溢出。
  - 点击分组聚合卡可进入该分组的已办二级页。
- 备注：`dart format` 仍会超时，本轮未作为阻塞项；代码已通过 analyze/test/build。

### 2026-06-20 待办模块批量操作与已办动作补强

- 用户要求继续推进待办模块。
- 已补分组详情页多选模式：
  - 长按待办进入多选。
  - 顶部标题显示已选数量，左上角关闭多选。
  - 顶部提供全选。
  - 底部批量工具条提供：完成、移动、删除。
  - 批量删除支持撤销，并会恢复相关计划记录。
  - 多选时禁用拖拽排序和左滑删除，避免误操作。
- 已补已办记录动作面板的更多常用动作：
  - 保留原 8 宫格：自由计时、番茄计时、视频打卡、取消完成、设定目标、计划日期、删除、统计。
  - 新增列表操作：详情、重命名、复制待办、移动到分组、设为/取消重点。
  - 详情面板可编辑标题、备注、优先级、预计时长、重点、截止日期，并刷新已办列表。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，25 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `58.2MB`。
- 已覆盖安装到 `emulator-5556` 并启动 `com.focustimer.focus_timer/.MainActivity`，未见 FATAL 崩溃日志，启动显示约 `+1s479ms`。

### 2026-06-20 待办主页布局切换动画修正

- 用户提供视频 `77b5f621881630d2b138f3600d0c5f8c.mp4`，反馈动画很奇怪。
- 已用本地视频抽帧工具读取视频，确认问题发生在待办主页点击顶部 `列表 / 宫格` 切换按钮时：
  - AppBar 图标按钮的水波/高亮动画过大，像一个浅色胶囊贴在图标上。
  - 分组卡从窄卡变长卡时横向拉伸感明显。
- 已修正：
  - 新增 `_QuietIconButton`，待办主页 AppBar 普通图标按钮使用更小、更淡的高亮半径，避免大面积水波拖影。
  - 列表/宫格主体切换改为 `_TodoLayoutFade`，只做短淡入淡出，不再做横向尺寸拉伸。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，25 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物为 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `58.2MB`。
- 已覆盖安装到 `emulator-5556` 并启动，未见 FATAL 崩溃日志，启动显示约 `+2s19ms`。
- 用户随后补充说明：怪异点是卡片固定在左侧色条位置，像以该处为轴向左下 90 度下摆。
- 已进一步去掉待办主页列表/宫格主体切换动画，让布局直接切换，避免旋转轴心感、横向拉伸和下摆中间态。
- 已重新运行 `flutter analyze` 和 `flutter test`，均通过。
- 已重新构建 `app-release.apk`。
- 用户手机已通过 ADB 连接，设备为 `769d76ab` / `model:23127PN0CC`。
- 已将新版 APK 通过 `adb -s 769d76ab install -r ...` 安装到手机，安装结果 `Success`。
- 已通过 ADB 启动手机端 `com.focustimer.focus_timer/.MainActivity`，前台确认成功。
- 用户反馈仍可见轴心式下摆，并要求参考 GitHub/Web 做视图切换。
- 已查阅 Flutter 官方 `AnimatedSwitcher`/`AnimatedCrossFade` 相关说明，确认这类不同尺寸列表/宫格不适合做子树变形或尺寸过渡，否则容易出现共享元素/锚点式变形错觉。
- 已改为更稳的结构：新增 `_TodoHomeLayouts`，列表和宫格作为两个独立视图常驻在 `IndexedStack` 中，只切换可见层；列表项 key 和宫格项 key 使用不同前缀，避免 Flutter 把同一个卡片在两种布局间复用成变形对象。
- 已重新运行 `flutter analyze` 和 `flutter test`，均通过。
- 已重新构建并安装到手机 `769d76ab`，安装结果 `Success`，前台启动确认成功。
- 用户提供 `untitled.md` 进一步解释：问题核心不是过渡时长，而是左侧蓝线像屏幕外部固定轴，卡片从蓝线右侧生长/收缩；正常应当是蓝线作为卡片内部元素随卡片整体重排。
- 已据此调整 `_GroupCard`：
  - `Card` 增加 `clipBehavior: Clip.antiAlias`。
  - 左侧颜色条从贴卡片外沿的 `Positioned.fill + Align.left` 改为卡片内部 inset 装饰条：`left: 12, top/bottom: 16, width: 4`。
  - 内容左内边距从 `16` 调整为 `28`，保证蓝线明确属于卡片内部，而不是外部标尺。
- 已重新运行 `flutter analyze` 和 `flutter test`，均通过。
- 已重新构建并安装到手机 `769d76ab`，安装结果 `Success`，前台启动确认成功。

### 2026-06-20 待办主页布局切换严重修正

- 用户提供 `untitled.md` 和截图，进一步明确问题：即使没有显式动画，只要列表和宫格第一张卡片都从同一左边距开始，视觉上仍会被理解为“同一张卡从蓝线处变宽/变窄”。
- 已按 Flutter 官方文档和 Flutter packages GitHub 的 Material Motion 思路重新判断：
  - `AnimatedSwitcher` 文档强调相同类型和 key 会被框架当作同一 widget 更新，不一定形成真正替换。
  - Material Motion 的 `fade through` 适合没有强空间关系的 UI 之间切换；列表/宫格属于状态切换，不应做卡片级 resize 或 shared-axis 过渡。
- 已在 `group_list_screen.dart` 重做待办主页布局切换：
  - `_TodoHomeLayouts` 从 `StatelessWidget + IndexedStack` 改为 `StatefulWidget + AnimationController`。
  - 切换时先把旧布局整页淡出到透明，再替换为目标布局，再整页淡入，避免任何单张卡片被用户感知为跨布局变形。
  - 使用 `_visibleLayout/_targetLayout` 和切换 token 处理连续快速点击，避免状态错乱。
- 已在 `_GroupCard` 做视觉结构调整：
  - 移除左侧竖向颜色条，不再给用户“固定轴线/标尺”的视觉暗示。
  - 改为标题行内的彩色文件夹图标，分组颜色仍可见，但属于卡片内容的一部分。
- 验证：
  - `flutter analyze`：通过，`No issues found`。

### 2026-06-21 当前已安装 APK 全量冒烟测试

- 测试设备：
  - MuMu Android 12，`127.0.0.1:16416`，分辨率 `900x1600`，density `320`。
  - 当前安装包仍是 `D:\Projects\Focus Timer\build\app\outputs\flutter-apk\app-release.apk`，更新时间 `2026-06-21 05:49:18`。
- 通过项：
  - 待办首页：待办/已办标题切换、搜索、列表/宫格切换、更多底部菜单、回收站入口可用。
  - 分组详情：进入正常，新增待办正常，输入框不会一进入页面就拉起键盘，任务完成和任务操作面板可用。
  - 计划模式：`00:00-24:00` 时间轴可见，时段设置为底部 sheet；长按拖拽可把任务放入指定时段；同一时段可放不同任务；同一任务重复拖到同一时段不会重复创建；右侧任务可拖回左侧删除安排。
  - 计时页：自由计时、番茄计时、倒计时弹层可打开且不自动拉键盘；自由计时可开始、暂停、停止保存；倒计时运行态主数字显示剩余时间；停止倒计时有取消/放弃/保存确认。
  - 后台计时：自由计时切到桌面约 8 秒后回到应用，秒数继续增加；系统前台通知存在，停止后通知消失。
  - 视频打卡：入口会先说明需要打开系统相机；点击“去拍摄”可拉起 `com.android.camera2/.VideoCamera`。
  - 统计页：`2026年6月` 不再是一片空白，热力图、饼图、时间轴、补录、图表管理入口可见可用。
  - 我的页：应用名显示为 `Focus Timer`；主题色、显示模式、通知权限、回收站、关于入口可用；通知权限可跳系统设置兜底。
  - 日倒计时：首页卡片可进入详情，编辑弹层可打开且不自动拉键盘。
- 发现/待处理：
  - 当前已安装 APK 还没有带上“导出路径提示优化”的新版弹窗，只显示裸私有路径；等统一打新包后复测。
  - 搜索状态下点击空白区域不会退出搜索，只能点关闭或返回，后续应改成空白收起。
  - 分组详情中底部输入框获得焦点后，系统返回键优先收焦点/键盘，不一定直接退出详情页；交互可再顺。
  - 统计时间轴里不足 1 分钟的短记录显示为 `0 分钟`，建议后续显示为 `<1 分钟` 或秒级。
  - 主题色当前是预设色板，不是完全自定义颜色；后续 UI 统一时再决定是否加自定义色。
  - 若要判断源码最新状态，下一步需要重新构建 release APK 并安装复测。

### 2026-06-21 回收站恢复闭环

- 在当前已安装 APK 上复测了回收站恢复：
  - 回收站中原有 2 条 `111`。
  - 点击第一条的恢复按钮后，回收站减少为 1 条。
  - 返回首页后，待办首页的分组数量从 1 个变成 2 个，已办统计也同步变化。
- 结论：
  - 回收站恢复不是假动作，数据会回到首页结构里。
  - 这个闭环是通的，后续重点放在样式、提示语和批量操作一致性上。
  - `flutter test`：通过，25 个测试全部通过。
  - `flutter build apk --release`：成功，产物 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `58.2MB`。
  - 已覆盖安装到实体手机 `769d76ab`，安装结果 `Success`。
  - 已通过 ADB 启动 `com.focustimer.focus_timer`。

### 2026-06-20 待办主页布局切换柔化

- 用户确认布局切换方向已经可以，但渐入渐出仍有“闪一下”的感觉，不够柔和。
- 已继续调整 `_TodoHomeLayouts`：
  - 保留整页切换，避免回到卡片级变形。
  - 从“先淡出到透明、再换布局、再淡入”改成“旧布局和新布局短暂叠层 cross-fade”。
  - 过渡时旧布局 `IgnorePointer + Opacity` 退场，新布局同时淡入，避免中间出现空白/断帧感。
  - 动画时长调整为 `260ms`，曲线使用 `Curves.easeOutCubic`，视觉更软。
- 验证：
  - `flutter analyze`：通过，`No issues found`。
  - `flutter test`：通过，25 个测试全部通过。
  - `flutter build apk --release`：成功，产物 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `58.2MB`。
  - 已覆盖安装到实体手机 `769d76ab`，安装结果 `Success`。
  - 已通过 ADB 启动 `com.focustimer.focus_timer`。

### 2026-06-20 待办首页、日倒计时、计划模式体验修正

- 用户集中反馈：
  - 待办卡片上的文件夹图标不喜欢，颜色自定义/跟随主题不明显。
  - 搜索待办像空壳，不知道能搜什么。
  - 日倒计时在待办首页没有提醒存在感，独立页空状态和已设置态都太空。
  - 回收提示只有查看没有撤回，SnackBar 不主动收束；回收所有/空分组缺少撤回。
  - 创建分组/表单入口不要立即拉起键盘，搜索除外。
  - 计划模式同一时段只能放一项，但参考 App 可以同一时间块放多个事项；时段设置下拉铺满全屏很怪。
- 已调整待办首页：
  - 分组卡片从文件夹图标改为分组颜色圆点标识，颜色仍来自分组颜色设置。
  - 分组菜单里的 `颜色` 改为 `分组颜色`，语义更明确。
  - 搜索进入后即显示说明：可搜待办标题、备注、分组名称。
  - 搜索结果分为 `分组` 和 `待办` 两类，点击进入对应分组。
  - 待办首页顶部新增日倒计时卡片；未设置时提示用途，已设置时直接显示事件、目标日期和剩余天数。
  - 创建分组和多个编辑/重命名表单去掉 `autofocus`，避免刚进入就弹键盘；搜索框保留自动聚焦。
- 已调整回收交互：
  - `softDeleteEmptyLists()` / `softDeleteAllLists()` 改为返回被回收分组 id 列表。
  - `GroupNotifier` 新增 `restoreGroups()`，用于撤回一批回收操作。
  - 回收空分组、回收所有分组、单个分组移至回收站后，SnackBar 提供 `撤回`，并会先清理旧 SnackBar，避免提示长期堆住。
- 已调整日倒计时：
  - 空状态增加标题、说明和单一主按钮，避免两个新建同时抢视觉。
  - 已设置页面增加图标和说明，明确它会在待办首页持续展示。
  - FAB 固定为编辑含义。
- 已调整计划模式：
  - 仓库层取消“同一时段先删旧计划”的逻辑，新增/移动计划会追加到同一时间块。
  - 同一时段的多条计划用 `sortOrder` 排序。
  - 右侧时间格：单项占满格，多项时以短卡片并排显示，可横向查看。
  - 时段设置从 `DropdownButtonFormField` 改为底部时间选择列表 + 分段 `ChoiceChip`，避免弹出铺满全屏的奇怪下拉层。
  - 测试从 `task plans keep only one item in the same time slot` 改为 `task plans allow multiple items in the same time slot`。
- 验证：
  - `flutter analyze`：通过，`No issues found`。
  - `flutter test`：通过，25 个测试全部通过。
  - `flutter build apk --release`：成功，产物 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `58.3MB`。
  - 已覆盖安装到实体手机 `769d76ab`，安装结果 `Success`。
  - 已通过 ADB 启动 `com.focustimer.focus_timer`。

### 2026-06-20 APK 构建脚本

- 用户建议把构建流程写成脚本。
- 已新增 `tools/build_apk.ps1`：
  - 默认执行 `flutter analyze`、`flutter test`、`flutter build apk --release`。
  - 支持 `-Mode debug|release`。
  - 支持 `-SkipAnalyze`、`-SkipTests` 快速构建。
  - 支持 `-Install`、`-Launch`、`-DeviceId <serial>`，可构建后安装并启动到 ADB 设备。
  - 未传 `-DeviceId` 且只有一个 ADB 设备时自动选择；多个设备时会列出设备并要求指定。
- 已更新 `docs/APK_BUILD.md`，加入脚本用法。
- 已用 PowerShell Parser 校验脚本语法：`PowerShell syntax OK`。
- 备注：尝试用脚本执行一次 `flutter build apk --release` 时，Gradle 构建在 5 分钟工具超时内未结束，APK 时间戳未更新；脚本参数和语法已验证，未把该次超时视作业务构建失败。

### 2026-06-20 待办顶栏、分组图标、撤回和计划视图修正

- 用户反馈：
  - 待办页右上角三点菜单展开会遮住顶栏组件。
  - 日倒计时已经置顶展示，顶栏日倒计时按钮重复。
  - 待办分组希望能自定义图标。
  - 回收 SnackBar 的撤回无效。
  - 计划模式与参考 App 差距仍明显，同一时段多事项不应横向挤压/截断。
- 已调整待办页顶栏：
  - 移除 AppBar 上的日倒计时按钮，保留顶部置顶倒数日卡片入口。
  - 右上角 `更多` 从 `PopupMenuButton` 改为底部操作面板，避免遮住顶栏和内容。
- 已实现分组自定义图标：
  - `TaskLists` 新增 `iconCodePoint` 字段，数据库版本升级到 `7`。
  - 新增迁移：`from < 7` 时添加 `taskLists.iconCodePoint`。
  - 创建分组弹层可选择分组图标。
  - 分组卡片显示用户选择的图标和分组颜色。
  - 分组操作面板新增 `分组图标`。
  - 克隆分组时保留图标。
- 已修回收撤回：
  - 补测试 `group notifier restores groups from undo ids`，验证 `moveAllGroupsToTrash()` 后 `restoreGroups()` 可以把分组恢复到主列表，并清空回收站视图。
- 已调整计划模式同槽多事项显示：
  - 时间轴取消固定 `itemExtent`，每个时段高度按该时段事项数量动态撑高。
  - 同一时段事项改为纵向完整显示，不再横向挤压/截断；放几个显示几个，时间轴整体滚动。
- 验证：
  - 已运行 `dart run build_runner build --delete-conflicting-outputs`，生成 Drift 代码成功。
  - `flutter analyze`：通过，`No issues found`。
  - `flutter test`：通过，26 个测试全部通过。
  - `flutter build apk --release`：成功，产物 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `58.2MB`。
  - 用户已断开 ADB，本轮未安装到手机。
### 2026-06-20 计划模式同槽显示与重复规则修正

- 用户反馈：计划模式里一个时间段被多条任务撑开后，后续时间段看起来“不见了”；同时“同一时段可添加无上限任务”不等于“同一待办可以在同一时段无限重复添加”。
- 已调整计划模式右侧时间轴：时段行高改为可控高度，1/2/3 项逐步增高，超过 3 项后在该时段内部滚动，并显示剩余数量提示，避免 00:00 一格把 02:00、04:00 等后续时间段顶出视野。
- 已调整计划写入规则：同一 dayNum + startMinute + taskId 只保留一条计划；不同待办仍可放在同一时段。
- 已在仓库层、Provider 层、恢复删除任务和复制计划路径加入同槽同任务去重保护，旧数据渲染时也会折叠重复项。
- 已更新测试 `task plans allow multiple different items in the same time slot`，覆盖不同待办同槽、同待办重复新建不新增、同待办从其他时段拖回同槽不制造重复。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，26 个测试全部通过。
### 2026-06-20 待办单条颜色与每日重置

- 用户确认前 1/2/3 项功能可以先通过，UI 和动画后面统一做，本轮继续完成第 4 项。
- 已给 `Tasks` 新增 nullable `color` 字段，数据库 `schemaVersion` 升级到 `8`，并补充 `from < 8` 迁移；`AppConstants.databaseVersion` 同步为 `8`。
- 已运行 `dart run build_runner build --delete-conflicting-outputs`，Drift 生成代码成功。
- 已实现单个待办自定义颜色：
  - 待办详情页、任务动作面板和已办详情面板可设置/清除待办颜色。
  - 任务标题、勾选框、搜索结果、已办时间线、计划模式任务池和计划条优先使用单条颜色；没有单条颜色时回退到分组颜色。
  - 复制任务、移动任务、克隆分组时保留单条颜色。
- 已实现每日重置分组的真实行为：
  - 进入待办首页时触发 `applyDailyReset()`。
  - 只处理未删除、开启每日重置的分组。
  - 将昨日及更早已完成任务恢复为未完成，更新到今日 `dayNum`，并清空 `completedAt`。
  - 重置后刷新分组、任务和全局任务 Provider，保证 UI 能立刻看到变化。
- 已补充测试：
  - `applyDailyReset reopens old completed tasks in daily groups only` 覆盖每日重置边界。
  - 复制/移动相关测试补充颜色保留断言。
- 已运行 `flutter analyze`，结果为 `No issues found`。
- 已运行 `flutter test`，27 个测试全部通过。
- 已运行 `flutter build apk --release`，构建成功，产物 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `58.3MB`。
### 2026-06-20 计时页交互第一轮推进

- 用户要求开始做计时部分，本轮优先处理功能和交互规则，不做大范围视觉/动画统一打磨。
- 已检查现有计时页：已有卡片入口、底部启动 Sheet、运行页和基础停止逻辑；本轮在此基础上补齐更接近参考 App 的核心体验。
- 已调整计时入口和运行反馈：
  - 计时首页在今日统计下方新增 `上次计时` 卡片，展示最近一条记录的名称、类型、时长和开始/结束时间。
  - 自由计时默认名称从旧的 `专注` 改为 `自由计时`；其他类型空名称也按类型生成默认名称。
  - 运行中只显示一个大圆形暂停按钮；暂停后才显示 `继续` 和 `结束`，更贴近“先暂停，再决定结束”的流程。
- 已调整停止策略：
  - 自由计时仍然结束即保存。
  - 番茄计时和倒计时在暂停后结束，会弹出确认，可选择放弃或保存。
  - `TimerNotifier.stopTimer(save: false)` 支持放弃本次计时且不写入数据库。
  - 目标计时保存时长会钳制到目标时长，避免自动完成时记录超过预设目标。
- 已补充测试：
  - 更新空名称默认值断言为 `自由计时`。
  - 新增 `stopTimer can discard a running record without saving`，覆盖放弃不保存。
- 验证：
  - `flutter analyze`：通过，`No issues found`。
  - `flutter test test\timer_provider_test.dart`：通过，3 个计时测试全部通过。
  - `flutter test`：通过，28 个测试全部通过。
  - `dart format lib\presentation\providers\timer_provider.dart lib\presentation\screens\timer_screen.dart test\timer_provider_test.dart`：本机工具 60 秒超时，未发现残留 Dart/Flutter 进程，未作为阻塞项。
  - `flutter build apk --release`：成功，产物 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `58.3MB`。
### 2026-06-20 计时软件功能调研与记录操作补齐

- 用户要求继续计时模块前先搜索计时软件常见功能。
- 已参考 Pomofocus、Toggl Track、Clockify、Focus To-Do/public productivity apps 类计时工具的公开功能方向，结论是近期应优先补三类基础能力：
  - 快速继续上一次计时。
  - 今日记录可回看。
  - 记录可改错，例如重命名和删除。
- 已在计时首页增强记录闭环：
  - `上次计时` 卡片可点击打开操作面板。
  - 最近记录支持 `继续计时`、`重命名`、`删除记录`。
  - 今日记录区显示最近 5 条历史记录，支持点击操作和右侧快速继续。
  - `继续计时` 会沿用原记录的类型、名称和目标时长。
- 已在 `TimerNotifier` 增加记录操作：
  - `renameRecord(id, name)` 更新记录名称并刷新今日数据。
  - `deleteRecord(id)` 删除记录并刷新今日数据。
- 已补充测试 `renameRecord and deleteRecord refresh today data`，覆盖记录重命名/删除后的 Provider 刷新。
- 验证：
  - `flutter analyze`：通过，`No issues found`。
  - `flutter test`：通过，29 个测试全部通过。
  - `flutter build apk --release`：成功，产物 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `58.4MB`。
### 2026-06-20 计时记录时长编辑与小拆分

- 用户要求先完成当前没收尾的内容，再按自然边界拆分，并顺手补必要注释。
- 已完成上轮未收口的计时记录编辑：
  - 记录操作面板新增 `修改时长`。
  - 弹窗按分钟输入，保存后更新 `durationMs` 和 `endTime`。
  - `TimerNotifier.updateRecordDuration()` 更新记录后刷新今日数据。
- 已修计时模块小债务：
  - `TimerState.initial()` 默认名称从 `专注` 改为 `自由计时`。
  - 计时 ticker 从 `state = state.copyWith()` 强刷改为显式更新 `tickMs`。
  - 后台前台服务启动时传入有效开始时间，恢复暂停后通知计时会扣除已暂停时长。
  - `databaseProvider` 从 `timer_provider.dart` 移到独立的 `providers/database_provider.dart`。
- 已拆分 `timer_screen.dart`：
  - `timer_record_widgets.dart`：最近记录卡、今日记录列表、记录操作面板。
  - `timer_setup_sheets.dart`：开始计时 Sheet、分钟输入、重命名、修改时长弹窗。
  - `timer_ui_helpers.dart`：计时类型名称、图标、时长和时间段格式化。
  - `timer_screen.dart` 从约 1574 行降到约 795 行。
  - 注释只加在 Sheet 文件入口，说明其只负责收集用户输入，不直接写 Provider。
- 已补充测试：
  - `rename duration update and delete refresh today data` 覆盖重命名、修改时长和删除后的今日数据刷新。
- 验证：
  - `flutter analyze`：通过，`No issues found`。
  - `flutter test`：通过，29 个测试全部通过。
  - `flutter build apk --release`：成功，产物 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `58.4MB`。
### 2026-06-20 计时模块模拟器实测

- 用户要求继续去模拟器测试。
- 已将最新 release APK 覆盖安装到 `emulator-5556`，设备信息为 `product:rubens model:22041211A`，启动前台为 `com.focustimer.focus_timer/.MainActivity`。
- 已完成计时首页和记录操作实测：
  - 首页正常显示今日汇总、`上次计时`、自由计时、番茄计时、倒计时入口。
  - `上次计时` 操作面板可打开，包含 `继续计时`、`重命名`、`修改时长`、`删除记录`。
  - `修改时长` 实测将一条记录改为 3 分钟后，今日专注从 `<1 分钟` 刷新为 `3 分钟`，记录展示同步变为 `3 分钟 · 01:25 - 01:28`。
  - `重命名`、`删除记录` 可执行；删除最新记录后今日汇总能回退，最近记录恢复为上一条。
- 已完成自由计时实测：
  - 开始 Sheet 正常打开，默认名称为 `自由计时`，不会自动拉起键盘。
  - 开始后进入运行态，只有一个大暂停按钮。
  - 暂停后显示 `继续` 和停止按钮，恢复后继续累计。
  - 停止后自动保存，今日汇总从 `3 分钟 / 1 次` 更新到 `4 分钟 / 2 次`，最近记录更新为自由计时。
- 已完成番茄计时实测：
  - 设置 Sheet 正常打开，默认选中 25 分钟，不自动拉起键盘。
  - 开始后进入倒计时运行态，显示剩余时间和已进行时间。
  - 暂停后停止会弹出确认框，提供 `取消`、`放弃`、`保存`。
  - 选择 `放弃` 后不新增记录，今日汇总保持 `4 分钟 / 2 次`。
- 已完成倒计时实测：
  - 设置 Sheet 正常打开，默认选中 10 分钟，不自动拉起键盘。
  - 开始、暂停、停止确认框正常。
  - 选择 `保存` 后新增记录，今日次数从 2 次更新为 3 次，最近记录更新为倒计时。
- 已检查通知：
  - 运行中能看到 `timer_foreground` 前台通知，通知标题为 `自由计时 进行中`，正文显示当前计时时长。
  - 结束保存后活动的 `NotificationRecord` 已清除，仅剩通知频道配置。
- 备注：
  - 模拟器状态栏显示 `11:xx`，记录时间显示 `23:xx`，已确认模拟器系统时间为 `Sat Jun 20 23:53:27 CST 2026`，时区为 `Asia/Shanghai`，状态栏是 12 小时制显示，不是应用记录时间计算错误。
### 2026-06-20 计时后台留存与继续拆分

- 用户指出计时缺少后台留存能力，并要求继续拆代码，防止文件重新变成屎山。
- 已补计时活动会话持久化：
  - 新增 `ActiveTimerSession` 表，数据库 `schemaVersion` 升级到 `9`，`AppConstants.databaseVersion` 同步为 `9`。
  - `TimerRepository` 新增 `getActiveSession()`、`saveActiveSession()`、`clearActiveSession()`。
  - `TimerNotifier` 在开始、暂停、恢复时保存活动会话；停止保存或放弃时清理会话。
  - App/Provider 重建时会从活动会话恢复正在进行或暂停的计时，并按真实经过时间继续计算。
  - 恢复初始化暴露 `ready` Future，测试可稳定等待异步恢复完成。
- 已增强 Android 前台服务自身留存：
  - `TimerForegroundService` 将通知所需的开始时间、目标时长和名称写入原生 `SharedPreferences`。
  - Sticky service 被系统重启且 intent 为空时，可从原生参数恢复通知内容。
  - Flutter 主动停止服务时同步清理原生留存参数。
- 已继续拆分计时 UI：
  - 新增 `timer_start_surface.dart`：计时停止态首页、今日概览、入口卡、快速休息、今日记录入口。
  - 新增 `timer_running_surface.dart`：运行/暂停态 UI、停止确认弹窗。
  - 新增 `timer_common_widgets.dart`：计时模块共用小组件。
  - `timer_screen.dart` 缩到约 251 行，只保留主屏切换和启动 Sheet 流程。
  - 当前计时相关 UI 文件均控制在约 400 行以内。
- 已补测试：
  - `running timer session is restored after provider rebuild` 覆盖 Provider 重建后的运行态恢复。
  - `paused timer session persists and stop clears active session` 覆盖暂停态留存和停止清理。
- 验证：
  - `dart run build_runner build --delete-conflicting-outputs`：成功生成 Drift 代码。
  - `flutter analyze`：通过，`No issues found`。
  - `flutter test test\timer_provider_test.dart`：通过，6 个计时测试全部通过。
  - `flutter test`：通过，31 个测试全部通过。
  - `flutter build apk --release`：成功，产物 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `58.4MB`。
  - 已覆盖安装到 `emulator-5556` 并实测：番茄计时运行 1 秒后 `am force-stop` 强停 App，重新打开后切到计时页，恢复为运行态，已进行时间继续累计到约 2 分钟，证明 Flutter 侧后台/重启留存生效。
### 2026-06-21 活动计时入口提示

- 用户要求继续推进。
- 本轮接着把后台留存能力暴露到首页导航：
  - `HomeScreen` 开始监听 `timerProvider`。
  - 有正在进行或暂停的计时时，底部 `计时` tab 显示 `Badge` 小角标。
  - 冷启动/Provider 恢复到活动计时后，如果用户还没有手动切 tab，会自动切到计时页，并弹出 `已恢复正在进行的计时` 提示。
  - 用户手动切换任意 tab 后，本轮自动跳转保护会关闭，避免和用户操作抢焦点；活动计时仍通过角标提示。
- 验证：
  - `flutter analyze`：通过，`No issues found`。
  - `flutter test test\timer_provider_test.dart`：通过，6 个计时测试全部通过。
  - `flutter test`：通过，31 个测试全部通过。
  - `flutter build apk --release`：成功，产物 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `58.4MB`。
  - 已覆盖安装到 `emulator-5556` 并实测：倒计时运行后底部计时 tab 出现角标；`am force-stop` 强停后冷启动，App 自动回到计时页，计时继续运行，角标仍可见。
### 2026-06-21 计时入口排序与视频打卡语义

- 用户提出计时页面任务排序不合理，并提醒视频打卡应调用摄像头，同时不要忘记参考 参考应用的方案。
- 已对照 `docs/Codex观察记录.md`：
  - 参考应用的全局 `+` 面板主动作包含自由计时、番茄计时、视频打卡、起床睡觉、休息快捷项。
  - 参考应用的 `视频打卡` 会先弹业务权限说明，说明需要相机权限，不是一上来直接拉系统权限，也不是普通计时名称 Sheet。
  - reference app 还有 `视频草稿箱`，说明视频打卡后续应是独立凭证/草稿链路。
- 已参考官方技术方向：
  - Flutter `NavigationBar` 面向主要目的地，计时页入口应让高频核心路径稳定、清晰。
  - Flutter 官方完整相机方案是 `camera` 插件，但本轮 `flutter pub add camera` 因网络/工具超时未成功，且当前需求更像“调用系统相机拍摄凭证”。
- 已调整计时首页排序和分组：
  - `开始计时` 只保留核心计时：`番茄计时`、`自由计时`、`倒计时`。
  - `快速休息` 保留 5/10/20 分钟。
  - 新增 `打卡记录` 分区，包含 `视频打卡` 和 `起床睡觉`。
  - `视频打卡` 文案改为 `拍摄凭证后记录`，不再伪装成普通计时入口。
- 已实现视频打卡的第一版本地调用：
  - 点击 `视频打卡` 先弹业务说明，按钮为 `取消 / 去拍摄`。
  - 选择 `去拍摄` 后通过 Android 原生 `MediaStore.ACTION_VIDEO_CAPTURE` 打开系统录像界面。
  - 用户取消录像时不会误启动计时，并提示 `未完成视频打卡`。
  - 用户完成录像后会开始一条 `视频打卡` 计时记录；当前还未保存视频 URI/草稿箱，后续需要补凭证文件与草稿箱数据模型。
- 验证：
  - `flutter analyze`：通过，`No issues found`。
  - `flutter test`：通过，31 个测试全部通过。
  - `flutter build apk --release`：成功，产物 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `58.4MB`。
  - 已覆盖安装到 `emulator-5556` 并实测：计时页排序生效，视频打卡说明弹窗正常，系统录像界面可打开，返回取消后提示 `未完成视频打卡` 且未误启动计时。
### 2026-06-21 快速休息规则收口

- 用户追问 `快速休息呢`，并提醒不要闭门造车。
- 已临时查看开源 Flutter 番茄钟项目 `sbafsk/pomodoro-flutter` 的休息模式：短休息/长休息作为独立计时类型存在，可手动切换，完成后按休息完成提醒；这和 reference app 观察中的 `5/10/20 分钟休息快捷项直接进入倒计时，并进入时间轴记录` 一致。
- 本轮确定快速休息规则：
  - `快速休息` 保持独立分区，不混进 `开始计时` 的核心专注入口。
  - 点击 5/10/20 分钟直接开始倒计时，记录进入今日时间轴。
  - 休息记录不计入今日专注、热力图专注统计和今日专注次数。
  - 运行页不再把休息耗时标成 `已专注`，改为按类型显示 `已休息`。
  - 完成通知按类型区分，休息完成显示 `休息结束`，倒计时完成显示 `倒计时结束`。
- 已修改：
  - `timer_ui_helpers.dart`：新增 `isRestTimerType()`、`elapsedLabelForType()`。
  - `timer_running_surface.dart`：运行态详情和目标计时辅助文案按类型显示 `已休息 / 已记录 / 已专注`。
  - `notification_service.dart`：`showTimerComplete()` 支持传入 type，并按类型给通知标题。
  - `timer_provider.dart`：完成通知传入当前计时类型。
  - `timer_provider_test.dart`：新增 `rest timer is recorded but excluded from today focus total`，覆盖休息记录进时间轴但不计入今日专注。
- 验证：
  - `flutter analyze`：通过，`No issues found`。
  - `flutter test test\timer_provider_test.dart`：通过，7 个计时测试全部通过。
  - `flutter test`：通过，32 个测试全部通过。
  - `flutter build apk --release`：成功，产物 `build\app\outputs\flutter-apk\app-release.apk`，大小约 `58.4MB`。
- 备注：
  - `dart.bat` 在本机启动阶段异常卡住，直接调用 `D:\Tools\Flutter\bin\cache\dart-sdk\bin\dart.exe format ...` 可正常格式化。
### 2026-06-21 代码拆分接手

- 用户说明 Claude 开了 `claude/split-screens` 分支拆代码块，但状态不对劲，要求 Codex 接手。
- 当前工作区已在 `claude/split-screens` 分支，保留 Claude 新增的 `todo_color_picker.dart`，并将其正式接入待办首页：
  - `group_list_screen.dart` 改为引用 `TaskPreviewLine`、`ColorSwatches`、`TaskColorSwatches`、`IconSwatches`、`groupIconData()`、`effectiveTaskColor()`。
  - 删除 `group_list_screen.dart` 尾部重复的颜色、图标、待办预览组件定义。
- 拆分 `task_plan_screen.dart`：
  - 主文件保留入口、设置弹层和启动计时桥接。
  - 新增 `task_plan_view.dart`：计划模式整体双栏视图。
  - 新增 `task_plan_pool.dart`：左侧任务池和拖拽任务块。
  - 新增 `task_plan_timeline.dart`：右侧时间轴与槽位。
  - 新增 `task_plan_items.dart`：计划条、计划操作弹层和操作按钮。
  - 新增 `task_plan_feedback.dart`：拖拽反馈与时间选择 tile。
- 拆分 `group_list_screen.dart`：
  - 新增 `group_cards.dart`：待办首页工具按钮、倒数日卡、列表/宫格切换动画、分组卡片和分组操作弹层。
  - 新增 `group_search_view.dart`：待办/分组搜索结果和首页标题切换控件。
  - 新增 `group_done_view.dart`：已办主页、已办分组页、已办统计、时间线、已办任务操作面板。
- 拆分方式使用 Dart `part`，优先保留私有类和私有 helper 的可见性，降低纯搬代码引入行为变化的风险。
- 验证：
  - `D:\Tools\Flutter\bin\cache\dart-sdk\bin\dart.exe format ...`：已格式化本轮涉及的 11 个文件。
  - `flutter analyze`：通过，`No issues found`。
  - `flutter test`：通过，32 个测试全部通过。
### 2026-06-21 继续拆分与分支状态

- 用户追问 Codex 分支，并要求继续拆代码。
- 当前仓库存在 `codex/android-Focus_Timer` 分支，但本轮尝试从 `claude/split-screens` 切回时失败：
  - `git switch codex/android-Focus_Timer` 报错：无法创建 `.git/index.lock`，`Permission denied`。
  - 检查到外部 `git` 进程仍在运行并占用仓库；当前审批策略不允许提权或强制处理进程，因此暂时未切分支。
  - 当前工作区改动仍在 `claude/split-screens` 上；待外部 git 进程释放后，应执行 `git switch codex/android-Focus_Timer` 将工作区改动带回 Codex 分支。
- 继续拆分：
  - `group_detail_screen.dart`：
    - 新增 `group_detail_widgets.dart`，移动 `_BatchActionBar` 和 `_TaskMetaLine`。
    - 复用 `todo_color_picker.dart` 里的 `TaskColorSwatches` 和 `effectiveTaskColor()`，删除详情页内重复的颜色选择组件。
    - 备注：曾尝试把 `GroupDetailScreen` 的实例方法拆进 part 文件，确认 Dart 不支持 partial class 式续写实例方法，已回退并只保留安全的独立 widget 拆分。
  - `stats_screen.dart`：
    - 新增 `stats_widgets.dart`，移动 `_StatsContent`、范围选择、摘要、热力图、饼图、时间轴、图表开关和统计 tile 等纯展示组件。
    - 主文件保留页面入口、补录、图表管理和范围切换逻辑。
- 验证：
  - `D:\Tools\Flutter\bin\cache\dart-sdk\bin\dart.exe format ...`：已格式化本轮涉及的 15 个文件。
  - `flutter analyze`：通过，`No issues found`。
  - `flutter test`：通过，32 个测试全部通过。
### 2026-06-21 回到 Codex 分支并继续拆分

- 用户在本地终端成功执行 `git switch codex/android-Focus_Timer`，当前分支已回到 `codex/android-Focus_Timer`。
- 继续拆分 `group_list_screen.dart`：
  - 新增 `group_done_actions.dart`，移动已办任务相关顶层操作函数：
    - 计时入口、取消完成、删除撤销。
    - 目标设置、重命名、详情编辑、移动分组。
    - 日期格式、时间轴格式、跳转计时/统计、通用 toast。
  - `group_list_screen.dart` 进一步收敛为待办首页入口、全局动作面板和创建分组逻辑。
- 复核 `stats_screen.dart`：
  - 当前已拆为 `stats_screen.dart` + `stats_widgets.dart`。
  - 继续保留补录、记录编辑、图表管理等实例方法在主文件内，避免 Dart 不支持 partial class 导致的方法续写问题。
- 验证：
  - `D:\Tools\Flutter\bin\cache\dart-sdk\bin\dart.exe format ...`：已格式化本轮涉及文件。
  - `flutter analyze`：通过，`No issues found`。
  - `flutter test`：通过，32 个测试全部通过。

### 2026-06-21 继续大文件拆分收口

- 用户要求“直接全部都拆干净，到时候好修补”，本轮以结构重组为主，不新增功能。
- 继续拆分待办与计划模式：
  - `group_home_actions.dart` 拆为 `group_navigation_actions.dart`、`group_feedback_actions.dart`、`group_global_actions.dart`、`group_create_sheet.dart`。
  - `group_card_actions.dart` 拆出 `group_card_edit_sheets.dart`、`group_card_data_actions.dart`。
  - `group_detail_task_actions.dart` 拆出 `group_detail_task_action_sections.dart`。
  - `group_done_task_sheet.dart` 拆出 `group_done_task_action_sections.dart`。
  - `task_plan_pill_actions.dart` 拆出 `task_plan_pill_action_items.dart`、`task_plan_pill_edit_sheets.dart`。
- 继续拆分统计、计时和设置：
  - `stats_record_manager_sheet.dart` / `stats_manual_entry_sheet.dart` 共用 `_RecordEditFields`，保存逻辑移动到 `stats_record_actions.dart`。
  - `timer_screen.dart` 的启动流程移动到 `timer_start_flow_actions.dart`。
  - `timer_start_surface.dart` 拆出 `timer_start_widgets.dart`。
  - `timer_running_surface.dart` 拆出 `timer_running_widgets.dart`。
  - `profile_screen.dart` 拆为 `profile_widgets.dart`、`profile_theme_sheets.dart`、`profile_data_actions.dart`。
  - `trash_screen.dart` 拆为 `trash_widgets.dart`、`trash_actions.dart`。
  - `day_countdown_screen.dart` 拆为 `day_countdown_widgets.dart`、`day_countdown_dialog.dart`。
  - `todo_color_picker.dart` 改为 barrel export，拆出 `task_preview_line.dart`、`todo_color_swatches.dart`、`todo_icon_swatches.dart`。
- 当前结构结果：
  - `group_list_screen.dart`、`timer_screen.dart`、`profile_screen.dart`、`trash_screen.dart`、`day_countdown_screen.dart` 等主屏已收敛为入口/布局调度。
  - 继续保留 Dart `part` 方案用于同一 screen library 内的私有组件，避免为了拆文件把私有类公开化。
- 验证：
  - `D:\Tools\Flutter\bin\cache\dart-sdk\bin\dart.exe format lib test`：已完成全量格式化。
  - `flutter analyze`：通过，`No issues found`。
  - `flutter test`：通过，32 个测试全部通过。

### 2026-06-21 拆分后 Release APK 构建

- 用户确认继续后，开始构建本轮拆分后的 APK。
- 首次执行 `powershell -ExecutionPolicy Bypass -File tools\build_apk.ps1 -Mode release -SkipAnalyze -SkipTests`，工具层 10 分钟超时；检查发现旧 APK 时间为 `2026-06-21 01:58:58`，不能作为本轮新包。
- 改用完整 Flutter 路径并跳过依赖解析：
  - `D:\Tools\Flutter\bin\flutter.bat build apk --release --no-pub`
- 构建成功：
  - APK：`D:\Projects\Focus Timer\build\app\outputs\flutter-apk\app-release.apk`
  - 大小：`58.6MB`
  - 更新时间：`2026-06-21 05:49:18`
  - SHA256：`D03703C9644787F497A32B374EC66D57505B07A8C91CF7B02C7CA789234546D1`

### 2026-06-21 public-apis 可用方向记录

- 用户提到 `public-apis/public-apis`，要求评估有什么可用于 Focus Timer，并要求记录。
- 已加入 `docs/Codexplan.md` 的后期可选扩展：
  - 日历/节假日 API：最适合日倒计时、计划模式、待办日期、节假日/工作日提示。
  - Todoist / Notion / Clockify / WakaTime 类集成：适合后期可选导入、导出或同步，不作为核心功能。
  - 天气 API：可作为计划日上下文，用于户外/运动任务提示。
  - 每日一句/激励语 API：低优先级，只适合完成页或空状态点缀。
- 约束：
  - Android APK 仍保持本地优先。
  - 在待办、计时、统计稳定前，不接入云同步、第三方登录、外部存储用户数据的服务。

### 2026-06-21 导出路径提示优化

- 模拟器测试时发现“导出数据”虽然能成功，但弹出的 `/data/user/0/.../app_flutter/...json` 对普通安卓用户不友好。
- 用户确认“还是提示一下比较好”。
- 已修改 `profile_data_actions.dart`：
  - 导出完成弹窗改为先说明“数据已导出到应用数据目录，普通文件管理器可能无法直接打开这个位置”。
  - 保留技术路径为可选择文本。
  - 新增“复制路径”按钮，方便调试或后续取文件。
- 验证：
  - `flutter analyze`：通过，`No issues found`。

### 2026-06-21 待办交互与计时记录收口

- 用户澄清“再进入下一轮功能这里也一起做了”，本轮不只做小修，顺手把计时记录管理和统计联动补齐。
- 待办首页搜索：
  - 搜索状态增加 `PopScope`，返回键先退出搜索。
  - 搜索页外层增加空白点击退出，关闭时同步清空输入和 query。
  - 搜索输入框增加 `onTapOutside` 收键盘。
- 分组详情输入体验：
  - 底部输入框接入独立 `FocusNode`。
  - 系统返回键和左上角返回键都会优先收起键盘，再退出选择模式或页面。
  - 输入框支持点空白收键盘，缓解键盘顶起后退出不顺的问题。
- 计时记录入口：
  - “上次计时”卡片右侧三点从装饰图标改为真正的“更多操作”按钮。
  - 今日记录列表右侧也改为“更多操作”入口，弹出继续计时、重命名、修改时长、删除记录。
  - 计时记录改名、改时长、删除后触发统计快照和热力图缓存刷新。
- 统计联动：
  - 统计页补录、编辑、删除记录后统一刷新统计快照、热力图和计时页今日记录。
  - 统计时长格式修正：0 到 1 分钟之间显示 `<1 分钟`，避免显示成 `0 分钟`。
- 验证：
  - `dart format ...`：完成本轮涉及文件格式化。
  - `flutter analyze`：通过，`No issues found`。
  - `flutter test`：通过，32 个测试全部通过。
  - `tools\build_apk.ps1 -Mode release -SkipAnalyze -SkipTests`：构建成功。
  - 新 APK：`D:\Projects\Focus Timer\build\app\outputs\flutter-apk\app-release.apk`
  - 大小：`58.7MB`
  - 更新时间：`2026-06-21 07:58:20`
  - SHA256：`5689AAB5CBCEF3B3A3C942C24847596E06C562B0966B5638FFC62D8F03559915`
- 模拟器冒烟：
  - 已安装到 `127.0.0.1:16416`，安装结果 `Success`。
  - 包更新时间确认：`lastUpdateTime=2026-06-21 07:59:07`。
  - 启动后首页可见待办、搜索、计划模式、回收站、列表/宫格切换、更多、四个底部 Tab。
  - 搜索页确认有“关闭搜索”“搜索待办和分组”，空白区域可点击。
  - 计时页确认有“上次计时”“开始计时”“快速休息”，记录“更多操作”菜单可打开并显示继续计时、重命名、修改时长、删除记录。

### 2026-06-21 计时记录细节、视频凭证与统计图管理

- 用户确认设备测试由用户完成，本轮只做代码侧验证和 release 构建。
- 数据库：
  - Drift schema 升级到 10。
  - `focus_time` 和 `active_timer_session` 增加 `note`、`evidence_uri` 字段。
  - `AppConstants.databaseVersion` 同步为 10。
- 计时记录：
  - 计时状态、活跃会话、完成记录支持保存备注和视频凭证 URI。
  - 视频打卡完成系统相机录制后，会把返回 URI 写入计时记录。
  - 统计页补录和编辑记录表单增加“备注”“视频凭证”字段。
- 统计：
  - 统计图可见配置从无序集合改为有序列表。
  - 图表管理改为可拖拽排序，热力图、饼图、时间轴按用户配置顺序显示。
- 我的页：
  - 新增“本地工具”分组。
  - 增加计时统计、日倒计时、视频凭证入口。
  - 新增 `VideoEvidenceScreen`，读取本地视频打卡记录中的 URI，支持复制凭证 URI。
- 验证：
  - `dart format ...`：完成本轮涉及文件格式化。
  - `flutter analyze`：通过，`No issues found`。
  - `flutter test`：通过，32 个测试全部通过。
  - `tools\build_apk.ps1 -Mode release -SkipAnalyze -SkipTests`：构建成功。
  - 新 APK：`D:\Projects\Focus Timer\build\app\outputs\flutter-apk\app-release.apk`
  - 大小：`58.8MB`
  - 更新时间：`2026-06-21 08:58:19`
  - SHA256：`3013741108B46A18FE8D078CD2BFC13C49F143498AB8443F62B99C6E184E91CC`
### 2026-06-21 Release APK 构建恢复与 wakelock 依赖替换

- 构建失败原因已定位：新增 `wakelock_plus` 后间接引入 `package_info_plus 10.1.0`，其 Android 子工程会下载 `com.android.tools.build:gradle:8.12.1`。
- 用户本机执行 `flutter build apk --release` 时，Gradle 访问 `https://dl.google.com/.../gradle-8.12.1.pom` 出现 TLS 握手中断；这不是业务代码错误，也不是构建脚本未更新。
- 处理方式：
  - 从 `pubspec.yaml` 移除 `wakelock_plus`。
  - 在 `BackgroundTimerService` 增加 `setKeepScreenOn(bool enabled)`，复用现有 `com.focustimer/timer` MethodChannel。
  - 在 Android `TimerPlugin.kt` 增加 `setKeepScreenOn`，通过 `WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON` 实现屏幕常亮。
  - `TimerRunningSurface` 改为调用本地原生方法，不再依赖第三方 wakelock 插件。
- 用户本机重新执行 `flutter pub get` 后，已确认 `.flutter-plugins-dependencies` 中不再包含 `package_info_plus` / `wakelock_plus`。
- Release APK 已成功构建：
  - APK: `D:\Projects\Focus Timer\build\app\outputs\flutter-apk\app-release.apk`
  - 更新时间：`2026-06-21 20:47:27`
  - 大小：`61,857,116 bytes`，约 `59.0MB`
  - SHA256: `675D97D1A00EF140EB3B5C33E5746B48F05799034292271E5EE42AB2F2ECE5F4`
- 备注：
  - 本轮 `flutter analyze --no-pub` / `flutter test --no-pub` 在 Codex 沙盒中超时，未作为业务失败处理。
  - 后续应优先用用户本机或正常终端执行 Flutter/Gradle 命令；Codex 沙盒对 Flutter SDK/Gradle 缓存写入和 Java/Gradle daemon 行为不稳定。

### 2026-06-21 每日打卡与统计边界调整

- 用户指出“每日起床睡觉不是计时，它是一个打卡功能”，本轮按产品边界重新整理：
  - 计时记录继续表示一段有时长的专注/休息/视频凭证。
  - 起床、睡觉改为 `daily_logs` 打卡记录，表示某个时间点。
  - 统计页负责聚合计时记录和打卡记录，但不把起床/睡觉计入专注时长。
- 参考方向：
  - Todoist 官方功能页：`https://www.todoist.com/features`，核心是任务捕获、项目/优先级/标签/过滤器、提醒、Today/Upcoming 和完成趋势。
  - public productivity apps 官方功能页：`https://www.ticktick.com/features`，产品结构把任务、日历、习惯、番茄/专注、倒数日和统计分开。
  - 结论：Focus Timer 也应坚持 `待办 / 计时 / 打卡或习惯 / 倒数日 / 统计聚合` 的数据边界，不把所有东西塞进计时类型。
- 数据库：
  - 新增 `DailyLogs` 表，包含 `dayNum`、`type`、`loggedAt`、`note` 等字段。
  - `AppConstants.databaseVersion` 与 Drift `schemaVersion` 升到 `13`。
  - v12 迁移会把旧 `focus_time.type == typeSleep` 记录搬入 `daily_logs`，再删除旧计时记录。
  - v13 迁移负责把旧统计图配置补上 `dailyLog` 图表，但用户之后在图表管理里关闭它会被尊重。
  - 为已经装过早期 v12 APK 的设备增加运行时兜底：统计页/导出前会幂等整理旧 `typeSleep` 记录。
- UI/功能：
  - 计时入口移除“起床睡觉”，视频凭证保留在计时侧。
  - 统计页新增 `打卡` 图表卡，支持今天起床/睡觉快捷记录。
  - 统计时间轴合并展示计时记录和打卡记录。
  - 图表管理支持 `打卡` 图表显示/隐藏/排序。
  - 导出数据新增 `导出打卡`，`全部数据` 会包含 `dailyLogs`；JSON 里为打卡补 `typeLabel` 和 `loggedAtIso`。
- 测试/验证：
  - `dart format`：完成本轮涉及文件格式化。
  - `dart analyze`：通过，`No issues found!`。
  - 新增 `test/daily_log_repository_test.dart`，覆盖 daily log 保存/查询和旧睡眠计时记录迁移。
  - `flutter test --no-pub test\daily_log_repository_test.dart` 在 Codex 沙盒 180 秒超时，未证明失败；建议在用户本机 PowerShell 跑。
  - `dart run build_runner build --delete-conflicting-outputs` 本轮被沙盒网络限制挡住，报 `Got socket error trying to find package riverpod_generator at https://pub.dev`；本轮未改 Drift 表结构生成代码，`database.g.dart` 的 daily_logs 生成内容来自上一轮已生成结果。

### 2026-06-21 统计底部范围控件与计时时钟样式

- 用户希望统计页日/周/月/年切换接近截图二：改为底部悬浮胶囊控制条。
- 统计页调整：
  - 移除顶部日/周/月/年 ChoiceChip。
  - 日/周/月/年和上一段/下一段合并为底部悬浮范围控制。
  - 列表底部留白增加，避免被悬浮控件遮挡。
- 计时运行页调整：
  - 暂停态颜色从 tertiary 紫粉色改为当前主题 primary 体系，避免和主题不统一。
  - 新增 `TimerClockStyle`：环形、数字、翻页感。
  - 计时设置页新增“时钟样式”入口。
  - 运行页根据设置切换显示样式，先提供三种可测试方向，后续按用户偏好再深化动画。
- 验证：
  - `dart format`：完成涉及文件格式化。
  - `dart analyze`：通过，`No issues found!`。

### 2026-06-21 统计、计时、搜索、打卡、数据闭环优化

- 用户选择继续优化 1/2/3/4/5 五个方向，本轮先做可落地闭环，不碰大视觉重构。
- 统计页：
  - 热力图日期格支持点击，弹出当天明细：专注总时长、记录数、打卡数、当天计时和打卡列表。
  - 饼图图例支持点击，弹出对应计时类型的记录列表和总时长。
  - 时间轴中的打卡记录支持点击编辑。
- 计时记录：
  - 现有编辑弹层已具备名称、类型、日期、开始时间、时长、备注、视频凭证。
  - 本轮补充“结束时间”编辑，修改结束时间会自动反算时长；修改开始时间或时长会同步刷新结束时间。
- 打卡：
  - `DailyLogRepository` 新增 `updateLog`。
  - 打卡编辑弹层支持修改起床/睡觉类型、日期、时间、备注。
  - 打卡编辑弹层支持删除打卡。
- 待办搜索：
  - 搜索结果按未完成/已完成拆分。
  - 任务结果显示重点、优先级、日期、预计时长等已有字段提示。
  - 已完成任务显示删除线，降低和未完成任务混淆。
- 数据导出/恢复：
  - 导出页新增“恢复数据”入口提示。
  - 先明确导入恢复需要覆盖/追加/去重/视频路径校验规则，避免误操作损坏本地数据。
- 验证：
  - `dart format`：完成涉及文件格式化。
  - `dart analyze`：通过，`No issues found!`。
  - `test/daily_log_repository_test.dart` 增加 daily log 更新/删除测试。

### 2026-06-21 1-5 二轮补齐：自定义范围、明细编辑、凭证清理、筛选提示、导入预检

- 用户继续选择 `1/2/3/4/5`，本轮继续补功能闭环，不做大视觉重构。
- 统计：
  - 范围类型新增 `custom`，统计页底部范围控制增加 `自定`。
  - `自定` 调用系统日期范围选择器，统计快照按自定义起止日期读取计时和打卡。
  - 自定义范围支持上一段/下一段，按当前范围长度平移。
  - 热力图日期明细里的计时记录和打卡记录现在可点击进入对应编辑弹层。
- 计时：
  - 计时记录编辑页的视频凭证字段新增 `清除凭证`，不用手动删除 URI。
- 待办：
  - 搜索空状态增加筛选提示：重点、P1/P2、有日期、已完成，给后续正式筛选页留入口语义。
- 打卡：
  - 打卡面板增加本范围趋势摘要：起床次数、睡觉次数、覆盖天数。
- 数据：
  - 恢复数据入口新增 JSON 预检。
  - 预检只解析并统计 JSON 中的 `taskLists/tasks/taskPlans/focusTimes/dailyLogs/videoEvidence` 数量，不写入数据库。
- 验证：
  - `dart format`：完成涉及文件格式化。
  - `dart analyze`：通过，`No issues found!`。

### 2026-06-22 数据恢复、视频凭证、待办提醒重复、计时时钟样式

- 用户反馈：
  - JSON 恢复不能依赖剪贴板粘贴，应支持选择文件/多选文件。
  - 视频打卡不应只复制路径或跳外部播放器，应能在应用内查看。
  - 待办需要任务级置顶/重点、提醒、重复任务。
  - 计时时钟样式需要更多可选项。
  - 权限应围绕 Todo/计时真实场景补齐，但不滥加无关权限。
- 资料结论：
  - Android 文件恢复优先走系统文件选择器/SAF，多选 JSON，避免剪贴板长度限制。
  - 视频凭证流程采用：拍摄或选择已有视频 -> 复制到 `Download/Focus Timer/Videos` -> JSON 导出保留索引 -> 应用内播放。
  - Todo 类应用核心权限应主要是通知、精确提醒、相机/所选媒体、前台服务/常亮；不加入位置、联系人、日历等无关权限。
- Android 原生：
  - `TimerPlugin` 新增 `pickJsonFiles`、`pickVideoFile`、`openFile`、`scheduleTaskReminder`、`cancelTaskReminder`。
  - 新增 `VideoPlayerActivity`，用原生 `VideoView + MediaController` 做应用内视频播放。
  - 新增 `TaskReminderReceiver`，由 `AlarmManager` 到点触发本地待办提醒通知。
  - `AndroidManifest.xml` 增加 `CAMERA`、`SCHEDULE_EXACT_ALARM`、Android 12 及以下 `READ_EXTERNAL_STORAGE`，相机硬件设为非必需；注册视频播放 Activity 和提醒 Receiver。
- 数据：
  - `Tasks` 表新增 `isPinned`、`pinnedAt`、`reminderAt`、`repeatRule`。
  - Drift `schemaVersion` 升到 `14`，v14 迁移添加上述列。
  - 清理 build_runner 旧缓存后重新生成 `database.g.dart`。
- 待办：
  - 任务列表排序新增置顶优先：`isPinned` / `pinnedAt` / `priority` / `sortOrder`。
  - 待办详情新增置顶开关、提醒时间、重复规则（不重复/每天/每周/每月）。
  - 更多操作新增“置顶/取消置顶”。
  - 完成重复任务时创建下一条未完成任务，并继承标题、备注、优先级、预计时长、重点、颜色、重复规则；提醒时间按下一周期迁移。
  - 完成任务会取消当前提醒；保存提醒会调度系统提醒。
- 视频凭证：
  - 视频打卡入口支持“去拍摄”和“选择视频”，选择的视频会复制到 `Download/Focus Timer/Videos`。
  - 视频凭证列表新增播放按钮，打开应用内原生播放器。
  - 计时记录操作新增“播放视频凭证”和“复制视频位置”。
  - 统计记录编辑/补录页新增选择视频；编辑页可播放当前视频凭证。
- 数据导出/恢复：
  - 恢复入口从粘贴 JSON 改为系统文件多选 JSON 预检。
  - 预检显示每个 JSON 文件的 app、导出范围和 `taskLists/tasks/taskPlans/focusTimes/dailyLogs/videoEvidence` 数量，不写数据库。
- 计时：
  - `TimerClockStyle` 从 3 种扩展到 5 种：环形、数字、翻页感、进度条、极简。
  - 计时设置页补充新样式标签/说明/图标。
- 验证：
  - `dart run build_runner clean` 后 `dart run build_runner build --delete-conflicting-outputs` 成功，生成新 Drift 字段。
  - `dart analyze --format=machine` 首次因分析服务器无法写 `C:\Users\Andyxu\AppData\Local\.dartServer\.plugin_manager` 失败；将 `LOCALAPPDATA/APPDATA` 指到项目内后通过，输出为空。
  - `flutter test test\task_provider_test.dart test\timer_provider_test.dart` 超过 180 秒超时，未证明失败。
  - `flutter build apk --debug` 超过 300 秒超时，未生成可确认的新 APK；当前需用户本机或下一轮继续构建验证 Kotlin/Android 编译。

### 2026-06-22 用户本机构建完成

- 用户反馈构建已完成。
- Codex 确认 APK 输出：
  - Debug APK：`D:\Projects\Focus Timer\build\app\outputs\flutter-apk\app-debug.apk`
    - 修改时间：`2026-06-22 01:12:47`
    - 大小：`190.81 MB`
    - SHA256：`9C0FC15121A561410C2F47F4952B149A3C157F80E8AB9EEE37F37D97C876FAAD`
  - Release APK：`D:\Projects\Focus Timer\build\app\outputs\flutter-apk\app-release.apk`
    - 修改时间：`2026-06-21 23:56:10`
    - 大小：`59.48 MB`
    - SHA256：`56E8F6959E2CB900751DA30B7A1FC0D6C5A746B91EAF31BA570D1988B28A221E`
- 说明：
  - Debug 包体积明显更大是正常现象，包含调试符号和未优化内容。
  - 用户如果只做功能测试，可优先安装最新 `app-debug.apk`；如果测试接近真实使用体验，应安装 `app-release.apk`。

### 2026-06-22 待办 / 计时 / 统计联动闭环

- 按用户给出的“打通待办、计时、统计”计划继续实现，本轮重点不做整体 UI 重绘，只补核心数据闭环和必要入口。
- 数据库：
  - `focus_time` 与 `active_timer_session` 新增可空 `taskId/listId/planId`。
  - Drift schema 升到 `15`，迁移为旧库补充上述字段。
  - `database.g.dart` 已通过 build_runner 重新生成。
- 计时：
  - `TimerState`、`TimerNotifier.createTimer()`、运行中会话、保存记录均支持 `taskId/listId/planId`。
  - 待办详情、计划模式、已办任务、继续计时等入口会把任务/分组/计划关联写入计时记录。
  - 计时首页新增“从待办开始”，并按今日计划、今日/逾期、重点、置顶、优先级排序展示前 6 个任务。
  - 运行页显示当前来源；关联待办的计时停止时可选择“仅保存”或“保存并完成待办”，不自动完成。
  - 计时记录卡片和操作面板显示来源信息；如果记录有 `listId` 且来源分组仍存在，可从记录操作打开对应分组。
- 待办：
  - 首页新增智能视图入口：今日、逾期、重点、置顶、提醒、重复、已计划。
  - 智能视图基于现有任务字段和当天计划筛选，不新增数据库表。
  - 待办详情新增反向联动摘要：已专注、预计、计划数、最近关联计时、最近计划。
  - `TaskNotifier.completeIfActive()` 用于计时停止时“保存并完成待办”，并保留重复任务生成逻辑。
- 统计：
  - `StatsSnapshot` 现在同时读取计时记录、待办、分组、计划和作息打卡。
  - 新增任务完成数、完成率、逾期数、重点完成数、关联耗时、计划命中、预计 vs 实际、按待办/分组归因。
  - 统计时间轴中计时记录显示来源任务/分组/计划信息。
- 数据导出：
  - Drift `toJson()` 会导出新增关联字段。
  - 视频凭证索引加入 `taskId/listId/planId`。
  - 恢复预检会统计 JSON 中带关联字段的计时记录数量，仍只预检不写入数据库。
- 验证：
  - `dart analyze --format=machine` 通过，输出为空。
  - `flutter test test\database_test.dart test\task_provider_test.dart test\task_repository_test.dart test\timer_provider_test.dart` 通过，31 个测试全过。
  - 本轮未重新构建 APK；下一步可由用户或 Codex 继续执行 release/debug 构建后上机测。

### 2026-06-22 非 UI 功能补齐：恢复、提醒、计划命中

- 按用户要求继续做“除了 UI 以外的功能”，本轮不做视觉/动画调整。
- 数据恢复：
  - 新增 `lib/shared/services/data_restore_service.dart`。
  - 导出页的 JSON 恢复从“只预检”改为“预检后可追加恢复”。
  - 恢复策略为追加写入 + 去重 + ID 重映射，不覆盖现有数据。
  - 已支持恢复 `taskLists/tasks/taskPlans/focusTimes/dailyLogs`，并保持 `taskId/listId/planId` 关联指向新 ID。
  - 已支持恢复日倒计时文件 `countdown.json`。
  - 已支持导出和恢复 `timerSettings`，恢复到 `timer_settings.json`。
  - 已新增 `appearance_settings.json`，持久化主题颜色、深浅色模式、待办列表/宫格布局。
  - JSON 导出/恢复已覆盖 `appearanceSettings`。
  - 恢复完成后刷新待办、计划、计时、统计、热力图、日倒计时、计时设置相关 provider。
- 待办提醒：
  - `TaskRepository` 新增 `getFutureReminderTasks()`。
  - 应用首页首次加载时会重排未来未完成待办提醒。
  - 分组移入回收站/永久删除时取消该分组内任务提醒；恢复分组时重新调度未来提醒。
  - 删除任务会取消提醒；恢复任务会重新调度提醒。
- 待办/计划一致性：
  - `moveTaskToList()` 现在会同步移动该任务的计划记录到目标分组，避免计划模式和统计来源错位。
  - 任务增删改、移动、排序后同步刷新 `allTaskListProvider`，计时页“从待办开始”和统计不会拿旧任务列表。
- 权限和平台能力：
  - `BackgroundTimerService` 新增 `canScheduleExactAlarms()`、`openExactAlarmSettings()`。
  - Android `TimerPlugin` 新增精确闹钟能力查询和系统设置入口。
  - `PermissionService` 的启动提示改为真实用途：通知、精确提醒、相机；不再提示不需要的存储权限。
- 统计：
  - `StatsSnapshot` 新增真实计划命中计算：绑定 `planId` 或计时开始时间落在计划时段内都算命中。
  - 统计联动卡增加“计划 vs 实际”命中率数据。
- 测试：
  - 新增 `test/data_restore_service_test.dart`，覆盖 JSON 预检、追加恢复、ID 重映射、视频索引、日倒计时/计时设置/外观设置恢复、重复导入去重。
  - `test/task_repository_test.dart` 新增“移动任务同步移动计划”的测试。
  - 已运行 `dart analyze --format=machine`，通过，输出为空。
  - 已运行 `flutter test test\data_restore_service_test.dart test\database_test.dart test\task_repository_test.dart test\task_provider_test.dart test\timer_provider_test.dart`，通过，34 个测试全过。
  - 已运行 `powershell -ExecutionPolicy Bypass -File tools\build_apk.ps1 -Mode release -SkipAnalyze -SkipTests`，构建成功。
  - 新 APK：`D:\Projects\Focus Timer\build\app\outputs\flutter-apk\app-release.apk`，大小约 `60.1MB`。
