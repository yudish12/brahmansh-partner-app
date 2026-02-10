// To parse this JSON data, do
//
//     final planetReportModel = planetReportModelFromJson(jsonString);

import 'dart:convert';

PlanetReportModel planetReportModelFromJson(String str) =>
    PlanetReportModel.fromJson(json.decode(str));

String planetReportModelToJson(PlanetReportModel data) =>
    json.encode(data.toJson());

class PlanetReportModel {
  String? message;
  PlanetReport? planetReport;
  int? status;

  PlanetReportModel({
    this.message,
    this.planetReport,
    this.status,
  });

  factory PlanetReportModel.fromJson(Map<String, dynamic> json) =>
      PlanetReportModel(
        message: json["message"],
        planetReport: json["planetReport"] == null
            ? null
            : PlanetReport.fromJson(json["planetReport"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "planetReport": planetReport?.toJson(),
        "status": status,
      };
}

class PlanetReport {
  int? status;
  List<Response>? response;

  PlanetReport({
    this.status,
    this.response,
  });

  factory PlanetReport.fromJson(Map<String, dynamic> json) => PlanetReport(
        status: json["status"],
        response: json["response"] == null
            ? []
            : List<Response>.from(
                json["response"]!.map((x) => Response.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response == null
            ? []
            : List<dynamic>.from(response!.map((x) => x.toJson())),
      };
}

class Response {
  String? planetConsidered;
  int? planetLocation;
  int? planetNativeLocation;
  String? planetZodiac;
  String? zodiacLord;
  String? zodiacLordLocation;
  int? zodiacLordHouseLocation;
  String? generalPrediction;
  String? zodiacLordStrength;
  String? planetStrength;
  String? planetDefinitions;
  String? gayatriMantra;
  String? qualitiesLong;
  String? qualitiesShort;
  String? affliction;
  String? personalisedPrediction;
  String? verbalLocation;
  String? planetZodiacPrediction;
  List<String>? characterKeywordsPositive;
  List<String>? characterKeywordsNegative;

  Response({
    this.planetConsidered,
    this.planetLocation,
    this.planetNativeLocation,
    this.planetZodiac,
    this.zodiacLord,
    this.zodiacLordLocation,
    this.zodiacLordHouseLocation,
    this.generalPrediction,
    this.zodiacLordStrength,
    this.planetStrength,
    this.planetDefinitions,
    this.gayatriMantra,
    this.qualitiesLong,
    this.qualitiesShort,
    this.affliction,
    this.personalisedPrediction,
    this.verbalLocation,
    this.planetZodiacPrediction,
    this.characterKeywordsPositive,
    this.characterKeywordsNegative,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        planetConsidered: json["planet_considered"],
        planetLocation: json["planet_location"],
        planetNativeLocation: json["planet_native_location"],
        planetZodiac: json["planet_zodiac"],
        zodiacLord: json["zodiac_lord"],
        zodiacLordLocation: json["zodiac_lord_location"],
        zodiacLordHouseLocation: json["zodiac_lord_house_location"],
        generalPrediction: json["general_prediction"],
        zodiacLordStrength: json["zodiac_lord_strength"],
        planetStrength: json["planet_strength"],
        planetDefinitions: json["planet_definitions"],
        gayatriMantra: json["gayatri_mantra"],
        qualitiesLong: json["qualities_long"],
        qualitiesShort: json["qualities_short"],
        affliction: json["affliction"],
        personalisedPrediction: json["personalised_prediction"],
        verbalLocation: json["verbal_location"],
        planetZodiacPrediction: json["planet_zodiac_prediction"],
        characterKeywordsPositive: json["character_keywords_positive"] == null
            ? []
            : List<String>.from(
                json["character_keywords_positive"]!.map((x) => x)),
        characterKeywordsNegative: json["character_keywords_negative"] == null
            ? []
            : List<String>.from(
                json["character_keywords_negative"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "planet_considered": planetConsidered,
        "planet_location": planetLocation,
        "planet_native_location": planetNativeLocation,
        "planet_zodiac": planetZodiac,
        "zodiac_lord": zodiacLord,
        "zodiac_lord_location": zodiacLordLocation,
        "zodiac_lord_house_location": zodiacLordHouseLocation,
        "general_prediction": generalPrediction,
        "zodiac_lord_strength": zodiacLordStrength,
        "planet_strength": planetStrength,
        "planet_definitions": planetDefinitions,
        "gayatri_mantra": gayatriMantra,
        "qualities_long": qualitiesLong,
        "qualities_short": qualitiesShort,
        "affliction": affliction,
        "personalised_prediction": personalisedPrediction,
        "verbal_location": verbalLocation,
        "planet_zodiac_prediction": planetZodiacPrediction,
        "character_keywords_positive": characterKeywordsPositive == null
            ? []
            : List<dynamic>.from(characterKeywordsPositive!.map((x) => x)),
        "character_keywords_negative": characterKeywordsNegative == null
            ? []
            : List<dynamic>.from(characterKeywordsNegative!.map((x) => x)),
      };
}
