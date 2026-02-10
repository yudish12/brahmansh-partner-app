// ignore_for_file: file_names

import 'dart:convert';

ProductModelScreen productModelScreenFromJson(String str) =>
    ProductModelScreen.fromJson(json.decode(str));

String productModelScreenToJson(ProductModelScreen data) =>
    json.encode(data.toJson());

class ProductModelScreen {
  List<ProdcutDataList>? recordList;
  int? status;
  int? totalRecords;

  ProductModelScreen({
    this.recordList,
    this.status,
    this.totalRecords,
  });

  factory ProductModelScreen.fromJson(Map<String, dynamic> json) =>
      ProductModelScreen(
        recordList: json["recordList"] == null
            ? []
            : List<ProdcutDataList>.from(
                json["recordList"]!.map((x) => ProdcutDataList.fromJson(x))),
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

class ProdcutDataList {
  int? id;
  String? name;
  String? features;
  String? productImage;
  int? productCategoryId;
  dynamic amount;
  dynamic description;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? createdBy;
  int? modifiedBy;

  ProdcutDataList({
    this.id,
    this.name,
    this.features,
    this.productImage,
    this.productCategoryId,
    this.amount,
    this.description,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.modifiedBy,
  });

  factory ProdcutDataList.fromJson(Map<String, dynamic> json) =>
      ProdcutDataList(
        id: json["id"],
        name: json["name"],
        features: json["features"],
        productImage: json["productImage"],
        productCategoryId: json["productCategoryId"],
        amount: json["amount"],
        description: json["description"],
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "features": features,
        "productImage": productImage,
        "productCategoryId": productCategoryId,
        "amount": amount,
        "description": description,
        "isActive": isActive,
        "isDelete": isDelete,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
      };
}
