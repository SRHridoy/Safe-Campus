package com.example.safe_campus

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.IBinder
import android.os.SystemClock
import android.util.Log
import androidx.core.app.NotificationCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class VolumeButtonService : Service() {
    private var count = 0
    private var lastPress = 0L
    private lateinit var receiver: BroadcastReceiver
    private lateinit var channel: MethodChannel
    private lateinit var flutterEngine: FlutterEngine

    override fun onCreate() {
        super.onCreate()
        try {
            initializeFlutterEngine()
            createNotificationChannel()
            startForeground(1, createNotification())
            setupReceiver()
            Log.d("VolumeButtonService", "Service created and started")
        } catch (e: Exception) {
            Log.e("VolumeButtonService", "Initialization error: ${e.message}")
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("VolumeButtonService", "Service started with startId: $startId")
        // Return START_STICKY to restart service if it gets killed
        return START_STICKY
    }

    private fun initializeFlutterEngine() {
        flutterEngine =
            FlutterEngine(this).apply {
                dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
            }
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.safe_campus/sos")
    }

    override fun onDestroy() {
        try {
            Log.d("VolumeButtonService", "Service being destroyed")
            unregisterReceiver(receiver)
            flutterEngine.destroy()
        } catch (e: Exception) {
            Log.e("VolumeButtonService", "Cleanup error: ${e.message}")
        }
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel =
                NotificationChannel(
                    "sos_channel",
                    "SOS Service",
                    NotificationManager.IMPORTANCE_LOW
                )
                    .apply { description = "Background service for SOS detection" }
            getSystemService(NotificationManager::class.java)?.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        val intent =
            Intent(this, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_SINGLE_TOP
                putExtra("sos", false)
            }

        val pendingIntent =
            PendingIntent.getActivity(
                this,
                0,
                intent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )

        return NotificationCompat.Builder(this, "sos_channel")
            .setContentTitle("SOS Protection Active")
            .setContentText("Volume button monitoring enabled")
            .setSmallIcon(android.R.drawable.ic_dialog_info) // Using system icon
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .build()
    }

    private fun setupReceiver() {
        receiver =
            object : BroadcastReceiver() {
                override fun onReceive(context: Context?, intent: Intent?) {
                    if (intent?.action == "android.media.VOLUME_CHANGED_ACTION") {
                        handleVolumePress()
                    }
                }
            }
        registerReceiver(receiver, IntentFilter("android.media.VOLUME_CHANGED_ACTION"))
    }

    private fun handleVolumePress() {
        val now = SystemClock.elapsedRealtime()
        count = if (now - lastPress < 3000) count + 1 else 1
        lastPress = now

        if (count >= 3) {
            triggerSOS()
            count = 0
        }
    }

    private fun triggerSOS() {
        sendNotification()
        notifyFlutter()
        launchMainActivity()
    }

    private fun sendNotification() {
        val intent =
            Intent(this, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                putExtra("sos", true)
            }

        val pendingIntent =
            PendingIntent.getActivity(
                this,
                0,
                intent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )

        val notification =
            NotificationCompat.Builder(this, "sos_channel")
                .setContentTitle("🚨 EMERGENCY ALERT! 🚨")
                .setContentText("Your Location is Sent to Protorial Body")
                .setSmallIcon(android.R.drawable.ic_dialog_alert) // Using system alert icon
                .setContentIntent(pendingIntent)
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setAutoCancel(true)
                .setVibrate(longArrayOf(1000, 1000, 1000))
                .build()

        getSystemService(NotificationManager::class.java)?.notify(2, notification)
    }

    private fun notifyFlutter() {
        try {
            if (::channel.isInitialized) {
                channel.invokeMethod(
                    "sosTriggered",
                    mapOf(
                        "timestamp" to System.currentTimeMillis(),
                        "triggerType" to "volume_button"
                    )
                )
            } else {
                Log.w("SOS", "Method channel not initialized")
            }
        } catch (e: Exception) {
            Log.e("SOS", "Flutter notification failed: ${e.message}")
        }
    }

    private fun launchMainActivity() {
        val intent =
            Intent(this, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                putExtra("sos", true)
            }
        startActivity(intent)
    }
}