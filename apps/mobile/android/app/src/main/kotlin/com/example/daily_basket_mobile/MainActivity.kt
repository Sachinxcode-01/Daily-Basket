package com.example.daily_basket_mobile

import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            try {
                val window = window
                val modes = display?.supportedModes
                if (modes != null && modes.isNotEmpty()) {
                    val maxRefreshRateMode = modes.maxByOrNull { it.refreshRate }
                    if (maxRefreshRateMode != null) {
                        val params = window.attributes
                        params.preferredDisplayModeId = maxRefreshRateMode.modeId
                        window.attributes = params
                    }
                }
            } catch (_: Exception) {
                // Fallback gracefully on custom vendor ROMs
            }
        }
    }
}
