// To parse this JSON data, do
//
//     final reportDetailModel = reportDetailModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

ReportDetailModel reportDetailModelFromJson(String str) =>
    ReportDetailModel.fromJson(json.decode(str));

String reportDetailModelToJson(ReportDetailModel data) =>
    json.encode(data.toJson());

class ReportDetailModel {
  String? message;
  Ascendant? ascendant;
  int? status;

  ReportDetailModel({
    this.message,
    this.ascendant,
    this.status,
  });

  factory ReportDetailModel.fromJson(Map<String, dynamic> json) =>
      ReportDetailModel(
        message: json["message"],
        ascendant: json["ascendant"] == null
            ? null
            : Ascendant.fromJson(json["ascendant"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "ascendant": ascendant?.toJson(),
        "status": status,
      };
}

class Ascendant {
  int? status;
  List<Response>? response;

  Ascendant({
    this.status,
    this.response,
  });

  factory Ascendant.fromJson(Map<String, dynamic> json) => Ascendant(
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
  String? ascendant;
  String? ascendantLord;
  String? ascendantLordLocation;
  int? ascendantLordHouseLocation;
  String? generalPrediction;
  String? personalisedPrediction;
  String? verbalLocation;
  String? ascendantLordStrength;
  String? symbol;
  String? zodiacCharacteristics;
  String? luckyGem;
  String? dayForFasting;
  String? gayatriMantra;
  String? flagshipQualities;
  String? spiritualityAdvice;
  String? goodQualities;
  String? badQualities;

  Response({
    this.ascendant,
    this.ascendantLord,
    this.ascendantLordLocation,
    this.ascendantLordHouseLocation,
    this.generalPrediction,
    this.personalisedPrediction,
    this.verbalLocation,
    this.ascendantLordStrength,
    this.symbol,
    this.zodiacCharacteristics,
    this.luckyGem,
    this.dayForFasting,
    this.gayatriMantra,
    this.flagshipQualities,
    this.spiritualityAdvice,
    this.goodQualities,
    this.badQualities,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        ascendant: json["ascendant"],
        ascendantLord: json["ascendant_lord"],
        ascendantLordLocation: json["ascendant_lord_location"],
        ascendantLordHouseLocation: json["ascendant_lord_house_location"],
        generalPrediction: json["general_prediction"],
        personalisedPrediction: json["personalised_prediction"],
        verbalLocation: json["verbal_location"],
        ascendantLordStrength: json["ascendant_lord_strength"],
        symbol: json["symbol"],
        zodiacCharacteristics: json["zodiac_characteristics"],
        luckyGem: json["lucky_gem"],
        dayForFasting: json["day_for_fasting"],
        gayatriMantra: json["gayatri_mantra"],
        flagshipQualities: json["flagship_qualities"],
        spiritualityAdvice: json["spirituality_advice"],
        goodQualities: json["good_qualities"],
        badQualities: json["bad_qualities"],
      );

  Map<String, dynamic> toJson() => {
        "ascendant": ascendant,
        "ascendant_lord": ascendantLord,
        "ascendant_lord_location": ascendantLordLocation,
        "ascendant_lord_house_location": ascendantLordHouseLocation,
        "general_prediction": generalPrediction,
        "personalised_prediction": personalisedPrediction,
        "verbal_location": verbalLocation,
        "ascendant_lord_strength": ascendantLordStrength,
        "symbol": symbol,
        "zodiac_characteristics": zodiacCharacteristics,
        "lucky_gem": luckyGem,
        "day_for_fasting": dayForFasting,
        "gayatri_mantra": gayatriMantra,
        "flagship_qualities": flagshipQualities,
        "spirituality_advice": spiritualityAdvice,
        "good_qualities": goodQualities,
        "bad_qualities": badQualities,
      };
}
