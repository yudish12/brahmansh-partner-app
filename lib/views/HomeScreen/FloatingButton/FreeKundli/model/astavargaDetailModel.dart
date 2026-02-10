// To parse this JSON data, do
//
//     final astavargaDetailModel = astavargaDetailModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

AstavargaDetailModel astavargaDetailModelFromJson(String str) =>
    AstavargaDetailModel.fromJson(json.decode(str));

String astavargaDetailModelToJson(AstavargaDetailModel data) =>
    json.encode(data.toJson());

class AstavargaDetailModel {
  String? message;
  Ashtakvarga? ashtakvarga;
  Binnashtakvarga? binnashtakvarga;
  int? status;

  AstavargaDetailModel({
    this.message,
    this.ashtakvarga,
    this.binnashtakvarga,
    this.status,
  });

  factory AstavargaDetailModel.fromJson(Map<String, dynamic> json) =>
      AstavargaDetailModel(
        message: json["message"],
        ashtakvarga: json["ashtakvarga"] == null
            ? null
            : Ashtakvarga.fromJson(json["ashtakvarga"]),
        binnashtakvarga: json["binnashtakvarga"] == null
            ? null
            : Binnashtakvarga.fromJson(json["binnashtakvarga"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "ashtakvarga": ashtakvarga?.toJson(),
        "binnashtakvarga": binnashtakvarga?.toJson(),
        "status": status,
      };
}

class Ashtakvarga {
  int? status;
  AshtakvargaResponse? response;

  Ashtakvarga({
    this.status,
    this.response,
  });

  factory Ashtakvarga.fromJson(Map<String, dynamic> json) => Ashtakvarga(
        status: json["status"],
        response: json["response"] == null
            ? null
            : AshtakvargaResponse.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response?.toJson(),
      };
}

class AshtakvargaResponse {
  List<String>? ashtakvargaOrder;
  List<List<int>>? ashtakvargaPoints;
  List<int>? ashtakvargaTotal;

  AshtakvargaResponse({
    this.ashtakvargaOrder,
    this.ashtakvargaPoints,
    this.ashtakvargaTotal,
  });

  factory AshtakvargaResponse.fromJson(Map<String, dynamic> json) =>
      AshtakvargaResponse(
        ashtakvargaOrder: json["ashtakvarga_order"] == null
            ? []
            : List<String>.from(json["ashtakvarga_order"]!.map((x) => x)),
        ashtakvargaPoints: json["ashtakvarga_points"] == null
            ? []
            : List<List<int>>.from(json["ashtakvarga_points"]!
                .map((x) => List<int>.from(x.map((x) => x)))),
        ashtakvargaTotal: json["ashtakvarga_total"] == null
            ? []
            : List<int>.from(json["ashtakvarga_total"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "ashtakvarga_order": ashtakvargaOrder == null
            ? []
            : List<dynamic>.from(ashtakvargaOrder!.map((x) => x)),
        "ashtakvarga_points": ashtakvargaPoints == null
            ? []
            : List<dynamic>.from(ashtakvargaPoints!
                .map((x) => List<dynamic>.from(x.map((x) => x)))),
        "ashtakvarga_total": ashtakvargaTotal == null
            ? []
            : List<dynamic>.from(ashtakvargaTotal!.map((x) => x)),
      };
}

class Binnashtakvarga {
  int? status;
  BinnashtakvargaResponse? response;

  Binnashtakvarga({
    this.status,
    this.response,
  });

  factory Binnashtakvarga.fromJson(Map<String, dynamic> json) =>
      Binnashtakvarga(
        status: json["status"],
        response: json["response"] == null
            ? null
            : BinnashtakvargaResponse.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response?.toJson(),
      };
}

class BinnashtakvargaResponse {
  List<int>? ascendant;
  List<int>? sun;
  List<int>? moon;
  List<int>? mars;
  List<int>? mercury;
  List<int>? jupiter;
  List<int>? saturn;
  List<int>? venus;

  BinnashtakvargaResponse({
    this.ascendant,
    this.sun,
    this.moon,
    this.mars,
    this.mercury,
    this.jupiter,
    this.saturn,
    this.venus,
  });

  factory BinnashtakvargaResponse.fromJson(Map<String, dynamic> json) =>
      BinnashtakvargaResponse(
        ascendant: json["Ascendant"] == null
            ? []
            : List<int>.from(json["Ascendant"]!.map((x) => x)),
        sun: json["Sun"] == null
            ? []
            : List<int>.from(json["Sun"]!.map((x) => x)),
        moon: json["Moon"] == null
            ? []
            : List<int>.from(json["Moon"]!.map((x) => x)),
        mars: json["Mars"] == null
            ? []
            : List<int>.from(json["Mars"]!.map((x) => x)),
        mercury: json["Mercury"] == null
            ? []
            : List<int>.from(json["Mercury"]!.map((x) => x)),
        jupiter: json["Jupiter"] == null
            ? []
            : List<int>.from(json["Jupiter"]!.map((x) => x)),
        saturn: json["Saturn"] == null
            ? []
            : List<int>.from(json["Saturn"]!.map((x) => x)),
        venus: json["Venus"] == null
            ? []
            : List<int>.from(json["Venus"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Ascendant": ascendant == null
            ? []
            : List<dynamic>.from(ascendant!.map((x) => x)),
        "Sun": sun == null ? [] : List<dynamic>.from(sun!.map((x) => x)),
        "Moon": moon == null ? [] : List<dynamic>.from(moon!.map((x) => x)),
        "Mars": mars == null ? [] : List<dynamic>.from(mars!.map((x) => x)),
        "Mercury":
            mercury == null ? [] : List<dynamic>.from(mercury!.map((x) => x)),
        "Jupiter":
            jupiter == null ? [] : List<dynamic>.from(jupiter!.map((x) => x)),
        "Saturn":
            saturn == null ? [] : List<dynamic>.from(saturn!.map((x) => x)),
        "Venus": venus == null ? [] : List<dynamic>.from(venus!.map((x) => x)),
      };
}
