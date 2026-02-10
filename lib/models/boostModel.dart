// To parse this JSON data, do
//
//     final getBoostModel = getBoostModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

GetBoostModel getBoostModelFromJson(String str) => GetBoostModel.fromJson(json.decode(str));

String getBoostModelToJson(GetBoostModel data) => json.encode(data.toJson());

class GetBoostModel {
  BoostData? recordList;
  int? status;

  GetBoostModel({
    this.recordList,
    this.status,
  });

  factory GetBoostModel.fromJson(Map<String, dynamic> json) => GetBoostModel(
    recordList: json["recordList"] == null ? null : BoostData.fromJson(json["recordList"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "recordList": recordList?.toJson(),
    "status": status,
  };
}

class BoostData {
  int? id;
  int? chatCommission;
  int? callCommission;
  int? videoCallCommission;
  List<String>? profileBoostBenefits;
  int? profileBoost;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? remainingBoost;

  BoostData({
    this.id,
    this.chatCommission,
    this.callCommission,
    this.videoCallCommission,
    this.profileBoostBenefits,
    this.profileBoost,
    this.createdAt,
    this.updatedAt,
    this.remainingBoost,
  });

  factory BoostData.fromJson(Map<String, dynamic> json) => BoostData(
    id: json["id"],
    chatCommission: json["chat_commission"],
    callCommission: json["call_commission"],
    videoCallCommission: json["video_call_commission"],
    profileBoostBenefits: json["profile_boost_benefits"] == null ? [] : List<String>.from(json["profile_boost_benefits"]!.map((x) => x)),
    profileBoost: json["profile_boost"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    remainingBoost: json["remaining_boost"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "chat_commission": chatCommission,
    "call_commission": callCommission,
    "video_call_commission": videoCallCommission,
    "profile_boost_benefits": profileBoostBenefits == null ? [] : List<dynamic>.from(profileBoostBenefits!.map((x) => x)),
    "profile_boost": profileBoost,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "remaining_boost": remainingBoost,
  };
}
