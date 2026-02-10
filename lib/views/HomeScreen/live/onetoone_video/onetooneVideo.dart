// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:async';
import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:brahmanshtalk/controllers/CalltimerController.dart';
import 'package:brahmanshtalk/controllers/HomeController/wallet_controller.dart';
import 'package:brahmanshtalk/controllers/free_kundli_controller.dart';
import 'package:brahmanshtalk/utils/constantskeys.dart';
import 'package:brahmanshtalk/utils/foreground_task_handler.dart';
import 'package:brahmanshtalk/views/HomeScreen/call/agora/CallSessions.dart';
import 'package:brahmanshtalk/views/HomeScreen/home_screen.dart';
import 'package:draggable_widget/draggable_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import '../../../../controllers/Authentication/signup_controller.dart';
import '../../../../controllers/HomeController/call_controller.dart';
import '../../../../services/apiHelper.dart';
import '../../../../utils/global.dart';
import 'AgoraEventHandler.dart';
import 'Agrommanager.dart';
import 'cohost_screen.dart';
import 'host_screen.dart';

class OneToOneLiveScreen extends StatefulWidget {
  final int id;
  final String name;
  final String profile;
  final int callId;
  final String fcmToken;
  final String call_duration;

  const OneToOneLiveScreen({
    super.key,
    required this.id,
    required this.name,
    required this.profile,
    required this.callId,
    required this.fcmToken,
    required this.call_duration,
  });

  @override
  State<OneToOneLiveScreen> createState() => OneToOneLiveScreenState();
}

class OneToOneLiveScreenState extends State<OneToOneLiveScreen> {
  ValueNotifier<bool> isMuted = ValueNotifier(global.isaudioMuted);
  ValueNotifier<bool> isSpeaker = ValueNotifier(global.isaudioEnabled);
  ValueNotifier<bool> isImHost = ValueNotifier(false);
  ValueNotifier<bool> isJoined = ValueNotifier(false);
  ValueNotifier<int?> remoteUid = ValueNotifier(null);
  ValueNotifier<String> statusText = ValueNotifier('calling..');
  final calltimercontroller = Get.find<CalltimerController>();
  final kundlicontroller = Get.find<KundliController>();
  final callController = Get.find<CallController>();
  final dragController = DragController();
  final walletController = Get.put(WalletController());
  late AgoraEventHandler agoraEventHandler;
  CountdownTimer? countdownTimer;
  final apiHelper = APIHelper();
  var uid = 0;
  int conneId = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        log('isvideocall type is 0 ${global.isvideoCallinprogress}');
        if (global.isvideoCallinprogress == 0) {
          global.isCallOrChat = 3;
          global.inCallscreen(true);
          debugPrint(
              'one to one id ${widget.callId}, name ${widget.name}, profile ${widget.profile} callid ${widget.callId}, fcm ${widget.fcmToken}');
          ForegroundServiceManager.startForegroundTask();
          clearList();
          await generateToken().then((e) {
            initagora();
          });
        } else {
          isJoined.value = true; // ✅ ensure UI updates
          remoteUid.value = global.isvideoCallinprogress;
          isImHost.value = global.isImHostGlobally;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        log('sending chatstarted time is ${global.callStartedAt}');
        log('global Videocallstarted at 0 ${(GetStorage().read('callStartedAt'))}');
        final session = Callsessions(
            sessionId: widget.callId.toString(),
            astrologerId: int.parse(widget.id.toString()),
            astrologerName: widget.name.toString(),
            astrologerProfile: widget.profile.toString(),
            token: widget.fcmToken.toString(),
            callChannel: widget.callId.toString(),
            callId: widget.callId.toString(),
            duration: (calltimercontroller.totalDuration ~/ 1000).toString(),
            savedAt: GetStorage().read('callStartedAt'),
            isfromnotification: false);
        log('save and backrpess 0');
        Get.find<CallController>().addCallSession(session); //add session
        Get.off(() => HomeScreen());
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          body: ValueListenableBuilder(
            valueListenable: isJoined,
            builder: (BuildContext context, bool isJoin, Widget? child) =>
                ValueListenableBuilder(
              valueListenable: isImHost,
              builder: (BuildContext context, bool meHost, Widget? child) =>
                  Stack(
                children: [
                  SizedBox(
                    height: 100.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //IS USER JOINED LAYOUT
                        isJoin
                            ? SizedBox(
                                width: double.infinity,
                                height: 100.h,
                                child: CoHostWidget(
                                  remoteUid: remoteUid.value,
                                  agoraEngine: callController.agoraEngine,
                                ),
                                //CO-HOST VIDEO
                              )
                            : const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.amberAccent,
                                ),
                              )
                      ],
                    ),
                  ),
                  //IS IM HOST YES
                  meHost
                      ? DraggableWidget(
                          intialVisibility: true,
                          horizontalSpace: 2.h,
                          verticalSpace: 10.h,
                          shadowBorderRadius: 10.h,
                          initialPosition: AnchoringPosition.topLeft,
                          dragController: dragController,
                          child: SizedBox(
                            height: 25.h,
                            width: 35.w,
                            //HOST CHILD
                            child: HostWidget(
                                uid: uid,
                                agoraEngine: callController.agoraEngine),
                          ))
                      : Center(
                          child: Text('Im host-->s $meHost'),
                        ),
                  // ----------For Camera Fliping------------
                  Positioned(
                    top: 30,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        callController.switchCamera();
                      },
                      child: Container(
                        height: 10.w,
                        width: 10.w,
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.3)),
                        child: Icon(
                          Icons.flip_camera_ios_outlined,
                          size: 15.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 70,
                    child: GestureDetector(
                      onTap: () async {
                        global.showOnlyLoaderDialog();
                        await kundlicontroller.getBasicDetailChart(
                            widget.id, false);
                      },
                      child: Container(
                          alignment: Alignment.center,
                          height: 5.h,
                          // width: 20.w,
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.sp),
                              color: Colors.black),
                          child: const Text(
                            "Kundli",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),

                  //BOTTOM BAR MUTE CALL DISCONNECT SPEAKER
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: SizedBox(
                      height: 10.h,
                      width: 100.w,
                      child: Row(children: [
                        Expanded(
                          child: SizedBox(
                            height: 10.h,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  isMuted.value = !isMuted.value;
                                  log('mute Audio is ${isMuted.value}');
                                  global.isaudioMuted = isMuted.value;
                                  AgoraManager().muteVideoCall(isMuted.value,
                                      callController.agoraEngine);
                                },
                                child: ValueListenableBuilder(
                                  valueListenable: isMuted,
                                  builder: (BuildContext context, bool meMuted,
                                          Widget? child) =>
                                      CircleAvatar(
                                    radius: 3.h,
                                    backgroundColor: meMuted
                                        ? Colors.black12
                                        : Colors.black38,
                                    child: FaIcon(
                                      meMuted
                                          ? FontAwesomeIcons.microphoneSlash
                                          : FontAwesomeIcons.microphone,
                                      color:
                                          meMuted ? Colors.blue : Colors.white,
                                      size: 15.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: SizedBox(
                              height: 10.h,
                              child: InkWell(
                                onTap: () async {
                                  await walletController.getAmountList();
                                  log('clciked video end');
                                  leaveVideoCall();
                                },
                                child: SizedBox(
                                  width: 100.w,
                                  height: 6.h,
                                  child: Center(
                                    child: CircleAvatar(
                                      radius: 3.h,
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.call_end,
                                        color: Colors.white,
                                        size: 20.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 10.h,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 2.h),
                                child: InkWell(
                                  onTap: () {
                                    isSpeaker.value = !isSpeaker.value;
                                    global.isaudioEnabled = isSpeaker.value;
                                    AgoraManager().onVolume(isSpeaker.value,
                                        callController.agoraEngine);
                                  },
                                  child: ValueListenableBuilder(
                                    valueListenable: isSpeaker,
                                    builder: (BuildContext context,
                                            bool meSpeaker, Widget? child) =>
                                        CircleAvatar(
                                      radius: 3.h,
                                      backgroundColor: meSpeaker
                                          ? Colors.black12
                                          : Colors.black38,
                                      child: Icon(
                                        meSpeaker
                                            ? FontAwesomeIcons.volumeHigh
                                            : FontAwesomeIcons.volumeLow,
                                        color: meSpeaker
                                            ? Colors.blue
                                            : Colors.white,
                                        size: 20.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),

                  Positioned(
                    top: 3.h,
                    left: 36.w,
                    child: ValueListenableBuilder(
                      valueListenable: isJoined,
                      builder:
                          (BuildContext context, bool isJoin, Widget? child) =>
                              isJoin ? status() : const SizedBox(),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget status() {
    dynamic remotestatus = remoteUid.value == null
        ? global.isaudioCallinprogress
        : remoteUid.value.toString();

    log('onetoOne video status is $remotestatus and duration is ${widget.call_duration}');

    if (remotestatus == null) {
      statusText.value = 'Calling...';
      return ValueListenableBuilder(
        valueListenable: statusText,
        builder: (context, value, child) =>
            Text(value, style: TextStyle(fontSize: 14.sp, color: Colors.white))
                .tr(),
      );
    } else {
      statusText.value = 'Calling in progress';

      return GetBuilder<CalltimerController>(
        builder: (calltimercontroller) {
          final now = DateTime.now().millisecondsSinceEpoch;
          final remainingMillis = calltimercontroller.callendTime - now;
          final remainingSeconds = (remainingMillis / 1000).floor();

          log('⏱️ Real-time callendTime: ${calltimercontroller.callendTime}');
          log('⏱️ Now: $now');
          log('⏱️ Remaining Seconds: $remainingSeconds');

          if (remainingSeconds <= 0) {
            Future.microtask(() {
              if (remoteUid.value != null) {
                isJoined.value = false;
                leaveVideoCall();
              }
            });
            return const SizedBox.shrink();
          }

          return CountdownTimer(
            endTime: calltimercontroller.callendTime,
            widgetBuilder: (_, CurrentRemainingTime? time) {
              if (time == null) return const Text('');
              return Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  _formatRemainingTime(time),
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: Colors.white),
                ),
              );
            },
            onEnd: () {
              final now = DateTime.now().millisecondsSinceEpoch;
              if (now >= calltimercontroller.callendTime) {
                debugPrint('⏰ Timer ended - leave triggered');
                isJoined.value = false;
                leaveVideoCall();
              } else {
                log('⚠️ Timer onEnd triggered early, ignored.');
              }
            },
          );
        },
      );
    }
  }

  String _formatRemainingTime(CurrentRemainingTime time) {
    if ((time.hours ?? 0) > 0) {
      return '${_pad(time.hours)}:${_pad(time.min)}:${_pad(time.sec)}';
    } else if ((time.min ?? 0) > 0) {
      return '${_pad(time.min)}:${_pad(time.sec)}';
    } else {
      return '00:${_pad(time.sec)}';
    }
  }

  String _pad(int? n) => (n ?? 0).toString().padLeft(2, '0');

  void handler() {
    agoraEventHandler.handleEvent(callController.agoraEngine);
  }

  Future<void> initagora() async {
    log('inside video int agora');
    callController.agoraEngine = await AgoraManager().initializeAgora(
        global.getSystemFlagValue(global.systemFlagNameList.agoraAppId));
    log("channel token:- ${global.agoraLiveChannelName}");
    log('agora Livetoken ${global.agoraLiveToken}');
    AgoraManager().joinChannel(global.agoraLiveToken,
        global.agoraLiveChannelName, callController.agoraEngine);
    agoraEventHandler = AgoraEventHandler(
      onJoinChannelSuccessCallback: (isHost, localUid) {
        isImHost.value = isHost;
        isImHostGlobally = isImHost.value;
        conneId = localUid!;
      },
      onUserJoinedCallback: (remoteId, isJoin) {
        GetStorage()
            .write('callStartedAt', DateTime.now().millisecondsSinceEpoch);
        isJoined.value = isJoin!;
        remoteUid.value = remoteId;
        global.isvideoCallinprogress = remoteId;
        log('isvideocall type is 3 ${global.isvideoCallinprogress}');
        calltimercontroller
            .restartTimer(int.parse(widget.call_duration)); //! Star timer
        apiHelper.setAstrologerOnOffBusyline("Busy");
      },
      onUserMutedCallback: (remoteUid3, muted) {
        log('Is muted->  $muted');
        if (remoteUid.value == remoteUid3) {
          if (muted == true) {
            isImHost.value = true;
            log('isimHost in onUserMuteVideo muted $isImHost');
          } else {
            isImHost.value = true;
            log('isimHost in onUserMuteVideo mutede else $isImHost');
          }
        }
      },
      onUserOfflineCallback: (id, reason) {
        debugPrint("User is Offiline reasion is -> $reason");
        remoteUid.value = null;
        apiHelper.setAstrologerOnOffBusyline("Online");
        global.isvideoCallinprogress = 0;
        log('isvideocall type is 4 ${global.isvideoCallinprogress}');

        if (reason == UserOfflineReasonType.userOfflineQuit) {
          leaveVideoCall();
        } else if (reason == UserOfflineReasonType.userOfflineDropped) {
          leaveVideoCall();
        }
      },
      onLeaveChannelCallback: (con, sc) {
        apiHelper.setAstrologerOnOffBusyline("Online");
        debugPrint("onLeaveChannel called id- >${con.localUid}");
        isJoined.value = false;
        remoteUid.value = null;
      },
      onAgoraError: (err, msg) {
        log('error agora - $err  and msg is - $msg');
      },
    );

    handler();
  }

  Future generateToken() async {
    try {
      global.agoraLiveChannelName = '${global.liveChannelName}_${widget.id}';

      await liveAstrologerController.getRitcToken(
          global.getSystemFlagValue(global.systemFlagNameList.agoraAppId),
          global.getSystemFlagValue(
              global.systemFlagNameList.agoraAppCertificate),
          "$uid",
          global.agoraLiveChannelName);

      await callController.sendCallToken(
          global.agoraLiveToken, global.agoraLiveChannelName, widget.callId);
    } catch (e) {
      debugPrint("Exception in getting token: ${e.toString()}");
    }
  }

  void leaveVideoCall() async {
    global.isvideoCallinprogress = 0;
    ForegroundServiceManager.stopForegroundTask();
    log('leave video call click ${global.isvideoCallinprogress}');
    await callController.agoraEngine.leaveChannel();
    await callController.agoraEngine.release();
    //clear data for fututre
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(ConstantsKeys.ISACCEPTED, false);
    await prefs.setString(ConstantsKeys.ISACCEPTEDDATA, '');
    await prefs.setBool(ConstantsKeys.ISREJECTED, false);
    global.inCallscreen(false);
    global.isaudioMuted = false;
    global.isaudioEnabled = true;
    calltimercontroller.resetTimer();
    try {
      await liveAstrologerController.endLiveSession(false);
      liveAstrologerController.isImInLive = false;
      liveAstrologerController.update();
       apiHelper.setAstrologerOnOffBusyline("Online");
      log("leave Video - 4");
      if (callController.activeaudiocallSessions.values.isNotEmpty) {
        final session = callController.activeaudiocallSessions.values.first;
        log('removed session is $session');
        Get.find<CallController>().removeCallSession(session.sessionId);
      } else {
        log('No active audio call sessions found');
      }
      await Get.find<SignupController>().astrologerProfileById(false);
    } on Exception catch (e) {
      log("Exception in leaveVideoCall: ${e.toString()}");
    }
    Get.off(() => HomeScreen(isId: widget.id));
  }

  void clearList() async {
    callController.callList.removeWhere((call) => call.callId == widget.callId);
    callController.callList.clear();
    callController.update();
    await walletController.getAmountList();
    // leaveVideoCall();
    await callController.getCallList(false);
  }
}
