import 'dart:convert';

BankDetailsModel bankDetailsModelFromJson(String str) =>
    BankDetailsModel.fromJson(json.decode(str));

String bankDetailsModelToJson(BankDetailsModel data) =>
    json.encode(data.toJson());

class BankDetailsModel {
  String? address;
  String? centre;
  String? contact;
  String? micr;
  String? swift;
  String? district;
  String? iso3166;
  String? city;
  bool? neft;
  bool? imps;
  bool? upi;
  String? branch;
  bool? rtgs;
  String? state;
  String? bank;
  String? bankcode;
  String? ifsc;

  BankDetailsModel({
    this.address,
    this.centre,
    this.contact,
    this.micr,
    this.swift,
    this.district,
    this.iso3166,
    this.city,
    this.neft,
    this.imps,
    this.upi,
    this.branch,
    this.rtgs,
    this.state,
    this.bank,
    this.bankcode,
    this.ifsc,
  });

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) =>
      BankDetailsModel(
        address: json["ADDRESS"],
        centre: json["CENTRE"],
        contact: json["CONTACT"],
        micr: json["MICR"],
        swift: json["SWIFT"],
        district: json["DISTRICT"],
        iso3166: json["ISO3166"],
        city: json["CITY"],
        neft: json["NEFT"],
        imps: json["IMPS"],
        upi: json["UPI"],
        branch: json["BRANCH"],
        rtgs: json["RTGS"],
        state: json["STATE"],
        bank: json["BANK"],
        bankcode: json["BANKCODE"],
        ifsc: json["IFSC"],
      );

  Map<String, dynamic> toJson() => {
        "ADDRESS": address,
        "CENTRE": centre,
        "CONTACT": contact,
        "MICR": micr,
        "SWIFT": swift,
        "DISTRICT": district,
        "ISO3166": iso3166,
        "CITY": city,
        "NEFT": neft,
        "IMPS": imps,
        "UPI": upi,
        "BRANCH": branch,
        "RTGS": rtgs,
        "STATE": state,
        "BANK": bank,
        "BANKCODE": bankcode,
        "IFSC": ifsc,
      };
}
