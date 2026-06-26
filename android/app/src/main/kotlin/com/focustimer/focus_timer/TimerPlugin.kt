package com.focustimer.focus_timer

import android.app.Activity
import android.app.AlarmManager
import android.app.NotificationManager
import android.content.ClipData
import android.content.ActivityNotFoundException
import android.content.ContentValues
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.Settings
import android.provider.MediaStore
import android.view.WindowManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class TimerPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var activityBinding: ActivityPluginBinding? = null
    private var pendingVideoResult: MethodChannel.Result? = null
    private var pendingVideoOutput: SharedFileOutput? = null
    private var pendingJsonPickResult: MethodChannel.Result? = null
    private var pendingVideoPickResult: MethodChannel.Result? = null

    companion object {
        private const val VIDEO_CHECK_IN_REQUEST = 8408
        private const val JSON_PICK_REQUEST = 8409
        private const val VIDEO_PICK_REQUEST = 8410
        private const val ROOT_FOLDER = "Focus Timer"
        private const val VIDEO_FOLDER = "Videos"
        private const val EXPORT_FOLDER = "Exports"
        private const val VIDEO_MIME_TYPE = "video/mp4"
        private const val JSON_MIME_TYPE = "application/json"
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "com.focustimer/timer")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        activityBinding = binding
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityBinding?.removeActivityResultListener(this)
        activityBinding = null
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        activityBinding = binding
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activityBinding?.removeActivityResultListener(this)
        activityBinding = null
        activity = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val context = activity ?: run {
            result.error("NO_ACTIVITY", "Activity is null", null)
            return
        }

        when (call.method) {
            "startBackgroundTimer" -> {
                val startTime = call.argument<Number>("startTimeMs")?.toLong()
                    ?: System.currentTimeMillis()
                val targetDuration = call.argument<Number>("targetDurationMs")?.toLong() ?: 0L
                val name = call.argument<String>("name") ?: "专注"
                TimerForegroundService.start(context, startTime, targetDuration, name)
                result.success(null)
            }
            "stopBackgroundTimer" -> {
                TimerForegroundService.stop(context)
                result.success(null)
            }
            "startVideoCheckIn" -> {
                if (pendingVideoResult != null) {
                    result.error("VIDEO_BUSY", "A video check-in is already in progress", null)
                    return
                }
                val output = createSharedFile(
                    displayName = "focus_timer_video_${timestamp()}.mp4",
                    mimeType = VIDEO_MIME_TYPE,
                    childFolder = VIDEO_FOLDER,
                    mediaKind = MediaKind.Download
                ) ?: run {
                    result.error("VIDEO_OUTPUT_FAILED", "Cannot create video output file", null)
                    return
                }
                val intent = Intent(MediaStore.ACTION_VIDEO_CAPTURE).apply {
                    putExtra(MediaStore.EXTRA_OUTPUT, output.uri)
                    addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
                    clipData = ClipData.newRawUri("Focus Timer video", output.uri)
                }
                try {
                    pendingVideoResult = result
                    pendingVideoOutput = output
                    context.startActivityForResult(intent, VIDEO_CHECK_IN_REQUEST)
                } catch (error: ActivityNotFoundException) {
                    pendingVideoResult = null
                    pendingVideoOutput = null
                    deleteSharedFile(output.uri)
                    result.error("NO_CAMERA_APP", "No camera app can record video", null)
                }
            }
            "writeExportJson" -> {
                val content = call.argument<String>("content") ?: run {
                    result.error("NO_CONTENT", "JSON content is missing", null)
                    return
                }
                val displayName = call.argument<String>("displayName")
                    ?: "focus_timer_export_${timestamp()}.json"
                val output = createSharedFile(
                    displayName = displayName,
                    mimeType = JSON_MIME_TYPE,
                    childFolder = EXPORT_FOLDER,
                    mediaKind = MediaKind.Download
                ) ?: run {
                    result.error("EXPORT_OUTPUT_FAILED", "Cannot create export output file", null)
                    return
                }
                try {
                    context.contentResolver.openOutputStream(output.uri, "w").use { stream ->
                        if (stream == null) {
                            throw IllegalStateException("Cannot open export output stream")
                        }
                        stream.write(content.toByteArray(Charsets.UTF_8))
                    }
                    markSharedFileReady(output.uri)
                    result.success(output.toMap())
                } catch (error: Exception) {
                    deleteSharedFile(output.uri)
                    result.error("EXPORT_WRITE_FAILED", error.message, null)
                }
            }
            "pickJsonFiles" -> {
                if (pendingJsonPickResult != null) {
                    result.error("PICK_BUSY", "A JSON picker is already open", null)
                    return
                }
                val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                    addCategory(Intent.CATEGORY_OPENABLE)
                    type = "application/json"
                    putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
                }
                try {
                    pendingJsonPickResult = result
                    context.startActivityForResult(intent, JSON_PICK_REQUEST)
                } catch (error: ActivityNotFoundException) {
                    pendingJsonPickResult = null
                    result.error("NO_FILE_PICKER", "No file picker is available", null)
                }
            }
            "pickVideoFile" -> {
                if (pendingVideoPickResult != null) {
                    result.error("PICK_BUSY", "A video picker is already open", null)
                    return
                }
                val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                    addCategory(Intent.CATEGORY_OPENABLE)
                    type = "video/*"
                }
                try {
                    pendingVideoPickResult = result
                    context.startActivityForResult(intent, VIDEO_PICK_REQUEST)
                } catch (error: ActivityNotFoundException) {
                    pendingVideoPickResult = null
                    result.error("NO_FILE_PICKER", "No video picker is available", null)
                }
            }
            "openFile" -> {
                val rawUri = call.argument<String>("uri") ?: run {
                    result.error("NO_URI", "File uri is missing", null)
                    return
                }
                val mimeType = call.argument<String>("mimeType") ?: "*/*"
                val uri = Uri.parse(rawUri)
                val intent = if (mimeType.startsWith("video/")) {
                    Intent(context, VideoPlayerActivity::class.java).apply {
                        putExtra(VideoPlayerActivity.EXTRA_URI, uri.toString())
                        putExtra(VideoPlayerActivity.EXTRA_TITLE, call.argument<String>("title") ?: "")
                        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                    }
                } else {
                    Intent(Intent.ACTION_VIEW).apply {
                        setDataAndType(uri, mimeType)
                        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                    }
                }
                try {
                    context.startActivity(intent)
                    result.success(true)
                } catch (error: ActivityNotFoundException) {
                    result.success(false)
                }
            }
            "scheduleTaskReminder" -> {
                val taskId = call.argument<Number>("taskId")?.toInt() ?: run {
                    result.error("NO_TASK_ID", "Task id is missing", null)
                    return
                }
                val title = call.argument<String>("title") ?: "待办提醒"
                val reminderAt = call.argument<Number>("reminderAtMs")?.toLong() ?: run {
                    result.error("NO_REMINDER_TIME", "Reminder time is missing", null)
                    return
                }
                scheduleTaskReminder(context, taskId, title, reminderAt)
                result.success(null)
            }
            "cancelTaskReminder" -> {
                val taskId = call.argument<Number>("taskId")?.toInt() ?: run {
                    result.error("NO_TASK_ID", "Task id is missing", null)
                    return
                }
                cancelTaskReminder(context, taskId)
                result.success(null)
            }
            "canScheduleExactAlarms" -> {
                val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
                val canSchedule = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    alarmManager.canScheduleExactAlarms()
                } else {
                    true
                }
                result.success(canSchedule)
            }
            "openExactAlarmSettings" -> {
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
                    result.success(true)
                    return
                }
                val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
                    data = Uri.parse("package:${context.packageName}")
                }
                try {
                    context.startActivity(intent)
                    result.success(true)
                } catch (error: ActivityNotFoundException) {
                    result.success(false)
                }
            }
            "setKeepScreenOn" -> {
                val enabled = call.argument<Boolean>("enabled") ?: false
                setKeepScreenOn(context, enabled)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == JSON_PICK_REQUEST) {
            val result = pendingJsonPickResult ?: return true
            pendingJsonPickResult = null
            if (resultCode != Activity.RESULT_OK || data == null) {
                result.success(emptyList<Map<String, String>>())
                return true
            }
            result.success(readPickedJsonFiles(data))
            return true
        }
        if (requestCode == VIDEO_PICK_REQUEST) {
            val result = pendingVideoPickResult ?: return true
            pendingVideoPickResult = null
            if (resultCode != Activity.RESULT_OK || data?.data == null) {
                result.success(null)
                return true
            }
            val source = data.data!!
            val output = createSharedFile(
                displayName = "focus_timer_video_${timestamp()}.mp4",
                mimeType = VIDEO_MIME_TYPE,
                childFolder = VIDEO_FOLDER,
                mediaKind = MediaKind.Download
            ) ?: run {
                result.error("VIDEO_OUTPUT_FAILED", "Cannot create copied video output file", null)
                return true
            }
            copyReturnedVideo(source, output.uri)
            markSharedFileReady(output.uri)
            result.success(output.toMap())
            return true
        }
        if (requestCode != VIDEO_CHECK_IN_REQUEST) return false
        val result = pendingVideoResult ?: return true
        val output = pendingVideoOutput
        pendingVideoResult = null
        pendingVideoOutput = null
        if (resultCode == Activity.RESULT_OK) {
            if (output == null) {
                result.success(null)
                return true
            }
            val returnedUri = data?.data
            if (returnedUri != null && returnedUri != output.uri) {
                copyReturnedVideo(returnedUri, output.uri)
            }
            markSharedFileReady(output.uri)
            result.success(output.toMap())
        } else {
            if (output != null) {
                deleteSharedFile(output.uri)
            }
            result.success(null)
        }
        return true
    }

    private fun readPickedJsonFiles(data: Intent): List<Map<String, String>> {
        val context = activity ?: return emptyList()
        val uris = mutableListOf<Uri>()
        val clip = data.clipData
        if (clip != null) {
            for (index in 0 until clip.itemCount) {
                clip.getItemAt(index).uri?.let { uris.add(it) }
            }
        } else {
            data.data?.let { uris.add(it) }
        }
        return uris.mapNotNull { uri ->
            try {
                val flags = data.flags and
                    (Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
                try {
                    context.contentResolver.takePersistableUriPermission(
                        uri,
                        flags and Intent.FLAG_GRANT_READ_URI_PERMISSION
                    )
                } catch (_: Exception) {
                    // Some providers do not grant persistable access.
                }
                val content = context.contentResolver.openInputStream(uri).use { input ->
                    input?.bufferedReader(Charsets.UTF_8)?.readText()
                } ?: return@mapNotNull null
                mapOf(
                    "uri" to uri.toString(),
                    "displayName" to displayNameFor(uri),
                    "mimeType" to (context.contentResolver.getType(uri) ?: JSON_MIME_TYPE),
                    "content" to content
                )
            } catch (_: Exception) {
                null
            }
        }
    }

    private enum class MediaKind { Download }

    private data class SharedFileOutput(
        val uri: Uri,
        val displayName: String,
        val relativePath: String,
        val mimeType: String
    ) {
        fun toMap(): Map<String, String> = mapOf(
            "uri" to uri.toString(),
            "displayName" to displayName,
            "relativePath" to relativePath,
            "mimeType" to mimeType
        )
    }

    private fun createSharedFile(
        displayName: String,
        mimeType: String,
        childFolder: String,
        mediaKind: MediaKind
    ): SharedFileOutput? {
        val context = activity ?: return null
        val relativePath = "${Environment.DIRECTORY_DOWNLOADS}/$ROOT_FOLDER/$childFolder"

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val values = ContentValues().apply {
                put(MediaStore.MediaColumns.DISPLAY_NAME, displayName)
                put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
                put(MediaStore.MediaColumns.RELATIVE_PATH, relativePath)
                put(MediaStore.MediaColumns.IS_PENDING, 1)
            }
            val collection = when (mediaKind) {
                MediaKind.Download -> MediaStore.Downloads.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
            }
            val uri = context.contentResolver.insert(collection, values) ?: return null
            SharedFileOutput(uri, displayName, relativePath, mimeType)
        } else {
            val directory = File(
                Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS),
                "$ROOT_FOLDER/$childFolder"
            )
            if (!directory.exists() && !directory.mkdirs()) return null
            val file = File(directory, displayName)
            SharedFileOutput(Uri.fromFile(file), displayName, relativePath, mimeType)
        }
    }

    private fun markSharedFileReady(uri: Uri) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) return
        val context = activity ?: return
        val values = ContentValues().apply {
            put(MediaStore.MediaColumns.IS_PENDING, 0)
        }
        context.contentResolver.update(uri, values, null, null)
    }

    private fun deleteSharedFile(uri: Uri) {
        val context = activity ?: return
        try {
            if (uri.scheme == "file") {
                File(uri.path ?: return).delete()
            } else {
                context.contentResolver.delete(uri, null, null)
            }
        } catch (_: Exception) {
            // Best effort cleanup for canceled camera/export flows.
        }
    }

    private fun copyReturnedVideo(source: Uri, target: Uri) {
        val context = activity ?: return
        try {
            context.contentResolver.openInputStream(source).use { input ->
                context.contentResolver.openOutputStream(target, "w").use { output ->
                    if (input != null && output != null) {
                        input.copyTo(output)
                    }
                }
            }
        } catch (_: Exception) {
            // Some camera apps already write to EXTRA_OUTPUT and still return a Uri.
        }
    }

    private fun displayNameFor(uri: Uri): String {
        val context = activity ?: return uri.lastPathSegment ?: "selected.json"
        val projection = arrayOf(MediaStore.MediaColumns.DISPLAY_NAME)
        return try {
            context.contentResolver.query(uri, projection, null, null, null).use { cursor ->
                if (cursor != null && cursor.moveToFirst()) {
                    val index = cursor.getColumnIndex(MediaStore.MediaColumns.DISPLAY_NAME)
                    if (index >= 0) cursor.getString(index) else null
                } else {
                    null
                }
            } ?: uri.lastPathSegment ?: "selected.json"
        } catch (_: Exception) {
            uri.lastPathSegment ?: "selected.json"
        }
    }

    private fun setKeepScreenOn(activity: Activity, enabled: Boolean) {
        activity.runOnUiThread {
            val flag = WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
            if (enabled) {
                activity.window.addFlags(flag)
            } else {
                activity.window.clearFlags(flag)
            }
        }
    }

    private fun scheduleTaskReminder(context: Context, taskId: Int, title: String, reminderAt: Long) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val pendingIntent = taskReminderIntent(context, taskId, title)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && !alarmManager.canScheduleExactAlarms()) {
            alarmManager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, reminderAt, pendingIntent)
            return
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, reminderAt, pendingIntent)
        } else {
            alarmManager.setExact(AlarmManager.RTC_WAKEUP, reminderAt, pendingIntent)
        }
    }

    private fun cancelTaskReminder(context: Context, taskId: Int) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.cancel(taskReminderIntent(context, taskId, ""))
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancel(TaskReminderReceiver.NOTIFICATION_ID_OFFSET + taskId)
    }

    private fun taskReminderIntent(context: Context, taskId: Int, title: String): PendingIntent {
        val intent = Intent(context, TaskReminderReceiver::class.java).apply {
            putExtra(TaskReminderReceiver.EXTRA_TASK_ID, taskId)
            putExtra(TaskReminderReceiver.EXTRA_TITLE, title)
        }
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0
        return PendingIntent.getBroadcast(context, taskId, intent, flags)
    }

    private fun timestamp(): String {
        return SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).format(Date())
    }
}
