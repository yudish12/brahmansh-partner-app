import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:brahmanshtalk/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:synchronized/synchronized.dart';
import '../../../../controllers/Authentication/signup_controller.dart';
import '../../../../controllers/HomeController/chat_controller.dart';
import '../../../../controllers/HomeController/home_controller.dart';
import '../../../../controllers/HomeController/live_astrologer_controller.dart';
import '../../../../controllers/HomeController/wallet_controller.dart';
import '../../../../models/message_model.dart';
import '../../../../models/user_model.dart';
import '../../../../services/apiHelper.dart';
import '../../../../utils/foreground_task_handler.dart';
import '../../../../utils/global.dart' as global;
import '../../home_screen.dart';
import 'peerVideomodel.dart';

class HMSLiveScreen extends StatefulWidget {
  const HMSLiveScreen({super.key});

  @override
  State<HMSLiveScreen> createState() => _HMSLiveScreenState();
}

class _HMSLiveScreenState extends State<HMSLiveScreen>
    implements HMSUpdateListener {
  late HMSSDK hmsSDK;
  final homeController = Get.find<HomeController>();
  final apiHelper = APIHelper();
  final liveAstrologerController = Get.find<LiveAstrologerController>();
  final messageController = TextEditingController();
  final chatcontroller = Get.find<ChatController>();
  final walletController = Get.find<WalletController>();
  final signupcontroller = Get.find<SignupController>();
  String? reqType, username;
  String peerUserId = "";
  int currentUserId = 0;
  String userName = "";
  String currenUserName = "You";
  bool isAlreadyTaking = false;
  String channelName = '';

  // HMS related variables
  HMSPeer? localPeer;
  List<HMSPeer> remoteBroadcasters = [];
  List<HMSPeer> remoteViewers = [];
  HMSVideoTrack? localPeerVideoTrack;
  List<PeerVideoTrack> remoteBroadcasterTracks = [];
  List<PeerVideoTrack> remoteViewerTracks = []; // Added missing list
  HMSAudioTrack? localPeerAudioTrack;

  ValueNotifier<bool> isMicMuted = ValueNotifier(false);
  ValueNotifier<bool> isVideoOn = ValueNotifier(true);
  ValueNotifier<bool> isSpeakerOn = ValueNotifier(true);
  ValueNotifier<bool> isJoined = ValueNotifier(false);
  ValueNotifier<bool> isImHost = ValueNotifier(false);
  ValueNotifier<String> localName = ValueNotifier("Joining...");
  ValueNotifier<String> remoteName = ValueNotifier("Waiting...");
  ValueNotifier<String> currentUserProfile = ValueNotifier<String>('');
  ValueNotifier<int> myviewerCount = ValueNotifier<int>(1);
  ValueNotifier<Duration> liveDuration = ValueNotifier(Duration.zero);
  ValueNotifier<List<HMSRoleChangeRequest>> pendingRoleRequests =
      ValueNotifier<List<HMSRoleChangeRequest>>([]);
  // Split screen support variables
  ValueNotifier<int> broadcasterCount = ValueNotifier(0);
  ValueNotifier<String> remotePeerRole = ValueNotifier("viewer");

  // Chat related variables
  ValueNotifier<List<MessageModel>> reverseMessage = ValueNotifier([]);
  List<MessageModel> messageList = [];
  final _messageLock = Lock();
  SharedPreferences? sp;

  // Session timer variables
  DateTime? _sessionStartTime;
  final _sessionDuration = ValueNotifier(Duration.zero);
  Timer? _sessionTimer;
  bool _hasActiveSession = false;

  @override
  void initState() {
    super.initState();
    initHMSSDK();
    getCurrentUserInfo();
  }

  bool _isAudioOnlyRole(String roleName) {
    return roleName.toLowerCase().contains("audio-moderator");
  }

  void getCurrentUserInfo() async {
    sp = await SharedPreferences.getInstance();
    CurrentUser userData = CurrentUser.fromJson(
      json.decode(sp!.getString("currentUser") ?? ""),
    );
    setState(() {
      currentUserId = userData.id ?? 0;
      currenUserName = userData.name ?? "User";

      currentUserProfile.value =
          userData.imagePath != "" ? "${userData.imagePath}" : "";
      log("callmethod profile is  ->  ${signupcontroller.astrologerList[0]?.imagePath}");
      log('starting image path is ${currentUserProfile.value}');
    });
  }

  void initHMSSDK() async {
    global.sp = await SharedPreferences.getInstance();
    CurrentUser userData = CurrentUser.fromJson(
      json.decode(global.sp!.getString("currentUser") ?? ""),
    );
    int id = userData.id ?? 0;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ForegroundServiceManager.startForegroundTask();
      await liveAstrologerController.sendLiveToken(
          id, 'hmsLiveAstrologer_$id', '', "");
      global.agoraLiveChannelName = 'hmsLiveAstrologer_$id';
      hmsSDK = HMSSDK();
      await hmsSDK.build();
      hmsSDK.addUpdateListener(listener: this);
      log('joining token is ${global.hmsauthToken}');

      if (global.hmsauthToken != null) {
        hmsSDK.join(
          config: HMSConfig(
              authToken: global.hmsauthToken,
              userName: currenUserName,
              metaData: json.encode({
                'user_id': currentUserId,
                'profile_pic': currentUserProfile.value,
              })),
        );
      } else {
        log('100ms auth_token null so retry');
      }
      getWaitList();
    });
  }

  Future<void> getWaitList() async {
    if (global.agoraLiveChannelName != "") {
      await liveAstrologerController.getWaitList(global.agoraLiveChannelName);
    }
  }

  Future<void> leaveMeeting() async {
    log('leaving meeting');
    try {
      ForegroundServiceManager.stopForegroundTask();
      localPeerVideoTrack = null;
      localPeerAudioTrack = null;
      localPeer = null;
      remotePeerRole.value = "viewer";
      isImHost.value = false;
      _stopSessionTimer(); // Stop session timer when leaving
      await hmsSDK.leave();
      hmsSDK.destroy();
      await apiHelper.setAstrologerOnOffBusyline('Online');
      await liveAstrologerController.endLiveSession(false);
      Get.offAll(() => HomeScreen());
    } catch (e) {
      debugPrint("Error leaving meeting: $e");
      Get.offAll(() => HomeScreen());
    }
  }

  // Start session timer when someone joins
  void _startSessionTimer() {
    log('session time started ');

    if (!_hasActiveSession) {
      _sessionStartTime = DateTime.now();
      _hasActiveSession = true;

      _sessionTimer?.cancel();
      _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_sessionStartTime != null) {
          _sessionDuration.value =
              DateTime.now().difference(_sessionStartTime!);
        }
      });
    } else {
      log('session already started');
    }
  }

  void _stopSessionTimer() {
    log('remote session timer stopped');
    _sessionTimer?.cancel();
    _sessionStartTime = null;
    _sessionDuration.value = Duration.zero;
    _hasActiveSession = false;

    setState(
      () => isAlreadyTaking = false,
    );
  }

  void _toggleMicMute() async {
    try {
      await hmsSDK.toggleMicMuteState();
    } on Exception catch (e) {
      log('Error toggling mic mute state: $e');
    }
  }

  void _toggleVideo() async {
    await hmsSDK.toggleCameraMuteState();
  }

  void _toggleSpeaker() async {
    if (isSpeakerOn.value) {
      hmsSDK.switchAudioOutput(audioDevice: HMSAudioDevice.EARPIECE);
    } else {
      hmsSDK.switchAudioOutput(audioDevice: HMSAudioDevice.SPEAKER_PHONE);
    }
  }

  sendMessage(String messageText) async {
    try {
      MessageModel newUserMessage = MessageModel(
        message: messageText,
        userName: currenUserName,
        profile: currentUserProfile.value,
        isMe: true,
        gift: null,
        createdAt: DateTime.now(),
      );
      log('sending name is $currenUserName');
      log('first image path is ${signupcontroller.astrologerList[0]?.imagePath}');
      log('sending profile is is ${currentUserProfile.value}');

      String messageWithMetadata = json.encode({
        'message': messageText,
        'userName': currenUserName,
        'profile': currentUserProfile.value,
        'userId': currentUserId.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      await hmsSDK.sendBroadcastMessage(
        message: messageWithMetadata,
        type: "chat",
      );

      messageList.add(newUserMessage);
      reverseMessage.value = messageList.reversed.toList();
    } catch (e) {
      log('Failed to send message: $e');
    }
  }

  @override
  void onJoin({required HMSRoom room}) async {
    remoteBroadcasters.clear();
    remoteViewers.clear();
    remoteBroadcasterTracks.clear();
    remoteViewerTracks.clear();

    for (var peer in room.peers ?? []) {
      log('role name ${peer.role.name}');

      if (peer.isLocal) {
        localPeer = peer;
        isImHost.value = true;
        log("🎯 Local peer set as host: ${peer.name}");

        if (peer.videoTrack != null) {
          localPeerVideoTrack = peer.videoTrack;
          isVideoOn.value = !peer.videoTrack!.isMute;
        }

        if (peer.audioTrack != null) {
          localPeerAudioTrack = peer.audioTrack;
          isMicMuted.value = peer.audioTrack!.isMute;
        }
      } else {
        log("👥 Remote peer: ${peer.name} (${peer.role.name})");

        bool isAudioOnly = _isAudioOnlyRole(peer.role.name);
        bool isBroadcaster = _isBroadcasterRole(peer.role.name) || isAudioOnly;

        if (isBroadcaster) {
          remoteBroadcasters.add(peer);
          remoteBroadcasterTracks.add(PeerVideoTrack(
            peerId: peer.peerId,
            peerName: peer.name,
            videoTrack: isAudioOnly ? null : peer.videoTrack,
            roleName: peer.role.name,
            isAudioOnly: isAudioOnly,
          ));
          log("Added broadcaster: ${peer.name} (${isAudioOnly ? 'Audio-only' : 'Video'})");
        } else {
          remoteViewers.add(peer);
          if (peer.videoTrack != null) {
            remoteViewerTracks.add(PeerVideoTrack(
              peerId: peer.peerId,
              peerName: peer.name,
              videoTrack: peer.videoTrack!,
              roleName: peer.role.name,
              isAudioOnly: false,
            ));
          }
          log("Added viewer: ${peer.name}");
        }

        myviewerCount.value = myviewerCount.value + 1;
      }
    }

    broadcasterCount.value = remoteBroadcasters.length;
    log('Broadcaster count after join: ${broadcasterCount.value}');
    if (mounted) setState(() {});
  }

  bool _isBroadcasterRole(String roleName) {
    return roleName.toLowerCase().contains("livestreaming") ||
        roleName.toLowerCase().contains("host");
  }

  @override
  void onPeerUpdate(
      {required HMSPeer peer, required HMSPeerUpdate update}) async {
    log('onPeerUpdate → ${peer.name}, update=$update, role=${peer.role.name}');
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        _addPeer(peer);
        if (peer.role.name.toLowerCase().contains('audio-moderator') ||
            peer.role.name.toLowerCase().contains('livestreaming')) {
          _startSessionTimer();
        }

        break;

      case HMSPeerUpdate.peerLeft:
        _removePeer(peer);
        // Only stop session if WE (the host) are leaving or if there are no broadcasters left
        // Since we're the host, we should always continue unless we explicitly leave
        bool shouldStopSession = localPeer == null;
        if (mounted) {
          setState(
            () => isAlreadyTaking = false,
          );
        }
        // Add a small delay to ensure state is consistent
        await Future.delayed(const Duration(milliseconds: 100));
        log('left peer: ${peer.name}, should stop session: $shouldStopSession');
        if (shouldStopSession) {
          _stopSessionTimer();
        }
        break;

      case HMSPeerUpdate.roleUpdated:
        if (peer.role.name.toLowerCase().contains('audio-moderator') ||
            peer.role.name.toLowerCase().contains('livestreaming')) {
          _startSessionTimer();
        }

        _removePeer(peer);
        _addPeer(peer);

        // Check if we still have broadcasters after role change
        bool hasActiveBroadcasters = remoteBroadcasters.isNotEmpty;
        if (!hasActiveBroadcasters) {
          _stopSessionTimer();
        }
        break;

      default:
        break;
    }

    broadcasterCount.value = remoteBroadcasters.length;
    myviewerCount.value = remoteViewers.length + 1;

    if (mounted) setState(() {});
  }

  void _addPeer(HMSPeer peer) {
    // Skip local peer for remote lists so that it remain in same live screen
    if (peer.isLocal) return;

    bool isValidPeer = peer.name != null &&
        peer.name.trim().isNotEmpty &&
        peer.peerId != null &&
        peer.peerId.trim().isNotEmpty;

    bool isAudioOnly = _isAudioOnlyRole(peer.role.name);
    bool isBroadcaster = _isBroadcasterRole(peer.role.name) || isAudioOnly;
    if (isBroadcaster && isValidPeer) {
      if (!remoteBroadcasters.any((p) => p.peerId == peer.peerId)) {
        remoteBroadcasters.add(peer);
      }

      final existingTrackIndex =
          remoteBroadcasterTracks.indexWhere((t) => t.peerId == peer.peerId);
      if (existingTrackIndex >= 0) {
        remoteBroadcasterTracks[existingTrackIndex] = PeerVideoTrack(
          peerId: peer.peerId,
          peerName: peer.name,
          videoTrack: isAudioOnly ? null : peer.videoTrack,
          roleName: peer.role.name,
          isAudioOnly: isAudioOnly,
        );
      } else {
        remoteBroadcasterTracks.add(PeerVideoTrack(
          peerId: peer.peerId,
          peerName: peer.name,
          videoTrack: isAudioOnly ? null : peer.videoTrack,
          roleName: peer.role.name,
          isAudioOnly: isAudioOnly,
        ));
      }
    } else {
      if (!remoteViewers.any((p) => p.peerId == peer.peerId)) {
        remoteViewers.add(peer);
      }
      if (peer.videoTrack != null) {
        final existingTrackIndex =
            remoteViewerTracks.indexWhere((t) => t.peerId == peer.peerId);
        if (existingTrackIndex >= 0) {
          remoteViewerTracks[existingTrackIndex] = PeerVideoTrack(
            peerId: peer.peerId,
            peerName: peer.name,
            videoTrack: peer.videoTrack!,
            roleName: peer.role.name,
            isAudioOnly: false,
          );
        } else {
          remoteViewerTracks.add(PeerVideoTrack(
            peerId: peer.peerId,
            peerName: peer.name,
            videoTrack: peer.videoTrack!,
            roleName: peer.role.name,
            isAudioOnly: false,
          ));
        }
      }
      log('Added/Updated viewer: ${peer.name}');
    }
  }

  void _removePeer(HMSPeer peer) {
    // Only remove remote peers, not local peer
    log('Removed peer local ${peer.isLocal}, role ${peer.role.name}');

    if (!peer.isLocal) {
      remoteBroadcasters.removeWhere((p) => p.peerId == peer.peerId);
      remoteViewers.removeWhere((p) => p.peerId == peer.peerId);
      remoteBroadcasterTracks.removeWhere((t) => t.peerId == peer.peerId);
      remoteViewerTracks.removeWhere((t) => t.peerId == peer.peerId);
    }
    log('Removed peer: ${peer.name}');
  }

  @override
  void onTrackUpdate({
    required HMSTrack track,
    required HMSTrackUpdate trackUpdate,
    required HMSPeer peer,
  }) {
    if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
      final videoTrack = track as HMSVideoTrack;

      if (peer.isLocal) {
        localPeerVideoTrack = videoTrack;
        isVideoOn.value = !videoTrack.isMute;
      } else {
        final List<PeerVideoTrack> targetList =
            _isBroadcasterRole(peer.role.name)
                ? remoteBroadcasterTracks
                : remoteViewerTracks;

        final existingIndex =
            targetList.indexWhere((pt) => pt.peerId == peer.peerId);
        if (existingIndex >= 0) {
          targetList[existingIndex] = PeerVideoTrack(
            peerId: peer.peerId,
            peerName: peer.name,
            videoTrack: videoTrack,
            roleName: peer.role.name,
          );
        } else {
          targetList.add(PeerVideoTrack(
            peerId: peer.peerId,
            peerName: peer.name,
            videoTrack: videoTrack,
            roleName: peer.role.name,
          ));
        }
      }
    } else if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
      if (peer.isLocal) {
        localPeerAudioTrack = track as HMSAudioTrack;
        isMicMuted.value = track.isMute;
      } else {
        // Handle audio-only peers here
        bool isAudioOnly = _isAudioOnlyRole(peer.role.name);

        if (isAudioOnly) {
          final existingIndex = remoteBroadcasterTracks
              .indexWhere((pt) => pt.peerId == peer.peerId);

          if (existingIndex >= 0) {
            remoteBroadcasterTracks[existingIndex] = PeerVideoTrack(
              peerId: peer.peerId,
              peerName: peer.name,
              videoTrack: null,
              roleName: peer.role.name,
              isAudioOnly: true,
            );
          } else {
            // Add new audio-only peer
            remoteBroadcasterTracks.add(PeerVideoTrack(
              peerId: peer.peerId,
              peerName: peer.name,
              videoTrack: null, // No video for audio-only
              roleName: peer.role.name,
              isAudioOnly: true,
            ));
          }
        }
      }
    }

    if (mounted) setState(() {});
  }

  @override
  void onMessage({required HMSMessage message}) {
    try {
      final data = json.decode(message.message);
      log('onMessage data: $data');
      MessageModel newMessage = MessageModel(
        message: data['message'] ?? "",
        userName: data['userName'] ?? "User",
        profile: data['profile'] ?? "",
        isMe: false,
        gift: null,
        createdAt: DateTime.parse(data['timestamp']),
      );

      log('on message live screen is ${newMessage.message}');
      _messageLock.synchronized(() {
        messageList.add(newMessage);
        reverseMessage.value = messageList.reversed.toList();
      });
    } catch (e) {
      log('Message handling error: $e');
    }
  }

  @override
  void onAudioDeviceChanged({
    HMSAudioDevice? currentAudioDevice,
    List<HMSAudioDevice>? availableAudioDevice,
  }) {
    if (currentAudioDevice == HMSAudioDevice.SPEAKER_PHONE) {
      isSpeakerOn.value = true;
    } else {
      isSpeakerOn.value = false;
    }
  }

  @override
  void onSessionStoreAvailable({HMSSessionStore? hmsSessionStore}) {}
  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {}
  @override
  void onHMSError({required HMSException error}) {
    log('onHMSError error is ${error.message}');
  }

  @override
  void onReconnected() {}
  @override
  void onReconnecting() {}
  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {}
  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    pendingRoleRequests.value.add(roleChangeRequest);
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {}
  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {}
  @override
  void onPeerListUpdate(
      {required List<HMSPeer> addedPeers,
      required List<HMSPeer> removedPeers}) {}

  Future<void> wailtListDialog() {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => Container(
            height: 50.h,
            width: 100.w,
            margin: EdgeInsets.all(3.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 100.w,
                    child: Stack(
                      children: [
                        Center(
                          child: const Text(
                            "Waitlist",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ).tr(),
                        ),
                        Positioned(
                          right: 10,
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3.w),
                    child: Text(
                      "Customers who missed the call & were marked offline will get priority as per the list, if they come online.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.sp,
                      ),
                      textAlign: TextAlign.center,
                    ).tr(),
                  ),
                  SizedBox(
                    height: 25.h,
                    // ignore: prefer_is_empty
                    child: liveAstrologerController.waitList.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: liveAstrologerController.waitList.length,
                            itemBuilder: (
                              BuildContext context,
                              int index,
                            ) {
                              return Container(
                                padding: EdgeInsets.all(3.w),
                                width: 100.w,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        liveAstrologerController.waitList[index]
                                                    .userProfile !=
                                                ""
                                            ? CircleAvatar(
                                                radius: 15,
                                                backgroundColor:
                                                    Get.theme.primaryColor,
                                                child: Image.network(
                                                  liveAstrologerController
                                                      .waitList[index]
                                                      .userProfile,
                                                  height: 18,
                                                ),
                                              )
                                            : CircleAvatar(
                                                radius: 15,
                                                backgroundColor:
                                                    Get.theme.primaryColor,
                                                child: Image.asset(
                                                  "assets/images/no_customer_image.png",
                                                  height: 18,
                                                ),
                                              ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 3.w,
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                liveAstrologerController
                                                    .waitList[index].userName,
                                                style: TextStyle(
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                liveAstrologerController
                                                        .waitList[index]
                                                        .isOnline
                                                    ? 'Online'
                                                    : 'Offline',
                                                style: TextStyle(
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ).tr(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 10,
                                          backgroundColor:
                                              Get.theme.primaryColor,
                                          child: Icon(
                                            liveAstrologerController
                                                        .waitList[index]
                                                        .requestType ==
                                                    "Video"
                                                ? Icons.video_call
                                                : liveAstrologerController
                                                            .waitList[index]
                                                            .requestType ==
                                                        "Audio"
                                                    ? Icons.call
                                                    : Icons.chat,
                                            color: Colors.black,
                                            size: 13,
                                          ),
                                        ),
                                        liveAstrologerController
                                                .waitList[index].isOnline
                                            ? Container(
                                                margin: EdgeInsets.only(
                                                  left: 3.w,
                                                ),
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color:
                                                      liveAstrologerController
                                                              .waitList[index]
                                                              .isOnline
                                                          ? Get.theme
                                                              .primaryColor
                                                          : Colors.grey,
                                                ),
                                                child: ElevatedButton(
                                                  //! WAITING LIST
                                                  onPressed: () async {
                                                    Future.delayed(
                                                      const Duration(
                                                        milliseconds: 500,
                                                      ),
                                                    ).then((value) async {
                                                      await localNotifications
                                                          .cancelAll();
                                                    });
                                                    log(
                                                      'alreay running $isAlreadyTaking',
                                                    );

                                                    if (isAlreadyTaking ==
                                                        true) {
                                                      global.showToast(
                                                        message:
                                                            "already running",
                                                      );

                                                      return;
                                                    } else {
                                                      log(
                                                        'no live chat carry on jatta',
                                                      );
                                                    }

                                                    List<String> list = [];
                                                    for (var i = 0;
                                                        i <
                                                            liveAstrologerController
                                                                .waitList
                                                                .length;
                                                        i++) {
                                                      log(
                                                        "STATUS 1 ${liveAstrologerController.waitList[i].status}",
                                                      );

                                                      if (liveAstrologerController
                                                              .waitList[i]
                                                              .status ==
                                                          "Pending") {
                                                        list.add("value");

                                                        setState(
                                                          () =>
                                                              isAlreadyTaking =
                                                                  true,
                                                        );
                                                      }
                                                    }
                                                    debugPrint("marker1");
                                                    debugPrint(
                                                      '${list.isEmpty}',
                                                    );
                                                    debugPrint('$list');

                                                    if (list.isNotEmpty) {
                                                      //! connect other user by desconnecting current user
                                                      log(
                                                        "statu Already is in chat",
                                                      );

                                                      CurrentUser userData =
                                                          CurrentUser.fromJson(
                                                        json.decode(
                                                          global.sp!.getString(
                                                                "currentUser",
                                                              ) ??
                                                              "",
                                                        ),
                                                      );
                                                      String id = userData.id
                                                          .toString();
                                                      String? fcmToken =
                                                          await FirebaseMessaging
                                                              .instance
                                                              .getToken();

                                                      setState(() {
                                                        reqType =
                                                            liveAstrologerController
                                                                .waitList[index]
                                                                .requestType;
                                                        log(
                                                          'req type $reqType',
                                                        );
                                                        username =
                                                            liveAstrologerController
                                                                .waitList[index]
                                                                .userName;
                                                      });
                                                      global.sendNotification(
                                                        call_method: 'hms',
                                                        fcmToken:
                                                            liveAstrologerController
                                                                .waitList[index]
                                                                .userFcmToken,
                                                        title:
                                                            "For Live accept/reject",
                                                        subtitle:
                                                            "For Live accept/reject",
                                                        astroname: (global.user
                                                                        .name !=
                                                                    null &&
                                                                global.user
                                                                        .name !=
                                                                    "")
                                                            ? global.user.name
                                                            : "Astrologer",
                                                        channelname: global
                                                            .agoraLiveChannelName,
                                                        token: global
                                                            .agoraLiveToken,
                                                        astroId: id.toString(),
                                                        requestType:
                                                            liveAstrologerController
                                                                .waitList[index]
                                                                .requestType,
                                                        id: liveAstrologerController
                                                            .waitList[index].id
                                                            .toString(),
                                                        charge: global
                                                            .user.charges
                                                            .toString(),
                                                        nfcmToken: fcmToken,
                                                        astroProfile: global
                                                                .user
                                                                .imagePath ??
                                                            "",
                                                        videoCallCharge: global
                                                            .user.videoCallRate
                                                            .toString(),
                                                      );

                                                      liveAstrologerController
                                                          .endTime = DateTime
                                                                  .now()
                                                              .millisecondsSinceEpoch +
                                                          1000 *
                                                              int.parse(
                                                                liveAstrologerController
                                                                    .waitList[
                                                                        index]
                                                                    .time,
                                                              );
                                                    } else {
                                                      global.showToast(
                                                        message:
                                                            "Once running session complete, you will be able to start new session",
                                                      );
                                                    }
                                                    Get.back();
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        liveAstrologerController
                                                                .waitList[index]
                                                                .isOnline
                                                            ? MaterialStateProperty
                                                                .all(
                                                                Get.theme
                                                                    .primaryColor,
                                                              )
                                                            : MaterialStateProperty
                                                                .all(
                                                                Colors.grey,
                                                              ),
                                                  ),
                                                  child: Center(
                                                    child: const Text(
                                                      "Start",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ).tr(),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : Center(
                            child: const Text(
                              "No members available",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ).tr(),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            ValueListenableBuilder<int>(
              valueListenable: broadcasterCount,
              builder: (context, count, child) {
                if (count == 0 && remoteBroadcasterTracks.isNotEmpty) {
                  count = remoteBroadcasterTracks.length;
                }
                if (count == 0) {
                  return _buildSingleBroadcasterView();
                } else if (count == 1) {
                  return _buildSplitScreenView();
                } else {
                  return _buildMultiBroadcasterView();
                }
              },
            ),

            // Top info bar with viewer count and timer
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Container(
                width: 90.w,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Live status and timer
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.circle,
                              color: Colors.white, size: 10),
                          const SizedBox(width: 6),
                          ValueListenableBuilder<int>(
                            valueListenable: myviewerCount,
                            builder: (_, count, __) {
                              return Text(
                                "LIVE • $count viewers",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Session timer
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ValueListenableBuilder<Duration>(
                        valueListenable: _sessionDuration,
                        builder: (_, duration, __) {
                          if (duration.inSeconds <= 0) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            liveAstrologerController.formatDuration(duration),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Chat section
            Positioned(
              bottom: 120,
              left: 10,
              child: SizedBox(
                child: ValueListenableBuilder<List<MessageModel>>(
                  valueListenable: reverseMessage,
                  builder: (context, messages, child) => messages.isEmpty
                      ? const SizedBox()
                      : Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.65,
                          ),
                          height: 200,
                          child: ListView.builder(
                            itemCount: messages.length,
                            reverse: true,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: messages[index].profile !=
                                                  null &&
                                              messages[index]
                                                  .profile!
                                                  .isNotEmpty &&
                                              global.isValidUrl(
                                                  messages[index].profile!)
                                          ? global.encodeUrl(
                                              messages[index].profile!)
                                          : '', // This will trigger errorBuilder
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        backgroundImage: imageProvider,
                                        radius: 15,
                                      ),
                                      placeholder: (context, url) =>
                                          CircleAvatar(
                                        backgroundColor: Colors.grey[300],
                                        radius: 15,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.grey),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/no_customer_image.png"),
                                        radius: 15,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            messages[index].userName ?? "User",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.45,
                                            ),
                                            child: Text(
                                              messages[index].message ?? "",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ),
            ),

            // Bottom bar with controls
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Stack(
      children: [
        // Chat input at bottom center
        Positioned(
          bottom: 20,
          left: 20,
          right: 80,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.w),
            ),
            constraints: const BoxConstraints(
              minHeight: 48,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: messageController,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: "say hi..",
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          sendMessage(value);
                          messageController.clear();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8e44ad), Color(0xFF3498db)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: () {
                      if (messageController.text.isNotEmpty) {
                        sendMessage(messageController.text);
                        messageController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // Vertical controls on right side
        Positioned(
          bottom: 20,
          right: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () async {
                  Future.delayed(
                    const Duration(milliseconds: 500),
                  ).then((value) async {
                    await localNotifications.cancelAll();
                  });
                  await liveAstrologerController.getWaitList(
                    global.agoraLiveChannelName,
                  );
                  await liveAstrologerController
                      .getLiveuserData(global.agoraLiveChannelName);
                  await liveAstrologerController.onlineOfflineUser();
                  liveAstrologerController.isUserJoinWaitList = false;
                  liveAstrologerController.update();
                  wailtListDialog();
                },
                child: GetBuilder<LiveAstrologerController>(
                  builder: (liveController) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.hourglassEnd,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        liveController.isUserJoinWaitList
                            ? const Positioned(
                                right: 20,
                                top: 0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 6,
                                ),
                              )
                            : const SizedBox(),
                      ],
                    );
                  },
                ),
              ),

              // Mic Button
              ValueListenableBuilder(
                valueListenable: isMicMuted,
                builder: (_, muted, __) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: muted ? Colors.red : Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        muted ? Icons.mic_off : Icons.mic,
                        color: Colors.white,
                      ),
                      onPressed: _toggleMicMute,
                    ),
                  );
                },
              ),

              // Video Button
              ValueListenableBuilder(
                valueListenable: isVideoOn,
                builder: (_, videoOn, __) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color:
                          videoOn ? Colors.black.withOpacity(0.7) : Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        videoOn ? Icons.videocam : Icons.videocam_off,
                        color: Colors.white,
                      ),
                      onPressed: _toggleVideo,
                    ),
                  );
                },
              ),

              // Speaker Button
              ValueListenableBuilder(
                valueListenable: isSpeakerOn,
                builder: (_, speakerOn, __) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: speakerOn
                          ? Colors.black.withOpacity(0.7)
                          : Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        speakerOn ? Icons.volume_up : Icons.volume_off,
                        color: Colors.white,
                      ),
                      onPressed: _toggleSpeaker,
                    ),
                  );
                },
              ),

              // End Call Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.6),
                      blurRadius: 12,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.call_end, color: Colors.white),
                  onPressed: () {
                    leaveMeeting();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSingleBroadcasterView() {
    return Stack(
      children: [
        localPeerVideoTrack != null
            ? HMSVideoView(
                track: localPeerVideoTrack!,
                setMirror: true,
                scaleType: ScaleType.SCALE_ASPECT_FILL,
              )
            : _buildPlaceholderAvatar(currenUserName),
        _buildNameOverlay('',
            bottom: 20, left: 20), //if add name will show below textfield msg
      ],
    );
  }

// Updated _buildSplitScreenView method to handle audio-only
  Widget _buildSplitScreenView() {
    if (remoteBroadcasterTracks.isEmpty) return _buildSingleBroadcasterView();

    final remotePeerTrack = remoteBroadcasterTracks.first;
    log('in design audio is ${remotePeerTrack.isAudioOnly}');
    return Column(
      children: [
        // Remote broadcaster (video or audio-only)
        Expanded(
          child: Stack(
            children: [
              if (remotePeerTrack.isAudioOnly)
                _buildAudioOnlyView(remotePeerTrack.peerName ?? '')
              else
                HMSVideoView(
                  track: remotePeerTrack.videoTrack!,
                  setMirror: false,
                  scaleType: ScaleType.SCALE_ASPECT_FILL,
                ),
              _buildNameOverlay(
                "${remotePeerTrack.peerName}${remotePeerTrack.isAudioOnly ? ' (Audio)' : ''}",
                bottom: 10,
                left: 10,
              ),
            ],
          ),
        ),

        // Divider
        Container(height: 2, color: Colors.red),

        // Local broadcaster
        Expanded(
          child: Stack(
            children: [
              localPeerVideoTrack != null
                  ? HMSVideoView(
                      track: localPeerVideoTrack!,
                      setMirror: true,
                      scaleType: ScaleType.SCALE_ASPECT_FILL,
                    )
                  : _buildPlaceholderAvatar(currenUserName),
              _buildNameOverlay("$currenUserName (You)", top: 10, right: 10),
            ],
          ),
        ),
      ],
    );
  }

// Updated _buildMultiBroadcasterView method
  Widget _buildMultiBroadcasterView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
      ),
      itemCount: remoteBroadcasterTracks.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          // Local peer
          return Stack(
            children: [
              localPeerVideoTrack != null
                  ? HMSVideoView(
                      track: localPeerVideoTrack!,
                      setMirror: true,
                      scaleType: ScaleType.SCALE_ASPECT_FILL,
                    )
                  : _buildPlaceholderAvatar(currenUserName),
              _buildNameOverlay("$currenUserName (You)"),
            ],
          );
        } else {
          // Remote broadcasters
          final peerTrack = remoteBroadcasterTracks[index - 1];
          return Stack(
            children: [
              if (peerTrack.isAudioOnly)
                _buildAudioOnlyView(peerTrack.peerName ?? '')
              else
                HMSVideoView(
                  track: peerTrack.videoTrack!,
                  setMirror: false,
                  scaleType: ScaleType.SCALE_ASPECT_FILL,
                ),
              _buildNameOverlay(
                "${peerTrack.peerName}${peerTrack.isAudioOnly ? ' (Audio)' : ''}",
              ),
            ],
          );
        }
      },
    );
  }

// New method to build audio-only view
  Widget _buildAudioOnlyView(String peerName) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.green.shade700,
              radius: 50,
              child: Text(
                peerName.isNotEmpty
                    ? peerName.substring(0, 1).toUpperCase()
                    : "U",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Animated voice indicator
            AnimatedBuilder(
              animation: const AlwaysStoppedAnimation(0),
              builder: (context, child) {
                return Image.asset(
                  'assets/images/voice.gif',
                  height: 30,
                  width: 30,
                );
              },
            ),
            const SizedBox(height: 8),
            const Text(
              'Audio Only',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderAvatar(String name) {
    return Container(
      color: Colors.black,
      child: Center(
        child: CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 40,
          child: Text(
            name.isNotEmpty ? name.substring(0, 1).toUpperCase() : "?",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameOverlay(String name,
      {double? top, double? bottom, double? left, double? right}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  @override
  void dispose() {
    hmsSDK.removeUpdateListener(listener: this);
    hmsSDK.destroy();
    super.dispose();
  }
}
