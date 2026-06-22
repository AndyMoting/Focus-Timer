package com.focustimer.focus_timer

import android.app.Activity
import android.net.Uri
import android.os.Bundle
import android.view.Gravity
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.ImageButton
import android.widget.MediaController
import android.widget.TextView
import android.widget.VideoView

class VideoPlayerActivity : Activity() {
    companion object {
        const val EXTRA_URI = "uri"
        const val EXTRA_TITLE = "title"
    }

    private lateinit var videoView: VideoView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val uriText = intent.getStringExtra(EXTRA_URI)
        if (uriText.isNullOrBlank()) {
            finish()
            return
        }

        val root = FrameLayout(this).apply {
            setBackgroundColor(0xFF000000.toInt())
        }
        videoView = VideoView(this).apply {
            layoutParams = FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT,
                Gravity.CENTER
            )
            setVideoURI(Uri.parse(uriText))
            setMediaController(MediaController(this@VideoPlayerActivity).also {
                it.setAnchorView(this)
            })
            setOnPreparedListener { mediaPlayer ->
                mediaPlayer.isLooping = false
                start()
            }
        }
        root.addView(videoView)

        val topBar = FrameLayout(this).apply {
            setBackgroundColor(0x66000000)
            layoutParams = FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                dp(56),
                Gravity.TOP
            )
            setPadding(4, 0, 12, 0)
        }
        val back = ImageButton(this).apply {
            setImageResource(android.R.drawable.ic_menu_close_clear_cancel)
            setBackgroundColor(0x00000000)
            setColorFilter(0xFFFFFFFF.toInt())
            contentDescription = "返回"
            setOnClickListener { finish() }
            layoutParams = FrameLayout.LayoutParams(dp(52), dp(56), Gravity.START or Gravity.CENTER_VERTICAL)
        }
        val title = TextView(this).apply {
            text = intent.getStringExtra(EXTRA_TITLE)?.takeIf { it.isNotBlank() } ?: "视频凭证"
            setTextColor(0xFFFFFFFF.toInt())
            textSize = 16f
            maxLines = 1
            gravity = Gravity.CENTER_VERTICAL
            layoutParams = FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            ).apply {
                leftMargin = dp(60)
                rightMargin = dp(12)
            }
        }
        topBar.addView(back)
        topBar.addView(title)
        root.addView(topBar)
        setContentView(root)
    }

    override fun onPause() {
        super.onPause()
        if (::videoView.isInitialized) videoView.pause()
    }

    private fun dp(value: Int): Int {
        return (value * resources.displayMetrics.density).toInt()
    }
}
