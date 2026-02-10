package com.brahmanshtalk.astrologer

import android.util.Log
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.embedding.engine.FlutterEngine

object NotificationEventManager {
    private var eventSink: EventSink? = null
    fun initialize(flutterEngine: FlutterEngine) {
        Log.e("flutterEngine initialized", "flutterEngine")
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.brahmanshtalk.astrologer/event_channel").setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventSink?) {
                    eventSink = events
                }
                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            }
        )
    }

    // Method to send data to Flutter
    fun sendNotificationDataToFlutter(data: String) {
        Log.e("NotificationEventManager", "start")
        //yana pe data nahi ara h null ara h THINGS TO DO hai
        if (eventSink != null) {
            Log.e("NotificationEventManager", "not null")
            eventSink?.success(data)
        } else {
            Log.e("NotificationEventManager", "EventSink is null. Cannot send data.")
        }
    }
}
