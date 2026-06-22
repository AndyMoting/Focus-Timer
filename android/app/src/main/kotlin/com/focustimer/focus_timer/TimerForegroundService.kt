package com.focustimer.focus_timer

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import androidx.core.app.NotificationCompat
import java.util.Timer
import java.util.TimerTask

class TimerForegroundService : Service() {
    private var startTimeMs: Long = 0
    private var targetDurationMs: Long = 0
    private var timerName: String = ""
    private var timer: Timer? = null
    private var wakeLock: PowerManager.WakeLock? = null

    companion object {
        const val CHANNEL_ID = "timer_foreground"
        const val NOTIFICATION_ID = 1
        const val STOP_ACTION = "com.focustimer.STOP_TIMER"
        private const val PREFS_NAME = "timer_foreground_service"
        private const val KEY_START_TIME = "start_time"
        private const val KEY_TARGET_DURATION = "target_duration"
        private const val KEY_TIMER_NAME = "timer_name"
        private const val KEY_ACTIVE = "active"

        fun start(
            context: Context,
            startTime: Long,
            targetDuration: Long,
            name: String
        ) {
            val intent = Intent(context, TimerForegroundService::class.java).apply {
                putExtra("start_time", startTime)
                putExtra("target_duration", targetDuration)
                putExtra("timer_name", name)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        fun stop(context: Context) {
            context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                .edit()
                .clear()
                .apply()
            context.stopService(Intent(context, TimerForegroundService::class.java))
        }
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        acquireWakeLock()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val restored = restoreSession()
        startTimeMs = intent?.getLongExtra("start_time", restored?.startTime ?: System.currentTimeMillis())
            ?: restored?.startTime
            ?: System.currentTimeMillis()
        targetDurationMs = intent?.getLongExtra("target_duration", restored?.targetDuration ?: 0) ?: restored?.targetDuration ?: 0
        timerName = intent?.getStringExtra("timer_name") ?: restored?.name ?: "自由计时"

        persistSession()

        startForeground(NOTIFICATION_ID, buildNotification(System.currentTimeMillis()))
        startTimer()

        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        timer?.cancel()
        wakeLock?.let { if (it.isHeld) it.release() }
        super.onDestroy()
    }

    private data class PersistedSession(
        val startTime: Long,
        val targetDuration: Long,
        val name: String
    )

    private fun restoreSession(): PersistedSession? {
        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        if (!prefs.getBoolean(KEY_ACTIVE, false)) return null
        return PersistedSession(
            startTime = prefs.getLong(KEY_START_TIME, System.currentTimeMillis()),
            targetDuration = prefs.getLong(KEY_TARGET_DURATION, 0),
            name = prefs.getString(KEY_TIMER_NAME, "自由计时") ?: "自由计时"
        )
    }

    private fun persistSession() {
        getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .putBoolean(KEY_ACTIVE, true)
            .putLong(KEY_START_TIME, startTimeMs)
            .putLong(KEY_TARGET_DURATION, targetDurationMs)
            .putString(KEY_TIMER_NAME, timerName)
            .apply()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "计时进行中",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "显示当前计时器进度"
                setSound(null, null)
            }
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }

    private fun acquireWakeLock() {
        val powerManager = getSystemService(POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "FocusTimer:BackgroundTimer"
        )
        wakeLock?.acquire(24 * 60 * 60 * 1000L) // max 24 hours
    }

    private fun startTimer() {
        timer?.cancel()
        timer = Timer()
        timer?.scheduleAtFixedRate(object : TimerTask() {
            override fun run() {
                val now = System.currentTimeMillis()
                val elapsedMs = now - startTimeMs
                val remainingMs = (targetDurationMs - elapsedMs).coerceAtLeast(0)

                updateNotification(now)

                if (targetDurationMs > 0 && elapsedMs >= targetDurationMs) {
                    stopSelf()
                }
            }
        }, 0, 1000)
    }

    private fun updateNotification(now: Long) {
        val manager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        manager.notify(NOTIFICATION_ID, buildNotification(now))
    }

    private fun buildNotification(now: Long): Notification {
        val elapsedMs = now - startTimeMs
        val remainingMs = if (targetDurationMs > 0) {
            (targetDurationMs - elapsedMs).coerceAtLeast(0)
        } else null

        val contentText = if (remainingMs != null) {
            "剩余 ${formatDuration(remainingMs)}"
        } else {
            formatDuration(elapsedMs)
        }

        // Tap notification to return to app
        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP
        }
        val pendingIntent = PendingIntent.getActivity(
            this, 0, launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("$timerName 进行中")
            .setContentText(contentText)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setContentIntent(pendingIntent)
            .build()
    }

    private fun formatDuration(totalMs: Long): String {
        val totalSeconds = totalMs / 1000
        val hours = totalSeconds / 3600
        val minutes = (totalSeconds % 3600) / 60
        val seconds = totalSeconds % 60
        return if (hours > 0) {
            String.format("%d:%02d:%02d", hours, minutes, seconds)
        } else {
            String.format("%02d:%02d", minutes, seconds)
        }
    }
}
