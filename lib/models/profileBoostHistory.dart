// To parse this JSON data, do

// ignore_for_file: file_names

import 'dart:convert';

ProfileboostHistory profileboostHistoryFromJson(String str) => ProfileboostHistory.fromJson(json.decode(str));

String profileboostHistoryToJson(ProfileboostHistory data) => json.encode(data.toJson());

class ProfileboostHistory {
  List<ProfileboosthistoryData>? recordList;
  int? status;

  ProfileboostHistory({
    this.recordList,
    this.status,
  });

  factory ProfileboostHistory.fromJson(Map<String, dynamic> json) => ProfileboostHistory(
    recordList: json["recordList"] == null ? [] : List<ProfileboosthistoryData>.from(json["recordList"]!.map((x) => ProfileboosthistoryData.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "recordList": recordList == null ? [] : List<dynamic>.from(recordList!.map((x) => x.toJson())),
    "status": status,
  };
}

class ProfileboosthistoryData {
  int? id;
  int? astrologerId;
  int? chatCommission;
  int? callCommission;
  int? videoCallCommission;
  DateTime? boostedDatetime;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProfileboosthistoryData({
    this.id,
    this.astrologerId,
    this.chatCommission,
    this.callCommission,
    this.videoCallCommission,
    this.boostedDatetime,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileboosthistoryData.fromJson(Map<String, dynamic> json) => ProfileboosthistoryData(
    id: json["id"],
    astrologerId: json["astrologer_id"],
    chatCommission: json["chat_commission"],
    callCommission: json["call_commission"],
    videoCallCommission: json["video_call_commission"],
    boostedDatetime: json["boosted_datetime"] == null ? null : DateTime.parse(json["boosted_datetime"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "astrologer_id": astrologerId,
    "chat_commission": chatCommission,
    "call_commission": callCommission,
    "video_call_commission": videoCallCommission,
    "boosted_datetime": boostedDatetime?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
