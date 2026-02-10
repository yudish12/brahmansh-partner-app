// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, unused_local_variable, prefer_typing_uninitialized_variables, unnecessary_null_comparison, non_constant_identifier_names, depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:brahmanshtalk/utils/constantskeys.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';
import 'package:translator/translator.dart';
import '../controllers/HomeController/live_astrologer_controller.dart';
import '../controllers/networkController.dart';
import '../controllers/splashController.dart';
import '../models/Master Table Model/all_skill_model.dart';
import '../models/Master Table Model/assistant/assistant_all_skill_model.dart';
import '../models/Master Table Model/assistant/assistant_language_list_model.dart';
import '../models/Master Table Model/assistant/assistant_primary_skill_model.dart';
import '../models/Master Table Model/astrologer_category_list_model.dart';
import '../models/Master Table Model/get_master_table_list_model.dart';
import '../models/Master Table Model/highest_qualification_model.dart';
import '../models/Master Table Model/language_list_model.dart';
import '../models/Master Table Model/main_source_business_model.dart';
import '../models/Master Table Model/primary_skill_model.dart';
import '../models/hororScopeSignModel.dart';
import '../models/systemFlagNameList.dart';
import '../models/user_model.dart';
import '../services/apiHelper.dart';
import '../views/Authentication/login_screen.dart';
import 'config.dart';
import 'package:audioplayers/audioplayers.dart';

//----------------------------------------------Variable--------------------------------------

//Getx Controller
NetworkController networkController = Get.put(NetworkController());
LiveAstrologerController liveAstrologerController =
    Get.find<LiveAstrologerController>();
//Shared PReffrence
SharedPreferences? sp;
SharedPreferences? spLanguage;
// String? onesignalId;
bool? isChatAccepted = false;
bool? isCallAccepted = false;
dynamic firebaseChatId;

bool? isChatTimerStarted = false;
bool? isCallTimerStarted = false;
dynamic chatStartedAt = null;
int? callStartedAt;
bool isaudioEnabled = false;
bool isaudioMuted = false;

int? isCallOrChat = 0;
dynamic isaudioCallinprogress = 0;
dynamic isvideoCallinprogress = 0;
dynamic isImHostGlobally;
//Model
CurrentUser user = CurrentUser();
Map<String, dynamic>? globaldocumentmap = {};

GetMasterTableDataModel getMasterTableDataModelList = GetMasterTableDataModel();
SplashController splashController = Get.find<SplashController>();

//Model List
final List<String> genderList = <String>["Male", "Female", "Other"];
List<AstrolgoerCategoryModel>? astrologerCategoryModelList = [];
List<PrimarySkillModel>? skillModelList = [];
List<AllSkillModel>? allSkillModelList = [];

dynamic hmsauthToken = 0;

dynamic zegoAuthToken = 0;
dynamic zegoLiveID = 0;
dynamic zegoUserid = 0;
final getStorage = GetStorage();
bool? isinAcceptCallscreen;
void inCallscreen(bool flag) {
  isinAcceptCallscreen = flag;
  log('in callscreen flag $isinAcceptCallscreen');
}

// Helper methods
bool isValidUrl(String url) {
  try {
    final uri = Uri.parse(url);
    return uri.isAbsolute;
  } catch (e) {
    return false;
  }
}

String encodeUrl(String url) {
  try {
    final uri = Uri.parse(url);
    return uri.toString();
  } catch (e) {
    return url;
  }
}

bool? isinAcceptChatscreen;
void inChatscreen(bool flag) {
  isinAcceptChatscreen = flag;
  log('in isinAcceptChatscreen flag $isinAcceptChatscreen');
}

bool isDialogopend = false;
String maskMobileNumber(String number) {
  if (number.length < 4) return number; // not enough digits to mask
  String start = number.substring(0, 2);
  String end = number.substring(number.length - 2);
  String stars = '*' * (number.length - 4);
  return '$start$stars$end';
}

List<LanguageModel>? languageModelList = [];
List<AssistantPrimarySkillModel>? assistantPrimarySkillModelList = [];
List<AssistantAllSkillModel>? assistantAllSkillModelList = [];
List<AssistantLanguageModel>? assistantLanguageModelList = [];
List<MainSourceBusinessModel>? mainSourceBusinessModelList = [];
bool isUserJoinAsChatInLive = false;
List<HighestQualificationModel>? highestQualificationModelList = [];
List<CountryTravel>? degreeDiplomaList = [];
List<CountryTravel>? jobWorkingList = [];
APIHelper apiHelper = APIHelper();
List<HororscopeSignModel> hororscopeSignList = [];
final List foreignCountryCountList = <String>["0", "1-2", "3-5", "6+"];
int? userID;
String appUrl = Uri.encodeFull(
    "https://play.google.com/store/apps/details?id=com.brahmanshtalk.astrologer");

abstract class DateFormatter {
  static String? formatDate(DateTime timestamp) {
    if (timestamp == null) {
      return null;
    }
    String date =
        "${timestamp.day} ${DateFormat('MMMM').format(timestamp)} ${timestamp.year}";
    return date;
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }

  static DateTime? toDateTime(Timestamp value) {
    if (value == null) return null;

    return value.toDate();
  }
}

//Other Variable
Map<int, Color> color = {
  50: const Color.fromRGBO(240, 223, 32, .1),
  100: const Color.fromRGBO(240, 223, 32, .2),
  200: const Color.fromRGBO(240, 223, 32, .3),
  300: const Color.fromRGBO(240, 223, 32, .4),
  400: const Color.fromRGBO(240, 223, 32, .5),
  500: const Color.fromRGBO(240, 223, 32, .6),
  600: const Color.fromRGBO(240, 223, 32, .7),
  700: const Color.fromRGBO(240, 223, 32, .8),
  800: const Color.fromRGBO(240, 223, 32, .9),
  900: const Color.fromRGBO(240, 223, 32, 1),
};

String getSystemFlagValue(String flag) {
  return splashController.systemFlag.firstWhere((e) => e.name == flag).value;
}

//Application Id
String appId = Platform.isAndroid ? "AstroGuruAndroid" : "AstroGuruIos";
AndroidDeviceInfo? androidInfo;
IosDeviceInfo? iosInfo;
DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
String? deviceId;
String? fcmToken;
String? deviceLocation;
String? deviceManufacturer;
String? deviceModel;
var appVersion;
int? currentUserId;
int? astrologerId;

String agoraAppId = "832f8b58443247a2b8b74677198bbc82";
String agoraAppCertificate = "36a8fdae33b447e8a928e108a7f36bd9";
bool? isLeaveVideoCall = false;

String agoraChannelName = "";
String agoraToken = "";
String agoraLiveToken = "";
String channelName = "astrowayGuruLive";
String agoraLiveChannelName = "";
String zegoLiveChannelName = "";

String liveChannelName = "astrowayGuruLive";
String agoraChatToken = "";
String agoraChatUserId = "astrowayGuruLive";
String chatChannelName = "astrowayGuruLive";
String encodedString = "&&";
String appName = "";
var nativeAndroidPlatform = const MethodChannel('nativeAndroid');
SystemFlagNameList systemFlagNameList = SystemFlagNameList();

//Get app version
String getAppVersion() {
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    appVersion = packageInfo.version;
  });
  return appVersion;
}
  AudioPlayer? audio_player = AudioPlayer();

Future<void> playNotificationSound() async {
  await audio_player?.play(AssetSource('ringtone.mp3'));
  Future.delayed(const Duration(seconds: 5), () {
    audio_player?.stop();
    audio_player?.dispose();
    log('stopped notification sound');
  });
}

Future<void> stopNotification() async {
    audio_player?.stop();
    audio_player?.dispose();
    log('stopped notification sound');
}
String buildImageUrl(String? path) {
  if (path == null || path.isEmpty) return "";
  // Check if already a full URL
  if (path.startsWith("http://") || path.startsWith("https://")) {
    return path;
  }
  path = path.replaceFirst(RegExp(r"^/"), "");
  log('return path is-> $path');
  return "$imgBaseurl$path";
}

Widget buildCoinIcon() {
  return CachedNetworkImage(
    imageUrl: global.getSystemFlagValue(
      global.systemFlagNameList.coinIcon,
    ),
    height: 18.sp,
    width: 18.sp,
  );
}

bool isCoinWallet() {
  return global.getSystemFlagValue(global.systemFlagNameList.walletType) ==
      'Coin';
}

void debugRoomState(HMSRoom room) {
  log('=== ROOM STATE DEBUG ===');
  log('Room: ${room.name} (${room.id})');
  log('Peers count: ${room.peers?.length}');

  for (var peer in room.peers ?? []) {
    log('Peer: ${peer.name} (${peer.isLocal ? 'Local' : 'Remote'})');
    log('  - Role: ${peer.role.name}');
    log('  - Video Track: ${peer.videoTrack != null ? "${peer.videoTrack?.trackId} (muted: ${peer.videoTrack?.isMute})" : "NULL"}');
    log('  - Audio Track: ${peer.audioTrack != null ? "${peer.audioTrack?.trackId} (muted: ${peer.audioTrack?.isMute})" : "NULL"}');
  }
  log('=========================');
}

// Build Translated Text Here.....
Widget buildTranslatedText(
  String text,
  TextStyle? style,
) {
  final googleTranslator = GoogleTranslator();

  return FutureBuilder<String>(
    future: googleTranslator
        .translate(text, to: Get.locale!.languageCode)
        .then((value) => value.text),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: SizedBox(
            height: 16.0,
            width: 16.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              color: Get.theme.primaryColor,
            ),
          ),
        );
      } else if (snapshot.hasError) {
        return Text(
          text,
          style: style ??
              Get.textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.w400, fontSize: 13),
        );
      } else {
        return Text(
          snapshot.data ?? "No translation available",
          style: style ??
              Get.textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.w700, fontSize: 13),
        );
      }
    },
  );
}

//Get device info
getDeviceData() async {
  await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    appVersion = packageInfo.version;
  });
  if (Platform.isAndroid) {
    androidInfo ??= await deviceInfo.androidInfo;
    deviceModel = androidInfo!.model;
    deviceManufacturer = androidInfo!.manufacturer;
    deviceId = androidInfo!.id;
    fcmToken = await FirebaseMessaging.instance.getToken();
  } else if (Platform.isIOS) {
    iosInfo ??= await deviceInfo.iosInfo;
    deviceModel = iosInfo!.model;
    deviceManufacturer = "Apple";
    deviceId = iosInfo!.identifierForVendor;
    fcmToken = await FirebaseMessaging.instance.getToken();
  }
}

Future<Map<String, dynamic>> loadCredentials() async {
  String credentialsPath = 'lib/utils/noti_service.json';
  String content = await rootBundle.loadString(credentialsPath);
  return json.decode(content);
}

Future<void> sendNotification(
    {String? fcmToken,
    String? title,
    String? subtitle,
    String? astroname,
    String? channelname,
    String? token,
    String? astroId,
    String? requestType,
    String? id,
    String? charge,
    String? nfcmToken,
    String? astroProfile,
    String? videoCallCharge,
    String? call_method = 'agora'}) async {
  var accountCredentials = await loadCredentials();
  var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  var client = http.Client();
  try {
    var credentials = await obtainAccessCredentialsViaServiceAccount(
        ServiceAccountCredentials.fromJson(accountCredentials), scopes, client);
    if (credentials == null) {
      log('Failed to obtain credentials');
      return;
    }
    final headers = {
      'content-type': 'application/json',
      'Authorization': 'Bearer ${credentials.accessToken.data}'
    };
    log("GENERATED TOKEN IS-> ${credentials.accessToken.data}");
    final data = {
      "message": {
        "token": fcmToken,
        "notification": {"body": subtitle, "title": title}, //remove later
        "data": {
          "title": title,
          "description": subtitle,
          "astroName": astroname,
          "channel": channelname,
          "token": token,
          "astroId": astroId,
          "requestType": requestType,
          "id": id,
          "charge": charge,
          "fcmToken": nfcmToken,
          "astroProfile": astroProfile,
          "videoCallCharge": videoCallCharge,
          "call_method": call_method
        },
        "android": {
          "notification": {"click_action": "android.intent.action.MAIN"}
        }
      }
    };

    final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/brahmansh-a4c4e/messages:send');

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(data),
    );
    log('noti response ${response.body}');
    if (response.statusCode == 200) {
      log('Notification sent successfully');
    } else {
      log('Failed to send notification: ${response.body}');
    }
  } catch (e) {
    print('Error sending notification: $e');
  } finally {
    client.close();
  }
}

Future<void> sendOneSignalNotification({
  required String playerId,
  required String title,
  bool? isSilent = true,
  String? fcmToken,
  String? subtitle,
  String? astroname,
  String? channelname,
  String? token,
  String? astroId,
  String? requestType,
  String? id,
  String? charge,
  String? nfcmToken,
  String? astroProfile,
  String? videoCallCharge,
}) async {
  const String onesignalApiUrl = "https://onesignal.com/api/v1/notifications";
  String onesignalAppId = OnesignalID;
  String onesignalApiKey =
      getSystemFlagValue(systemFlagNameList.oneSignalRestApiKey);

  print(
      '---------------------------------ONESIGNAL-----------------------------------------------------');
  log('onesignal apikey is-> $onesignalApiKey');
  log('onesignal appid is-> $onesignalAppId');
  log('onesignal playerid is-> $playerId');
  print(
      '-----------------------------------------------------------------------------------------------');

  final headers = {
    "Content-Type": "application/json; charset=utf-8",
    "Authorization": "Basic $onesignalApiKey",
  };
  try {
    final response = await http.post(
      Uri.parse(onesignalApiUrl),
      headers: headers,
      body: json.encode({
        "app_id": onesignalAppId,
        "include_player_ids": [playerId],
        if (isSilent == true) "content_available": true,
        "priority": "high",
        "data": {
          "title": title,
          "description": subtitle,
          "astroName": astroname,
          "channel": channelname,
          "token": token,
          "astroId": astroId,
          "requestType": requestType,
          "id": id,
          "charge": charge,
          "fcmToken": nfcmToken,
          "astroProfile": astroProfile,
          "videoCallCharge": videoCallCharge
        },
      }),
    );
    log('onesignal status is-> ${response.statusCode}');
    print('onesignal repsone is-> ${response.body}');
    if (response.statusCode == 200) {
      log("Notification sent successfully: ${response.body}");
    } else {
      log("Failed to send onesignal notification: ${response.body}");
    }
  } catch (e) {
    log("Error sending OneSignal notification: $e");
  }
}

Future<void> cancelOneSignalNotification(String notificationId) async {
  String onesignalApiUrl =
      "https://onesignal.com/api/v1/notifications/$notificationId";
  String onesignalApiKey =
      getSystemFlagValue(systemFlagNameList.oneSignalRestApiKey);

  final headers = {
    "Authorization": "Basic $onesignalApiKey",
  };

  try {
    final response = await http.delete(
      Uri.parse(onesignalApiUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      log("Notification canceled successfully: ${response.body}");
    } else {
      log("Failed to cancel notification: ${response.body}");
    }
  } catch (e) {
    log("Error canceling OneSignal notification: $e");
  }
}

//Shared prefrences
//save current user
CurrentUser? astroUser;
saveCurrentUser(CurrentUser user) async {
  try {
    sp = await SharedPreferences.getInstance();
    await sp!.setString(ConstantsKeys.CURRENTUSER, json.encode(user.toJson()));
    print("sucess");
  } catch (e) {
    print("Exception - gloabl.dart - saveCurrentUser():" + e.toString());
  }
}

///  =================================================================
/// ********************** LOGOUT ********************
/// ==================================================================
logoutUser(BuildContext context) async {
  showOnlyLoaderDialog();
  await apiHelper.setAstrologerOnOffBusyline("Offline");
  await apiHelper.logoutapi();
  sp = await SharedPreferences.getInstance();
  sp!.remove(ConstantsKeys.CURRENTUSER);
  log("current user logout:- ${sp!.getString('currentUserId')}");
  currentUserId = null;
  astrologerId = null;
  splashController.currentUser = null;
  user = CurrentUser();
  await Future.delayed(const Duration(seconds: 3)).then(
    (value) {
      hideLoader();
      Get.offAll(() => const LoginScreen());
    },
  );
}

//get current user
Future<int> getCurrentUser() async {
  sp = await SharedPreferences.getInstance();
  CurrentUser userData = CurrentUser.fromJson(
      json.decode(sp!.getString(ConstantsKeys.CURRENTUSER) ?? ""));
  int id = userData.id ?? 0;
  return id;
}

//Get data of current user id
getCurrentUserId() async {
  sp = await SharedPreferences.getInstance();
  CurrentUser userData = CurrentUser.fromJson(
      json.decode(sp!.getString(ConstantsKeys.CURRENTUSER) ?? ""));
  currentUserId = userData.id;
  astrologerId = userData.userId;
  debugPrint("Astrologer Auth Id $astrologerId");
}

//check login
Future<bool> isLogin() async {
  sp = await SharedPreferences.getInstance();
  if (sp!.getString("token") == null && sp!.getInt("currentUserId") == null) {
    Get.to(() => const LoginScreen());
    return false;
  } else {
    return true;
  }
}

//Device Details
String appId2 = Platform.isAndroid ? "2" : "2";
String reviewAppId = "2";
//-------------------------------------------Functions--------------------------------------

///  =================================================================
/// ********************** API HEADER ********************
/// ==================================================================
Future<Map<String, String>> getApiHeaders(bool authorizationRequired,
    {bool? ismultipart = false}) async {
  try {
    // ignore: prefer_collection_literals
    Map<String, String> apiHeader = Map<String, String>();
    Map<String, dynamic> deviceData = {};

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceData = {
        "deviceModel": androidInfo.model,
        "deviceManufacturer": androidInfo.manufacturer,
        "deviceId": androidInfo.id,
        "fcmToken": await FirebaseMessaging.instance.getToken(),
        "deviceLocation": null,
      };
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceData = {
        "deviceModel": iosInfo.model,
        "deviceManufacturer": "Apple",
        "deviceId": iosInfo.identifierForVendor,
        "fcmToken": await FirebaseMessaging.instance.getToken(),
        "deviceLocation": null,
      };
    }

    if (authorizationRequired) {
      sp = await SharedPreferences.getInstance();
      if (sp!.getString(ConstantsKeys.CURRENTUSER) != null) {
        String? tokenType;
        String? token;
        if (sp!.getString(ConstantsKeys.CURRENTUSER) != null) {
          CurrentUser userData = CurrentUser.fromJson(
              json.decode(sp!.getString(ConstantsKeys.CURRENTUSER) ?? ""));
          tokenType = userData.tokenType;
          token = userData.token;
        }
        print('authentication token :- $token');
        apiHeader.addAll({"Authorization": " $tokenType $token"});
      } else {
        apiHeader.addAll({"Authorization": appId});
      }
    } else {
      apiHeader.addAll({"Authorization": appId});
    }
    if (ismultipart == true) {
      // log('header multipart true yeah ');
      apiHeader.addAll({"Content-Type": "multipart/form-data"});
    } else {
      apiHeader.addAll({"Content-Type": "application/json"});
    }
    apiHeader.addAll({"DeviceInfo": json.encode(deviceData)});
    // log('api header-> $apiHeader');

    return apiHeader;
  } catch (err) {
    print("Exception: global.dart : getApiHeaders" + err.toString());
    return {};
  }
}

showToast(
    {required String message,
    int toasttimer = 2,
    Color? bgcolors = Colors.green}) async {
  return toastification.show(
    primaryColor: bgcolors,
    style: ToastificationStyle.fillColored,
    title: Text(message),
    alignment: Alignment.bottomCenter,
    autoCloseDuration: Duration(seconds: toasttimer),
  );
}

sendTokenToApi(
    int id, String agoraLiveChannelName, String agoraLiveToken, String s) {
  liveAstrologerController.sendLiveToken(
      id, agoraLiveChannelName, agoraLiveToken, "");
}

Future<Widget> showHtml(
    {required String html, Map<String, Style>? style}) async {
  try {
    return Html(
      data: html,
      style: style ?? {},
    );
  } catch (e) {
    return Html(
      data: html,
      style: style ?? {},
    );
  }
}

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) {
    return text; // Return empty string if text is empty
  }
  return text[0].toUpperCase() + text.substring(1);
}

void showOnlyLoaderDialog() {
  Future.delayed(Duration.zero, () {
    if (Get.context != null) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Center(child: CircularProgressIndicator()),
          );
        },
      );
    } else {
      debugPrint("context is null");
    }
  });
}

void hideLoader() {
  Get.back();
}

// For Network controller
Future<bool> checkBody() async {
  bool result;
  try {
    await networkController.initConnectivity();
    if (networkController.connectionStatus.value != 0) {
      result = true;
    } else {
      ever(networkController.connectionStatus, (status) {
        debugPrint('status init $status');
        if (status > 0) {
          result = true;
        } else {
          Get.snackbar(
            "Warning",
            "No Internet Connection",
            snackPosition: SnackPosition.BOTTOM,
            messageText: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.signal_wifi_off,
                  color: Colors.white,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                    ),
                    child: const Text(
                      "No Internet Available",
                      textAlign: TextAlign.start,
                    ).tr(),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (networkController.connectionStatus.value != 0) {
                      Get.back();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: Colors.white),
                    height: 30,
                    width: 55,
                    child: Center(
                      child: Text(
                        "Retry",
                        style: TextStyle(
                            color: Theme.of(Get.context!).primaryColor),
                      ).tr(),
                    ),
                  ),
                ),
              ],
            ),
            duration: const Duration(days: 1),
            backgroundColor: Theme.of(Get.context!).primaryColor,
            colorText: Colors.white,
          );
        }
      });

      result = false;
    }

    return result;
  } catch (e) {
    print("Exception - checkBodyController - checkBody():" + e.toString());
    return false;
  }
}

// Mobile Number Masking With 78*******09
// String maskMobileNumber(String number) {
//   if (number.length < 4) return number; // not enough digits to mask
//   String start = number.substring(0, 2);
//   String end = number.substring(number.length - 2);
//   String stars = '*' * (number.length - 4);
//   return '$start$stars$end';
// }

printException(String className, String functionName, dynamic err) {
  print("Exception: $className: - $functionName(): $err");
}

Future exitAppDialog() async {
  try {
    showCupertinoDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return Theme(
            data: ThemeData(dialogBackgroundColor: Colors.white),
            child: CupertinoAlertDialog(
              title: const Text(
                'Exit App',
              ).tr(),
              content: Text(
                'Are you sure you want to exit app?',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ).tr(),
                  onPressed: () {
                    // Dismiss the dialog but don't
                    // dismiss the swiped item
                    return Navigator.of(context).pop(false);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text(
                    'Exit',
                  ).tr(),
                  onPressed: () async {
                    exit(0);
                  },
                ),
              ],
            ),
          );
        });
  } catch (e) {
    print('Exception - gloabl.dart - exitAppDialog(): ${e.toString()}');
  }
}
