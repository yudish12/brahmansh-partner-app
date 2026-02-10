// To parse this JSON data, do
//
//     final imageModel = imageModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

ImageModel imageModelFromJson(String str) =>
    ImageModel.fromJson(json.decode(str));

String imageModelToJson(ImageModel data) => json.encode(data.toJson());

class ImageModel {
  String? message;
  List<RecordList>? recordList;
  int? status;

  ImageModel({
    this.message,
    this.recordList,
    this.status,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        message: json["message"],
        recordList: json["recordList"] == null
            ? []
            : List<RecordList>.from(
                json["recordList"]!.map((x) => RecordList.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "recordList": recordList == null
            ? []
            : List<dynamic>.from(recordList!.map((x) => x.toJson())),
        "status": status,
      };
}

class RecordList {
  String? astrologerId;
  String? media;
  String? mediaType;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? id;

  RecordList({
    this.astrologerId,
    this.media,
    this.mediaType,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  factory RecordList.fromJson(Map<String, dynamic> json) => RecordList(
        astrologerId: json["astrologerId"],
        media: json["media"],
        mediaType: json["mediaType"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "astrologerId": astrologerId,
        "media": media,
        "mediaType": mediaType,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "id": id,
      };
}




// To parse this JSON data, do
//
//     final pujaImageModel = pujaImageModelFromJson(jsonString);


PujaImageModel pujaImageModelFromJson(String str) => PujaImageModel.fromJson(json.decode(str));

String pujaImageModelToJson(PujaImageModel data) => json.encode(data.toJson());

class PujaImageModel {
    String? message;
    RecordList? recordList;
    int? status;

    PujaImageModel({
        this.message,
        this.recordList,
        this.status,
    });

    factory PujaImageModel.fromJson(Map<String, dynamic> json) => PujaImageModel(
        message: json["message"],
        recordList: json["recordList"] == null ? null : RecordList.fromJson(json["recordList"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "recordList": recordList?.toJson(),
        "status": status,
    };
}

class PujaImageListModel {
    String? astrologerId;
    String? pujaTitle;
    String? slug;
    String? pujaPrice;
    String? longDescription;
    DateTime? pujaStartDatetime;
    DateTime? pujaEndDatetime;
    String? pujaPlace;
    List<dynamic>? pujaImages;
    String? createdBy;
    DateTime? updatedAt;
    DateTime? createdAt;
    int? id;

    PujaImageListModel({
        this.astrologerId,
        this.pujaTitle,
        this.slug,
        this.pujaPrice,
        this.longDescription,
        this.pujaStartDatetime,
        this.pujaEndDatetime,
        this.pujaPlace,
        this.pujaImages,
        this.createdBy,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    factory PujaImageListModel.fromJson(Map<String, dynamic> json) => PujaImageListModel(
        astrologerId: json["astrologerId"],
        pujaTitle: json["puja_title"],
        slug: json["slug"],
        pujaPrice: json["puja_price"],
        longDescription: json["long_description"],
        pujaStartDatetime: json["puja_start_datetime"] == null ? null : DateTime.parse(json["puja_start_datetime"]),
        pujaEndDatetime: json["puja_end_datetime"] == null ? null : DateTime.parse(json["puja_end_datetime"]),
        pujaPlace: json["puja_place"],
        pujaImages: json["puja_images"] == null ? [] : List<dynamic>.from(json["puja_images"]!.map((x) => x)),
        createdBy: json["created_by"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "astrologerId": astrologerId,
        "puja_title": pujaTitle,
        "slug": slug,
        "puja_price": pujaPrice,
        "long_description": longDescription,
        "puja_start_datetime": pujaStartDatetime?.toIso8601String(),
        "puja_end_datetime": pujaEndDatetime?.toIso8601String(),
        "puja_place": pujaPlace,
        "puja_images": pujaImages == null ? [] : List<dynamic>.from(pujaImages!.map((x) => x)),
        "created_by": createdBy,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
    };
}
