// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:brahmanshtalk/views/HomeScreen/call/hms/VideoLoadingIndicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../controllers/HomeController/call_controller.dart';
import '../../../../controllers/HomeController/live_astrologer_controller.dart';
import '../../../../services/apiHelper.dart';
import '../../../../utils/constantskeys.dart';
import '../../../../utils/foreground_task_handler.dart';
import '../../../../utils/global.dart' as global;
import '../../home_screen.dart';

class HmsOneToOneVideoCallScreen extends StatefulWidget {
  final int callId;
  final String userName;
  final String profile;
  final int id;
  final String fcmToken;
  final String callduration;

  const HmsOneToOneVideoCallScreen({
    super.key,
    required this.callId,
    required this.userName,
    required this.profile,
    required this.id,
    required this.fcmToken,
    required this.callduration,
  });

  @override
  State<HmsOneToOneVideoCallScreen> createState() =>
      _HmsOneToOneVideoCallScreenState();
}

class _HmsOneToOneVideoCallScreenState extends State<HmsOneToOneVideoCallScreen>
    implements HMSUpdateListener {
  late HMSSDK hmsSDK;
  HMSPeer? localPeer, remotePeer;
  HMSVideoTrack? localPeerVideoTrack, remotePeerVideoTrack;
  final ValueNotifier<bool> isMicMuted = ValueNotifier(false);
  final ValueNotifier<bool> isVideoOn = ValueNotifier(true);
  final ValueNotifier<bool> isSpeakerOn = ValueNotifier(true);
  final ValueNotifier<String> localName = ValueNotifier("Joining...");
  final ValueNotifier<String> remoteName = ValueNotifier("Waiting...");
  final ValueNotifier<Duration> remainingTime = ValueNotifier(Duration.zero);
  final ValueNotifier<int> connectionQuality = ValueNotifier(4); // 1-4 scale
  final ValueNotifier<String> callStatus = ValueNotifier("Connecting");
  Timer? _timer;
  final callController = Get.find<CallController>();
  // Draggable local video position
  Offset _localVideoPosition = const Offset(20, 100);
  final bool _isLocalVideoVisible = true;
  Duration _initialDuration = Duration.zero;
  final liveAstrologerController = Get.find<LiveAstrologerController>();
  final apiHelper = APIHelper();

  @override
  void initState() {
    super.initState();
    log('profile is ${widget.profile}');
    _parseCallDuration();
    initHMSSDK();
  }

  void _parseCallDuration() {
    try {
      int seconds = int.tryParse(widget.callduration) ?? 0;
      _initialDuration = Duration(seconds: seconds);
      remainingTime.value = _initialDuration;
    } catch (e) {
      log('Error parsing callduration: $e');
      _initialDuration = const Duration(minutes: 5);
      remainingTime.value = _initialDuration;
    }
  }

  void initHMSSDK() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      global.showOnlyLoaderDialog();
      ForegroundServiceManager.startForegroundTask();
      final calltoken = await callController.sendCallToken(
          '', global.agoraChannelName, widget.callId);
      log('video_call token is $calltoken');
      global.hideLoader();
      if (calltoken != null) {
        try {
          hmsSDK = HMSSDK();
          await hmsSDK.build();
          hmsSDK.addUpdateListener(listener: this);
          hmsSDK.join(
            config: HMSConfig(
              authToken: calltoken,
              userName: widget.userName,
              captureNetworkQualityInPreview: true,
              metaData:
                  json.encode({'user_id': widget.id, 'auto_subscribe': 'true'}),
            ),
          );
        } on Exception catch (e) {
          log('Error joining HMS SDK: $e');
        }
      } else {
        global.showToast(message: "Retrying to fetch call token...");
        Future.delayed(const Duration(seconds: 2), () {
          initState(); // or call sendCallToken again
        });
      }
    });
  }

  Future<void> leaveMeeting() async {
    try {
      ForegroundServiceManager.stopForegroundTask();
      _timer?.cancel();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(ConstantsKeys.ISACCEPTED, false);
      await prefs.setString(ConstantsKeys.ISACCEPTEDDATA, '');
      await prefs.setBool(ConstantsKeys.ISREJECTED, false);
      await liveAstrologerController.endLiveSession(false);
      liveAstrologerController.isImInLive = false;
      liveAstrologerController.update();
      await apiHelper.setAstrologerOnOffBusyline("Online");
      await hmsSDK.leave();
      hmsSDK.destroy();
      Get.off(() => HomeScreen(isId: widget.id));
    } catch (e) {
      Get.back();
      debugPrint("Error leaving meeting: $e");
    }
  }

  void _toggleMicMute() async {
    await hmsSDK.toggleMicMuteState();
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

  void _switchCamera() async {
    try {
      await hmsSDK.switchCamera();
      log('Camera switched successfully');
    } catch (e) {
      log('Error switching camera: $e');
      global.showToast(message: "Failed to switch camera");
    }
  }

  void _startCountdownTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingTime.value.inSeconds > 0) {
        remainingTime.value = remainingTime.value - const Duration(seconds: 1);
      } else {
        // Call time ended
        _timer?.cancel();
        leaveMeeting();
        global.showToast(message: "Call time has ended");
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }

  Color _getConnectionColor(int quality) {
    switch (quality) {
      case 4: // Excellent
        return Colors.green.withOpacity(0.7);
      case 3: // Good
        return Colors.blue.withOpacity(0.7);
      case 2: // Poor
        return Colors.orange.withOpacity(0.7);
      case 1: // Bad
      default:
        return Colors.red.withOpacity(0.7);
    }
  }

  String _getConnectionText(int quality) {
    switch (quality) {
      case 4:
        return "Excellent";
      case 3:
        return "Good";
      case 2:
        return "Poor";
      case 1:
        return "Bad";
      default:
        return "Unknown";
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    remainingTime.value = Duration.zero;
    remotePeer = null;
    remotePeerVideoTrack = null;
    localPeer = null;
    localPeerVideoTrack = null;
    super.dispose();
  }

  @override
  void onJoin({required HMSRoom room}) {
    log('Joined room: ${room.name} with ${room.peers?.length} peers');
    global.debugRoomState(room); // Add this line
    callStatus.value = "Connected";

    for (var peer in room.peers ?? []) {
      if (peer.isLocal) {
        localPeer = peer;
        localName.value = peer.name;
        if (peer.videoTrack != null) {
          localPeerVideoTrack = peer.videoTrack;
          isVideoOn.value = !(localPeerVideoTrack?.isMute ?? false);
          log('Local video track: ${localPeerVideoTrack?.trackId}');
        }
        if (peer.audioTrack != null) {
          isMicMuted.value = peer.audioTrack?.isMute ?? true;
          log('Local audio track: ${peer.audioTrack?.trackId}');
        }
      } else {
        remotePeer = peer;
        remoteName.value = widget.userName;
        log("✅ remoteName onJoin ${peer.name}");

        // Check for existing tracks
        if (peer.videoTrack != null) {
          remotePeerVideoTrack = peer.videoTrack;
          log('Remote video track available: ${peer.videoTrack?.trackId}');
        }

        if (peer.audioTrack != null) {
          log('Remote audio track available: ${peer.audioTrack?.trackId}');
        }
      }
    }
    if (mounted) setState(() {});
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        log("✅ peer role of ${peer.role.name}");
        if (!peer.isLocal) {
          remotePeer = peer;
          remoteName.value = widget.userName;
          log("✅ remoteName onpeerUpdate ${peer.name}");
          if (peer.videoTrack != null) {
            remotePeerVideoTrack = peer.videoTrack;
            log('✅ Remote video track found on join: ${peer.videoTrack?.trackId}');
          }

          if (_timer == null) _startCountdownTimer();
          if (mounted) setState(() {});
        }
        break;
      case HMSPeerUpdate.roleUpdated:
        if (!peer.isLocal && peer.peerId == remotePeer?.peerId) {
          log('✅ Role updated for remote peer: ${peer.role.name}');
          // Check if video track is available after role change
          if (peer.videoTrack != null) {
            remotePeerVideoTrack = peer.videoTrack;
            log('✅ Remote video track after role change: ${peer.videoTrack?.trackId}');
          }
          if (mounted) setState(() {});
        }
        break;
      case HMSPeerUpdate.peerLeft:
        if (!peer.isLocal) {
          remotePeer = null;
          remotePeerVideoTrack = null;
          remoteName.value = "Waiting...";
          callStatus.value = "Disconnected";
          _timer?.cancel();
          remainingTime.value = _initialDuration;
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
    log('Track Update - Track: ${track.trackId}, Kind: ${track.kind}, Update: $trackUpdate, Peer: ${peer.name}');

    if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
      if (peer.isLocal) {
        localPeerVideoTrack = track as HMSVideoTrack;
        isVideoOn.value = !localPeerVideoTrack!.isMute;
        log('Local video track updated: ${track.trackId}, muted: ${track.isMute}');
      } else {
        // Handle remote video track updates
        switch (trackUpdate) {
          case HMSTrackUpdate.trackAdded:
            remotePeerVideoTrack = track as HMSVideoTrack;
            log('✅ Remote video track ADDED: ${track.trackId}');
            break;
          case HMSTrackUpdate.trackRemoved:
            remotePeerVideoTrack = null;
            leaveMeeting();
            log('❌ Remote video track REMOVED: ${track.trackId}');
            break;
          case HMSTrackUpdate.trackMuted:
            log('🔇 Remote video track MUTED: ${track.trackId}');
            break;
          case HMSTrackUpdate.trackUnMuted:
            remotePeerVideoTrack = track as HMSVideoTrack;
            log('🔊 Remote video track UNMUTED: ${track.trackId}');
            break;
          default:
            log('Other video track update: $trackUpdate');
        }
      }
      if (mounted) setState(() {});
    } else if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
      if (peer.isLocal) {
        isMicMuted.value = track.isMute;
        log('Local audio track updated: ${track.trackId}, muted: ${track.isMute}');
      } else {
        switch (trackUpdate) {
          case HMSTrackUpdate.trackAdded:
            log('✅ Remote audio track ADDED: ${track.trackId}');
            break;
          case HMSTrackUpdate.trackRemoved:
            log('❌ Remote audio track REMOVED: ${track.trackId}');
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
  void onChangeTrackStateRequest({
    required HMSTrackChangeRequest hmsTrackChangeRequest,
  }) {}
  @override
  void onHMSError({required HMSException error}) {
    callStatus.value = "Error";
  }

  @override
  void onMessage({required HMSMessage message}) {
    log('chat msg is ${message.message}');
  }

  @override
  void onReconnected() {
    log('onReconnected');
    callStatus.value = "Connected";
    connectionQuality.value = 4;
  }

  @override
  void onReconnecting() {
    log('onReconnecting');
    callStatus.value = "Reconnecting";
    connectionQuality.value = 2;
  }

  @override
  void onRemovedFromRoom({
    required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer,
  }) {}
  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {}
  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {}
  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {}
  @override
  void onPeerListUpdate({
    required List<HMSPeer> addedPeers,
    required List<HMSPeer> removedPeers,
  }) {}

  Widget _buildVideoTile(
    HMSVideoTrack? videoTrack,
    HMSPeer? peer,
    bool isLocal,
  ) {
    if (videoTrack == null || peer == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: VideoLoadingIndicator(),
        ),
      );
    }

    return HMSVideoView(track: videoTrack, setMirror: isLocal);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Main remote video (full screen)
            _buildVideoTile(remotePeerVideoTrack, remotePeer, false),

            // Draggable local video (PIP)
            if (_isLocalVideoVisible && localPeerVideoTrack != null)
              Positioned(
                left: _localVideoPosition.dx,
                top: _localVideoPosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      final screenSize = MediaQuery.of(context).size;
                      const videoWidth = 120.0;
                      const videoHeight = 160.0;

                      // Update new position
                      double newX = _localVideoPosition.dx + details.delta.dx;
                      double newY = _localVideoPosition.dy + details.delta.dy;

                      // Clamp to screen bounds
                      newX = newX.clamp(0.0, screenSize.width - videoWidth);
                      newY =
                          newY.clamp(0.0, screenSize.height - videoHeight - 80);
                      // subtract 80 to avoid going under bottom controls

                      _localVideoPosition = Offset(newX, newY);
                    });
                  },
                  child: Container(
                    width: 120,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _buildVideoTile(
                        localPeerVideoTrack,
                        localPeer,
                        true,
                      ),
                    ),
                  ),
                ),
              ),

            // Bottom control buttons
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Mic Button
                    ValueListenableBuilder(
                      valueListenable: isMicMuted,
                      builder: (_, muted, __) {
                        return _buildControlButton(
                          icon: muted ? Icons.mic_off : Icons.mic,
                          color: Colors.white,
                          background: muted
                              ? Colors.red.withOpacity(0.7)
                              : Colors.blueGrey,
                          onPressed: _toggleMicMute,
                        );
                      },
                    ),

                    // Video Button
                    ValueListenableBuilder(
                      valueListenable: isVideoOn,
                      builder: (_, videoOn, __) {
                        return _buildControlButton(
                          icon: videoOn ? Icons.videocam : Icons.videocam_off,
                          color: Colors.white,
                          background: videoOn ? Colors.blueGrey : Colors.red,
                          onPressed: _toggleVideo,
                        );
                      },
                    ),

                    // End Call Button (highlighted)
                    _buildControlButton(
                      icon: Icons.call_end,
                      color: Colors.white,
                      background: Colors.red,
                      size: 60,
                      onPressed: leaveMeeting,
                    ),

                    // Speaker Button
                    ValueListenableBuilder(
                      valueListenable: isSpeakerOn,
                      builder: (_, speakerOn, __) {
                        return _buildControlButton(
                          icon: speakerOn ? Icons.volume_up : Icons.volume_off,
                          color: Colors.white,
                          background: speakerOn ? Colors.blueGrey : Colors.red,
                          onPressed: _toggleSpeaker,
                        );
                      },
                    ),

                    // Camera Switch Button
                    _buildControlButton(
                      icon: Icons.cameraswitch,
                      color: Colors.white,
                      background: Colors.blueGrey,
                      onPressed: _switchCamera,
                    ),
                  ],
                ),
              ),
            ),

            // Status indicators
            Positioned(
              bottom: 100,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder(
                    valueListenable: isMicMuted,
                    builder: (_, muted, __) {
                      return muted
                          ? const Row(
                              children: [
                                Icon(
                                  Icons.mic_off,
                                  color: Colors.red,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Mic off',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )
                          : const SizedBox();
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: isVideoOn,
                    builder: (_, videoOn, __) {
                      return !videoOn
                          ? const Row(
                              children: [
                                Icon(
                                  Icons.videocam_off,
                                  color: Colors.red,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Video off',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )
                          : const SizedBox();
                    },
                  ),
                ],
              ),
            ),

            // Top info bar
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 20,
              right: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.2), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side: Remote user info
                    Expanded(
                      child: Row(
                        children: [
                          // User avatar
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1.5),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  widget.profile,
                                ),
                                fit: BoxFit.cover,
                                onError: (error, stackTrace) {},
                              ),
                            ),
                            child: widget.profile.isEmpty
                                ? Icon(Icons.person,
                                    color: Colors.white.withOpacity(0.7),
                                    size: 20)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          // Name and status
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ValueListenableBuilder(
                                  valueListenable: remoteName,
                                  builder: (_, name, __) {
                                    return Text(
                                      name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  },
                                ),
                                const SizedBox(height: 2),
                                ValueListenableBuilder(
                                  valueListenable: callStatus,
                                  builder: (_, status, __) {
                                    return Text(
                                      status,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Right side: Timer and connection indicator
                    Row(
                      children: [
                        // Connection indicator
                        ValueListenableBuilder(
                          valueListenable: connectionQuality,
                          builder: (_, quality, __) {
                            return Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getConnectionColor(quality),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.wifi,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _getConnectionText(quality),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        // Timer with pulsating effect for low time
                        ValueListenableBuilder(
                          valueListenable: remainingTime,
                          builder: (_, duration, __) {
                            final isCritical = duration.inSeconds <= 60;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isCritical
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isCritical
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.3),
                                  width: isCritical ? 1.5 : 1,
                                ),
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                child: Text(
                                  _formatDuration(duration),
                                  style: TextStyle(
                                    color:
                                        isCritical ? Colors.red : Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable button widget
  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required Color background,
    required VoidCallback onPressed,
    double size = 50,
  }) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: background,
      child: IconButton(
        icon: Icon(icon, color: color, size: 28),
        onPressed: onPressed,
      ),
    );
  }

  // ADD THIS METHOD
  void changePeerToVideoOrModerator(HMSPeer peer) async {
    try {
      final List<HMSRole> roles = await hmsSDK.getRoles();
      for (var role in roles) {
        print('''
                🔹 Role: ${role.name}
                 canPublish: ${role.publishSettings?.allowed}
                 priority: ${role.priority}

      ''');
      }
      // Safely get roles (returns null if not found)
      final HMSRole? moderatorRole =
          roles.firstWhereOrNull((role) => role.name == "moderator");

      final HMSRole? targetRole = moderatorRole;

      if (targetRole != null) {
        await hmsSDK.changeRoleOfPeer(
          forPeer: peer,
          toRole: targetRole,
          force: false,
        );
        log('✅ Changed ${peer.name} from ${peer.role.name} to ${targetRole.name} role');
      } else {
        log("❌ Neither video nor moderator role found");
      }
    } catch (e) {
      log('❌ Error changing role: $e');
    }
  }
}
