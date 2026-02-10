// To parse this JSON data, do
//
//     final getPdfPrice = getPdfPriceFromJson(jsonString);

import 'dart:convert';

GetPdfPrice getPdfPriceFromJson(String str) =>
    GetPdfPrice.fromJson(json.decode(str));

String getPdfPriceToJson(GetPdfPrice data) => json.encode(data.toJson());

class GetPdfPrice {
  List<RecordList>? recordList;
  bool? isFreeSession;
  int? status;

  GetPdfPrice({
    this.recordList,
    this.isFreeSession,
    this.status,
  });

  factory GetPdfPrice.fromJson(Map<String, dynamic> json) => GetPdfPrice(
        recordList: json["recordList"] == null
            ? []
            : List<RecordList>.from(
                json["recordList"]!.map((x) => RecordList.fromJson(x))),
        isFreeSession: json["isFreeSession"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "recordList": recordList == null
            ? []
            : List<dynamic>.from(recordList!.map((x) => x.toJson())),
        "isFreeSession": isFreeSession,
        "status": status,
      };
}

class RecordList {
  int? id;
  int? price;
  int? priceUsd;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;

  RecordList({
    this.id,
    this.price,
    this.priceUsd,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory RecordList.fromJson(Map<String, dynamic> json) => RecordList(
        id: json["id"],
        price: json["price"],
        priceUsd: json["price_usd"],
        type: json["type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "price_usd": priceUsd,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
