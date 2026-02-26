class ChatSession {
  final String sessionId;
  final int customerId;
  final int astrologerId;
  final String? fireBasechatId;
  final String? customerName;
  final String? customerProfile;
  final dynamic chatduration;
  final dynamic astrouserID;
  final dynamic subscriptionId;
  final dynamic userFcm;
  final String? lastSaved;
  /// End time in milliseconds since epoch. Used to hide/end chat when expired.
  final int? chatEndedAt;

  ChatSession({
    required this.sessionId,
    required this.customerId,
    required this.astrologerId,
    required this.fireBasechatId,
    this.customerName,
    this.customerProfile,
    required this.chatduration,
    required this.astrouserID,
    required this.subscriptionId,
    required this.userFcm,
    this.lastSaved,
    this.chatEndedAt,
  });

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'customerId': customerId,
        'astrologerId': astrologerId,
        'fireBasechatId': fireBasechatId,
        'customerName': customerName,
        'customerProfile': customerProfile,
        'chatduration': chatduration,
        'astrouserID': astrouserID,
        'subscriptionId': subscriptionId,
        'userFcm': userFcm,
        "lastSaved": lastSaved ?? DateTime.now().toIso8601String(),
        'chatEndedAt': chatEndedAt,
      };

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
        sessionId: json['sessionId'],
        customerId: json['customerId'],
        astrologerId: json['astrologerId'],
        fireBasechatId: json['fireBasechatId'],
        customerName: json['customerName'] ?? "",
        customerProfile: json['customerProfile'] ?? "",
        chatduration: json['chatduration'],
        astrouserID: json['astrouserID'],
        subscriptionId: json['subscriptionId'],
        userFcm: json['userFcm'],
        lastSaved: json["lastSaved"]?.toString(),
        chatEndedAt: json['chatEndedAt'] != null
            ? (json['chatEndedAt'] is int
                ? json['chatEndedAt'] as int
                : int.tryParse(json['chatEndedAt'].toString()))
            : null,
      );
}