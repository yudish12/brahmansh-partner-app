// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:brahmanshtalk/models/call_model.dart';
import 'package:brahmanshtalk/services/apiHelper.dart';
import 'package:brahmanshtalk/views/HomeScreen/call/agora/CallSessions.dart';
import 'package:brahmanshtalk/views/HomeScreen/call/hms/hmsAcceptCallscreen.dart'
    show HmsOneToOneAudioCallScreen;
import 'package:brahmanshtalk/views/HomeScreen/call/zegocloud/zego_onetoone_call.dart';
import 'package:brahmanshtalk/views/HomeScreen/call/zegocloud/zego_onetoone_videocall.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/intake_model.dart';
import '../../models/user_model.dart';
import '../../views/HomeScreen/call/agora/accept_call_screen.dart';
import '../../views/HomeScreen/call/hms/HmsOneToOneVideoCallScreen.dart';
import '../../views/HomeScreen/live/onetoone_video/onetooneVideo.dart';

class CallController extends GetxController {
  String screen = 'call_controller.dart';
  APIHelper apiHelper = APIHelper();
  List<CallModel> callList = [];
  var intakeData = <IntakeModel>[];
  ScrollController scrollController = ScrollController();
  int fetchRecord = 5;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;
  bool isRejectCall = false;
  AudioPlayer player = AudioPlayer();
  late RtcEngine agoraEngine;
  bool isvideoEnd = false;
  Timer? callListTimer;
  bool newIsStartTimer = false;

  // Handle Camera Flip Here
  void switchCamera() {
    agoraEngine.switchCamera();
  }

  final activeaudiocallSessions = <String, Callsessions>{}.obs;

  void addCallSession(Callsessions session) {
    activeaudiocallSessions[session.sessionId] = session;
    print('active session is ${activeaudiocallSessions[session.sessionId]}');
    update();
  }

  void removeCallSession(String sessionId) {
    global.callStartedAt = null;
    activeaudiocallSessions.remove(sessionId);
    log('removed seesioin id is $sessionId');
    update();
  }

  Future getCallList(bool isLazyLoading, {int? isLoading = 1}) async {
    try {
      startIndex = 0;
      if (callList.isNotEmpty) {
        startIndex = 0;
        fetchRecord = fetchRecord + 10;
      }
      if (!isLazyLoading) {
        log('Lazy loading ${!isLazyLoading}');
        isDataLoaded = false;
      }
      log('Lazy loading insde body $isLazyLoading');

      isLoading == 0 ? '' : global.showOnlyLoaderDialog();
      int id = global.user.id ?? 0;
      log('userid $id');

      await apiHelper.getCallRequest(id, startIndex, fetchRecord).then(
        (result) {
          isLoading == 0 ? '' : global.hideLoader();
          if (result.status == "200") {
            if (isLazyLoading) {
              callList.clear();
              update();
            }
            callList.addAll(result.recordList);
            update();
            if (result.recordList.length == 0) {
              isMoreDataAvailable = false;
              isAllDataLoaded = true;
            }
            update();
          } else {
            debugPrint('No call list is here');
          }
          update();
        },
      );
    } catch (e) {
      print('Exception: $screen - getCallList(): $e');
    }
  }

  acceptCallRequest(
      int callId,
      String? profile,
      String name,
      int id,
      String? fcmToken,
      String callduration,
      String callMethod,
     ) async {
    try {
      await apiHelper.acceptCallRequest(callId).then(
        (result) async {
          if (result.status == "200") {
            global.isaudioCallinprogress == 0;
            global.hideLoader();
            isRejectCall = false;
            update();
            if (callMethod == "exotel") {
              await sendCallToken("", "", callId);
              global.showToast(message: tr("You will get a call"));
            } else {
              log('audio callMethod $callMethod');

              if (callMethod == "hms") {
                Get.to(() => HmsOneToOneAudioCallScreen(
                      callId: callId,
                      userName: name,
                      audioDuration: callduration.toString(),
                      profile: profile ?? '',
                    ));
              } else if (callMethod == "agora") {
                Get.to(() => AcceptCallScreen(
                    name: name,
                    profile: profile ?? '',
                    id: id,
                    callId: callId,
                    fcmToken: fcmToken ?? '',
                    callduration: callduration.toString()));
              } else if (callMethod == "zegocloud") {
                //  callId: callId,
                //                 userName: name,
                //                 audioDuration: callduration.toString(),
                //                 profile: profile ?? '',
                //                 callToken: callToken ?? '',
                getCurrentUserInfoAndOpenZegocallscreen(callId, name, id,
                    profile, fcmToken, callduration);
              } else {
                log('no callmethod found pls add $callMethod in callcontroller');
              }
            }
          } else {
            global.showToast(message: tr("User Cancelled the Request"));
            callList.clear();
            isAllDataLoaded = false;
            await getCallList(false);
          }
        },
      );

      update();
    } catch (e) {
      print('Exception: $screen - acceptCallRequest(): $e');
    }
  }

  void getCurrentUserInfoAndOpenZegocallscreen(
      dynamic callId,
      dynamic name,
      dynamic id,
      dynamic profile,
      dynamic fcmToken,
      dynamic callduration,) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    CurrentUser userData = CurrentUser.fromJson(
      json.decode(sp.getString("currentUser") ?? ""),
    );
    int currrentUserid = userData.id ?? 0;
    String? currentUserName = userData.name;
    Get.to(
      () => OnetooneZegoAudioCallScreen(
        callID: callId.toString(),
        userName: name,
        id: id,
        profile: profile ?? '',
        fcmToken: fcmToken ?? '',
        callduration: callduration.toString(),
        currrentUserid: currrentUserid,
        currentUserName: currentUserName ?? '',
      ),
    );
  }

  acceptVideoCallRequest(
    int callId,
    String? profile,
    String name,
    int id,
    String? fcmToken,
    String? callDuration,
    String callMethod,
  ) async {
    try {
      await apiHelper.acceptVideoCallRequest(callId).then(
        (result) async {
          if (result.status == "200") {
            global.hideLoader();
            isRejectCall = false;
            update();
            log('video callMethod $callMethod');
            if (callMethod == "hms") {
              Get.to(
                () => HmsOneToOneVideoCallScreen(
                  userName: name,
                  callId: callId,
                  profile: profile ?? '',
                  id: id,
                  fcmToken: fcmToken ?? '',
                  callduration: callDuration.toString(),
                ),
              );
            } else if (callMethod == "agora") {
              Get.to(
                () => OneToOneLiveScreen(
                  name: name,
                  profile: profile ?? '',
                  id: id,
                  callId: callId,
                  fcmToken: fcmToken ?? '',
                  call_duration: callDuration.toString(),
                ),
              );
            } else if (callMethod == "zegocloud") {
              getCurrentUserInfoAndOpenVideoZegocallscreen(
                callId,
                name,
                id,
                profile,
                fcmToken,
                callDuration,
              );
            } else {
              log('no callmethod found pls add $callMethod in callcontroller');
            }

            callList.clear();
            isAllDataLoaded = false;
            await getCallList(false);
            update();
          } else {
            global.showToast(message: tr("User Cancelled the Request"));
            callList.clear();
            isAllDataLoaded = false;
            await getCallList(false);
          }
        },
      );
      update();
    } catch (e) {
      print('Exception acceptCallRequest() $screen$e');
    }
  }

  void getCurrentUserInfoAndOpenVideoZegocallscreen(
      dynamic callId,
      dynamic name,
      dynamic id,
      dynamic profile,
      dynamic fcmToken,
      dynamic callduration,) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    CurrentUser userData = CurrentUser.fromJson(
      json.decode(sp.getString("currentUser") ?? ""),
    );
    int currrentUserid = userData.id ?? 0;
    String? currentUserName = userData.name;
    log('user id is $currrentUserid and username is $currentUserName');
    Get.to(
      () => OnetooneZegoVideoCallScreen(
        callID: callId.toString(),
        userName: name,
        profile: profile ?? '',
        id: id,
        fcmToken: fcmToken ?? '',
        callduration: callduration.toString(),
      ),
    );
  }

  Future<String?> sendCallToken(
      String token, String channelName, dynamic callId) async {
    try {
      final result = await apiHelper.addCallToken(token, channelName, callId);

      if (result != null && result["status"] == 200) {
        String apiToken = result["token"];
        print('✅ call token received :- $apiToken');
        return apiToken;
      } else {
        global.showToast(message: tr("accept Request"));
        return null;
      }
    } catch (e) {
      print('Exception: $screen - sendCallToken(): $e');
      return null;
    } finally {
      update();
    }
  }

  rejectCallRequest(int callId) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            await apiHelper.rejectCallRequest(callId).then(
              (result) async {
                if (result.status == "200") {
                  global.showToast(
                      message: tr("Reject call request Successfully"));
                  callList.clear();
                  isAllDataLoaded = false;
                  update();
                  await getCallList(false);
                } else {
                  global.showToast(
                      message: tr("Reject Request failed,try again later!"));
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: rejectCallRequest() $screen$e');
    }
  }

  Future<dynamic> getRtcToken(String appId, String appCertificate,
      String chatId, String channelName) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .generateRtcToken(appId, appCertificate, chatId, channelName)
              .then((result) {
            if (result.status == "200") {
              global.agoraToken = result.recordList['rtcToken'];
            } else {
              global.showToast(
                  message: '${result.status} failed to get live RTC Token');
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getRtcToken :-$e");
    }
  }

  getFormIntakeData(int userId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getIntakedata(userId).then((result) {
            if (result.status == "200") {
              intakeData = result.recordList;
              if (intakeData.isNotEmpty) {}
              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: tr('Fail to get get Intake data'),
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getFormIntakeData():$e');
    }
  }

  rejectDialog() {
    showDialog(
        context: Get.context!,
        // barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: SizedBox(
              height: 150,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: const Text(
                      "Call Rejected!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ).tr(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: const Text(
                      "The call was declined/cancelled by the user. Please decline the call.",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      textAlign: TextAlign.center,
                    ).tr(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: const Text(
                            "Ok",
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ).tr(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actionsPadding:
                const EdgeInsets.only(bottom: 15, left: 15, right: 15),
          );
        });
  }
}
