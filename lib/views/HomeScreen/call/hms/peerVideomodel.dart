import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PeerVideoTrack {
  final String peerId;
  final String? peerName;
  final HMSVideoTrack? videoTrack; // Made nullable for audio-only
  final String roleName;
  final bool isAudioOnly;

  PeerVideoTrack({
    required this.peerId,
    required this.peerName,
    this.videoTrack,
    required this.roleName,
    this.isAudioOnly = false,
  });
}

