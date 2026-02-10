// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/home_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/wallet_controller.dart';
import 'package:brahmanshtalk/controllers/notification_controller.dart';
import 'package:brahmanshtalk/views/HomeScreen/tabs/chatTab.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;
import '../models/systemFlagModel.dart';
import '../models/user_model.dart';
import '../services/apiHelper.dart';
import '../utils/constantskeys.dart';
import '../views/Authentication/login_screen.dart';
import '../views/HomeScreen/Drawer/Wallet/Wallet_screen.dart';
import '../views/HomeScreen/Report_Module/report_request_screen.dart';
import '../views/HomeScreen/history/HistroryScreen.dart';
import '../views/HomeScreen/home_screen.dart';
import '../views/HomeScreen/notification_screen.dart';
import 'HomeController/call_controller.dart';
import 'HomeController/chat_controller.dart';
import 'HomeController/live_astrologer_controller.dart';
import 'HomeController/report_controller.dart';
import 'following_controller.dart';
import 'networkController.dart';

class SplashController extends GetxController {
  // getxcontroller instance
  final networkController = Get.put(NetworkController());
  final chatController = Get.find<ChatController>();
  final callController = Get.find<CallController>();
  final reportController = Get.put(ReportController());
  final followingController = Get.put(FollowingController());
  final liveAstrologerController = Get.put(LiveAstrologerController());
  String? appShareLinkForLiveSreaming;
  final homecontroller = Get.find<HomeController>();
  final walletController = Get.find<WalletController>();
  final signupController = Get.put(SignupController());
  //Class
  APIHelper apiHelper = APIHelper();
  CurrentUser? currentUser;
  //Variables
  var systemFlag = <SystemFlag>[];
  RxBool isDataLoaded = false.obs;
  String? version;
  String currentLanguageCode = 'en';

  void _handleNotificationNavigation(Map<String, dynamic> chatData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ConstantsKeys.CHATDATA, '');

    if (chatData.containsKey('body')) {
      Map<String, dynamic> body = jsonDecode(chatData['body']);
      print('notificationType ${body["notificationType"]}');
      if (body["notificationType"] == 8) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          Get.to(() => const ChatTab());
        });
      } else {
        print('Notification type is not 8');
      }
    } else {
      Get.off(() => HomeScreen());
      print('No body field found in chat data.');
    }
  }

  @override
  void onInit() async {
    super.onInit();
    _init();
  }

  _init() async {
    try {
      await global.checkBody().then(
        (networkResult) async {
          print('after check body $networkResult');
          if (networkResult) {
            if (networkController.connectionStatus.value != 0) {
              await performApiCalls();
            } else {
              global.showToast(message: "No Network Available");
            }
          } else {
            global.showToast(message: "No Network Available");
          }
        },
      );
    } catch (err) {
      print('catch errror $err');
      global.printException("SplashController", "_init", err);
    }
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print('FCM TOKEN $fcmToken');
  }

  getSystemList() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getSystemFlag().then((result) {
            print("kjansdkj ${result.status}");
            if (result.status == "200") {
              systemFlag = result.recordList;
              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(message: "System flag not found");
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getKundliList():$e');
    }
  }

  performApiCalls() async {
    await apiHelper.getMasterTableData().then(
      (apiResult) async {
        print("jansjkn ${apiResult.status}");
        if (apiResult.status == "200") {
          await global.getDeviceData();
          await getSystemList();
          global.appName =
              global.getSystemFlagValue(global.systemFlagNameList.appName);
          global.spLanguage = await SharedPreferences.getInstance();
          currentLanguageCode =
              global.spLanguage!.getString(ConstantsKeys.CURRENTLANGUAGE) ??
                  'en';
          update();
          global.getMasterTableDataModelList = apiResult.recordList;
          global.astrologerCategoryModelList =
              global.getMasterTableDataModelList.astrologerCategory;
          global.skillModelList = global.getMasterTableDataModelList.skill;
          global.allSkillModelList =
              global.getMasterTableDataModelList.allskill;
          global.languageModelList =
              global.getMasterTableDataModelList.language;
          dev.log('language gloabl length ${global.languageModelList?.length}');
          global.assistantPrimarySkillModelList =
              global.getMasterTableDataModelList.assistantPrimarySkill;
          global.assistantAllSkillModelList =
              global.getMasterTableDataModelList.assistantAllSkill;
          global.assistantLanguageModelList =
              global.getMasterTableDataModelList.assistantLanguage;
          global.mainSourceBusinessModelList =
              global.getMasterTableDataModelList.mainSourceBusiness;
          global.highestQualificationModelList =
              global.getMasterTableDataModelList.highestQualification;
          global.degreeDiplomaList =
              global.getMasterTableDataModelList.qualifications;
          global.jobWorkingList = global.getMasterTableDataModelList.jobs;
        }
      },
    );
    global.sp = await SharedPreferences.getInstance();
    dev.log(
        'global sp is get ${global.sp!.getString(ConstantsKeys.CURRENTUSER)}');
    if (global.sp!.getString(ConstantsKeys.CURRENTUSER) != null) {
      await apiHelper.validateSession().then((result) async {
        if (result.status == "200") {
          global.user = result.recordList;
          global.user.token = global.user.sessionToken!.split(" ")[1];
          await global.sp!.setString(
              ConstantsKeys.CURRENTUSER, json.encode(global.user.toJson()));
          if (global.user.id != null) {
            await global.getCurrentUserId();

            Future.wait<void>([
              chatController.getChatList(false),
              callController.getCallList(false),
              reportController.getReportList(false),
              followingController.followingList(false),
              signupController.astrologerProfileById(false),
              liveAstrologerController.endLiveSession(true),
              walletController.getAmountList(),
            ]);
            bool isNotificationHandled = false;
            bool isNavigated = false;
            OneSignal.Notifications.addClickListener((event) {
              try {
                if (isNavigated) return;
                isNavigated = true;
                isNotificationHandled = true;
                onSelectNotification(event.notification.additionalData);
              } catch (e) {
                print('Error: $e');
              }
            });
            await Future.delayed(const Duration(seconds: 2));
            print('isNotificationHandled splash ${!isNotificationHandled}');
            print('isNavigated splash ${!isNavigated}');

            if (!isNotificationHandled && !isNavigated) {
              print('loadAllData splash');
              loadAllData();
            }
          } else {
            Get.off(() => const LoginScreen(), routeName: "LoginScreen");
          }
        } else {
          Get.off(() => const LoginScreen(), routeName: "LoginScreen");
        }
      });
    } else {
      Get.off(() => const LoginScreen(), routeName: "LoginScreen");
    }
  }

  void onSelectNotification(Map<String, dynamic>? additionalData) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Small delay
    global.sp = await SharedPreferences.getInstance();
    if (global.sp!.getString("currentUser") != null) {
      if (additionalData == null) {
        print('No additional data available in handleNotificationData');
        return;
      }
      final description = additionalData['description'] ?? '';
      final body = additionalData['body'] ?? '';
      final title = additionalData['title'] ?? '';
      print('onesignal Description: $description');
      print('onesignal Title: $title');
      print('onesignal body: $body');

      if (body is String) {
        try {
          final bodyData = json.decode(body);
          if (bodyData["notificationType"] == 7) {
            await walletController.getAmountList();
            walletController.update();
            Get.to(() => WalletScreen());
          } else if (bodyData["notificationType"] == 30) {
            //  move to history screen when puja started within 5 min
            await signupController.astrologerProfileById(true);
            Get.find<HomeController>().homeTabIndex = 1;
            homecontroller.historyTabController!.animateTo(1);
            Get.find<HomeController>().update();
            Get.to(() => const HistoryScreen());
          } else if (bodyData["notificationType"] == 15) {
            print('elsif splashcontroller NotificationScreen 15');
            await Future.delayed(
                const Duration(milliseconds: 100)); // Small delay

            await Get.find<NotificationController>().getNotificationList(false);
            Get.to(() => const NotificationScreen());
          } else if (bodyData["notificationType"] == 9) {
            reportController.reportList.clear();
            reportController.update();
            homecontroller.homeTabIndex = 0;

            homecontroller.update();
            await reportController.getReportList(false);
            reportController.update();

            Get.to(() => ReportRequestScreen());
          } else if (bodyData["notificationType"] == 13) {
            //GIFT
            print('noti typ live - ${bodyData["notificationType"]}');
            print('is online ${homecontroller.notificationHandlingremoteUID}');
            if (homecontroller.notificationHandlingremoteUID != 0) {
              global.showToast(message: 'You are already live, end call first');
            } else {
              Future.wait<void>([
                walletController.getAmountList(),
                signupController.astrologerProfileById(false)
              ]);

              signupController.astrologerList = [];
              signupController.update();
              walletController.update();
              homecontroller.homeTabIndex = 0;
              homecontroller.homeTabIndex = 1; //pageview index
              homecontroller.isSelectedBottomIcon = 1;
              homecontroller.historyTabController!.animateTo(0);
              homecontroller.update();
              Get.offAll(() => HomeScreen());
            }
          } else if (bodyData["notificationType"] == 8) {
            //chat
            print('chat tab clear and updated');
            Get.to(() => const ChatTab());
          } else if (bodyData["notificationType"] == 2) {
            callController.callList.clear();
            callController.update();
            await callController.getCallList(false);
            callController.update();

            if (bodyData['call_type'] == 10) {
              callController.acceptCallRequest(
                  bodyData['callId'],
                  bodyData['profile'],
                  bodyData['name'],
                  bodyData['id'],
                  bodyData['fcmToken'],
                  bodyData['call_duration'].toString(),
                  bodyData['call_method'].toString());
            } else if (bodyData['call_type'] == 11) {
              callController.acceptVideoCallRequest(
                bodyData['callId'],
                bodyData['profile'] ?? '',
                bodyData['name'],
                bodyData['id'],
                bodyData['fcmToken'],
                bodyData['call_duration'].toString(),
                bodyData['call_method'].toString(),
              );
            }
          } else {
            //IF NO NOTIFICATION TYPE AVAIL THEN SHOW NOTIFICATION SCREEN TO PARTNER
            print('els NotificationScreen}');
            Get.to(() => HomeScreen());
          }
        } catch (e) {
          print('Failed to onesignal body: $e');
          Get.to(() => HomeScreen());
        }
      }
    } else {
      print('No additional data available in handleNotificationData');
    }
  }

  void loadAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    await Future.delayed(const Duration(seconds: 2));
    bool? isacceptedcall = prefs.getBool(ConstantsKeys.ISACCEPTED);
    bool? isrejectedcall = prefs.getBool(ConstantsKeys.ISREJECTED);
    bool? isChatDataAvailable = prefs.getBool(ConstantsKeys.ISCHATAVILABLE);
    print('loadAllData isacceptedcall called $isacceptedcall');
    print('loadAllData isrejectedcall called $isrejectedcall');
    print('loadAllData data ${prefs.getString(ConstantsKeys.ISACCEPTEDDATA)}');

    if (isacceptedcall == true) {
      String? dataaccepted = prefs.getString(ConstantsKeys.ISACCEPTEDDATA);
      if (dataaccepted!.isNotEmpty) {
        await prefs.setBool(ConstantsKeys.ISACCEPTED, false);
        callAccept(jsonDecode(dataaccepted));
        await prefs.setString(ConstantsKeys.ISACCEPTEDDATA, '');
      }
    } else if (isrejectedcall == true) {
      print('else isrejectedcall chat');
      await prefs.setBool(ConstantsKeys.ISACCEPTED, false);
      await prefs.setString(ConstantsKeys.ISACCEPTEDDATA, '');
      await prefs.setBool(ConstantsKeys.ISREJECTED, false);
      Get.off(() => HomeScreen());
    } else if (isChatDataAvailable == true) {
      print('Processing chat data... $isChatDataAvailable');
      await Future.delayed(const Duration(milliseconds: 200));
      Get.to(() => const ChatTab())?.then(
        (value) {
            Get.to(() =>  HomeScreen());
        },
      );
    } else {
      print('is accepted is not either false or not set ');
      await prefs.setBool(ConstantsKeys.ISACCEPTED, false);
      await prefs.setString(ConstantsKeys.ISACCEPTEDDATA, '');
      Get.off(() => HomeScreen());
    }
  }
}

@pragma('vm:entry-point')
void callAccept(Map<String, dynamic> extraData) async {
  print('extra call/chat astrologerId $extraData');
  print('extra call/chat notificationType ${extraData['notificationType']}');

  final notificationType = extraData["notificationType"];

  // Handle chat acceptance (type 8)
  if (notificationType == 8) {
    print('Processing chat accept from background/killed state');
    final chatController = Get.find<ChatController>();
    
    // Store chat ID
    await chatController.storeChatId(
      extraData['userId'],
      extraData['chatId'],
    );

    // Accept chat request and navigate to chat screen
    chatController.acceptChatRequest(
      extraData['subscription_id'] ?? "",
      extraData['chatId'],
      extraData['userId'],
      extraData['userName'] ?? "",
      extraData['profile'] ?? "",
      extraData['userId'],
      extraData['fcmToken']?.toString() ?? "",
      extraData['chat_duration']?.toString() ?? '',
      "splashController callAccept from background",
      appKilled: true,
    );
  }
  // Handle call acceptance (type 2)
  else if (notificationType == 2) {
    print('extra call calltype ${extraData['call_type']}');
    print('extra call calltype type ${extraData['call_type'].runtimeType}');

    final callController = Get.find<CallController>();
    callController.callList.clear();
    callController.update();
    await callController.getCallList(false);
    callController.update();

    if (extraData['call_type'] == 10) {
      callController.acceptCallRequest(
          extraData['callId'],
          extraData['profile'],
          extraData['name'],
          extraData['id'],
          extraData['fcmToken'] ?? '',
          extraData['call_duration'].toString(),
          extraData['call_method'].toString());
    } else if (extraData['call_type'] == 11) {
      callController.acceptVideoCallRequest(
        extraData['callId'],
        extraData['profile'],
        extraData['name'],
        extraData['id'],
        extraData['fcmToken'] ?? '',
        extraData['call_duration'].toString(),
        extraData['call_method'].toString(),
      );
    }
  }
}
