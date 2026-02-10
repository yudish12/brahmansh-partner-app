class AstrologerTicketsModel {
  List<AstrologerTickets>? recordList;
  int? status;
  int? totalRecords;

  AstrologerTicketsModel({
    this.recordList,
    this.status,
    this.totalRecords,
  });

  factory AstrologerTicketsModel.fromJson(Map<String, dynamic> json) =>
      AstrologerTicketsModel(
        recordList: json["recordList"] == null
            ? []
            : List<AstrologerTickets>.from(
                json["recordList"]!.map((x) => AstrologerTickets.fromJson(x))),
        status: json["status"],
        totalRecords: json["totalRecords"],
      );

  Map<String, dynamic> toJson() => {
        "recordList": recordList == null
            ? []
            : List<dynamic>.from(recordList!.map((x) => x.toJson())),
        "status": status,
        "totalRecords": totalRecords,
      };
}

class AstrologerTickets {
  int? id;
  dynamic helpSupportId;
  String? subject;
  String? description;
  String? ticketNumber;
  int? userId;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? createdBy;
  int? modifiedBy;
  String? chatId;
  String? ticketStatus;
  String? senderType;
  String? userName;

  AstrologerTickets({
    this.id,
    this.helpSupportId,
    this.subject,
    this.description,
    this.ticketNumber,
    this.userId,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.modifiedBy,
    this.chatId,
    this.ticketStatus,
    this.senderType,
    this.userName,
  });

  factory AstrologerTickets.fromJson(Map<String, dynamic> json) =>
      AstrologerTickets(
        id: json["id"],
        helpSupportId: json["helpSupportId"],
        subject: json["subject"],
        description: json["description"],
        ticketNumber: json["ticketNumber"],
        userId: json["userId"],
        isActive: json["isActive"],
        isDelete: json["isDelete"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        chatId: json["chatId"],
        ticketStatus: json["ticketStatus"],
        senderType: json["sender_type"],
        userName: json["userName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "helpSupportId": helpSupportId,
        "subject": subject,
        "description": description,
        "ticketNumber": ticketNumber,
        "userId": userId,
        "isActive": isActive,
        "isDelete": isDelete,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "chatId": chatId,
        "ticketStatus": ticketStatus,
        "sender_type": senderType,
        "userName": userName,
      };
}
