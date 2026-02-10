// To parse this JSON data, do
//
//     final documetModel = documetModelFromJson(jsonString);

import 'dart:convert';

DocumetModel documetModelFromJson(String str) => DocumetModel.fromJson(json.decode(str));

String documetModelToJson(DocumetModel data) => json.encode(data.toJson());

class DocumetModel {
    List<DocList>? recordList;
    int? status;

    DocumetModel({
        this.recordList,
        this.status,
    });

    factory DocumetModel.fromJson(Map<String, dynamic> json) => DocumetModel(
        recordList: json["recordList"] == null ? [] : List<DocList>.from(json["recordList"]!.map((x) => DocList.fromJson(x))),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "recordList": recordList == null ? [] : List<dynamic>.from(recordList!.map((x) => x.toJson())),
        "status": status,
    };
}

class DocList {
    int? id;
    String? name;
    String? type;
    DateTime? createdAt;
    DateTime? updatedAt;

    DocList({
        this.id,
        this.name,
        this.type,
        this.createdAt,
        this.updatedAt,
    });

    factory DocList.fromJson(Map<String, dynamic> json) => DocList(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
