package com.example.music_player_blu

import android.os.Bundle
import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.analytics.Analytics
import com.microsoft.appcenter.crashes.Crashes
import com.microsoft.appcenter.distribute.Distribute
import io.flutter.embedding.android.FlutterActivity


class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        AppCenter.start(
            getApplication(), "1f7de371-f728-43b7-b5a4-9d072a1990c1",
            Distribute::class.java,
            Analytics::class.java,
            Crashes::class.java
        )
        AppCenter.setEnabled(true)
        Analytics.trackEvent("Application started")
        super.onCreate(savedInstanceState)
    }
}