// To parse this JSON data, do
//
//     final poojaListModel = poojaListModelFromJson(jsonString);

import 'dart:convert';

PoojaListModel poojaListModelFromJson(String str) =>
    PoojaListModel.fromJson(json.decode(str));

String poojaListModelToJson(PoojaListModel data) => json.encode(data.toJson());

class PoojaListModel {
  List<PoojaList>? recordList;
  int? status;

  PoojaListModel({
    this.recordList,
    this.status,
  });

  factory PoojaListModel.fromJson(Map<String, dynamic> json) => PoojaListModel(
        recordList: json["recordList"] == null
            ? []
            : List<PoojaList>.from(
                json["recordList"]!.map((x) => PoojaList.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "recordList": recordList == null
            ? []
            : List<dynamic>.from(recordList!.map((x) => x.toJson())),
        "status": status,
      };
}

class PoojaList {
  int? id;
  int? categoryId;
  String? pujaTitle;
  String? pujaSubtitle;
  String? pujaPlace;
  String? longDescription;
  List<PujaBenefit>? pujaBenefits;
  List<String>? pujaImages;
  DateTime? pujaStartDatetime;
  DateTime? pujaEndDatetime;
  List<String>? packageId;
  int? pujaStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Package>? packages;

  PoojaList({
    this.id,
    this.categoryId,
    this.pujaTitle,
    this.pujaSubtitle,
    this.pujaPlace,
    this.longDescription,
    this.pujaBenefits,
    this.pujaImages,
    this.pujaStartDatetime,
    this.pujaEndDatetime,
    this.packageId,
    this.pujaStatus,
    this.createdAt,
    this.updatedAt,
    this.packages,
  });

  factory PoojaList.fromJson(Map<String, dynamic> json) => PoojaList(
        id: json["id"],
        categoryId: json["category_id"],
        pujaTitle: json["puja_title"],
        pujaSubtitle: json["puja_subtitle"],
        pujaPlace: json["puja_place"],
        longDescription: json["long_description"],
        pujaBenefits: json["puja_benefits"] == null
            ? []
            : List<PujaBenefit>.from(
                json["puja_benefits"]!.map((x) => PujaBenefit.fromJson(x))),
        pujaImages: json["puja_images"] == null
            ? []
            : List<String>.from(json["puja_images"]!.map((x) => x)),
        pujaStartDatetime: json["puja_start_datetime"] == null
            ? null
            : DateTime.parse(json["puja_start_datetime"]),
        pujaEndDatetime: json["puja_end_datetime"] == null
            ? null
            : DateTime.parse(json["puja_end_datetime"]),
        packageId: json["package_id"] == null
            ? []
            : List<String>.from(json["package_id"]!.map((x) => x)),
        pujaStatus: json["puja_status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        packages: json["packages"] == null
            ? []
            : List<Package>.from(
                json["packages"]!.map((x) => Package.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "puja_title": pujaTitle,
        "puja_subtitle": pujaSubtitle,
        "puja_place": pujaPlace,
        "long_description": longDescription,
        "puja_benefits": pujaBenefits == null
            ? []
            : List<dynamic>.from(pujaBenefits!.map((x) => x.toJson())),
        "puja_images": pujaImages == null
            ? []
            : List<dynamic>.from(pujaImages!.map((x) => x)),
        "puja_start_datetime": pujaStartDatetime?.toIso8601String(),
        "puja_end_datetime": pujaEndDatetime?.toIso8601String(),
        "package_id": packageId == null
            ? []
            : List<dynamic>.from(packageId!.map((x) => x)),
        "puja_status": pujaStatus,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "packages": packages == null
            ? []
            : List<dynamic>.from(packages!.map((x) => x.toJson())),
      };
}

class Package {
  int? id;
  String? title;
  String? person;
  dynamic packagePrice;
  List<String>? description;
  int? packageStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  Package({
    this.id,
    this.title,
    this.person,
    this.packagePrice,
    this.description,
    this.packageStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        id: json["id"],
        title: json["title"],
        person: json["person"],
        packagePrice: json["package_price"],
        description: json["description"] == null
            ? []
            : List<String>.from(json["description"]!.map((x) => x)),
        packageStatus: json["package_status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "person": person,
        "package_price": packagePrice,
        "description": description == null
            ? []
            : List<dynamic>.from(description!.map((x) => x)),
        "package_status": packageStatus,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class PujaBenefit {
  String? title;
  String? description;

  PujaBenefit({
    this.title,
    this.description,
  });

  factory PujaBenefit.fromJson(Map<String, dynamic> json) => PujaBenefit(
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
      };
}
