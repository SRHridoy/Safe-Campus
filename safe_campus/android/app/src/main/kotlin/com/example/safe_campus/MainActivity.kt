package com.example.safe_campus
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.safe_campus/sos"
    private var sosTriggered = false
    private lateinit var channel: MethodChannel
    private var isServiceRunning = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    startVolumeButtonService()
                    isServiceRunning = true
                    result.success(true)
                }
                "stopService" -> {
                    // Service stop disabled - always keep running
                    result.success(true)
                }
                "isServiceRunning" -> {
                    result.success(isServiceRunning)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleSOSIntent(intent)
        // Auto-start service when app launches
        if (!isServiceRunning) {
            startVolumeButtonService()
            isServiceRunning = true
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleSOSIntent(intent)
    }

    private fun handleSOSIntent(intent: Intent?) {
        if (intent?.getBooleanExtra("sos", false) == true) {
            sosTriggered = true
            try {
                channel.invokeMethod("sos_trigger", null)
            } catch (e: Exception) {
                Log.e("MainActivity", "Failed to invoke sos_trigger: ${e.message}")
            }
        }
    }

    private fun startVolumeButtonService() {
        try {
            val intent = Intent(this, VolumeButtonService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(intent)
            } else {
                startService(intent)
            }
            Log.d("MainActivity", "Service started")
        } catch (e: Exception) {
            Log.e("MainActivity", "Failed to start service: ${e.message}")
        }
    }

    private fun stopVolumeButtonService() {
        val intent = Intent(this, VolumeButtonService::class.java)
        stopService(intent)
        Log.d("MainActivity", "Service stopped")
    }
}