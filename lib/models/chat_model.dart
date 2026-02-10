// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

class ChatModel {
  List<ChatRequest>? chatRequest;
  List<Keyword>? keywords;

  ChatModel({
    this.chatRequest,
    this.keywords,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        chatRequest: json["chatRequest"] == null
            ? []
            : List<ChatRequest>.from(
                json["chatRequest"]!.map((x) => ChatRequest.fromJson(x))),
        keywords: json["keywords"] == null
            ? []
            : List<Keyword>.from(
                json["keywords"]!.map((x) => Keyword.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "chatRequest": chatRequest == null
            ? []
            : List<dynamic>.from(chatRequest!.map((x) => x.toJson())),
        "keywords": keywords == null
            ? []
            : List<dynamic>.from(keywords!.map((x) => x.toJson())),
      };
}

class ChatRequest {
  dynamic subscriptionid;
  int? id;
  String? name;
  String? contactNo;
  String? email;
  dynamic password;
  DateTime? birthDate;
  String? birthTime;
  dynamic profile;
  String? birthPlace;
  String? addressLine1;
  dynamic addressLine2;
  String? country;
  String? location;
  int? pincode;
  String? gender;
  String? referralToken;
  int? referrerId;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic chatRequestFcmToken;
  dynamic token;
  dynamic expirationDate;
  String? countryCode;
  dynamic deletedAt;
  int? chatId;
  dynamic senderId;
  String? fcmToken;
  String? chatDuration;
  DateTime? chatcreatedat;
  int? astrologerId;
  int? userId;
  dynamic astroUserId;

  ChatRequest({
    this.id,
    this.name,
    this.contactNo,
    this.email,
    this.password,
    this.birthDate,
    this.birthTime,
    this.profile,
    this.birthPlace,
    this.addressLine1,
    this.addressLine2,
    this.country,
    this.location,
    this.pincode,
    this.gender,
    this.referralToken,
    this.referrerId,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.chatRequestFcmToken,
    this.token,
    this.expirationDate,
    this.countryCode,
    this.deletedAt,
    this.chatId,
    this.senderId,
    this.fcmToken,
    this.chatDuration,
    this.chatcreatedat,
    this.astrologerId,
    this.userId,
    this.astroUserId,
    this.subscriptionid,
  });

  factory ChatRequest.fromJson(Map<String, dynamic> json) => ChatRequest(
        subscriptionid: json["subscription_id"],
        id: json["id"],
        name: json["name"],
        contactNo: json["contactNo"],
        email: json["email"],
        password: json["password"],
        birthDate: json["birthDate"] == null
            ? null
            : DateTime.parse(json["birthDate"]),
        birthTime: json["birthTime"],
        profile: json["profile"],
        birthPlace: json["birthPlace"],
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        country: json["country"],
        location: json["location"],
        pincode: json["pincode"],
        gender: json["gender"],
        referralToken: json["referral_token"],
        referrerId: json["referrer_id"],
        isActive: json["isActive"],
        isDelete: json["isDelete"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        chatRequestFcmToken: json["fcm_token"],
        token: json["token"],
        expirationDate: json["expirationDate"],
        countryCode: json["countryCode"],
        deletedAt: json["deleted_at"],
        chatId: json["chatId"],
        senderId: json["senderId"],
        fcmToken: json["fcmToken"],
        chatDuration: json["chat_duration"],
        chatcreatedat: json["chatcreatedat"] == null
            ? null
            : DateTime.parse(json["chatcreatedat"]),
        astrologerId: json["astrologerId"],
        userId: json["userId"],
        astroUserId: json["astroUserId"],
      );

  Map<String, dynamic> toJson() => {
        "subscription_id": subscriptionid,
        "id": id,
        "name": name,
        "contactNo": contactNo,
        "email": email,
        "password": password,
        "birthDate": birthDate?.toIso8601String(),
        "birthTime": birthTime,
        "profile": profile,
        "birthPlace": birthPlace,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "country": country,
        "location": location,
        "pincode": pincode,
        "gender": gender,
        "referral_token": referralToken,
        "referrer_id": referrerId,
        "isActive": isActive,
        "isDelete": isDelete,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "fcm_token": chatRequestFcmToken,
        "token": token,
        "expirationDate": expirationDate,
        "countryCode": countryCode,
        "deleted_at": deletedAt,
        "chatId": chatId,
        "senderId": senderId,
        "fcmToken": fcmToken,
        "chat_duration": chatDuration,
        "chatcreatedat": chatcreatedat?.toIso8601String(),
        "astrologerId": astrologerId,
        "userId": userId,
        "astroUserId": astroUserId,
      };
}

class Keyword {
  String? type;
  String? pattern;

  Keyword({
    this.type,
    this.pattern,
  });

  factory Keyword.fromJson(Map<String, dynamic> json) => Keyword(
        type: json["type"],
        pattern: json["pattern"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "pattern": pattern,
      };
}
