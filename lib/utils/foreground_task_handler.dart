import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:permission_handler/permission_handler.dart';

class ForegroundServiceManager {
  static const _notificationChannelId = 'chat_foreground_channel';
  static const _notificationChannelName = 'App Activity';
  static const _notificationTitle = 'BrahmanshTalk App is Active';
  static const _notificationText = 'You are in a conversation';

  /// Initialize foreground service configuration
  static void initialize() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: _notificationChannelId,
        channelName: _notificationChannelName,
        channelDescription: 'Displays when chat is active',
        channelImportance: NotificationChannelImportance.MAX,
        priority: NotificationPriority.HIGH,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        autoRunOnBoot: false,
        allowWakeLock: true,
        allowWifiLock: true,
        eventAction: ForegroundTaskEventAction.repeat(2000),
      ),
    );
  }

  /// Start the foreground service with required permissions
  static Future<void> startForegroundTask() async {
    try {
      // Optional: Wait a moment to ensure service is started
      await Future.delayed(const Duration(milliseconds: 100));
      await FlutterForegroundTask.startService(
        notificationTitle: _notificationTitle,
        notificationText: _notificationText,
        callback: _startCallback,
      );
    } catch (e) {
      log('Foreground service start error: $e');
    }
  }

  /// Stop the foreground service
  static Future<void> stopForegroundTask() async {
    log('stop foreground service');

    try {
      await FlutterForegroundTask.stopService();
    } on Exception catch (e) {
      log('stop foreground service error: $e');
    }
  }

  @pragma('vm:entry-point')
  static void _startCallback() {
    FlutterForegroundTask.setTaskHandler(_ForegroundTaskHandler());
  }

  static Future<bool> checkAndRequestPermissions() async {
    await FlutterCallkitIncoming.requestFullIntentPermission();

    try {
      if (!Platform.isAndroid) return true;

      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      // 1. First request CAMERA permission
      var cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        cameraStatus = await Permission.camera.request();
        if (cameraStatus.isDenied || cameraStatus.isPermanentlyDenied) {
          log('Camera permission denied');
          return false;
        }
      }

      // 2. Only if camera is granted, request MICROPHONE permission
      var micStatus = await Permission.microphone.status;
      if (!micStatus.isGranted) {
        micStatus = await Permission.microphone.request();
        if (micStatus.isDenied || micStatus.isPermanentlyDenied) {
          log('Microphone permission denied');
          return false;
        }
      }

      // 3. Only if both camera and microphone are granted, request NOTIFICATION permission (Android 13+)
      if (sdkInt >= 33) {
        var notificationStatus = await Permission.notification.status;
        if (!notificationStatus.isGranted) {
          notificationStatus = await Permission.notification.request();
          if (notificationStatus.isDenied ||
              notificationStatus.isPermanentlyDenied) {
            log('Notification permission denied');
            // Notification permission is not critical, so we don't return false here
          }
        }
      }

      return true;
    } catch (e) {
      log('Permission check error: $e');
      return false;
    }
  }

}

class _ForegroundTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    log('Foreground task started');
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    FlutterForegroundTask.sendDataToMain({
      "timestamp": timestamp.millisecondsSinceEpoch,
    });
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    log('Foreground task destroyed - timeout: $isTimeout');
  }

  @override
  void onReceiveData(Object data) => log('Data received: $data');

  @override
  void onNotificationButtonPressed(String id) => log('Button pressed: $id');

  @override
  void onNotificationPressed() => log('Notification pressed');

  @override
  void onNotificationDismissed() => log('Notification dismissed');
}
