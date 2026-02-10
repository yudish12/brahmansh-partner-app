// ignore_for_file: file_names

import 'dart:developer';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:uuid/uuid.dart';

class CallUtils {
  static Future<void> showIncomingCall(var body) async {
    Uuid uuid = const Uuid();
    String currentUuid = uuid.v4();
    String defaultImage = 'https://i.pravatar.cc/500';
    String? profilePic = body['profile'];
    String imageUrl;
    if (profilePic != null) {
      imageUrl = profilePic;
    } else {
      imageUrl = defaultImage;
    }
    bool calltype = body['call_type'] == 10; //video call or audio call
    log('calltype is  $calltype');
    log('imageUrl is  $imageUrl');
    log('imageUrl is  ${body['name']}');
    log('callmethod is  ${body['call_method']}');

    //call_method
    CallKitParams callKitParams = CallKitParams(
      id: currentUuid,
      nameCaller: body['name'],
      appName: 'BrahmanshTalk',
      handle: 'BrahmanshTalk',
      type: calltype ? 0 : 1, // 0 for audio call, 1 for video call
      textAccept: 'Accept',
      textDecline: 'Decline',
      duration: 30000,
      callingNotification: const NotificationParams(
          showNotification: false, isShowCallback: false),
      missedCallNotification: const NotificationParams(
          showNotification: true, isShowCallback: false),
      extra: <String, dynamic>{
        'call_type': body['call_type'],
        'notificationType': body['notificationType'],
        'callId': body['callId'],
        'profile': body['profile'],
        'name': body['name'],
        'id': body['id'],
        'call_token': body['token'],
        'fcmToken': body['fcmToken'],
        'call_duration': body['call_duration'].toString(),
        'call_method': body['call_method'].toString(),
        'channel_name' : body['channel_name'],
      },

      headers: <String, dynamic>{'apiKey': 'sunil@123!', 'platform': 'flutter'},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: true,
        isShowFullLockedScreen: true,

        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        actionColor: '#4CAF50',
        textColor: '#ffffff',
        incomingCallNotificationChannelName: "Incoming Call 1",
        isShowCallID: true, //for showing handle in incoming call notification
      ),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
  }

  /// Show incoming chat request notification with accept/reject buttons
  static Future<void> showIncomingChat(var body) async {
    Uuid uuid = const Uuid();
    String currentUuid = uuid.v4();
    String defaultImage = 'https://i.pravatar.cc/500';
    String? profilePic = body['profile'];
    String imageUrl = profilePic ?? defaultImage;

    log('showIncomingChat - userName: ${body['userName']}');
    log('showIncomingChat - chatId: ${body['chatId']}');
    log('showIncomingChat - userId: ${body['userId']}');
    log('showIncomingChat - profile: $imageUrl');

    CallKitParams callKitParams = CallKitParams(
      id: currentUuid,
      nameCaller: body['userName'] ?? 'New Chat Request',
      appName: 'BrahmanshTalk',
      handle: 'Chat Request',
      type: 0, // Use 0 for chat appearance
      textAccept: 'Accept',
      textDecline: 'Decline',
      duration: 60000, // 60 seconds timeout for chat
      callingNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: false,
      ),
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: false,
      ),
      extra: <String, dynamic>{
        'notificationType': 8, // Chat notification type
        'chatId': body['chatId'],
        'userId': body['userId'],
        'userName': body['userName'],
        'profile': body['profile'],
        'fcmToken': body['fcmToken'],
        'chat_duration': body['chat_duration']?.toString() ?? '',
        'subscription_id': body['subscription_id'] ?? '',
      },
      headers: <String, dynamic>{'apiKey': 'sunil@123!', 'platform': 'flutter'},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: true,
        isShowFullLockedScreen: true,
        ringtonePath: 'system_ringtone_default', // Same ringtone as call
        backgroundColor: '#EA6C10',
        actionColor: '#4CAF50',
        textColor: '#ffffff',
        incomingCallNotificationChannelName: "Incoming Chat Request",
        isShowCallID: true,
      ),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
  }
}
