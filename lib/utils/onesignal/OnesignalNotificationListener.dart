import 'dart:async';
import 'dart:developer';
import 'package:flutter/services.dart';

class OneSignalNotificationListener {
  static const _eventChannel =
      EventChannel('com.brahmanshtalk.astrologer/event_channel');

  // Singleton instance for global usage
  static final OneSignalNotificationListener _instance =
      OneSignalNotificationListener._internal();
  factory OneSignalNotificationListener() => _instance;

  OneSignalNotificationListener._internal();

  // Stream controller to emit changes
  final _notificationStreamController = StreamController<String>.broadcast();

  Stream<String> get notificationStream => _notificationStreamController.stream;

  void initialize() {
    // Listen to EventChannel
    _eventChannel.receiveBroadcastStream().listen((event) {
      log("onesig receiving notification data: $event");

      _notificationStreamController.add(event);
    }, onError: (error) {
      log("Error receiving notification data: $error");
    });
  }

  void dispose() {
    _notificationStreamController.close();
  }
}
