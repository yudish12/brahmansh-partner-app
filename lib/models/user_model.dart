// ignore_for_file: prefer_if_null_operators, avoid_print, prefer_interpolation_to_compose_strings

import 'package:brahmanshtalk/models/History/call_history_model.dart';
import 'package:brahmanshtalk/models/History/chat_history_model.dart';
import 'package:brahmanshtalk/models/History/report_history_model.dart';
import 'package:brahmanshtalk/models/History/wallet_history_model.dart';
import 'package:brahmanshtalk/models/Master%20Table%20Model/all_skill_model.dart';
import 'package:brahmanshtalk/models/Master%20Table%20Model/astrologer_category_list_model.dart';
import 'package:brahmanshtalk/models/Master%20Table%20Model/language_list_model.dart';
import 'package:brahmanshtalk/models/Master%20Table%20Model/primary_skill_model.dart';
import 'package:brahmanshtalk/models/customerReview_model.dart';
import 'package:brahmanshtalk/models/systemFlagModel.dart';
import 'package:brahmanshtalk/models/week_model.dart';
import 'History/payment_model.dart';

class CurrentUser {
  dynamic id;
  dynamic userId;
  dynamic roleId;
  dynamic country;
  dynamic callmethod;

  Map<String, dynamic>? documentmap;
  dynamic videoCallRateUsd;
  dynamic reportRateUsd;
  String? isshowcallsections;
  String? isshowchatsections;
  String? isshowlivesections;
  dynamic countrycode;
  List<AstrolgoerCategoryModel>? astrologerCategoryId = [];
  List<PrimarySkillModel>? primarySkillId = [];
  List<AllSkillModel>? allSkillId = [];
  List<LanguageModel>? languageId = [];
  dynamic isVerified;
  dynamic isAnyBodyRefer;
  dynamic isWorkingOnAnotherPlatform;
  String? name;
  String? email;
  String? contactNo;
  String? imagePath;
  String? gender;
  DateTime? birthDate;
  String? astrologerCategory;
  String? primarySkill;
  String? allSkill;
  String? languageKnown;
  dynamic charges;
  dynamic cusdcharges;
  dynamic videoCallRate;
  dynamic reportRate;
  dynamic chatDiscoutRate;
  dynamic audioDiscoutRate;
  dynamic videoDiscoutRate;
  dynamic expirenceInYear;
  dynamic dailyContributionHours;
  String? hearAboutAstroGuru;
  String? otherPlatformName;
  String? otherPlatformMonthlyEarning;
  String? onboardYou;
  String? suitableInterviewTime;
  String? currentCity;
  String? mainSourceOfBusiness;
  String? highestQualification;
  String? degreeDiploma;
  String? collegeSchoolUniversity;
  String? learnAstrology;
  String? instagramProfileLink;
  String? facebookProfileLink;
  String? linkedInProfileLink;
  String? youtubeProfileLink;
  String? webSiteProfileLink;
  String? referedPersonName;
  dynamic expectedMinimumEarning;
  dynamic expectedMaximumEarning;
  String? longBio;
  dynamic foreignCountryCount;
  String? currentlyWorkingJob;
  String? goodQualityOfAstrologer;
  String? biggestChallengeFaced;
  String? repeatedQuestion;
  List<Week>? week;
  String? sessionToken;
  String? token;
  String? tokenType;
  bool? isOAuth = false;
  List<ChatHistoryModel>? chatHistory;
  List<CallHistoryModel>? callHistory;
  List<WalletHistoryModel>? wallet;
  List<ReportHistoryModel>? reportHistory;
  List<CustomerReviewModel>? review;
  List<SystemFlag>? systemFlagList;
  List<Payment>? payment;
  String? chatStatus;
  String? callStatus;
  String? dateTime;
  DateTime? chatWaitTime;
  DateTime? callWaitTime;
  List<PujaOrder>? pujaOrder;
  List<CourseBadge>? courseBadges;

  dynamic whatsappNo;
  dynamic pancardNo;
  dynamic aadharNo;
  dynamic ifscCode;
  dynamic bankBranch;
  dynamic accountHoldername;
  dynamic bankName;
  dynamic accountType;
  dynamic accountNumber;
  dynamic upi;
  dynamic displayName;

  CurrentUser(
      {this.id,
      this.payment,
      this.userId,
      this.roleId,
      this.astrologerCategoryId,
      this.primarySkillId,
      this.allSkillId,
      this.languageId,
      this.name,
      this.email,
      this.contactNo,
      this.displayName,
      this.imagePath,
      this.gender,
      this.dateTime,
      this.birthDate,
      this.primarySkill,
      this.allSkill,
      this.languageKnown,
      this.astrologerCategory,
      this.charges,
      this.videoCallRate,
      this.reportRate,
      this.chatDiscoutRate,
      this.audioDiscoutRate,
      this.videoDiscoutRate,
      this.expirenceInYear,
      this.dailyContributionHours,
      this.hearAboutAstroGuru,
      this.otherPlatformName,
      this.otherPlatformMonthlyEarning,
      this.onboardYou,
      this.suitableInterviewTime,
      this.currentCity,
      this.mainSourceOfBusiness,
      this.highestQualification,
      this.degreeDiploma,
      this.collegeSchoolUniversity,
      this.learnAstrology,
      this.instagramProfileLink,
      this.facebookProfileLink,
      this.linkedInProfileLink,
      this.youtubeProfileLink,
      this.webSiteProfileLink,
      this.referedPersonName,
      this.expectedMinimumEarning,
      this.expectedMaximumEarning,
      this.longBio,
      this.foreignCountryCount,
      this.currentlyWorkingJob,
      this.goodQualityOfAstrologer,
      this.biggestChallengeFaced,
      this.repeatedQuestion,
      this.week,
      this.sessionToken,
      this.isOAuth,
      this.isWorkingOnAnotherPlatform,
      this.token,
      this.tokenType,
      this.callHistory,
      this.chatHistory,
      this.wallet,
      this.reportHistory,
      this.review,
      this.callStatus,
      this.callWaitTime,
      this.chatStatus,
      this.chatWaitTime,
      this.isshowchatsections,
      this.isshowcallsections,
      this.isshowlivesections,
      this.pujaOrder,
      this.courseBadges,
      this.country,
      this.videoCallRateUsd,
      this.reportRateUsd,
      this.cusdcharges,
      this.documentmap,
      this.whatsappNo,
      this.pancardNo,
      this.aadharNo,
      this.ifscCode,
      this.bankBranch,
      this.accountHoldername,
      this.bankName,
      this.accountType,
      this.accountNumber,
      this.upi,
      this.callmethod});

  CurrentUser.fromJson(Map<String, dynamic> json) {
    try {
      displayName = json["realName"];
      documentmap = json['documentMap'];
      id = json["id"];
      country = json["country"];
      videoCallRateUsd = json['videoCallRate_usd'];
      reportRateUsd = json['reportRate_usd'];
      cusdcharges = json['charge_usd'];
      callmethod = json['call_method'];

      chatDiscoutRate = json['chat_discount'];
      audioDiscoutRate = json['audio_discount'];
      videoDiscoutRate = json['video_discount'];

      whatsappNo = json['whatsappNo'];
      pancardNo = json['pancardNo'];
      aadharNo = json['aadharNo'];
      ifscCode = json['ifscCode'];
      bankBranch = json['bankBranch'];
      accountHoldername = json['accountHolderName'];
      bankName = json['bankName'];
      accountType = json['accountType'];
      accountNumber = json['accountNumber'];
      upi = json['upi'];

      payment = json["payment"] == null
          ? []
          : List<Payment>.from(
              json["payment"]!.map((x) => Payment.fromJson(x)));

      userId = json["userId"];
      countrycode = json["countryCode"];
      roleId = json["roleId"] ?? 2;
      isVerified = json["isVerified"] ?? 0;
      name = json["name"] ?? "";
      email = json["email"] ?? "";
      contactNo = json["contactNo"] ?? "";
      imagePath = json['profileImage'] ?? "";
      gender = json["gender"] ?? "";
      birthDate =
          DateTime.parse(json["birthDate"] ?? DateTime.now().toIso8601String());
      charges = json["charge"] ?? 0;
      videoCallRate = json['videoCallRate'] ?? 0;
      reportRate = json['reportRate'] ?? 0;
      expirenceInYear = json["experienceInYears"] ?? 0;
      dailyContributionHours = json["dailyContribution"] ?? 0;
      hearAboutAstroGuru = json["hearAboutAstroguru"] ?? "";
      isWorkingOnAnotherPlatform = json["isWorkingOnAnotherPlatform"] ?? 0;
      otherPlatformName = json["nameofplateform"] ?? "";
      otherPlatformMonthlyEarning = json["monthlyEarning"] ?? "";
      onboardYou = json["whyOnBoard"] ?? "";
      suitableInterviewTime = json["interviewSuitableTime"] ?? "";
      currentCity = json["currentCity"] ?? "";
      mainSourceOfBusiness = json["mainSourceOfBusiness"] ?? "";
      highestQualification = json["highestQualification"] ?? "";
      degreeDiploma = json["degree"] ?? "";
      collegeSchoolUniversity = json["college"] ?? "";
      learnAstrology = json["learnAstrology"] ?? "";
      instagramProfileLink = json["instaProfileLink"] ?? "";
      facebookProfileLink = json["facebookProfileLink"] ?? "";
      linkedInProfileLink = json["linkedInProfileLink"] ?? "";
      youtubeProfileLink = json["youtubeChannelLink"] ?? "";
      webSiteProfileLink = json["websiteProfileLink"] ?? "";
      isAnyBodyRefer = json["isAnyBodyRefer"] ?? 0;
      referedPersonName = json["referedPerson"] ?? "";
      expectedMinimumEarning = json["minimumEarning"] ?? 0;
      expectedMaximumEarning = json["maximumEarning"] ?? 0;
      longBio = json["loginBio"] ?? "";
      foreignCountryCount = json["NoofforeignCountriesTravel"] ?? "";
      currentlyWorkingJob = json["currentlyworkingfulltimejob"] ?? "";
      goodQualityOfAstrologer = json["goodQuality"] ?? "";
      biggestChallengeFaced = json["biggestChallenge"] ?? "";
      repeatedQuestion = json["whatwillDo"] ?? "";
      week = (json["astrologerAvailability"] != null &&
              json['astrologerAvailability'] != [])
          ? List<Week>.from(
              json['astrologerAvailability'].map((e) => Week.fromJson(e)))
          : [];
      sessionToken = json["sessionToken"] ?? "";
      token = json['token'] ?? "";
      tokenType = json['token_type'] ?? "";
      courseBadges = json["courseBadges"] == null
          ? []
          : List<CourseBadge>.from(
              json["courseBadges"]!.map((x) => CourseBadge.fromJson(x)));

      primarySkillId = (json['primarySkill'] != null &&
              json['primarySkill'] != [])
          ? List<PrimarySkillModel>.from(
              json['primarySkill'].map((e) => PrimarySkillModel.fromJson(e)))
          : [];
      allSkillId = (json['allSkill'] != null && json['allSkill'] != [])
          ? List<AllSkillModel>.from(
              json['allSkill'].map((e) => AllSkillModel.fromJson(e)))
          : [];
      languageId =
          (json['languageKnown'] != null && json['languageKnown'] != [])
              ? List<LanguageModel>.from(
                  json['languageKnown'].map((e) => LanguageModel.fromJson(e)))
              : [];
      astrologerCategoryId = (json['astrologerCategoryId'] != null &&
              json['astrologerCategoryId'] != [])
          ? List<AstrolgoerCategoryModel>.from(json['astrologerCategoryId']
              .map((e) => AstrolgoerCategoryModel.fromJson(e)))
          : [];
      chatHistory = (json['chatHistory'] != null && json['chatHistory'] != [])
          ? List<ChatHistoryModel>.from(
              json["chatHistory"].map((x) => ChatHistoryModel.fromJson(x)))
          : [];
      callHistory = (json['callHistory'] != null && json['callHistory'] != [])
          ? List<CallHistoryModel>.from(
              json["callHistory"].map((x) => CallHistoryModel.fromJson(x)))
          : [];
      wallet = (json['wallet'] != null && json['wallet'] != [])
          ? List<WalletHistoryModel>.from(
              json["wallet"].map((x) => WalletHistoryModel.fromJson(x)))
          : [];
      reportHistory = (json['report'] != null && json['report'] != [])
          ? List<ReportHistoryModel>.from(
              json["report"].map((x) => ReportHistoryModel.fromJson(x)))
          : [];
      review = (json['review'] != null && json['review'] != [])
          ? List<CustomerReviewModel>.from(
              json["review"].map((x) => CustomerReviewModel.fromJson(x)))
          : [];
      systemFlagList = json['systemFlag'] != null
          ? List<SystemFlag>.from(
              json['systemFlag'].map((p) => SystemFlag.fromJson(p)))
          : [];
      chatStatus = json['chatStatus'] ?? "";
      callStatus = json['callStatus'] ?? "";
      chatWaitTime = json["chatWaitTime"] != null
          ? DateTime.parse(
              json["chatWaitTime"] ?? DateTime.now().toIso8601String())
          : null;
      callWaitTime = json["callWaitTime"] != null
          ? DateTime.parse(
              json["callWaitTime"] ?? DateTime.now().toIso8601String())
          : null;
      isshowchatsections = json["chat_sections"] ?? '0';
      isshowcallsections = json["call_sections"] ?? '0';
      isshowlivesections = json["live_sections"] ?? '0';
      pujaOrder = json["pujaOrder"] == null
          ? []
          : List<PujaOrder>.from(
              json["pujaOrder"]!.map((x) => PujaOrder.fromJson(x)));
    } catch (e) {
      print("Exception - user_model.dart - CurrentUser.fromJson():" +
          e.toString());
    }
  }
  Map<String, dynamic> toJson() => {
        "call_method": callmethod,
        "realName": displayName,
        "whatsappNo": whatsappNo,
        "pancardNo": pancardNo,
        "aadharNo": aadharNo,
        "ifscCode": ifscCode,
        "bankBranch": bankBranch,
        "accountHolderName": accountHoldername,
        "bankName": bankName,
        "accountType": accountType,
        "accountNumber": accountNumber,
        "upi": upi,
        "documentMap": documentmap,
        "courseBadges": courseBadges == null
            ? []
            : List<dynamic>.from(courseBadges!.map((x) => x.toJson())),
        "roleId": roleId ?? 2,
        "id": id,
        "country": country,
        "videoCallRate_usd": videoCallRateUsd,
        "reportRate_usd": reportRateUsd,
        "charge_usd": cusdcharges,
        "countryCode": countrycode,
        "chat_sections": isshowchatsections,
        "call_sections": isshowcallsections,
        "live_sections": isshowlivesections,
        "payment": payment == null
            ? []
            : List<dynamic>.from(payment!.map((x) => x.toJson())),
        "userId": userId,
        "name": name ?? "",
        "email": email ?? "",
        "contactNo": contactNo ?? "",
        "profileImage": imagePath,
        "gender": gender ?? "",
        "birthDate": birthDate == null
            ? DateTime.now().toIso8601String()
            : birthDate!.toIso8601String(),
        "callWaitTime": callWaitTime == null
            ? DateTime.now().toIso8601String()
            : callWaitTime!.toIso8601String(),
        "chatWaitTime": chatWaitTime == null
            ? DateTime.now().toIso8601String()
            : chatWaitTime!.toIso8601String(),
        "charge": charges ?? 0,
        "videoCallRate": videoCallRate ?? 0,
        "reportRate": reportRate ?? 0,
        "experienceInYears": expirenceInYear ?? 0,
        "dailyContribution": dailyContributionHours ?? 0,
        "hearAboutAstroguru": hearAboutAstroGuru ?? "",
        "isWorkingOnAnotherPlatform": isWorkingOnAnotherPlatform,
        "nameofplateform": otherPlatformName ?? "",
        "monthlyEarning": otherPlatformMonthlyEarning ?? "",
        "whyOnBoard": onboardYou ?? "",
        "interviewSuitableTime": suitableInterviewTime ?? "",
        "currentCity": currentCity ?? "",
        "mainSourceOfBusiness": mainSourceOfBusiness ?? "",
        "highestQualification": highestQualification ?? "",
        "degree": degreeDiploma ?? "",
        "college": collegeSchoolUniversity ?? "",
        "learnAstrology": learnAstrology ?? "",
        "instaProfileLink": instagramProfileLink ?? "",
        "facebookProfileLink": facebookProfileLink ?? "",
        "linkedInProfileLink": linkedInProfileLink ?? "",
        "youtubeChannelLink": youtubeProfileLink ?? "",
        "websiteProfileLink": webSiteProfileLink ?? "",
        "isAnyBodyRefer": isAnyBodyRefer,
        "referedPerson": referedPersonName ?? "",
        "minimumEarning": expectedMinimumEarning ?? 0,
        "maximumEarning": expectedMaximumEarning ?? 0,
        "loginBio": longBio ?? "",
        "NoofforeignCountriesTravel": foreignCountryCount ?? "",
        "currentlyworkingfulltimejob": currentlyWorkingJob ?? "",
        "goodQuality": goodQualityOfAstrologer ?? "",
        "biggestChallenge": biggestChallengeFaced ?? "",
        "whatwillDo": repeatedQuestion ?? "",
        "astrologerAvailability": week ?? [],
        "primarySkill": primarySkillId ?? [],
        "allSkill": allSkillId ?? [],
        "languageKnown": languageId ?? [],
        "astrologerCategoryId": astrologerCategoryId ?? [],
        "token": token,
        "token_type": tokenType,
        "chatHistory": chatHistory ?? [],
        "callHistory": callHistory ?? [],
        "wallet": wallet ?? [],
        "report": reportHistory ?? [],
        "review": review ?? [],
        "systemFlag": systemFlagList ?? [],
        "chatStatus": chatStatus ?? "",
        "callStatus": callStatus ?? "",
        "pujaOrder": pujaOrder == null
            ? []
            : List<dynamic>.from(pujaOrder!.map((x) => x.toJson())),
        "chat_discount": chatDiscoutRate,
        "audio_discount": audioDiscoutRate,
        "video_discount": videoDiscoutRate
      };
}

class CourseBadge {
  String? courseBadge;

  CourseBadge({
    this.courseBadge,
  });
  factory CourseBadge.fromJson(Map<String, dynamic> json) => CourseBadge(
        courseBadge: json["course_badge"],
      );
  Map<String, dynamic> toJson() => {
        "course_badge": courseBadge,
      };
}

class PujaOrder {
  dynamic id;
  dynamic astrologerId;
  DateTime? astrologerJoinedAt;
  dynamic userId;
  dynamic pujaId;
  String? pujaName;
  DateTime? pujaStartDatetime;
  DateTime? pujaEndDatetime;
  dynamic pujaDuration;
  dynamic packageId;
  dynamic packageName;
  dynamic packagePerson;
  dynamic addressId;
  String? addressName;
  dynamic addressCountryCode;
  String? addressNumber;
  String? addressFlatno;
  dynamic addressLocality;
  String? addressCity;
  String? addressState;
  String? addressCountry;
  dynamic addressPincode;
  dynamic inrUsdConversionRate;
  dynamic orderPrice;
  dynamic orderGstAmount;
  dynamic orderTotalPrice;
  String? paymentType;
  dynamic paymentId;
  String? addressLandmark;
  String? pujaOrderStatus;
  dynamic pujaVideo;
  String? isPujaApproved;
  dynamic reminderSent;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic pujaImages;
  Package? package;
  String? pujaLink;
  bool? pujaDeleted;

  PujaOrder({
    this.id,
    this.astrologerId,
    this.astrologerJoinedAt,
    this.userId,
    this.pujaId,
    this.pujaName,
    this.pujaStartDatetime,
    this.pujaEndDatetime,
    this.pujaDuration,
    this.packageId,
    this.packageName,
    this.packagePerson,
    this.addressId,
    this.addressName,
    this.addressCountryCode,
    this.addressNumber,
    this.addressFlatno,
    this.addressLocality,
    this.addressCity,
    this.addressState,
    this.addressCountry,
    this.addressPincode,
    this.inrUsdConversionRate,
    this.orderPrice,
    this.orderGstAmount,
    this.orderTotalPrice,
    this.paymentType,
    this.paymentId,
    this.addressLandmark,
    this.pujaOrderStatus,
    this.pujaVideo,
    this.isPujaApproved,
    this.reminderSent,
    this.createdAt,
    this.updatedAt,
    this.pujaImages,
    this.package,
    this.pujaLink,
    this.pujaDeleted,
  });

  factory PujaOrder.fromJson(Map<String, dynamic> json) => PujaOrder(
        id: json["id"],
        astrologerId: json["astrologer_id"],
        astrologerJoinedAt: json["astrologer_joined_at"] == null
            ? null
            : DateTime.parse(json["astrologer_joined_at"]),
        userId: json["user_id"],
        pujaId: json["puja_id"],
        pujaName: json["puja_name"],
        pujaStartDatetime: json["puja_start_datetime"] == null
            ? null
            : DateTime.parse(json["puja_start_datetime"]),
        pujaEndDatetime: json["puja_end_datetime"] == null
            ? null
            : DateTime.parse(json["puja_end_datetime"]),
        pujaDuration: json["puja_duration"],
        packageId: json["package_id"],
        packageName: json["package_name"],
        packagePerson: json["package_person"],
        addressId: json["address_id"],
        addressName: json["address_name"],
        addressCountryCode: json["addressCountryCode"],
        addressNumber: json["address_number"],
        addressFlatno: json["address_flatno"],
        addressLocality: json["address_ locality"],
        addressCity: json["address_city"],
        addressState: json["address_state"],
        addressCountry: json["address_country"],
        addressPincode: json["address_pincode"],
        inrUsdConversionRate: json["inr_usd_conversion_rate"],
        orderPrice: json["order_price"],
        orderGstAmount: json["order_gst_amount"],
        orderTotalPrice: json["order_total_price"],
        paymentType: json["payment_type"],
        paymentId: json["payment_id"],
        addressLandmark: json["address_landmark"],
        pujaOrderStatus: json["puja_order_status"],
        pujaVideo: json["puja_video"],
        isPujaApproved: json["is_puja_approved"],
        reminderSent: json["reminder_sent"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        pujaImages: json["puja_images"],
        package:
            json["package"] == null ? null : Package.fromJson(json["package"]),
        pujaLink: json["pujaLink"],
        pujaDeleted: json["puja_deleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "astrologer_id": astrologerId,
        "astrologer_joined_at": astrologerJoinedAt?.toIso8601String(),
        "user_id": userId,
        "puja_id": pujaId,
        "puja_name": pujaName,
        "puja_start_datetime": pujaStartDatetime?.toIso8601String(),
        "puja_end_datetime": pujaEndDatetime?.toIso8601String(),
        "puja_duration": pujaDuration,
        "package_id": packageId,
        "package_name": packageName,
        "package_person": packagePerson,
        "address_id": addressId,
        "address_name": addressName,
        "addressCountryCode": addressCountryCode,
        "address_number": addressNumber,
        "address_flatno": addressFlatno,
        "address_ locality": addressLocality,
        "address_city": addressCity,
        "address_state": addressState,
        "address_country": addressCountry,
        "address_pincode": addressPincode,
        "inr_usd_conversion_rate": inrUsdConversionRate,
        "order_price": orderPrice,
        "order_gst_amount": orderGstAmount,
        "order_total_price": orderTotalPrice,
        "payment_type": paymentType,
        "payment_id": paymentId,
        "address_landmark": addressLandmark,
        "puja_order_status": pujaOrderStatus,
        "puja_video": pujaVideo,
        "is_puja_approved": isPujaApproved,
        "reminder_sent": reminderSent,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "puja_images": pujaImages,
        "package": package?.toJson(),
        "pujaLink": pujaLink,
        "puja_deleted": pujaDeleted,
      };
}

class Package {
  String? title;
  String? description;

  Package({
    this.title,
    this.description,
  });

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
      };
}
