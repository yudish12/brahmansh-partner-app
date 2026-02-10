package com.brahmanshtalk.astrologer

import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.Keep
import com.onesignal.notifications.IActionButton
import com.onesignal.notifications.IDisplayableMutableNotification
import com.onesignal.notifications.INotificationReceivedEvent
import com.onesignal.notifications.INotificationServiceExtension

@Keep // Prevents minification from removing or renaming this class
class NotificationServiceExtension : INotificationServiceExtension {
    override fun onNotificationReceived(event: INotificationReceivedEvent) {
        val notification: IDisplayableMutableNotification = event.notification
        Log.e("NotificationServiceExtension NOTIFICATION IS 0->", "${event.notification.additionalData}")
       
    
        val notificationData: String = event.notification.additionalData?.toString() ?: "{}"

        Log.e("NotificationServiceExtension NOTIFICATION IS 1->", notificationData)
            Handler(Looper.getMainLooper()).post {
                NotificationEventManager.sendNotificationDataToFlutter(notificationData)

            notification.actionButtons?.forEach { button: IActionButton ->
                // Perform modifications to action buttons here, if needed
            }

            // Example: Change the notification's background color to blue
            notification.setExtender { builder ->
                builder.setColor(0xFF0000FF.toInt()) // Set color to blue
            }

        }
    }
}
