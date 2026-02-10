class Callsessions {
  final String sessionId;
  final int astrologerId;
  final String astrologerName;
  final String astrologerProfile;
  final String token;
  final String callChannel;
  final String callId;
  final bool isfromnotification;
  final String duration;
  final dynamic savedAt;


  Callsessions({
    required this.sessionId,
    required this.astrologerId,
    required this.astrologerName,
    required this.astrologerProfile,
    required this.token,
    required this.callChannel,
    required this.callId,
    required this.isfromnotification,
    required this.duration,
    required this.savedAt,
  });
}
