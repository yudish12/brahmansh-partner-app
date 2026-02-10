class WaitList {
  WaitList({
    required this.userName,
    required this.userFcmToken,
    this.endTime,
    required this.status,
    required this.userProfile,
    required this.requestType,
    required this.userId,
    required this.channel,
    required this.time,
    required this.id,
    this.isOnline = true,
    this.subscriptionId,
  });

  String userName;
  String userProfile;
  String requestType;
  String channel;
  String time;
  int id;
  int userId;
  String userFcmToken;
  String status;
  int? endTime;
  bool isOnline;
  dynamic subscriptionId;

  factory WaitList.fromJson(Map<String, dynamic> json) => WaitList(
        userName: json["userName"] ?? "",
        userProfile: json['profile'] ?? "",
        requestType: json['requestType'] ?? "",
        channel: json['channel'] ?? "",
        time: json['time'] ?? "",
        id: json['id'],
        userId: json['userId'] ?? 0,
        userFcmToken: json['userFcmToken'] ?? "",
        status: json['status'] ?? "Pending",
        subscriptionId: json['subscription_id'] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "profile": userProfile,
        "requestType": requestType,
        "channel": channel,
        "time": time,
        "subscription_id": subscriptionId,
      };
}
