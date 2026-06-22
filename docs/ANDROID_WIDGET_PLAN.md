# Android 小组件实现方案

**现状**: Flutter 本身不支持小组件开发，需要混合开发（Kotlin + Flutter）

---

## 1. 技术架构

### 1.1 混合开发模型

```
┌─────────────────────────────┐
│   Flutter 应用              │
│ (Riverpod + Drift UI)       │
└────────────┬────────────────┘
             │
        MethodChannel
        ("focus_timer/widget")
             │
        ┌────▼──────────────┐
        │ Kotlin 原生层     │
        │ (AppWidgetProvider)│
        └────┬──────────────┘
             │ 共享
        ┌────▼──────────────┐
        │  SQLite DB       │
        │  SharedPrefs     │
        └───────────────────┘
```

**数据流**:
1. Flutter Riverpod 计时状态变化
2. 通过 MethodChannel 调用 Kotlin 方法
3. Kotlin 更新 SharedPreferences / SQLite
4. AppWidgetManager 触发小组件刷新
5. 小组件读取数据，UI 更新

---

## 2. 可实现的小组件类型

### 2.1 番茄钟小组件 (1×1 ~ 4×4)

**显示内容**:
- 大时间数字 (HH:MM:SS)
- 计时名称 (1 行文字)
- 进度圆环
- 暂停/继续/停止按钮

**交互**:
- 点击暂停按钮 → 暂停计时
- 点击继续按钮 → 恢复计时
- 点击停止按钮 → 停止计时
- 长按打开应用

**更新频率**: 每秒（通过 AlarmManager.setExact()）

```kotlin
// android/app/src/main/kotlin/FocusWidgetProvider.kt
class FocusWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val prefs = context.getSharedPreferences("FocusTimerWidget", Context.MODE_PRIVATE)
        val currentTime = prefs.getString("currentTime", "00:00:00") ?: "00:00:00"
        val focusName = prefs.getString("focusName", "专注计时") ?: "专注计时"
        val progress = prefs.getFloat("progress", 0f)
        val isRunning = prefs.getBoolean("isRunning", false)

        val views = RemoteViews(context.packageName, R.layout.widget_focus)
        views.setTextViewText(R.id.time_text, currentTime)
        views.setTextViewText(R.id.focus_name, focusName)
        views.setProgressBar(R.id.progress_ring, 100, (progress * 100).toInt(), false)

        // 按钮点击事件
        val pauseIntent = Intent(context, FocusWidgetProvider::class.java).apply {
            action = ACTION_PAUSE_FOCUS
        }
        val pausePendingIntent = PendingIntent.getBroadcast(
            context, 0, pauseIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.pause_btn, pausePendingIntent)

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        when (intent.action) {
            ACTION_PAUSE_FOCUS -> {
                // 通过 MethodChannel 调用 Flutter
                MethodChannelManager.pauseFocus()
            }
            ACTION_RESUME_FOCUS -> {
                MethodChannelManager.resumeFocus()
            }
            ACTION_STOP_FOCUS -> {
                MethodChannelManager.stopFocus()
            }
        }
    }

    companion object {
        const val ACTION_PAUSE_FOCUS = "com.focustimer.PAUSE_FOCUS"
        const val ACTION_RESUME_FOCUS = "com.focustimer.RESUME_FOCUS"
        const val ACTION_STOP_FOCUS = "com.focustimer.STOP_FOCUS"
    }
}
```

**layout 文件** (`android/app/src/main/res/layout/widget_focus.xml`):
```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:gravity="center"
    android:padding="8dp"
    android:background="#F5F5F5">

    <TextView
        android:id="@+id/time_text"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="00:00:00"
        android:textSize="32sp"
        android:textStyle="bold"
        android:gravity="center"
        android:fontFamily="monospace" />

    <TextView
        android:id="@+id/focus_name"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="专注计时"
        android:textSize="14sp"
        android:gravity="center"
        android:layout_marginTop="4dp" />

    <ProgressBar
        android:id="@+id/progress_ring"
        style="?android:attr/progressBarStyleHorizontal"
        android:layout_width="match_parent"
        android:layout_height="4dp"
        android:layout_marginTop="8dp" />

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="horizontal"
        android:gravity="center"
        android:layout_marginTop="8dp">

        <Button
            android:id="@+id/pause_btn"
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:layout_weight="1"
            android:text="暂停"
            android:layout_marginEnd="4dp" />

        <Button
            android:id="@+id/stop_btn"
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:layout_weight="1"
            android:text="停止" />
    </LinearLayout>
</LinearLayout>
```

**清单文件更新** (`android/app/src/main/AndroidManifest.xml`):
```xml
<receiver
    android:name=".FocusWidgetProvider"
    android:exported="true">
    <intent-filter>
        <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
        <action android:name="com.focustimer.PAUSE_FOCUS" />
        <action android:name="com.focustimer.RESUME_FOCUS" />
        <action android:name="com.focustimer.STOP_FOCUS" />
    </intent-filter>
    <meta-data
        android:name="android.appwidget.provider"
        android:resource="@xml/widget_focus_info" />
</receiver>

<appwidget-provider
    android:name=".FocusWidgetProvider"
    android:minWidth="180dp"
    android:minHeight="110dp"
    android:updatePeriodMillis="0"
    android:initialLayout="@layout/widget_focus" />
```

---

### 2.2 待办列表小组件

**显示内容**:
- 当日待办 TOP 3
- 每项可勾选
- 显示完成度

**交互**:
- 点击任务 → 标记完成/取消
- 长按打开应用

```kotlin
class TodoWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val views = RemoteViews(context.packageName, R.layout.widget_todo)
        
        // 从数据库获取今日任务（通过 Flutter）
        val tasks = MethodChannelManager.getTodayTasks()
        
        for (i in 0..minOf(2, tasks.size - 1)) {
            val task = tasks[i]
            val taskViewId = when (i) {
                0 -> R.id.task_1
                1 -> R.id.task_2
                else -> R.id.task_3
            }
            
            views.setTextViewText(taskViewId, task.title)
            
            val checkIntent = Intent(context, TodoWidgetProvider::class.java).apply {
                action = ACTION_TOGGLE_TASK
                putExtra("taskId", task.id)
            }
            val checkPendingIntent = PendingIntent.getBroadcast(
                context, task.id, checkIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(taskViewId, checkPendingIntent)
        }
        
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        when (intent.action) {
            ACTION_TOGGLE_TASK -> {
                val taskId = intent.getIntExtra("taskId", 0)
                MethodChannelManager.toggleTask(taskId)
            }
        }
    }

    companion object {
        const val ACTION_TOGGLE_TASK = "com.focustimer.TOGGLE_TASK"
    }
}
```

---

### 2.3 热力图小组件 (4×4)

**显示内容**:
- 当月迷你热力图
- 总专注时长
- 活跃天数

**更新频率**: 每天 00:00

```kotlin
class HeatmapWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val views = RemoteViews(context.packageName, R.layout.widget_heatmap)
        
        // 获取当月热力图数据
        val monthlyStats = MethodChannelManager.getMonthlyStats()
        
        views.setTextViewText(R.id.total_hours, "${monthlyStats.totalHours}h")
        views.setTextViewText(R.id.active_days, "${monthlyStats.activeDays} 天")
        
        // 绘制 7x4 热力图（简化版）
        drawMiniHeatmap(views, monthlyStats.dailyData)
        
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun drawMiniHeatmap(views: RemoteViews, dailyData: Map<Int, Int>) {
        // 通过 ImageView 绘制热力图（或用 Canvas 生成 Bitmap）
        val bitmap = generateHeatmapBitmap(dailyData)
        views.setImageViewBitmap(R.id.heatmap_image, bitmap)
    }

    private fun generateHeatmapBitmap(dailyData: Map<Int, Int>): Bitmap {
        // 使用 Canvas 绘制热力图
        val bitmap = Bitmap.createBitmap(280, 100, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        
        // 绘制每个格子（颜色深浅代表时长）
        var x = 0
        for ((day, minutes) in dailyData.entries) {
            val color = getHeatmapColor(minutes)
            canvas.drawRect(x.toFloat(), 0f, (x + 10).toFloat(), 100f, Paint().apply {
                this.color = color
            })
            x += 12
        }
        
        return bitmap
    }

    private fun getHeatmapColor(minutes: Int): Int {
        return when {
            minutes == 0 -> 0xFFEBEDF0.toInt()
            minutes in 1..30 -> 0xFFC6E48B.toInt()
            minutes in 31..60 -> 0xFF7BC96F.toInt()
            minutes in 61..120 -> 0xFF239A3B.toInt()
            else -> 0xFF0E4429.toInt()  // GitHub 风格
        }
    }
}
```

---

## 3. Flutter ↔ Kotlin 通信

### 3.1 MethodChannel 定义

```dart
// flutter/presentation/services/widget_channel_service.dart
class WidgetChannelService {
  static const _channel = MethodChannel('cn.focus_timer/widget');

  static Future<void> updateFocusWidget({
    required String currentTime,
    required String focusName,
    required double progress,
    required bool isRunning,
  }) async {
    try {
      await _channel.invokeMethod('updateFocusWidget', {
        'currentTime': currentTime,
        'focusName': focusName,
        'progress': progress,
        'isRunning': isRunning,
      });
    } catch (e) {
      print('Error updating widget: $e');
    }
  }

  static Future<void> pauseFocus() async {
    try {
      await _channel.invokeMethod('pauseFocus');
    } catch (e) {
      print('Error pausing focus: $e');
    }
  }

  static Future<List<Map>> getTodayTasks() async {
    try {
      final result = await _channel.invokeMethod('getTodayTasks');
      return List<Map>.from(result);
    } catch (e) {
      print('Error getting today tasks: $e');
      return [];
    }
  }
}
```

### 3.2 Kotlin 端实现

```kotlin
// android/app/src/main/kotlin/cn/focus_timer/WidgetChannelHandler.kt
class WidgetChannelHandler(
    private val context: Context,
    private val database: Database  // Drift 数据库访问
) {
    fun setupChannel(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "cn.focus_timer/widget"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "updateFocusWidget" -> {
                    val currentTime = call.argument<String>("currentTime") ?: "00:00:00"
                    val focusName = call.argument<String>("focusName") ?: ""
                    val progress = call.argument<Double>("progress") ?: 0.0
                    val isRunning = call.argument<Boolean>("isRunning") ?: false

                    updateFocusWidgetUI(currentTime, focusName, progress, isRunning)
                    result.success(null)
                }
                "getTodayTasks" -> {
                    val tasks = getTodayTasks()
                    result.success(tasks)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun updateFocusWidgetUI(
        currentTime: String,
        focusName: String,
        progress: Double,
        isRunning: Boolean
    ) {
        val prefs = context.getSharedPreferences("FocusTimerWidget", Context.MODE_PRIVATE)
        prefs.edit().apply {
            putString("currentTime", currentTime)
            putString("focusName", focusName)
            putFloat("progress", progress.toFloat())
            putBoolean("isRunning", isRunning)
            apply()
        }

        // 触发小组件刷新
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val componentName = ComponentName(context, FocusWidgetProvider::class.java)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)
        
        val intent = Intent(context, FocusWidgetProvider::class.java).apply {
            action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds)
        }
        context.sendBroadcast(intent)
    }

    private fun getTodayTasks(): List<Map<String, Any>> {
        val today = Calendar.getInstance()
        val dayNum = calculateDayNum(today)
        
        // 调用 Drift 查询
        val tasks = runBlocking {
            database.taskDao.getTasks(userId = 1, dayNum = dayNum)
        }
        
        return tasks.map {
            mapOf(
                "id" to it.id,
                "title" to it.title,
                "state" to it.state
            )
        }
    }
}
```

### 3.3 MainActivity 集成

```kotlin
// android/app/src/main/kotlin/cn/focus_timer/MainActivity.kt
class MainActivity: FlutterActivity() {
    private lateinit var widgetHandler: WidgetChannelHandler

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        val database = (application as MyApplication).database
        widgetHandler = WidgetChannelHandler(this, database)
        widgetHandler.setupChannel(flutterEngine)
    }
}
```

---

## 4. Flutter 端集成

### 4.1 定时更新小组件

```dart
// presentation/providers/widget_update_provider.dart
final widgetUpdateProvider = Provider((ref) {
  final focusState = ref.watch(focusTimeProvider);
  
  ref.listen(focusTimeProvider, (_, next) {
    next.whenData((focus) {
      if (focus != null) {
        _updateWidgets(focus);
      }
    });
  });
  
  return null;
});

Future<void> _updateWidgets(FocusTimeInfo focus) async {
  final displayTime = _formatTime(focus.durationMs);
  final progress = focus.scheduledTime != null && focus.scheduledTime! > 0
      ? focus.durationMs / focus.scheduledTime!
      : 0.0;
  
  await WidgetChannelService.updateFocusWidget(
    currentTime: displayTime,
    focusName: focus.name,
    progress: progress,
    isRunning: focus.state == FocusTimeConstants.STATE_FOCUSING,
  );
}

String _formatTime(int ms) {
  final seconds = ms ~/ 1000;
  final h = seconds ~/ 3600;
  final m = (seconds % 3600) ~/ 60;
  final s = seconds % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
}
```

### 4.2 处理小组件按钮点击

```dart
// presentation/services/widget_action_handler.dart
class WidgetActionHandler {
  static void setupPlatformChannel(MethodChannel channel) {
    channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'pauseFocus':
          // 触发 Riverpod notifier
          // ref.read(focusTimeProvider.notifier).pauseFocus();
          break;
        case 'resumeFocus':
          // ref.read(focusTimeProvider.notifier).resumeFocus();
          break;
        case 'stopFocus':
          // ref.read(focusTimeProvider.notifier).stopFocus();
          break;
      }
    });
  }
}
```

---

## 5. 项目配置变更

### 5.1 pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  # ... 其他依赖

dev_dependencies:
  flutter_test:
    sdk: flutter
  # 无需额外依赖，通过 Platform Channel 调用原生
```

### 5.2 android/app/build.gradle

```gradle
android {
    namespace "com.focustimer"
    compileSdkVersion 34

    defaultConfig {
        applicationId "com.focustimer"
        minSdkVersion 26  // API 26 以上支持小组件
        targetSdkVersion 34
        // ...
    }
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.8.10"
    // ... 其他依赖
}
```

### 5.3 android/app/src/main/AndroidManifest.xml

```xml
<manifest>
    <!-- 小组件权限 -->
    <uses-permission android:name="android.permission.BIND_APPWIDGET" />
    
    <application>
        <!-- ... 其他组件 -->
        
        <!-- 番茄钟小组件 -->
        <receiver
            android:name=".FocusWidgetProvider"
            android:exported="true">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
                <action android:name="com.focustimer.PAUSE_FOCUS" />
                <action android:name="com.focustimer.RESUME_FOCUS" />
                <action android:name="com.focustimer.STOP_FOCUS" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_focus_info" />
        </receiver>

        <!-- 待办列表小组件 -->
        <receiver
            android:name=".TodoWidgetProvider"
            android:exported="true">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
                <action android:name="com.focustimer.TOGGLE_TASK" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_todo_info" />
        </receiver>

        <!-- 热力图小组件 -->
        <receiver
            android:name=".HeatmapWidgetProvider"
            android:exported="true">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_heatmap_info" />
        </receiver>
    </application>
</manifest>
```

---

## 6. 工作量估算

| 任务 | 工作量 |
|------|--------|
| 番茄钟小组件（Kotlin + Layout） | 3 天 |
| 待办小组件（Kotlin + Layout） | 2 天 |
| 热力图小组件（Kotlin + 绘图） | 3 天 |
| MethodChannel 双向通信 | 2 天 |
| Flutter 端集成 | 2 天 |
| 测试与优化 | 3 天 |
| **总计** | **15 天** |

---

## 7. 集成到项目时间表

### 修改后的 MVP 时间表

```
W1: 项目初始化 + Drift 数据库
W2-W3: 计时引擎 + Timer Screen
W4: 待办列表（基础）
W5-W6: 热力图 + 分析
W6.5: Android 小组件集成 ← 新增 2.5 周
├─ W6.5: 番茄钟小组件
├─ W7: 待办/热力图小组件
└─ W7.5: 双向通信测试

总时间: 6 周 → 8.5 周
```

---

## 8. 优缺点分析

### ✅ 优点

- 完全可交互（暂停/继续/停止）
- 用户体验接近参考应用
- 可实时更新（无需打开应用）
- 支持多个小组件同时显示

### ⚠️ 缺点

- 需要写 Kotlin/XML 代码（增加维护复杂度）
- 数据同步依赖 SharedPreferences（不是实时）
- 仅支持 Android（iOS 无小组件概念）
- 首次编译时间增加（混合开发）
- 小组件 UI 受系统限制（不如 Flutter 灵活）

### 🎯 建议

- **MVP 中先不做**，验证核心功能可用
- **V1.1 版本加小组件**（用户反馈验证需求）
- 这样可以 6 周而不是 8.5 周上线 MVP
- 小组件是"锦上添花"，不是必须品

---

## 总结

| 方案 | MVP 时间 | 小组件 | 备注 |
|------|---------|--------|------|
| **纯 Flutter** | 6 周 | ❌ 无 | 快速上线 |
| **Flutter + 小组件** | 8.5 周 | ✅ 有 | 接近原版体验 |

**你的选择**:
1. **先做 MVP（6 周）** 再加小组件 → 推荐
2. **直接做完整版（8.5 周）** 包含小组件
3. **先做其他，后期加小组件** → 最灵活
