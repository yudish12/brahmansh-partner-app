// ignore_for_file: non_constant_identifier_names, prefer_null_aware_operators

class CallModel {
  CallModel({
    required this.id,
    required this.name,
    this.contactNo,
    this.email,
    this.password,
    this.birthDate,
    this.birthTime,
    this.profile,
    this.birthPlace,
    this.addressLine1,
    this.addressLine2,
    this.location,
    this.pincode,
    this.gender,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.recordListFcmToken,
    this.token,
    this.expirationDate,
    this.countryCode,
    this.deletedAt,
    required this.callId,
    this.callType,
    this.callDuration,
    this.fcmToken,
    this.call_method,
    this.IsSchedule,
    this.scheduleDatetime,
    this.channelname
  });
  String? channelname;

  int id;
  String? name;
  String? contactNo;
  dynamic email;
  String? password;
  DateTime? birthDate;
  dynamic birthTime;
  String? profile;
  dynamic birthPlace;
  dynamic addressLine1;
  dynamic addressLine2;
  dynamic location;
  dynamic pincode;
  String? gender;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic recordListFcmToken;
  dynamic token;
  dynamic expirationDate;
  dynamic countryCode;
  dynamic deletedAt;
  int callId;
  int? callType;
  String? callDuration;
  String? fcmToken;
  String? call_method;
  dynamic IsSchedule;
  dynamic scheduleDatetime;

  factory CallModel.fromJson(Map<String, dynamic> json) => CallModel(
        channelname:  json["channel_name"],
        id: json["id"],
        name: json["name"],
        contactNo: json["contactNo"],
        email: json["email"],
        password: json["password"],
        birthDate: DateTime.parse(
            json["birthDate"] ?? DateTime.now().toIso8601String()),
        birthTime: json["birthTime"] ?? '',
        profile: json["profile"],
        birthPlace: json["birthPlace"],
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        location: json["location"],
        pincode: json["pincode"],
        gender: json["gender"],
        isActive: json["isActive"],
        isDelete: json["isDelete"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        recordListFcmToken: json["fcm_token"],
        token: json["token"],
        expirationDate: json["expirationDate"],
        countryCode: json["countryCode"],
        deletedAt: json["deleted_at"],
        callId: json["callId"],
        callType: json["call_type"],
        callDuration: json["call_duration"],
        fcmToken: json["fcmToken"],
        call_method: json["call_method"],
        IsSchedule: json["IsSchedule"],
        scheduleDatetime: json["schedule_datetime"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "contactNo": contactNo,
        "email": email,
        "password": password,
        "birthDate": birthDate!.toIso8601String(),
        "birthTime": birthTime,
        "profile": profile,
        "birthPlace": birthPlace,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "location": location,
        "pincode": pincode,
        "gender": gender,
        "isActive": isActive,
        "isDelete": isDelete,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "fcm_token": recordListFcmToken,
        "token": token,
        "expirationDate": expirationDate,
        "countryCode": countryCode,
        "deleted_at": deletedAt,
        "callId": callId,
        "call_type": callType,
        "call_duration": callDuration,
        "fcmToken": fcmToken,
        "call_method": call_method,
        "IsSchedule": IsSchedule,
        "schedule_datetime": scheduleDatetime,
        "channel_name" : channelname
      };
}
