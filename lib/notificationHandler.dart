// ignore_for_file: file_names, prefer_const_declarations

import 'dart:convert';
import 'dart:developer';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/call_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/report_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/wallet_controller.dart';
import 'package:brahmanshtalk/main.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/HomeController/chat_controller.dart';
import 'controllers/HomeController/home_controller.dart';
import 'utils/constantskeys.dart';

class NotificationHandler {
  final walletController = Get.find<WalletController>();
  final reportController = Get.find<ReportController>();
  final homecontroller = Get.find<HomeController>();
  final signupController = Get.find<SignupController>();
  final chatController = Get.find<ChatController>();
  final callController = Get.find<CallController>();

  Future<void> onSelectNotification(String payload) async {
    Map<dynamic, dynamic> messageData;
    messageData = json.decode(payload);
    Map<dynamic, dynamic> body;
    body = jsonDecode(messageData['body']);
    log('in onSelectNotification');
    log('notification body $body');
    log('selected notificationType is ${body["notificationType"]} and calltype is ${body['call_type']}');
  }

  Future<void> foregroundNotificatioCustomAuddio(RemoteMessage payload) async {
    final initializationSettingsDarwin = DarwinInitializationSettings(
      defaultPresentBadge: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      defaultPresentSound: false,
    );

    log('payload is ${payload.data['title']}');
    log('payload description 1 ${payload.data['description']}');

    final android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    final initialSetting = InitializationSettings(
        android: android, iOS: initializationSettingsDarwin);
    localNotifications.initialize(initialSetting,
        onDidReceiveNotificationResponse: (_) {
      log('foregroundNotificatioCustomAuddio tap');

      onSelectNotification(json.encode(payload.data));
    });
    final customSound = 'app_sound.wav';
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      'channel_id_17',
      'channel.name',
      importance: Importance.max,
      icon: "@mipmap/ic_launcher",
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound('app_sound'),
    );

    final iOSDetails = DarwinNotificationDetails(
      sound: customSound,
    );
    final platformChannelSpecifics =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);
    global.sp = await SharedPreferences.getInstance();

    if (global.sp!.getString(ConstantsKeys.CURRENTUSER) != null) {
      await localNotifications.show(
        10,
        payload.data['title'], //message.data["title"]
        payload.data['description'] ?? '',
        platformChannelSpecifics,
        payload: json.encode(payload.data.toString()),
      );
    }
  }

  Future<void> foregroundNotification(RemoteMessage payload) async {
    log('--------------------------------------------------');
    log('started foreground notification');
    log('--------------------------------------------------');

    final initializationSettingsDarwin = DarwinInitializationSettings(
      defaultPresentBadge: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      defaultPresentSound: false,
    );
    final android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    final initialSetting = InitializationSettings(
        android: android, iOS: initializationSettingsDarwin);

    localNotifications.initialize(initialSetting,
        onDidReceiveNotificationResponse: (_) {
      log('foregroundNotification tap');

      onSelectNotification(json.encode(payload.data));
    });

    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      'channel_id-111',
      'channel.name',
      importance: Importance.max,
      icon: "@mipmap/ic_launcher",
      playSound: true,
      enableVibration: true,
    );

    final iOSDetails = const DarwinNotificationDetails();
    final platformChannelSpecifics =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);
    global.sp = await SharedPreferences.getInstance();

    if (global.sp!.getString(ConstantsKeys.CURRENTUSER) != null) {
      await localNotifications.show(
        10,
        payload.data['title'],
        payload.data['description'],
        platformChannelSpecifics,
        payload: json.encode(payload.data.toString()),
      );
    }
  }
}
