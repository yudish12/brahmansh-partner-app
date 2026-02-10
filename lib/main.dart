// ignore_for_file: must_be_immutable, avoid_print, unnecessary_nullable_for_final_variable_declarations, unused_element, no_leading_underscores_for_local_identifiers, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:brahmanshtalk/controllers/CalltimerController.dart';
import 'package:brahmanshtalk/controllers/HomeController/productController.dart';
import 'package:brahmanshtalk/controllers/customerSupportController/customerSupportController.dart';
import 'package:brahmanshtalk/controllers/notification_controller.dart';
import 'package:brahmanshtalk/utils/foreground_task_handler.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/chat_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/home_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/live_astrologer_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/report_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/timer_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/wallet_controller.dart';
import 'package:brahmanshtalk/controllers/callAvailability_controller.dart';
import 'package:brahmanshtalk/controllers/chatAvailability_controller.dart';
import 'package:brahmanshtalk/controllers/networkController.dart';
import 'package:brahmanshtalk/controllers/splashController.dart';
import 'package:brahmanshtalk/firebase_options.dart';
import 'package:brahmanshtalk/services/apiHelper.dart';
import 'package:brahmanshtalk/theme/nativeTheme.dart';
import 'package:brahmanshtalk/theme/themeService.dart';
import 'package:brahmanshtalk/utils/CallUtils.dart';
import 'package:brahmanshtalk/utils/binding/networkBinding.dart';
import 'package:brahmanshtalk/views/splash/splashScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'Courses/controller/courseController.dart';
import 'controllers/Chattimercontroller.dart';
import 'controllers/HomeController/call_controller.dart';
import 'controllers/following_controller.dart';
import 'controllers/life_cycle_controller.dart';
import 'notificationHandler.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'utils/FallbackLocalizationDelegate.dart';
import 'utils/config.dart';
import 'utils/constantskeys.dart';
import 'views/HomeScreen/home_screen.dart';

final localNotifications = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp(
      name: 'BrahmanshTalk', options: DefaultFirebaseOptions.currentPlatform);
  Get.put(WalletController());
  Get.put(ChatController());
  Get.put(CallController());
  Get.put(TimerController());
  Get.put(ReportController());
  Get.put(NetworkController());
  Get.put(SignupController());
  Get.put(FollowingController());
  Get.put(HomeController());
  print('firebase background msg called..');
  print('notification message -> ${message.data}');
  global.sp = await SharedPreferences.getInstance();
  if (global.sp != null &&
      global.sp!.getString(ConstantsKeys.CURRENTUSER) != null) {
    if (message.data.isNotEmpty) {
      var messageData = json.decode((message.data['body']));
      print('notification body background ->  $messageData');
      if (messageData['notificationType'] != null) {
        switch (messageData['notificationType']) {
          case 2:
            // in background
            print('calling from :- 2');
            CallUtils.showIncomingCall(messageData);
            initforbackground();

            break;
          case 8:
            final prefs = await SharedPreferences.getInstance();
            print('inside background noti type 8 - showing CallKit chat notification');
            
            final incomingChatId = messageData['chatId'];
            final userName = messageData['userName'] ?? 'User';
            bool shouldShowCallKit = true;
            
            // Check if chat is already in progress (stored in SharedPreferences or controller)
            // Note: In background, we can't check isInChatScreen directly, but we can check
            // if the chat was already accepted by checking ISACCEPTED flag
            final isAlreadyAccepted = prefs.getBool(ConstantsKeys.ISACCEPTED) ?? false;
            if (isAlreadyAccepted) {
              log('Chat already accepted, showing simple notification in background');
              // Note: Can't call _showSimpleChatNotification from background handler
              // The notification will be shown when app comes to foreground
              prefs.setBool(ConstantsKeys.ISCHATAVILABLE, true);
              initforbackground();
              break;
            }
            
            // Try to check accepted chat IDs if controller is available
            try {
              final chatController = Get.find<ChatController>();
              if (incomingChatId != null && chatController.acceptedChatIds.contains(incomingChatId)) {
                log('Chat $incomingChatId already accepted (from set), skipping CallKit notification in background');
                prefs.setBool(ConstantsKeys.ISCHATAVILABLE, true);
                initforbackground();
                break;
              }
            } catch (e) {
              log('Could not check acceptedChatIds in background: $e');
            }
            
            prefs.setBool(ConstantsKeys.ISCHATAVILABLE, true);
            // Show incoming chat notification with accept/reject buttons (same as call)
            CallUtils.showIncomingChat(messageData);
            initforbackground();
            break;
          default:
            print('Unknown notification type');
            NotificationHandler().foregroundNotification(message);
            await FirebaseMessaging.instance
                .setForegroundNotificationPresentationOptions(
                    alert: true, badge: true, sound: true);
        }
      } else {
        log('message else in firebase backgorund $messageData');
      }
    }
  } else {
    log('No additional data available in handleNotificationData in firebaseMessaging');
  }
}

void initforbackground() async {
  debugPrint('inside initforbackground called');
  FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
    debugPrint('inside initforbackground $event');
    if (event == null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(ConstantsKeys.ISACCEPTED, false);
      await prefs.setBool(ConstantsKeys.ISREJECTED, false);
      final success = await prefs.commit();
      print('success commit event==null $success');
      return;
    }
    switch (event.event) {
      case Event.actionCallStart:
        // Handle call accept action
        print('actionCallStart call incoming');
        break;
      case Event.actionCallAccept:
        // Handle call/chat accept action
        print('actionCallAccept incoming in background');
        final prefs = await SharedPreferences.getInstance();
        final notificationType = event.body['extra']["notificationType"];
        
        // SET new values
        String extraDataJson = jsonEncode(event.body['extra']);
        await Future.wait([
          prefs.setBool(ConstantsKeys.ISREJECTED, false),
          prefs.setBool(ConstantsKeys.ISACCEPTED, true),
          prefs.setString(ConstantsKeys.ISACCEPTEDDATA, extraDataJson)
        ]);
        final success = await prefs.commit();
        print('success commit accept $success');
        print('actionCallAccept extraDataJson $extraDataJson');
        print('actionCallAccept notificationType $notificationType');
        break;
      case Event.actionCallDecline:
        log('call/chat rejected init background');
        final callController = Get.put(CallController());
        final chatController = Get.put(ChatController());
        final prefs = await SharedPreferences.getInstance();
        final notificationTypeDecline = event.body['extra']["notificationType"];
        
        await Future.wait([
          prefs.setBool(ConstantsKeys.ISREJECTED, true),
          prefs.setBool(ConstantsKeys.ISACCEPTED, false),
          prefs.setString(ConstantsKeys.ISACCEPTEDDATA, ''),
        ]);
        final success = await prefs.commit();
        print('success commit in actionCallDecline $success');

        // Handle chat rejection (type 8)
        if (notificationTypeDecline == 8) {
          log('Chat reject from background');
          final chatId = event.body['extra']['chatId'];
          if (chatId != null) {
            await chatController.rejectChatRequest(chatId);
            chatController.update();
          }
        }
        // Handle call rejection (type 2)
        else if (notificationTypeDecline == 2) {
          callController.rejectCallRequest(event.body['extra']['callId']);
          callController.update();
        }

        break;

      case Event.actionCallCallback:
        print('actionCallCallback initforbackground call incoming click');
        break;
      case Event.actionCallTimeout:
        final prefs = await SharedPreferences.getInstance();
        print('actionCallTimeout initforbackground call incoming click');
        //clear background data when missed call so whenever app open agian then this data
        //not open direactly callscreens
        await prefs.setBool(ConstantsKeys.ISACCEPTED, false);
        await prefs.setBool(ConstantsKeys.ISREJECTED, false);
        await prefs.setString(ConstantsKeys.ISACCEPTEDDATA, '');
        final success = await prefs.commit();
        print('success commit in actionCallTimeout $success');
        break;
      default:
        break;
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await GetStorage.init();
  initonesignal();
  ForegroundServiceManager.initialize();
  await Firebase.initializeApp(
      name: 'BrahmanshTalk', options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('hi', 'IN'),
        Locale('bn', 'IN'),
        Locale('gu', 'IN'),
        Locale('kn', 'IN'),
        Locale('ml', 'IN'),
        Locale('mr', 'IN'),
        Locale('ta', 'IN'),
        Locale('te', 'IN')
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

void initonesignal() {
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.Debug.setAlertLevel(OSLogLevel.none);
  OneSignal.consentRequired(false);
  OneSignal.initialize(OnesignalID);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  dynamic analytics;
  final apiHelper = APIHelper();
  dynamic observer;
  final liveAstrologerController = Get.put(LiveAstrologerController());
  final walletController = Get.put(WalletController());
  final chatController = Get.put(ChatController());
  final callController = Get.put(CallController());
  final timerController = Get.put(TimerController());
  final reportController = Get.put(ReportController());
  final networkController = Get.put(NetworkController());
  final followingController = Get.put(FollowingController());
  final callavailibilty = Get.put(CallAvailabilityController());
  final chatavailibilty = Get.put(ChatAvailabilityController());
  final signupcontroller = Get.put(SignupController());
  final homecontroller = Get.put(HomeController());
  final notificationController = Get.put(NotificationController());
  final splashController = Get.put(SplashController());
  final hhomecheckcontrlller = Get.put(HomeCheckController());
  final courseController = Get.put(CoursesController());
  final chatitmercontroller = Get.put(ChattimerController());
  final productController = Get.put(Productcontroller());
  final callitmercontroller = Get.put(CalltimerController());
  final customersupportController = Get.put(AstrologerSupportController());

  @override
  void initState() {
    super.initState();

    OneSignal.Notifications.addPermissionObserver((state) {
      log("Has permission $state");
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) async {
      event.preventDefault();
      event.notification.display();
      print('one display event ${event.notification.additionalData}');

      showForegroundNotification(event.notification.additionalData);
    });

    initializeCallKitEventHandlers();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('notification onMessage foreground ->  $message');
      if (message.data['title'] == ConstantsKeys.StartSimpleChatTimer) {
        global.isChatTimerStarted = true;
        chatitmercontroller.newIsStartTimer = true;
        chatitmercontroller.update();
        Map<String, dynamic> notibody = jsonDecode(message.data['body']);
        debugPrint('newDuration notibody $notibody');

        if (notibody.containsKey('timeInInt')) {
          int newDuration = int.parse(notibody['timeInInt'].toString());
          chatitmercontroller.restartTimer(newDuration);
        } else {
          log('time set to true but update timer is not found in else block');
        }
      } else if (message.data['title'] == ConstantsKeys.callrejectedcustomer) {
        log('is in callscren or not ${global.isinAcceptCallscreen}');
        if (global.isinAcceptCallscreen == true) {
          global.showToast(message: 'Call Rejected by User');
          callController.agoraEngine.leaveChannel();
          callController.agoraEngine.release(sync: true);
          Get.off(() => HomeScreen());
        } else {
          log('do nothing no inside callscreen');
        }
        return;
      } else if (message.data['title'] ==
          ConstantsKeys.chatrejectedbyCustomer) {
        log('is in callscren or not ${global.isinAcceptChatscreen}');
        if (global.isinAcceptChatscreen == true) {
          log('Getback chat');
          global.showToast(message: 'Chat Rejected by User');
          Get.off(() => HomeScreen());
        } else {
          log('do nothing no inside callscreen');
        }
      } else if (message.data['title'] == ConstantsKeys.EndChatFromCustomer) {
        log('EndChatFromCustomer isInChatScreen ${chatController.isInChatScreen}');
        if (chatController.isInChatScreen) {
          chatController.updateChatScreen(false);
          apiHelper.setAstrologerOnOffBusyline("Online");
          chatController.update();
        } else {
          log('do nothing chat dismiss');
        }
        return;
      }

      global.sp = await SharedPreferences.getInstance();
      if (global.sp != null &&
          global.sp!.getString(ConstantsKeys.CURRENTUSER) != null) {
        if (message.data.isNotEmpty) {
          print('notification body background 1 ->  ${message.data}');
          var messageData = json.decode((message.data['body']));
          if (messageData['notificationType'] != null) {
            switch (messageData['notificationType']) {
              case 8:
                if(message.data['title']!="Chat Timer Started")
                  {
                    final incomingChatId = messageData['chatId'];
                    final userName = messageData['userName'] ?? 'User';
                    bool shouldShowCallKit = true;
                    
                    // Check if chat is already in progress to prevent showing CallKit again
                    if (chatController.isInChatScreen) {
                      log('Chat already in progress, showing simple notification instead of CallKit');
                      _showSimpleChatNotification(userName, 'Chat request update');
                      shouldShowCallKit = false;
                    }
                    
                    // Check if this chatId was already accepted
                    if (incomingChatId != null && shouldShowCallKit) {
                      // Check if chatId is in the accepted set
                      if (chatController.acceptedChatIds.contains(incomingChatId)) {
                        log('Chat $incomingChatId already accepted, showing simple notification instead of CallKit');
                        _showSimpleChatNotification(userName, 'Chat request update');
                        shouldShowCallKit = false;
                      }
                      
                      // Also check if chat is already in the chat list (meaning it was accepted)
                      if (shouldShowCallKit) {
                        final chatExists = chatController.chatList.any(
                          (chat) => chat.chatId == incomingChatId
                        );
                        if (chatExists) {
                          log('Chat $incomingChatId already exists in list, showing simple notification instead of CallKit');
                          // Mark it as accepted to prevent future notifications
                          chatController.acceptedChatIds.add(incomingChatId);
                          _showSimpleChatNotification(userName, 'Chat request update');
                          shouldShowCallKit = false;
                        }
                      }
                    }
                    
                    if (shouldShowCallKit) {
                      log('inside foreground noti type 8 - showing CallKit notification for chatId: $incomingChatId');
                      // Show incoming chat notification with accept/reject buttons (same as call)
                      CallUtils.showIncomingChat(messageData);
                    }
                    
                    await chatController.getChatList(true, isLoading: 0);
                    chatController.update();
                  }
                break;
              case 2:
                if (message.data['title'] == ConstantsKeys.startCalltimer) {
                  if (messageData.containsKey('timeInInt')) {
                    int newDuration =
                        int.parse(messageData['timeInInt'].toString());

                    log('My_timer call updated $newDuration seconds ');

                    callitmercontroller.extendTimer((newDuration));
                    String msg = "Your current Session has been extended";
                    global.showToast(message: msg);
                  }
                } else {
                  debugPrint('calling from :- 2 froeground');
                  Get.find<CallController>().getCallList(false);
                  Get.find<CallController>().update();
                  CallUtils.showIncomingCall(messageData);
                }

                break;
              default:
                log('Unknown notification type');
                NotificationHandler().foregroundNotification(message);
                await FirebaseMessaging.instance
                    .setForegroundNotificationPresentationOptions(
                        alert: true, badge: true, sound: true);
            }
          } else {
            log('firebase onmessage in else');
          }
        }
      } else {
        log('No additional data available in handleNotificationData');
      }
    });
  }

  void showForegroundNotification(Map<String, dynamic>? additionalData) async {
    if (additionalData == null) {
      print('No additional data available in handleNotificationData');
      return;
    }
    log('showForegroundNotification Additional Data: $additionalData');
    final title = additionalData['title'] ?? '';
    print('onesignal Title: $title');

    final body = additionalData['body'] ?? '';

    if (body is String) {
      try {
        final bodyData = json.decode(body);
        print('onesignal bodyData: $bodyData');
        print('onesignalTitle: $title');
        print('Notification Received');
        if (title == ConstantsKeys.LIVESTREAMING) {
          String sessionType = bodyData["sessionType"];
          if (sessionType == ConstantsKeys.STARTSESSION) {
            String? liveChatUserName2 = bodyData['liveChatSUserName'];
            if (liveChatUserName2 != null) {
              liveAstrologerController.liveChatUserName = liveChatUserName2;
              liveAstrologerController.update();
            }
            String chatId = bodyData["chatId"];
            liveAstrologerController.isUserJoinAsChat = true;
            liveAstrologerController.update();
            liveAstrologerController.chatId = chatId;
            int waitListId = int.parse(bodyData["waitListId"].toString());
            String time = liveAstrologerController.waitList
                .where((element) => element.id == waitListId)
                .first
                .time;
            liveAstrologerController.endTime =
                DateTime.now().millisecondsSinceEpoch +
                    1000 * int.parse(time.toString());
            liveAstrologerController.update();
          } else {
            if (liveAstrologerController.isOpenPersonalChatDialog) {
              Get.back(); //if chat dialog opended
              liveAstrologerController.isOpenPersonalChatDialog = false;
            }
            liveAstrologerController.isUserJoinAsChat = false;
            liveAstrologerController.chatId = null;
            liveAstrologerController.update();
          }
        } else if (title == ConstantsKeys.TimeAndSession) {
          int waitListId = int.parse(bodyData["waitListId"].toString());
          liveAstrologerController.joinedUserName = bodyData["name"] ?? "User";
          liveAstrologerController.joinedUserProfile =
              bodyData["profile"] ?? "";
          String time = liveAstrologerController.waitList
              .where((element) => element.id == waitListId)
              .first
              .time;
          liveAstrologerController.endTime =
              DateTime.now().millisecondsSinceEpoch +
                  1000 * int.parse(time.toString());
          liveAstrologerController.update();
        } else if (title == ConstantsKeys.RejectChatFromAstrologer) {
          print('user Rejected call request:-');
          callController.isRejectCall = true;
          callController.update();
          callController.rejectDialog();
        } else {
          try {
            if (bodyData.isNotEmpty) {
              var messageData = bodyData;
              debugPrint('set msg type foreground');

              log('noti body $messageData');
              global.userID = messageData['id'];
              print('id of user ${global.userID}');
              if (messageData['notificationType'] != null) {
                switch (messageData['notificationType']) {
                  case 7:
                    // get wallet api call
                    await walletController.getAmountList(isLoading: 0);

                    break;

                  case 2:
                    global.userID = messageData['id'];
                    print('new id is ${global.userID}');
                    await callController.getCallList(true);
                    CallUtils.showIncomingCall(messageData);

                    break;

                  case 9:
                    reportController.reportList.clear();
                    reportController.update();
                    await reportController.getReportList(false);

                    break;

                  case 10:
                  case 11:
                  case 12:
                    liveAstrologerController.isUserJoinWaitList = true;
                    liveAstrologerController.update();

                    break;

                  default:
                    print('Unknown notification type default');
                  // NotificationHandler().foregroundNotification(message);
                  // await FirebaseMessaging.instance
                  //     .setForegroundNotificationPresentationOptions(
                  //         alert: true, badge: true, sound: true);
                }
              } else {
                log('message admin is ${messageData['description']}');
              }
            } else {
              debugPrint('else data null');
            }
          } catch (e) {
            debugPrint('else data null exceptio is $e');
          }
        }
      } catch (e) {
        print('Failed to onesignal body: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: Sizer(
        builder: (context, orientation, deviceType) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: Get.key,
          defaultTransition: Transition.rightToLeftWithFade,
          enableLog: true,
          theme: Themes.light,
          darkTheme: Themes.dark,
          themeMode: ThemeService().theme,
          locale: context.locale,
          localizationsDelegates: [
            ...context.localizationDelegates,
            FallbackLocalizationDelegate()
          ],
          supportedLocales: context.supportedLocales,
          initialBinding: NetworkBinding(),
          title: global.appName,
          initialRoute: "SplashScreen",
          home: SplashScreen(
            a: analytics,
            o: observer,
          ),
        ),
      ),
    );
  }

  void initializeCallKitEventHandlers() async {
    dynamic fcmToken = await FirebaseMessaging.instance.getToken();
    log('FCM token is $fcmToken');

    FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
      if (event == null) return;

      switch (event.event) {
        case Event.actionCallStart:
          // Handle call accept action
          log('actionCallStart call incoming');
          break;
        case Event.actionCallAccept:
          // Handle call/chat accept action
          final prefs = await SharedPreferences.getInstance();
          final notificationType = event.body['extra']["notificationType"];

          print('actionCallAccept incoming - notificationType: $notificationType');
          await prefs.setBool(ConstantsKeys.ISACCEPTED, false);
          await prefs.setString(ConstantsKeys.ISACCEPTEDDATA, '');
          await prefs.commit();

          // Check if it's a chat notification (type 8) or call notification (type 2)
          if (notificationType == 8) {
            log('Chat accept from CallKit');
            chatAccept(event);
          } else if (notificationType == 2) {
            callAccept(event);
          }
          break;
        case Event.actionCallDecline:
          log('call/chat reject initializekit');
          //delay
          await Future.delayed(const Duration(milliseconds: 400));
          // Handle call/chat end action
          final prefs = await SharedPreferences.getInstance();
          await prefs.reload(); // <-- IMPORTANT: force reload from disk

          final notificationTypeDecline = event.body['extra']["notificationType"];

          // Handle chat rejection (type 8)
          if (notificationTypeDecline == 8) {
            log('Chat reject from CallKit');
            final chatId = event.body['extra']['chatId'];
            if (chatId != null) {
              await chatController.rejectChatRequest(chatId);
              chatController.update();
            }
          }
          // Handle call rejection (type 2)
          else if (notificationTypeDecline == 2) {
            if (event.body['extra']['call_type'] == 10 ||
                event.body['extra']['call_type'] == 11) {
              bool isAlreadyRejected =
                  prefs.getBool(ConstantsKeys.ISREJECTED) ?? false;
              log('isAlreadyRejected in backgorund ${!isAlreadyRejected} and real is $isAlreadyRejected');

              if (!isAlreadyRejected) {
                await prefs.setBool(ConstantsKeys.ISACCEPTED, false);
                await prefs.setBool(ConstantsKeys.ISREJECTED, false);
                await prefs.setString(ConstantsKeys.ISACCEPTEDDATA, '');
                await prefs.commit();
                log('not rejected in backgorund');

                await callController
                    .rejectCallRequest(event.body['extra']['callId']);
                callController.update();
              } else {
                log('already rejected in backgorund');
              }
            }
          }
          break;

        case Event.actionCallCallback:
          final notificationTypeCallback = event.body['extra']["notificationType"];
          if (notificationTypeCallback == 8) {
            chatAccept(event);
          } else {
            callAccept(event);
          }
          break;

        default:
          break;
      }
    });
  }

  void callAccept(CallEvent event) async {
    log('extra call notificationType ${event.body}');
    log('extra call notificationType ${event.body['extra']['call_method']}');
    log('extra call callId ${event.body['extra']['callId']}');
    log('extra call profile ${event.body['extra']['profile']}');
    log('extra call name ${event.body['extra']['name']}');
    log('extra call call_duration ${event.body['extra']['call_duration']}');
    log('extra call fcmToken ${event.body['extra']['fcmToken']}');
    log('extra call CustomerID ${event.body['extra']['id']}');
    //clear notification
    await localNotifications.cancelAll();

    if (event.body['extra']["notificationType"] == 2) {
      callController.callList.clear();
      callController.update();
      await callController.getCallList(false);
      callController.update();

      if (event.body['extra']['call_type'] == 10) {
        global.isaudioCallinprogress = 0;
        log('Accept call agora or hms');
        callController.acceptCallRequest(
          event.body['extra']['callId'],
          event.body['extra']['profile'],
          event.body['extra']['name'],
          event.body['extra']['id'],
          event.body['extra']['fcmToken'],
          event.body['extra']['call_duration'].toString(),
          event.body['extra']['call_method'].toString(),
        );
      } else if (event.body['extra']['call_type'] == 11) {
        callController.acceptVideoCallRequest(
          event.body['extra']['callId'],
          event.body['extra']['profile'],
          event.body['extra']['name'],
          event.body['extra']['id'],
          event.body['extra']['fcmToken'],
          event.body['extra']['call_duration'].toString(),
          event.body['extra']['call_method'].toString(),
        );
      }
    } else {
      //may be chat
    }
  }

  /// Handle chat accept from CallKit notification
  void chatAccept(CallEvent event) async {
    log('chatAccept - event body: ${event.body}');
    final extra = event.body['extra'];
    final chatId = extra['chatId'];
    log('chatAccept - chatId: $chatId');
    log('chatAccept - userId: ${extra['userId']}');
    log('chatAccept - userName: ${extra['userName']}');
    log('chatAccept - profile: ${extra['profile']}');
    log('chatAccept - fcmToken: ${extra['fcmToken']}');
    log('chatAccept - chat_duration: ${extra['chat_duration']}');
    log('chatAccept - subscription_id: ${extra['subscription_id']}');

    // Mark chat as accepted immediately to prevent duplicate notifications
    if (chatId != null) {
      chatController.acceptedChatIds.add(chatId);
      log('Chat $chatId marked as accepted in chatAccept. Accepted chats: ${chatController.acceptedChatIds}');
    }

    // Clear notifications
    await localNotifications.cancelAll();
    await FlutterCallkitIncoming.endAllCalls();

    // Store chat ID
    await chatController.storeChatId(
      extra['userId'],
      chatId,
    );

    // Accept chat request and navigate to chat screen
    chatController.acceptChatRequest(
      extra['subscription_id'] ?? "",
      extra['chatId'],
      extra['userId'],
      extra['userName'] ?? "",
      extra['profile'] ?? "",
      extra['userId'],
      extra['fcmToken']?.toString() ?? "",
      extra['chat_duration']?.toString() ?? '',
      "main.dart chatAccept from CallKit",
    );
  }

  // Show simple notification for chat requests that are already accepted/in progress
  Future<void> _showSimpleChatNotification(String userName, String message) async {
    try {
      final android = const AndroidInitializationSettings('@mipmap/ic_launcher');
      final initializationSettingsDarwin = DarwinInitializationSettings(
        defaultPresentBadge: true,
        requestSoundPermission: true,
        requestBadgePermission: true,
        defaultPresentSound: true,
      );
      final initialSetting = InitializationSettings(
        android: android,
        iOS: initializationSettingsDarwin,
      );

      // Initialize if not already initialized
      final initialized = await localNotifications.initialize(
        initialSetting,
        onDidReceiveNotificationResponse: (details) {
          log('Simple chat notification tapped');
        },
      );

      if (initialized != null && initialized) {
        const androidDetails = AndroidNotificationDetails(
          'chat_channel_id',
          'Chat Notifications',
          channelDescription: 'Notifications for chat requests',
          importance: Importance.high,
          priority: Priority.high,
          icon: "@mipmap/ic_launcher",
          playSound: true,
          enableVibration: true,
        );

        const iOSDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

        const platformChannelSpecifics = NotificationDetails(
          android: androidDetails,
          iOS: iOSDetails,
        );

        await localNotifications.show(
          DateTime.now().millisecondsSinceEpoch % 100000,
          'Chat Request from $userName',
          message,
          platformChannelSpecifics,
        );
        log('Simple chat notification shown for $userName');
      }
    } catch (e) {
      log('Error showing simple chat notification: $e');
    }
  }

  void showAcceptRejectDialog(Map<String, dynamic> messageData) {
    if (global.isDialogopend) {
      return;
    }
    global.isDialogopend = true;
    log('show-> $messageData');
    Future.delayed(Duration.zero, () {
      // Ensure it runs on the UI thread
      Get.defaultDialog(
        title: "Incoming Request",
        titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat, size: 50, color: Get.theme.primaryColor),
            const SizedBox(height: 10),
            Text(
              messageData['description'] ?? "You have a new request.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
          ],
        ),
        radius: 15,
        barrierDismissible: false,
        actions: [
          TextButton(
            onPressed: () async {
              global.stopNotification();
              Get.back();
              global.isDialogopend = false;
              await Future.delayed(const Duration(milliseconds: 500));
              await localNotifications.cancelAll();
              await chatController.rejectChatRequest(messageData['chatId']);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: const Text('Decline'),
          ),
          ElevatedButton(
            onPressed: () async {
              await Future.delayed(const Duration(milliseconds: 500));
              global.stopNotification();
              await localNotifications.cancelAll();
              global.isDialogopend = false;
              await chatController.storeChatId(
                messageData['userId'],
                messageData['chatId'],
              );
              Get.back();

              chatController.acceptChatRequest(
                  messageData['subscription_id'] ?? "",
                  messageData['chatId'] ?? "",
                  messageData['userId'],
                  messageData['userName'] ?? "",
                  messageData['profile'] ?? "",
                  messageData['userId'] ?? "",
                  messageData['fcmToken'].toString(),
                  messageData['chat_duration']?.toString() ?? '',
                  "main.dart:- ${messageData['fcmToken'].toString()}");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            child: const Text('Accept'),
          ),
        ],
      );
    });
  }
}
