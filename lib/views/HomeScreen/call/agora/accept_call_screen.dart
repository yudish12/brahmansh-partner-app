import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:brahmanshtalk/controllers/CalltimerController.dart';
import 'package:brahmanshtalk/controllers/HomeController/call_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/home_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/wallet_controller.dart';
import 'package:brahmanshtalk/controllers/free_kundli_controller.dart';
import 'package:brahmanshtalk/utils/constantskeys.dart';
import 'package:brahmanshtalk/utils/foreground_task_handler.dart';
import 'package:brahmanshtalk/views/HomeScreen/call/agora/CallSessions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../../controllers/Authentication/signup_controller.dart';
import '../../../../controllers/callAvailability_controller.dart';
import '../../../../controllers/chatAvailability_controller.dart';
import '../../../../models/user_model.dart';
import '../../../../services/apiHelper.dart';
import '../../home_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AcceptCallScreen extends StatefulWidget {
  final int id;
  final String name;
  final String profile;
  final int callId;
  final String fcmToken;
  final String callduration;
  const AcceptCallScreen({
    super.key,
    required this.id,
    required this.fcmToken,
    required this.name,
    required this.profile,
    required this.callId,
    required this.callduration,
  });

  @override
  State<AcceptCallScreen> createState() => _AcceptCallScreenState();
}

class _AcceptCallScreenState extends State<AcceptCallScreen> {
  int uid = 0;
  bool isCalling = true;
  ValueNotifier<bool> isMuted = ValueNotifier(global.isaudioMuted);
  ValueNotifier<bool> isSpeaker = ValueNotifier(global.isaudioEnabled);
  int min = 0;
  int sec = 0;
  final chatControlleronline = Get.find<ChatAvailabilityController>();
  final walletController = Get.find<WalletController>();
  final callController = Get.find<CallController>();
  final homecontroller = Get.find<HomeController>();
  final kundlicontroller = Get.find<KundliController>();
  final calltimercontroller = Get.find<CalltimerController>();
  final callControlleronline = Get.find<CallAvailabilityController>();
  ValueNotifier<bool> isJoined = ValueNotifier(false);
  ValueNotifier<String> statusText = ValueNotifier('calling..');
  ValueNotifier<int?> remoteUid = ValueNotifier(null);
  final apiHelper = APIHelper();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ForegroundServiceManager.startForegroundTask();
      global.isCallOrChat = 2;
      _requestNotificationPermissions();
      log('start call with id:- ${global.isaudioCallinprogress}');
      if (global.isaudioCallinprogress == 0) {
        ForegroundServiceManager.startForegroundTask();
        global.inCallscreen(true);
        clearList();
        setupVoiceSDKEngine();
      } else {
        isJoined.value = true;
        debugPrint("time updated and already agora runnnig ${isJoined.value}");
      }
    });
  }

  Future _requestNotificationPermissions() async {
    PermissionStatus status = await Permission.notification.status;
    log('request permission status ${status.isGranted}');
    if (!status.isGranted || status.isDenied || status.isPermanentlyDenied) {
      await FlutterCallkitIncoming.requestFullIntentPermission();
    }
  }

  Future generateToken() async {
    try {
      global.sp = await SharedPreferences.getInstance();
      CurrentUser userData = CurrentUser.fromJson(
          json.decode(global.sp!.getString(ConstantsKeys.CURRENTUSER) ?? ""));
      int id = userData.id ?? 0;
      global.agoraChannelName = '${global.channelName}${id}_${widget.id}';
      log('channel name :- ${global.agoraChannelName}');
      await callController.getRtcToken(
          global.getSystemFlagValue(global.systemFlagNameList.agoraAppId),
          global.getSystemFlagValue(
              global.systemFlagNameList.agoraAppCertificate),
          "$uid",
          global.agoraChannelName);
      log("call token:-${global.agoraToken}");
      global.showOnlyLoaderDialog();
      await callController.sendCallToken(global.agoraToken,
          global.agoraChannelName, widget.callId); //audio call_type
      global.hideLoader();
      log("object");
    } catch (e) {
      // ignore: avoid_print
      debugPrint("Exception in gettting token: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) return;
            log('global callstarted at 0 ${(GetStorage().read('callStartedAt'))}');
            final session = Callsessions(
                sessionId: widget.callId.toString(),
                astrologerId: int.parse(widget.id.toString()),
                astrologerName: widget.name.toString(),
                astrologerProfile: widget.profile.toString(),
                token: widget.fcmToken.toString(),
                callChannel: widget.callId.toString(),
                callId: widget.callId.toString(),
                duration:
                    (calltimercontroller.totalDuration ~/ 1000).toString(),
                savedAt: GetStorage().read('callStartedAt'),
                isfromnotification: false);
            log('save and backrpess 0');
            Get.find<CallController>().addCallSession(session);
            Get.off(() => HomeScreen());
          },
          child: Scaffold(
            backgroundColor: Get.theme.primaryColor,
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "BrahmanshTalk",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    widget.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder(
                    valueListenable: isJoined,
                    builder: (context, isjoin, child) => SizedBox(
                      child: isjoin ? status() : const SizedBox(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: widget.profile.isEmpty
                        ? const AssetImage(
                            'assets/images/no_customer_image.png')
                        : CachedNetworkImageProvider(
                            global.buildImageUrl(widget.profile),
                          ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildActionButton(Icons.mic_off, "Mute", () {
                        isMuted.value = !isMuted.value;
                        global.isaudioMuted = isMuted.value;
                        onMute(isMuted.value);
                      }, isMuted),
                      buildActionButton(CupertinoIcons.book, "Kundli",
                          () async {
                        global.showOnlyLoaderDialog();
                        await kundlicontroller.getBasicDetailChart(
                            widget.id, false);
                      }),
                      buildActionButton(Icons.volume_up, "Speaker", () {
                        isSpeaker.value = !isSpeaker.value;
                        global.isaudioEnabled = isSpeaker.value;
                        onVolume(isSpeaker.value);
                      }, isSpeaker),
                    ],
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () async {
                      await global.sendNotification(
                        fcmToken: widget.fcmToken,
                        title: "Astrologer Leave call",
                        subtitle: "",
                      );
                      leave();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.call_end,
                          color: Colors.white, size: 30),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<void> setupVoiceSDKEngine() async {
    await [
      Permission.microphone,
      Permission.camera,
    ].request();
    callController.agoraEngine = createAgoraRtcEngine();
    await callController.agoraEngine.initialize(RtcEngineContext(
      appId: global.getSystemFlagValue(global.systemFlagNameList.agoraAppId),
    ));
    log('setup voice sdk engine agora_appid is ${global.getSystemFlagValue(global.systemFlagNameList.agoraAppId)}');
    callController.agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          log('✅ HOST JOINED CHANNEL SUCCESS - uid: ${connection.localUid}, channel: ${connection.channelId}, elapsed: $elapsed');
          isJoined.value = true;
          statusText.value = 'Waiting for user to join...';
        },
        onUserJoined: (RtcConnection connection, int rmoteID, int elapsed) {
          GetStorage()
              .write('callStartedAt', DateTime.now().millisecondsSinceEpoch);
          log('onuser joined with callerstartat ${DateTime.now().millisecondsSinceEpoch}');
          callController.callList
              .removeWhere((call) => call.callId == widget.callId);
          isJoined.value = true;
          remoteUid.value = rmoteID;
          global.isaudioCallinprogress = remoteUid.value;
          global.isCallTimerStarted = true;
          calltimercontroller.restartTimer(int.parse(widget.callduration));

          callController.update();
          apiHelper.setAstrologerOnOffBusyline("Busy").then((value) {
            debugPrint("user also joined with RemoteId ${remoteUid.value}");
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUId,
            UserOfflineReasonType reason) {
          isJoined.value = false;
          remoteUid.value = null;
          global.isaudioCallinprogress = 0;
          debugPrint('remote offline $reason');
          leave();
        },
        onRtcStats: (connection, stats) {},
      ),
    );
    await generateToken();
    callController.agoraEngine.setDefaultAudioRouteToSpeakerphone(false);

    join();
  }

  Widget status() {
    dynamic remotestatus = remoteUid.value == null
        ? global.isaudioCallinprogress
        : remoteUid.value.toString();

    log('calltime status is $remotestatus and duration is ${widget.callduration}');

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
                leave();
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
                leave();
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

  Widget buildActionButton(IconData icon, String label, VoidCallback onTap,
      [ValueNotifier<bool>? toggle]) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: toggle ?? ValueNotifier(false),
            builder: (context, value, child) => CircleAvatar(
              backgroundColor: value ? Colors.white : Colors.transparent,
              radius: 25,
              child: Icon(
                icon,
                color: value ? Colors.blue : Colors.white,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  void join() async {
    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
      publishMicrophoneTrack: true,
      autoSubscribeAudio: true,
    );
    try {
      await callController.agoraEngine.joinChannel(
        token: global.agoraToken,
        channelId: global.agoraChannelName,
        options: options,
        uid: uid,
      );
    } on Exception catch (e) {
      log('Exception in join :-$e');
    }

    onMute(isMuted.value);
  }

  void onMute(bool mute) async {
    await callController.agoraEngine.muteLocalAudioStream(mute);
  }

  void onVolume(bool isSpeaker) async {
    await callController.agoraEngine.setEnableSpeakerphone(isSpeaker);
  }

  void leave() async {
    global.isaudioCallinprogress = 0;
    global.isaudioMuted = false;
    global.isaudioEnabled = false;
    GetStorage().write('callStartedAt', 0);
    if (callController.activeaudiocallSessions.values.isNotEmpty) {
      final session = callController.activeaudiocallSessions.values.first;
      log('removed session is $session');
      Get.find<CallController>().removeCallSession(session.sessionId);
    } else {
      log('No active audio call sessions found');
    }
    ForegroundServiceManager.stopForegroundTask();
    apiHelper.setAstrologerOnOffBusyline("Online");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      global.inCallscreen(false);
      await walletController.getAmountList();
      walletController.update();
      debugPrint("leave");
      // await apiHelper.setAstrologerOnOffBusyline("Online");
    });
    await Get.find<SignupController>().astrologerProfileById(false);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(ConstantsKeys.ISACCEPTED, false);
    await prefs.setString(ConstantsKeys.ISACCEPTEDDATA, '');
    await prefs.setBool(ConstantsKeys.ISREJECTED, false);

    if (mounted) {
      remoteUid.value = null;
      isSpeaker.value = false;
    }
    callController.agoraEngine.leaveChannel();
    callController.agoraEngine.release(sync: true);
    debugPrint('back called');
    Get.offAll(() => HomeScreen(isId: widget.id));
  }

  void clearList() async {
    callController.callList.removeWhere((call) => call.callId == widget.callId);
    callController.callList.clear();
    callController.update();
    await callController.getCallList(false);
    callController.update();
  }
}
