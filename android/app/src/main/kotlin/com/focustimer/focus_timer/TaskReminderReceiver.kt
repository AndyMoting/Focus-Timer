package com.focustimer.focus_timer

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build

class TaskReminderReceiver : BroadcastReceiver() {
    companion object {
        const val EXTRA_TASK_ID = "taskId"
        const val EXTRA_TITLE = "title"
        private const val CHANNEL_ID = "task_reminder"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val taskId = intent.getIntExtra(EXTRA_TASK_ID, 0)
        val title = intent.getStringExtra(EXTRA_TITLE)?.takeIf { it.isNotBlank() } ?: "待办提醒"
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "待办提醒",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "待办事项到点提醒"
                enableVibration(true)
            }
            manager.createNotificationChannel(channel)
        }

        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            ?: Intent()
        val pendingFlags = PendingIntent.FLAG_UPDATE_CURRENT or
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0
        val contentIntent = PendingIntent.getActivity(context, taskId, launchIntent, pendingFlags)
        val notification = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            android.app.Notification.Builder(context, CHANNEL_ID)
        } else {
            android.app.Notification.Builder(context)
        }
            .setSmallIcon(context.applicationInfo.icon)
            .setContentTitle("待办提醒")
            .setContentText(title)
            .setContentIntent(contentIntent)
            .setAutoCancel(true)
            .setShowWhen(true)
            .build()
        manager.notify(10_000 + taskId, notification)
    }
}
