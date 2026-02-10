// To parse this JSON data, do
//
//     final dashDetailsModel = dashDetailsModelFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

DashDetailsModel dashDetailsModelFromJson(String str) =>
    DashDetailsModel.fromJson(json.decode(str));

String dashDetailsModelToJson(DashDetailsModel data) =>
    json.encode(data.toJson());

class DashDetailsModel {
  String? message;
  MahaDasha? mahaDasha;
  MahaDashaPrediction? mahaDashaPrediction;
  AntarDasha? antarDasha;
  ParyantarDasha? paryantarDasha;
  YoginiDashaMain? yoginiDashaMain;
  YoginiDashaSub? yoginiDashaSub;
  int? status;

  DashDetailsModel({
    this.message,
    this.mahaDasha,
    this.mahaDashaPrediction,
    this.antarDasha,
    this.paryantarDasha,
    this.yoginiDashaMain,
    this.yoginiDashaSub,
    this.status,
  });

  factory DashDetailsModel.fromJson(Map<String, dynamic> json) =>
      DashDetailsModel(
        message: json["message"],
        mahaDasha: json["mahaDasha"] == null
            ? null
            : MahaDasha.fromJson(json["mahaDasha"]),
        mahaDashaPrediction: json["mahaDashaPrediction"] == null
            ? null
            : MahaDashaPrediction.fromJson(json["mahaDashaPrediction"]),
        antarDasha: json["antarDasha"] == null
            ? null
            : AntarDasha.fromJson(json["antarDasha"]),
        paryantarDasha: json["paryantarDasha"] == null
            ? null
            : ParyantarDasha.fromJson(json["paryantarDasha"]),
        yoginiDashaMain: json["yoginiDashaMain"] == null
            ? null
            : YoginiDashaMain.fromJson(json["yoginiDashaMain"]),
        yoginiDashaSub: json["yoginiDashaSub"] == null
            ? null
            : YoginiDashaSub.fromJson(json["yoginiDashaSub"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "mahaDasha": mahaDasha?.toJson(),
        "mahaDashaPrediction": mahaDashaPrediction?.toJson(),
        "antarDasha": antarDasha?.toJson(),
        "paryantarDasha": paryantarDasha?.toJson(),
        "yoginiDashaMain": yoginiDashaMain?.toJson(),
        "yoginiDashaSub": yoginiDashaSub?.toJson(),
        "status": status,
      };
}

class AntarDasha {
  int? status;
  AntarDashaResponse? response;

  AntarDasha({
    this.status,
    this.response,
  });

  factory AntarDasha.fromJson(Map<String, dynamic> json) => AntarDasha(
        status: json["status"],
        response: json["response"] == null
            ? null
            : AntarDashaResponse.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response?.toJson(),
      };
}

class AntarDashaResponse {
  List<List<String>>? antardashas;
  List<List<String>>? antardashaOrder;

  AntarDashaResponse({
    this.antardashas,
    this.antardashaOrder,
  });

  factory AntarDashaResponse.fromJson(Map<String, dynamic> json) =>
      AntarDashaResponse(
        antardashas: json["antardashas"] == null
            ? []
            : List<List<String>>.from(json["antardashas"]!
                .map((x) => List<String>.from(x.map((x) => x)))),
        antardashaOrder: json["antardasha_order"] == null
            ? []
            : List<List<String>>.from(json["antardasha_order"]!
                .map((x) => List<String>.from(x.map((x) => x)))),
      );

  Map<String, dynamic> toJson() => {
        "antardashas": antardashas == null
            ? []
            : List<dynamic>.from(
                antardashas!.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "antardasha_order": antardashaOrder == null
            ? []
            : List<dynamic>.from(antardashaOrder!
                .map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}

class MahaDasha {
  int? status;
  MahaDashaResponse? response;

  MahaDasha({
    this.status,
    this.response,
  });

  factory MahaDasha.fromJson(Map<String, dynamic> json) => MahaDasha(
        status: json["status"],
        response: json["response"] == null
            ? null
            : MahaDashaResponse.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response?.toJson(),
      };
}

class MahaDashaResponse {
  List<String>? mahadasha;
  List<String>? mahadashaOrder;
  int? startYear;
  String? dashaStartDate;
  String? dashaRemainingAtBirth;

  MahaDashaResponse({
    this.mahadasha,
    this.mahadashaOrder,
    this.startYear,
    this.dashaStartDate,
    this.dashaRemainingAtBirth,
  });

  factory MahaDashaResponse.fromJson(Map<String, dynamic> json) =>
      MahaDashaResponse(
        mahadasha: json["mahadasha"] == null
            ? []
            : List<String>.from(json["mahadasha"]!.map((x) => x)),
        mahadashaOrder: json["mahadasha_order"] == null
            ? []
            : List<String>.from(json["mahadasha_order"]!.map((x) => x)),
        startYear: json["start_year"],
        dashaStartDate: json["dasha_start_date"],
        dashaRemainingAtBirth: json["dasha_remaining_at_birth"],
      );

  Map<String, dynamic> toJson() => {
        "mahadasha": mahadasha == null
            ? []
            : List<dynamic>.from(mahadasha!.map((x) => x)),
        "mahadasha_order": mahadashaOrder == null
            ? []
            : List<dynamic>.from(mahadashaOrder!.map((x) => x)),
        "start_year": startYear,
        "dasha_start_date": dashaStartDate,
        "dasha_remaining_at_birth": dashaRemainingAtBirth,
      };
}

class MahaDashaPrediction {
  int? status;
  MahaDashaPredictionResponse? response;

  MahaDashaPrediction({
    this.status,
    this.response,
  });

  factory MahaDashaPrediction.fromJson(Map<String, dynamic> json) =>
      MahaDashaPrediction(
        status: json["status"],
        response: json["response"] == null
            ? null
            : MahaDashaPredictionResponse.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response?.toJson(),
      };
}

class MahaDashaPredictionResponse {
  List<Dasha>? dashas;
  String? translatedMahadasha;

  MahaDashaPredictionResponse({
    this.dashas,
    this.translatedMahadasha,
  });

  factory MahaDashaPredictionResponse.fromJson(Map<String, dynamic> json) =>
      MahaDashaPredictionResponse(
        dashas: json["dashas"] == null
            ? []
            : List<Dasha>.from(json["dashas"]!.map((x) => Dasha.fromJson(x))),
        translatedMahadasha: json["translated_mahadasha"],
      );

  Map<String, dynamic> toJson() => {
        "dashas": dashas == null
            ? []
            : List<dynamic>.from(dashas!.map((x) => x.toJson())),
        "translated_mahadasha": translatedMahadasha,
      };
}

class Dasha {
  String? prediction;
  String? dasha;
  String? dashaEndYear;
  String? dashaStartYear;
  String? planetInZodiac;

  Dasha({
    this.prediction,
    this.dasha,
    this.dashaEndYear,
    this.dashaStartYear,
    this.planetInZodiac,
  });

  factory Dasha.fromJson(Map<String, dynamic> json) => Dasha(
        prediction: json["prediction"],
        dasha: json["dasha"],
        dashaEndYear: json["dasha_end_year"],
        dashaStartYear: json["dasha_start_year"],
        planetInZodiac: json["planet_in_zodiac"],
      );

  Map<String, dynamic> toJson() => {
        "prediction": prediction,
        "dasha": dasha,
        "dasha_end_year": dashaEndYear,
        "dasha_start_year": dashaStartYear,
        "planet_in_zodiac": planetInZodiac,
      };
}

class ParyantarDasha {
  int? status;
  ParyantarDashaResponse? response;

  ParyantarDasha({
    this.status,
    this.response,
  });

  factory ParyantarDasha.fromJson(Map<String, dynamic> json) => ParyantarDasha(
        status: json["status"],
        response: json["response"] == null
            ? null
            : ParyantarDashaResponse.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response?.toJson(),
      };
}

class ParyantarDashaResponse {
  List<List<List<String>>>? paryantardasha;
  List<List<List<String>>>? paryantardashaOrder;

  ParyantarDashaResponse({
    this.paryantardasha,
    this.paryantardashaOrder,
  });

  factory ParyantarDashaResponse.fromJson(Map<String, dynamic> json) =>
      ParyantarDashaResponse(
        paryantardasha: json["paryantardasha"] == null
            ? []
            : List<List<List<String>>>.from(json["paryantardasha"]!.map((x) =>
                List<List<String>>.from(
                    x.map((x) => List<String>.from(x.map((x) => x)))))),
        paryantardashaOrder: json["paryantardasha_order"] == null
            ? []
            : List<List<List<String>>>.from(json["paryantardasha_order"]!.map(
                (x) => List<List<String>>.from(
                    x.map((x) => List<String>.from(x.map((x) => x)))))),
      );

  Map<String, dynamic> toJson() => {
        "paryantardasha": paryantardasha == null
            ? []
            : List<dynamic>.from(paryantardasha!.map((x) => List<dynamic>.from(
                x.map((x) => List<dynamic>.from(x.map((x) => x)))))),
        "paryantardasha_order": paryantardashaOrder == null
            ? []
            : List<dynamic>.from(paryantardashaOrder!.map((x) =>
                List<dynamic>.from(
                    x.map((x) => List<dynamic>.from(x.map((x) => x)))))),
      };
}

class YoginiDashaMain {
  int? status;
  YoginiDashaMainResponse? response;

  YoginiDashaMain({
    this.status,
    this.response,
  });

  factory YoginiDashaMain.fromJson(Map<String, dynamic> json) =>
      YoginiDashaMain(
        status: json["status"],
        response: json["response"] == null
            ? null
            : YoginiDashaMainResponse.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response?.toJson(),
      };
}

class YoginiDashaMainResponse {
  List<DashaList>? dashaList;
  List<String>? dashaEndDates;
  List<String>? dashaLordList;
  dynamic startDate;

  YoginiDashaMainResponse({
    this.dashaList,
    this.dashaEndDates,
    this.dashaLordList,
    this.startDate,
  });

  factory YoginiDashaMainResponse.fromJson(Map<String, dynamic> json) =>
      YoginiDashaMainResponse(
        dashaList: json["dasha_list"] == null
            ? []
            : List<DashaList>.from(json["dasha_list"]?.map(
                    (x) => dashaListValues.map[x] ?? DashaList.BHADRIKA) ??
                []),

        // dashaList: json["dasha_list"] == null
        //     ? []
        //     : List<DashaList>.from(
        //         json["dasha_list"]!.map((x) => dashaListValues.map[x]!)),
        dashaEndDates: json["dasha_end_dates"] == null
            ? []
            : List<String>.from(json["dasha_end_dates"]!.map((x) => x)),
        dashaLordList: json["dasha_lord_list"] == null
            ? []
            : List<String>.from(json["dasha_lord_list"]!.map((x) => x)),
        startDate: json["start_date"],
      );

  Map<String, dynamic> toJson() => {
        "dasha_list": dashaList == null
            ? []
            : List<dynamic>.from(
                dashaList!.map((x) => dashaListValues.reverse[x])),
        "dasha_end_dates": dashaEndDates == null
            ? []
            : List<dynamic>.from(dashaEndDates!.map((x) => x)),
        "dasha_lord_list": dashaLordList == null
            ? []
            : List<dynamic>.from(dashaLordList!.map((x) => x)),
        "start_date": startDate,
      };
}

enum DashaList {
  BHADRIKA,
  BHRAMARI,
  DHANYA,
  MANGALA,
  PINGALA,
  SANKATA,
  SIDDHA,
  ULKA
}

final dashaListValues = EnumValues({
  "Bhadrika": DashaList.BHADRIKA,
  "Bhramari": DashaList.BHRAMARI,
  "Dhanya": DashaList.DHANYA,
  "Mangala": DashaList.MANGALA,
  "Pingala": DashaList.PINGALA,
  "Sankata": DashaList.SANKATA,
  "Siddha": DashaList.SIDDHA,
  "Ulka": DashaList.ULKA
});

class YoginiDashaSub {
  int? status;
  List<ResponseElement>? response;

  YoginiDashaSub({
    this.status,
    this.response,
  });

  factory YoginiDashaSub.fromJson(Map<String, dynamic> json) => YoginiDashaSub(
        status: json["status"],
        response: json["response"] == null
            ? []
            : List<ResponseElement>.from(
                json["response"]!.map((x) => ResponseElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response == null
            ? []
            : List<dynamic>.from(response!.map((x) => x.toJson())),
      };
}

class ResponseElement {
  DashaList? mainDasha;
  String? mainDashaLord;
  List<DashaList>? subDashaList;
  List<String>? subDashaEndDates;
  String? subDashaStartDates;

  ResponseElement({
    this.mainDasha,
    this.mainDashaLord,
    this.subDashaList,
    this.subDashaEndDates,
    this.subDashaStartDates,
  });

  factory ResponseElement.fromJson(Map<String, dynamic> json) =>
      ResponseElement(
        mainDasha: json.containsKey("main_dasha") &&
                json["main_dasha"] != null &&
                dashaListValues.map[json["main_dasha"]] != null
            ? dashaListValues.map[json["main_dasha"]]
            : null,
        mainDashaLord: json["main_dasha_lord"],
        subDashaList: json["sub_dasha_list"] == null
            ? []
            : List<DashaList>.from(json["sub_dasha_list"]
                .map((x) => dashaListValues.map[x] ?? DashaList.BHADRIKA)),
        subDashaEndDates: json["sub_dasha_end_dates"] == null
            ? []
            : List<String>.from(json["sub_dasha_end_dates"].map((x) => x)),
        subDashaStartDates: json["sub_dasha_start_dates"],
      );

  Map<String, dynamic> toJson() => {
        "main_dasha": dashaListValues.reverse[mainDasha],
        "main_dasha_lord": mainDashaLord,
        "sub_dasha_list": subDashaList == null
            ? []
            : List<dynamic>.from(
                subDashaList!.map((x) => dashaListValues.reverse[x])),
        "sub_dasha_end_dates": subDashaEndDates == null
            ? []
            : List<dynamic>.from(subDashaEndDates!.map((x) => x)),
        "sub_dasha_start_dates": subDashaStartDates,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
