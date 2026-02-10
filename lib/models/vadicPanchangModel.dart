// To parse this JSON data, do
//
//     final vedicPanchangModel = vedicPanchangModelFromJson(jsonString);

import 'dart:convert';

VedicPanchangModel vedicPanchangModelFromJson(String str) =>
    VedicPanchangModel.fromJson(json.decode(str));

String vedicPanchangModelToJson(VedicPanchangModel data) =>
    json.encode(data.toJson());

class VedicPanchangModel {
  RecordList? recordList;
  int? status;

  VedicPanchangModel({
    this.recordList,
    this.status,
  });

  factory VedicPanchangModel.fromJson(Map<String, dynamic> json) =>
      VedicPanchangModel(
        recordList: json["recordList"] == null
            ? null
            : RecordList.fromJson(json["recordList"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "recordList": recordList?.toJson(),
        "status": status,
      };
}

class RecordList {
  int? status;
  Response? response;

  RecordList({
    this.status,
    this.response,
  });

  factory RecordList.fromJson(Map<String, dynamic> json) => RecordList(
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
  Ayanamsa? day;
  Karana? tithi;
  Karana? nakshatra;
  Karana? karana;
  Yoga? yoga;
  Ayanamsa? ayanamsa;
  Ayanamsa? rasi;
  AdvancedDetails? advancedDetails;
  String? rahukaal;
  String? gulika;
  String? yamakanta;
  String? date;

  Response({
    this.day,
    this.tithi,
    this.nakshatra,
    this.karana,
    this.yoga,
    this.ayanamsa,
    this.rasi,
    this.advancedDetails,
    this.rahukaal,
    this.gulika,
    this.yamakanta,
    this.date,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        day: json["day"] == null ? null : Ayanamsa.fromJson(json["day"]),
        tithi: json["tithi"] == null ? null : Karana.fromJson(json["tithi"]),
        nakshatra: json["nakshatra"] == null
            ? null
            : Karana.fromJson(json["nakshatra"]),
        karana: json["karana"] == null ? null : Karana.fromJson(json["karana"]),
        yoga: json["yoga"] == null ? null : Yoga.fromJson(json["yoga"]),
        ayanamsa: json["ayanamsa"] == null
            ? null
            : Ayanamsa.fromJson(json["ayanamsa"]),
        rasi: json["rasi"] == null ? null : Ayanamsa.fromJson(json["rasi"]),
        advancedDetails: json["advanced_details"] == null
            ? null
            : AdvancedDetails.fromJson(json["advanced_details"]),
        rahukaal: json["rahukaal"],
        gulika: json["gulika"],
        yamakanta: json["yamakanta"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "day": day?.toJson(),
        "tithi": tithi?.toJson(),
        "nakshatra": nakshatra?.toJson(),
        "karana": karana?.toJson(),
        "yoga": yoga?.toJson(),
        "ayanamsa": ayanamsa?.toJson(),
        "rasi": rasi?.toJson(),
        "advanced_details": advancedDetails?.toJson(),
        "rahukaal": rahukaal,
        "gulika": gulika,
        "yamakanta": yamakanta,
        "date": date,
      };
}

class AdvancedDetails {
  String? sunRise;
  String? sunSet;
  String? moonRise;
  String? moonSet;
  String? nextFullMoon;
  String? nextNewMoon;
  Masa? masa;
  String? moonYoginiNivas;
  double? ahargana;
  Years? years;
  String? vaara;
  String? dishaShool;
  AbhijitMuhurta? abhijitMuhurta;

  AdvancedDetails({
    this.sunRise,
    this.sunSet,
    this.moonRise,
    this.moonSet,
    this.nextFullMoon,
    this.nextNewMoon,
    this.masa,
    this.moonYoginiNivas,
    this.ahargana,
    this.years,
    this.vaara,
    this.dishaShool,
    this.abhijitMuhurta,
  });

  factory AdvancedDetails.fromJson(Map<String, dynamic> json) =>
      AdvancedDetails(
        sunRise: json["sun_rise"],
        sunSet: json["sun_set"],
        moonRise: json["moon_rise"],
        moonSet: json["moon_set"],
        nextFullMoon: json["next_full_moon"],
        nextNewMoon: json["next_new_moon"],
        masa: json["masa"] == null ? null : Masa.fromJson(json["masa"]),
        moonYoginiNivas: json["moon_yogini_nivas"],
        ahargana: json["ahargana"]?.toDouble(),
        years: json["years"] == null ? null : Years.fromJson(json["years"]),
        vaara: json["vaara"],
        dishaShool: json["disha_shool"],
        abhijitMuhurta: json["abhijit_muhurta"] == null
            ? null
            : AbhijitMuhurta.fromJson(json["abhijit_muhurta"]),
      );

  Map<String, dynamic> toJson() => {
        "sun_rise": sunRise,
        "sun_set": sunSet,
        "moon_rise": moonRise,
        "moon_set": moonSet,
        "next_full_moon": nextFullMoon,
        "next_new_moon": nextNewMoon,
        "masa": masa?.toJson(),
        "moon_yogini_nivas": moonYoginiNivas,
        "ahargana": ahargana,
        "years": years?.toJson(),
        "vaara": vaara,
        "disha_shool": dishaShool,
        "abhijit_muhurta": abhijitMuhurta?.toJson(),
      };
}

class AbhijitMuhurta {
  String? start;
  String? end;

  AbhijitMuhurta({
    this.start,
    this.end,
  });

  factory AbhijitMuhurta.fromJson(Map<String, dynamic> json) => AbhijitMuhurta(
        start: json["start"],
        end: json["end"],
      );

  Map<String, dynamic> toJson() => {
        "start": start,
        "end": end,
      };
}

class Masa {
  int? amantaNumber;
  int? amantaDate;
  String? amantaName;
  String? alternateAmantaName;
  String? amantaStart;
  String? amantaEnd;
  bool? adhikMaasa;
  String? ayana;
  String? realAyana;
  int? purnimantaDate;
  int? purnimantaNumber;
  String? purnimantaName;
  String? alternatePurnimantaName;
  String? purnimantaStart;
  String? purnimantaEnd;
  String? moonPhase;
  String? paksha;
  String? ritu;
  String? rituTamil;

  Masa({
    this.amantaNumber,
    this.amantaDate,
    this.amantaName,
    this.alternateAmantaName,
    this.amantaStart,
    this.amantaEnd,
    this.adhikMaasa,
    this.ayana,
    this.realAyana,
    this.purnimantaDate,
    this.purnimantaNumber,
    this.purnimantaName,
    this.alternatePurnimantaName,
    this.purnimantaStart,
    this.purnimantaEnd,
    this.moonPhase,
    this.paksha,
    this.ritu,
    this.rituTamil,
  });

  factory Masa.fromJson(Map<String, dynamic> json) => Masa(
        amantaNumber: json["amanta_number"],
        amantaDate: json["amanta_date"],
        amantaName: json["amanta_name"],
        alternateAmantaName: json["alternate_amanta_name"],
        amantaStart: json["amanta_start"],
        amantaEnd: json["amanta_end"],
        adhikMaasa: json["adhik_maasa"],
        ayana: json["ayana"],
        realAyana: json["real_ayana"],
        purnimantaDate: json["purnimanta_date"],
        purnimantaNumber: json["purnimanta_number"],
        purnimantaName: json["purnimanta_name"],
        alternatePurnimantaName: json["alternate_purnimanta_name"],
        purnimantaStart: json["purnimanta_start"],
        purnimantaEnd: json["purnimanta_end"],
        moonPhase: json["moon_phase"],
        paksha: json["paksha"],
        ritu: json["ritu"],
        rituTamil: json["ritu_tamil"],
      );

  Map<String, dynamic> toJson() => {
        "amanta_number": amantaNumber,
        "amanta_date": amantaDate,
        "amanta_name": amantaName,
        "alternate_amanta_name": alternateAmantaName,
        "amanta_start": amantaStart,
        "amanta_end": amantaEnd,
        "adhik_maasa": adhikMaasa,
        "ayana": ayana,
        "real_ayana": realAyana,
        "purnimanta_date": purnimantaDate,
        "purnimanta_number": purnimantaNumber,
        "purnimanta_name": purnimantaName,
        "alternate_purnimanta_name": alternatePurnimantaName,
        "purnimanta_start": purnimantaStart,
        "purnimanta_end": purnimantaEnd,
        "moon_phase": moonPhase,
        "paksha": paksha,
        "ritu": ritu,
        "ritu_tamil": rituTamil,
      };
}

class Years {
  int? kali;
  int? saka;
  int? vikramSamvaat;
  int? kaliSamvaatNumber;
  String? kaliSamvaatName;
  int? vikramSamvaatNumber;
  String? vikramSamvaatName;
  int? sakaSamvaatNumber;
  String? sakaSamvaatName;

  Years({
    this.kali,
    this.saka,
    this.vikramSamvaat,
    this.kaliSamvaatNumber,
    this.kaliSamvaatName,
    this.vikramSamvaatNumber,
    this.vikramSamvaatName,
    this.sakaSamvaatNumber,
    this.sakaSamvaatName,
  });

  factory Years.fromJson(Map<String, dynamic> json) => Years(
        kali: json["kali"],
        saka: json["saka"],
        vikramSamvaat: json["vikram_samvaat"],
        kaliSamvaatNumber: json["kali_samvaat_number"],
        kaliSamvaatName: json["kali_samvaat_name"],
        vikramSamvaatNumber: json["vikram_samvaat_number"],
        vikramSamvaatName: json["vikram_samvaat_name"],
        sakaSamvaatNumber: json["saka_samvaat_number"],
        sakaSamvaatName: json["saka_samvaat_name"],
      );

  Map<String, dynamic> toJson() => {
        "kali": kali,
        "saka": saka,
        "vikram_samvaat": vikramSamvaat,
        "kali_samvaat_number": kaliSamvaatNumber,
        "kali_samvaat_name": kaliSamvaatName,
        "vikram_samvaat_number": vikramSamvaatNumber,
        "vikram_samvaat_name": vikramSamvaatName,
        "saka_samvaat_number": sakaSamvaatNumber,
        "saka_samvaat_name": sakaSamvaatName,
      };
}

class Ayanamsa {
  String? name;

  Ayanamsa({
    this.name,
  });

  factory Ayanamsa.fromJson(Map<String, dynamic> json) => Ayanamsa(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class Karana {
  String? name;
  int? number;
  String? type;
  String? lord;
  String? diety;
  String? start;
  String? end;
  String? special;
  String? nextKarana;
  String? nextNakshatra;
  String? meaning;
  String? nextTithi;

  Karana({
    this.name,
    this.number,
    this.type,
    this.lord,
    this.diety,
    this.start,
    this.end,
    this.special,
    this.nextKarana,
    this.nextNakshatra,
    this.meaning,
    this.nextTithi,
  });

  factory Karana.fromJson(Map<String, dynamic> json) => Karana(
        name: json["name"],
        number: json["number"],
        type: json["type"],
        lord: json["lord"],
        diety: json["diety"],
        start: json["start"],
        end: json["end"],
        special: json["special"],
        nextKarana: json["next_karana"],
        nextNakshatra: json["next_nakshatra"],
        meaning: json["meaning"],
        nextTithi: json["next_tithi"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "number": number,
        "type": type,
        "lord": lord,
        "diety": diety,
        "start": start,
        "end": end,
        "special": special,
        "next_karana": nextKarana,
        "next_nakshatra": nextNakshatra,
        "meaning": meaning,
        "next_tithi": nextTithi,
      };
}

class Yoga {
  String? name;
  int? number;
  String? start;
  String? end;
  String? nextYoga;
  String? meaning;
  String? special;

  Yoga({
    this.name,
    this.number,
    this.start,
    this.end,
    this.nextYoga,
    this.meaning,
    this.special,
  });

  factory Yoga.fromJson(Map<String, dynamic> json) => Yoga(
        name: json["name"],
        number: json["number"],
        start: json["start"],
        end: json["end"],
        nextYoga: json["next_yoga"],
        meaning: json["meaning"],
        special: json["special"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "number": number,
        "start": start,
        "end": end,
        "next_yoga": nextYoga,
        "meaning": meaning,
        "special": special,
      };
}
