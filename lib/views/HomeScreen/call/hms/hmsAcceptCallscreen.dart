import 'dart:async';
import 'dart:developer';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../controllers/HomeController/call_controller.dart';
import '../../../../controllers/HomeController/wallet_controller.dart';
import '../../../../services/apiHelper.dart';
import '../../../../utils/constantskeys.dart';
import '../../../../utils/foreground_task_handler.dart';
import '../../home_screen.dart';

class HmsOneToOneAudioCallScreen extends StatefulWidget {
  final String userName;
  final int callId;
  final audioDuration;
  String? profile;

  HmsOneToOneAudioCallScreen(
      {super.key,
      required this.userName,
      required this.callId,
      required this.audioDuration,
      required this.profile,
});

  @override
  State<HmsOneToOneAudioCallScreen> createState() =>
      _HmsOneToOneAudioCallScreenState();
}

class _HmsOneToOneAudioCallScreenState extends State<HmsOneToOneAudioCallScreen>
    implements HMSUpdateListener {
  late HMSSDK hmsSDK;
  HMSPeer? localPeer, remotePeer;
  HMSAudioTrack? localPeerAudioTrack, remotePeerAudioTrack;
  final ValueNotifier<bool> isMicMuted = ValueNotifier(false);
  final ValueNotifier<bool> isSpeakerOn = ValueNotifier(true);
  final ValueNotifier<String> localName = ValueNotifier("Joining...");
  final ValueNotifier<String> remoteName = ValueNotifier("Connecting...");
  final ValueNotifier<bool> isConnected = ValueNotifier(false);
  Timer? _timer;
  final callController = Get.find<CallController>();
  final ValueNotifier<Duration> remainingTime = ValueNotifier(Duration.zero);
  final walletController = Get.find<WalletController>();
  final apiHelper = APIHelper();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      remainingTime.value = Duration(seconds: int.parse(widget.audioDuration));
      global.showOnlyLoaderDialog();

      ForegroundServiceManager.startForegroundTask();
      final _calltoken = await callController.sendCallToken(
          '', global.agoraChannelName, widget.callId);
      log('call token get is $_calltoken');
      log('profile image is ${widget.profile}');

      global.hideLoader();
      if (_calltoken != null) {
        initHMSSDK(_calltoken);
      } else {
        global.showToast(message: "Retrying to fetch call token...");
        Future.delayed(const Duration(seconds: 2), () {
          initState(); // or call sendCallToken again
        });
      }
    });
  }

  void initHMSSDK(String _calltoken) async {
    hmsSDK = HMSSDK();
    await hmsSDK.build();
    hmsSDK.addUpdateListener(listener: this);
    try {
      hmsSDK.join(
        config: HMSConfig(authToken: _calltoken, userName: widget.userName),
      );
    } on Exception catch (e) {
      log('Error joining HMS SDK: $e');
    }
  }

  Future<void> leaveMeeting() async {
    try {
      ForegroundServiceManager.stopForegroundTask();
      await hmsSDK.leave();
      hmsSDK.destroy();
      _timer?.cancel();
      await walletController.getAmountList();
      walletController.update();
      debugPrint("leave");
      await apiHelper.setAstrologerOnOffBusyline("Online");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(ConstantsKeys.ISACCEPTED, false);
      await prefs.setString(ConstantsKeys.ISACCEPTEDDATA, '');
      await prefs.setBool(ConstantsKeys.ISREJECTED, false);
      Get.offAll(() => HomeScreen(isId: widget.callId));
    } catch (e) {
      debugPrint("Error leaving meeting: $e");
      Get.back();
    }
  }

  void _toggleMicMute() async {
    await hmsSDK.toggleMicMuteState();
  }

  void _toggleSpeaker() async {
    if (isSpeakerOn.value) {
      hmsSDK.switchAudioOutput(audioDevice: HMSAudioDevice.EARPIECE);
    } else {
      hmsSDK.switchAudioOutput(audioDevice: HMSAudioDevice.SPEAKER_PHONE);
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingTime.value.inSeconds > 0) {
        remainingTime.value = remainingTime.value - const Duration(seconds: 1);
        log('time remaining: ${remainingTime.value}');
      } else {
        _timer?.cancel();
        global.showToast(message: 'call ended');
        leaveMeeting();
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    remotePeer = null;
    remotePeerAudioTrack = null;
    localPeer = null;
    localPeerAudioTrack = null;
    super.dispose();
  }

  @override
  void onJoin({required HMSRoom room}) {
    if (!mounted) return;

    for (var peer in room.peers ?? []) {
      if (peer.isLocal) {
        log('dont start timer');
        localPeer = peer;
        localName.value = peer.name;
        if (peer.audioTrack != null) {
          localPeerAudioTrack = peer.audioTrack;
          isMicMuted.value = localPeerAudioTrack?.isMute ?? true;
        }
      } else {
        log('start timer');
        remotePeer = peer;
        remoteName.value = peer.name;
        isConnected.value = true;
      }
    }
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    if (!mounted) return;

    switch (update) {
      case HMSPeerUpdate.peerJoined:
        if (!peer.isLocal) {
          remotePeer = peer;
          // remoteName.value = peer.name;
          remoteName.value = widget.userName;
          log('remote name is ${remoteName.value}');
          isConnected.value = true;
          _startCountdown();
        }
        break;

      case HMSPeerUpdate.peerLeft:
        if (!peer.isLocal) {
          remotePeer = null;
          remoteName.value = "Connecting...";
          isConnected.value = false;
          leaveMeeting();
          global.showToast(message: 'User Left');
        }
        break;

      default:
        return;
    }
  }

  @override
  void onTrackUpdate({
    required HMSTrack track,
    required HMSTrackUpdate trackUpdate,
    required HMSPeer peer,
  }) {
    if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
      if (peer.isLocal) {
        localPeerAudioTrack = track as HMSAudioTrack;
        isMicMuted.value = localPeerAudioTrack?.isMute ?? true;
        log('Local audio track updated: ${track.trackId}, muted: ${track.isMute}');
      } else {
        switch (trackUpdate) {
          case HMSTrackUpdate.trackAdded:
            log('✅ Remote audio track ADDED: ${track.trackId}');
            break;
          case HMSTrackUpdate.trackRemoved:
            log('❌ Remote audio track REMOVED: ${track.trackId}');
            leaveMeeting();
            break;
          case HMSTrackUpdate.trackMuted:
            log('🔇 Remote audio track MUTED: ${track.trackId}');
            break;
          case HMSTrackUpdate.trackUnMuted:
            log('🔊 Remote audio track UNMUTED: ${track.trackId}');
            break;
          default:
            log('Other audio track update: $trackUpdate');
        }
      }
    }
    // if (track.kind == HMSTrackKind.kHMSTrackKindAudio && peer.isLocal) {
    //   localPeerAudioTrack = track as HMSAudioTrack;
    //   isMicMuted.value = localPeerAudioTrack?.isMute ?? true;
    // }
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

  // Unused callbacks
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
  void onMessage({required HMSMessage message}) {
    log('onMessage chat msg is ${message.message}');
  }

  @override
  void onReconnected() {
    log('onReconnected');
  }

  @override
  void onReconnecting() {
    log('onReconnecting');
  }

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {}
  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {}
  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {}
  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {}
  @override
  void onPeerListUpdate(
      {required List<HMSPeer> addedPeers,
      required List<HMSPeer> removedPeers}) {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.deepPurple.shade900,
                    Colors.indigo.shade900,
                    Colors.black,
                  ],
                ),
              ),
            ),
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Timer (only show when connected)
                  ValueListenableBuilder(
                    valueListenable: isConnected,
                    builder: (_, connected, __) {
                      return connected
                          ? ValueListenableBuilder(
                              valueListenable: remainingTime,
                              builder: (_, duration, __) {
                                return Column(
                                  children: [
                                    Text(
                                      _formatDuration(duration),
                                      style: TextStyle(
                                        color: duration.inMinutes < 1
                                            ? Colors.red
                                            : Colors.green,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (duration.inMinutes < 1 &&
                                        duration.inSeconds > 0)
                                      Text(
                                        "${duration.inSeconds} seconds remaining",
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                );
                              },
                            )
                          : const SizedBox();
                    },
                  ),
                  const SizedBox(height: 10),

                  // Animated audio waves
                  ValueListenableBuilder(
                    valueListenable: isMicMuted,
                    builder: (_, muted, __) {
                      return Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: muted
                              ? Colors.grey.shade800
                              : Colors.blue.shade800,
                          boxShadow: [
                            BoxShadow(
                              color: muted
                                  ? Colors.grey.withOpacity(0.3)
                                  : Colors.blue.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center, // 👈 center everything
                          children: [
                            // Animated wave rings
                            ...List.generate(3, (index) {
                              return Positioned.fill(
                                child: AnimatedContainer(
                                  duration:
                                      Duration(milliseconds: 500 + index * 200),
                                  curve: Curves.easeInOut,
                                  margin: EdgeInsets.all(20 + index * 15),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white
                                          .withOpacity(0.3 - index * 0.1),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            }),

                            ClipOval(
                              child: widget.profile == null ||
                                      widget.profile == "" ||
                                      widget.profile == "null"
                                  ? Image.asset(
                                      'assets/images/no_customer_image.png',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      "${widget.profile}",
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/no_customer_image.png',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // User name with connection status
                  ValueListenableBuilder(
                    valueListenable: isConnected,
                    builder: (_, connected, __) {
                      return connected
                          ? ValueListenableBuilder(
                              valueListenable: remoteName,
                              builder: (_, name, __) {
                                return Text(
                                  name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            )
                          : const Text(
                              "Connecting...",
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                    },
                  ),

                  const SizedBox(height: 10),

                  // Connection status
                  ValueListenableBuilder(
                    valueListenable: isConnected,
                    builder: (_, connected, __) {
                      return Text(
                        connected ? "Connected" : "Connecting...",
                        style: TextStyle(
                          color: connected ? Colors.greenAccent : Colors.orange,
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Bottom control buttons
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Mic Button
                  ValueListenableBuilder(
                    valueListenable: isMicMuted,
                    builder: (_, muted, __) {
                      return CircleAvatar(
                        radius: 30,
                        backgroundColor: muted ? Colors.red : Colors.blueGrey,
                        child: IconButton(
                          icon:
                              Icon(muted ? Icons.mic_off : Icons.mic, size: 28),
                          color: Colors.white,
                          onPressed: _toggleMicMute,
                        ),
                      );
                    },
                  ),
                  // End Call Button
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.red,
                    child: IconButton(
                      icon: const Icon(Icons.call_end, size: 32),
                      color: Colors.white,
                      onPressed: leaveMeeting,
                    ),
                  ),
                  // Speaker Button
                  ValueListenableBuilder(
                    valueListenable: isSpeakerOn,
                    builder: (_, speakerOn, __) {
                      return CircleAvatar(
                        radius: 30,
                        backgroundColor:
                            speakerOn ? Colors.blue : Colors.blueGrey,
                        child: IconButton(
                          icon: Icon(
                              speakerOn ? Icons.volume_up : Icons.volume_off,
                              size: 28),
                          color: Colors.white,
                          onPressed: _toggleSpeaker,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Status indicators at top
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder(
                    valueListenable: isMicMuted,
                    builder: (_, muted, __) {
                      return muted
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.mic_off,
                                      size: 16, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text('Muted',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12)),
                                ],
                              ),
                            )
                          : const SizedBox();
                    },
                  ),
                  const SizedBox(width: 10),
                  ValueListenableBuilder(
                    valueListenable: isSpeakerOn,
                    builder: (_, speakerOn, __) {
                      return speakerOn
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.volume_up,
                                      size: 16, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text('Speaker',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12)),
                                ],
                              ),
                            )
                          : const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
