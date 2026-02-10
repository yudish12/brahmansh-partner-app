// To parse this JSON data, do
//
//     final basicDetailModel = basicDetailModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

BasicDetailModel basicDetailModelFromJson(String str) =>
    BasicDetailModel.fromJson(json.decode(str));

String basicDetailModelToJson(BasicDetailModel data) =>
    json.encode(data.toJson());

class BasicDetailModel {
  dynamic message;
  RecordList? recordList;
  PlanetDetails? planetDetails;
  int? status;

  BasicDetailModel({
    this.message,
    this.recordList,
    this.planetDetails,
    this.status,
  });

  factory BasicDetailModel.fromJson(Map<String, dynamic> json) =>
      BasicDetailModel(
        message: json["message"],
        recordList: json["recordList"] == null
            ? null
            : RecordList.fromJson(json["recordList"]),
        planetDetails: json["planetDetails"] == null
            ? null
            : PlanetDetails.fromJson(json["planetDetails"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "recordList": recordList?.toJson(),
        "planetDetails": planetDetails?.toJson(),
        "status": status,
      };
}

class PlanetDetails {
  int? status;
  Response? response;

  PlanetDetails({
    this.status,
    this.response,
  });

  factory PlanetDetails.fromJson(Map<String, dynamic> json) => PlanetDetails(
        status: json["status"],
        response: json["response"] == null
            ? null
            : Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response?.toJson(),
      };
}

class Response {
  The0? the0;
  The0? the1;
  The0? the2;
  The0? the3;
  The0? the4;
  The0? the5;
  The0? the6;
  The0? the7;
  The0? the8;
  The0? the9;
  dynamic birthDasa;
  dynamic currentDasa;
  dynamic birthDasaTime;
  dynamic currentDasaTime;
  List<String>? luckyGem;
  List<int>? luckyNum;
  List<String>? luckyColors;
  List<String>? luckyLetters;
  List<String>? luckyNameStart;
  dynamic rasi;
  dynamic nakshatra;
  int? nakshatraPada;
  Panchang? panchang;
  GhatkaChakra? ghatkaChakra;

  Response({
    this.the0,
    this.the1,
    this.the2,
    this.the3,
    this.the4,
    this.the5,
    this.the6,
    this.the7,
    this.the8,
    this.the9,
    this.birthDasa,
    this.currentDasa,
    this.birthDasaTime,
    this.currentDasaTime,
    this.luckyGem,
    this.luckyNum,
    this.luckyColors,
    this.luckyLetters,
    this.luckyNameStart,
    this.rasi,
    this.nakshatra,
    this.nakshatraPada,
    this.panchang,
    this.ghatkaChakra,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        the0: json["0"] == null ? null : The0.fromJson(json["0"]),
        the1: json["1"] == null ? null : The0.fromJson(json["1"]),
        the2: json["2"] == null ? null : The0.fromJson(json["2"]),
        the3: json["3"] == null ? null : The0.fromJson(json["3"]),
        the4: json["4"] == null ? null : The0.fromJson(json["4"]),
        the5: json["5"] == null ? null : The0.fromJson(json["5"]),
        the6: json["6"] == null ? null : The0.fromJson(json["6"]),
        the7: json["7"] == null ? null : The0.fromJson(json["7"]),
        the8: json["8"] == null ? null : The0.fromJson(json["8"]),
        the9: json["9"] == null ? null : The0.fromJson(json["9"]),
        birthDasa: json["birth_dasa"],
        currentDasa: json["current_dasa"],
        birthDasaTime: json["birth_dasa_time"],
        currentDasaTime: json["current_dasa_time"],
        luckyGem: json["lucky_gem"] == null
            ? []
            : List<String>.from(json["lucky_gem"]!.map((x) => x)),
        luckyNum: json["lucky_num"] == null
            ? []
            : List<int>.from(json["lucky_num"]!.map((x) => x)),
        luckyColors: json["lucky_colors"] == null
            ? []
            : List<String>.from(json["lucky_colors"]!.map((x) => x)),
        luckyLetters: json["lucky_letters"] == null
            ? []
            : List<String>.from(json["lucky_letters"]!.map((x) => x)),
        luckyNameStart: json["lucky_name_start"] == null
            ? []
            : List<String>.from(json["lucky_name_start"]!.map((x) => x)),
        rasi: json["rasi"],
        nakshatra: json["nakshatra"],
        nakshatraPada: json["nakshatra_pada"],
        panchang: json["panchang"] == null
            ? null
            : Panchang.fromJson(json["panchang"]),
        ghatkaChakra: json["ghatka_chakra"] == null
            ? null
            : GhatkaChakra.fromJson(json["ghatka_chakra"]),
      );

  Map<String, dynamic> toJson() => {
        "0": the0?.toJson(),
        "1": the1?.toJson(),
        "2": the2?.toJson(),
        "3": the3?.toJson(),
        "4": the4?.toJson(),
        "5": the5?.toJson(),
        "6": the6?.toJson(),
        "7": the7?.toJson(),
        "8": the8?.toJson(),
        "9": the9?.toJson(),
        "birth_dasa": birthDasa,
        "current_dasa": currentDasa,
        "birth_dasa_time": birthDasaTime,
        "current_dasa_time": currentDasaTime,
        "lucky_gem":
            luckyGem == null ? [] : List<dynamic>.from(luckyGem!.map((x) => x)),
        "lucky_num":
            luckyNum == null ? [] : List<dynamic>.from(luckyNum!.map((x) => x)),
        "lucky_colors": luckyColors == null
            ? []
            : List<dynamic>.from(luckyColors!.map((x) => x)),
        "lucky_letters": luckyLetters == null
            ? []
            : List<dynamic>.from(luckyLetters!.map((x) => x)),
        "lucky_name_start": luckyNameStart == null
            ? []
            : List<dynamic>.from(luckyNameStart!.map((x) => x)),
        "rasi": rasi,
        "nakshatra": nakshatra,
        "nakshatra_pada": nakshatraPada,
        "panchang": panchang?.toJson(),
        "ghatka_chakra": ghatkaChakra?.toJson(),
      };
}

class GhatkaChakra {
  dynamic rasi;
  List<String>? tithi;
  dynamic day;
  dynamic nakshatra;
  dynamic tatva;
  dynamic lord;
  dynamic sameSexLagna;
  dynamic oppositeSexLagna;

  GhatkaChakra({
    this.rasi,
    this.tithi,
    this.day,
    this.nakshatra,
    this.tatva,
    this.lord,
    this.sameSexLagna,
    this.oppositeSexLagna,
  });

  factory GhatkaChakra.fromJson(Map<String, dynamic> json) => GhatkaChakra(
        rasi: json["rasi"],
        tithi: json["tithi"] == null
            ? []
            : List<String>.from(json["tithi"]!.map((x) => x)),
        day: json["day"],
        nakshatra: json["nakshatra"],
        tatva: json["tatva"],
        lord: json["lord"],
        sameSexLagna: json["same_sex_lagna"],
        oppositeSexLagna: json["opposite_sex_lagna"],
      );

  Map<String, dynamic> toJson() => {
        "rasi": rasi,
        "tithi": tithi == null ? [] : List<dynamic>.from(tithi!.map((x) => x)),
        "day": day,
        "nakshatra": nakshatra,
        "tatva": tatva,
        "lord": lord,
        "same_sex_lagna": sameSexLagna,
        "opposite_sex_lagna": oppositeSexLagna,
      };
}

class Panchang {
  double? ayanamsa;
  dynamic ayanamsaName;
  dynamic dayOfBirth;
  dynamic dayLord;
  dynamic horaLord;
  dynamic sunriseAtBirth;
  dynamic sunsetAtBirth;
  dynamic karana;
  dynamic yoga;
  dynamic tithi;

  Panchang({
    this.ayanamsa,
    this.ayanamsaName,
    this.dayOfBirth,
    this.dayLord,
    this.horaLord,
    this.sunriseAtBirth,
    this.sunsetAtBirth,
    this.karana,
    this.yoga,
    this.tithi,
  });

  factory Panchang.fromJson(Map<String, dynamic> json) => Panchang(
        ayanamsa: json["ayanamsa"]?.toDouble(),
        ayanamsaName: json["ayanamsa_name"],
        dayOfBirth: json["day_of_birth"],
        dayLord: json["day_lord"],
        horaLord: json["hora_lord"],
        sunriseAtBirth: json["sunrise_at_birth"],
        sunsetAtBirth: json["sunset_at_birth"],
        karana: json["karana"],
        yoga: json["yoga"],
        tithi: json["tithi"],
      );

  Map<String, dynamic> toJson() => {
        "ayanamsa": ayanamsa,
        "ayanamsa_name": ayanamsaName,
        "day_of_birth": dayOfBirth,
        "day_lord": dayLord,
        "hora_lord": horaLord,
        "sunrise_at_birth": sunriseAtBirth,
        "sunset_at_birth": sunsetAtBirth,
        "karana": karana,
        "yoga": yoga,
        "tithi": tithi,
      };
}

class The0 {
  dynamic name;
  dynamic fullName;
  double? localDegree;
  double? globalDegree;
  double? progressInPercentage;
  int? rasiNo;
  dynamic zodiac;
  int? house;
  dynamic nakshatra;
  dynamic nakshatraLord;
  int? nakshatraPada;
  int? nakshatraNo;
  dynamic zodiacLord;
  bool? isPlanetSet;
  dynamic lordStatus;
  dynamic basicAvastha;
  bool? isCombust;
  double? speedRadiansPerDay;
  bool? retro;

  The0({
    this.name,
    this.fullName,
    this.localDegree,
    this.globalDegree,
    this.progressInPercentage,
    this.rasiNo,
    this.zodiac,
    this.house,
    this.nakshatra,
    this.nakshatraLord,
    this.nakshatraPada,
    this.nakshatraNo,
    this.zodiacLord,
    this.isPlanetSet,
    this.lordStatus,
    this.basicAvastha,
    this.isCombust,
    this.speedRadiansPerDay,
    this.retro,
  });

  factory The0.fromJson(Map<String, dynamic> json) => The0(
        name: json["name"],
        fullName: json["full_name"],
        localDegree: json["local_degree"]?.toDouble(),
        globalDegree: json["global_degree"]?.toDouble(),
        progressInPercentage: json["progress_in_percentage"]?.toDouble(),
        rasiNo: json["rasi_no"],
        zodiac: json["zodiac"],
        house: json["house"],
        nakshatra: json["nakshatra"],
        nakshatraLord: json["nakshatra_lord"],
        nakshatraPada: json["nakshatra_pada"],
        nakshatraNo: json["nakshatra_no"],
        zodiacLord: json["zodiac_lord"],
        isPlanetSet: json["is_planet_set"],
        lordStatus: json["lord_status"],
        basicAvastha: json["basic_avastha"],
        isCombust: json["is_combust"],
        speedRadiansPerDay: json["speed_radians_per_day"]?.toDouble(),
        retro: json["retro"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "full_name": fullName,
        "local_degree": localDegree,
        "global_degree": globalDegree,
        "progress_in_percentage": progressInPercentage,
        "rasi_no": rasiNo,
        "zodiac": zodiac,
        "house": house,
        "nakshatra": nakshatra,
        "nakshatra_lord": nakshatraLord,
        "nakshatra_pada": nakshatraPada,
        "nakshatra_no": nakshatraNo,
        "zodiac_lord": zodiacLord,
        "is_planet_set": isPlanetSet,
        "lord_status": lordStatus,
        "basic_avastha": basicAvastha,
        "is_combust": isCombust,
        "speed_radians_per_day": speedRadiansPerDay,
        "retro": retro,
      };
}

class RecordList {
  int? id;
  dynamic name;
  dynamic gender;
  DateTime? birthDate;
  dynamic birthTime;
  dynamic birthPlace;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? createdBy;
  int? modifiedBy;
  double? latitude;
  double? longitude;
  dynamic timezone;
  dynamic isForTrackPlanet;
  dynamic pdfType;
  dynamic matchType;
  dynamic forMatch;
  dynamic pdfLink;

  RecordList({
    this.id,
    this.name,
    this.gender,
    this.birthDate,
    this.birthTime,
    this.birthPlace,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.modifiedBy,
    this.latitude,
    this.longitude,
    this.timezone,
    this.isForTrackPlanet,
    this.pdfType,
    this.matchType,
    this.forMatch,
    this.pdfLink,
  });

  factory RecordList.fromJson(Map<String, dynamic> json) => RecordList(
        id: json["id"],
        name: json["name"],
        gender: json["gender"],
        birthDate: json["birthDate"] == null
            ? null
            : DateTime.parse(json["birthDate"]),
        birthTime: json["birthTime"],
        birthPlace: json["birthPlace"],
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
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        timezone: json["timezone"],
        isForTrackPlanet: json["isForTrackPlanet"],
        pdfType: json["pdf_type"],
        matchType: json["match_type"],
        forMatch: json["forMatch"],
        pdfLink: json["pdf_link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "gender": gender,
        "birthDate": birthDate?.toIso8601String(),
        "birthTime": birthTime,
        "birthPlace": birthPlace,
        "isActive": isActive,
        "isDelete": isDelete,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "latitude": latitude,
        "longitude": longitude,
        "timezone": timezone,
        "isForTrackPlanet": isForTrackPlanet,
        "pdf_type": pdfType,
        "match_type": matchType,
        "forMatch": forMatch,
        "pdf_link": pdfLink,
      };
}
