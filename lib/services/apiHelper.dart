// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:brahmanshtalk/Courses/model/coursemodel.dart';
import 'package:brahmanshtalk/models/Notification/storytextmodel.dart';
import 'package:brahmanshtalk/models/astrologerTicketsModel.dart';
import 'package:brahmanshtalk/models/bankDetailsModel.dart';
import 'package:brahmanshtalk/models/boostModel.dart';
import 'package:brahmanshtalk/models/docmodel.dart';
import 'package:brahmanshtalk/models/imageModel.dart';
import 'package:brahmanshtalk/models/productModelScreen.dart';
import 'package:brahmanshtalk/models/profileBoostHistory.dart';
import 'package:brahmanshtalk/models/viewStoryModel.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/model/astavargaDetailModel.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/model/basicDetailmodel.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/model/chartDetailmodel.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/model/doshaDetailModel.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/model/planetreportmodel.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/model/reportModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http_parser/http_parser.dart';
import 'package:brahmanshtalk/controllers/dailyHoroscopeController.dart';
import 'package:brahmanshtalk/models/Master%20Table%20Model/get_master_table_list_model.dart';
import 'package:brahmanshtalk/models/Notification/notification_model.dart';
import 'package:brahmanshtalk/models/app_review_model.dart';
import 'package:brahmanshtalk/models/astrologerAssistant_model.dart';
import 'package:brahmanshtalk/models/call_model.dart';
import 'package:brahmanshtalk/models/chat_model.dart';
import 'package:brahmanshtalk/models/customerReview_model.dart';
import 'package:brahmanshtalk/models/dailyHororscopeModelVedic.dart';
import 'package:brahmanshtalk/models/device_detail_model.dart';
import 'package:brahmanshtalk/models/following_model.dart';
import 'package:brahmanshtalk/models/hororScopeSignModel.dart';
import 'package:brahmanshtalk/models/kundliBasicModel.dart';
import 'package:brahmanshtalk/models/kundliModel.dart';
import 'package:brahmanshtalk/models/product_category_list_model.dart';
import 'package:brahmanshtalk/models/product_model.dart';
import 'package:brahmanshtalk/models/report_model.dart';
import 'package:brahmanshtalk/models/systemFlagModel.dart';
import 'package:brahmanshtalk/models/user_model.dart';
import 'package:brahmanshtalk/models/wallet_model.dart';
import 'package:brahmanshtalk/models/withdrawOptionModel.dart';
import 'package:brahmanshtalk/services/apiResult.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Courses/model/courseorderlistmodel.dart';
import '../controllers/callAvailability_controller.dart';
import '../controllers/chatAvailability_controller.dart';
import '../controllers/custompujaModel.dart';
import '../models/PoojaList.dart';
import '../models/ScheduleLiveModel.dart';
import '../models/amount_model.dart';
import '../models/assistant_chat_request_model.dart';
import '../models/astrology_blog_model.dart';
import '../models/intake_model.dart';
import '../models/kundlimodelAdd.dart';
import '../models/language.dart';
import '../models/live_users_model.dart';
import '../models/video_model.dart';
import '../models/wait_list_model.dart';
import '../utils/config.dart';
import '../views/HomeScreen/FloatingButton/FreeKundli/model/dashdetailmodel.dart';
import '../views/HomeScreen/FloatingButton/FreeKundli/model/kundlichartModel.dart';

String screen = 'apiHelper.dart';

class APIHelper {
  dynamic getAPIResult<T>(final response, T recordList) {
    try {
      APIResult result;
      result = APIResult.fromJson(json.decode(response.body), recordList);

      return result;
    } catch (e) {
      log("Exception1: $screen - getAPIResult $e");
    }
  }

  Future<dynamic> getReportApi(int? id, bool isKundali) async {
    log('ascendant-report detail id is here $id');
    var languageCode = supportedLanguages.contains(Get.locale?.languageCode)
        ? Get.locale?.languageCode
        : 'en';

    final modelbody = isKundali
        ? json.encode({"id": id, "language": languageCode})
        : json.encode({"userId": id, "language": languageCode});

    try {
      final response = await http.post(
        Uri.parse(
          "${appParameters[appMode]['apiUrl']}kundali/ascendant-report",
        ),
        headers: await global.getApiHeaders(true),
        body: modelbody,
      );
      log('ascendant-report chart res is here ${response.body}');
      dynamic kundlichartmodel;
      if (response.statusCode == 200) {
        kundlichartmodel = reportDetailModelFromJson(response.body);
      } else {
        kundlichartmodel = null;
      }
      return kundlichartmodel;
    } catch (e) {
      print('Exception in ascendant-report$e');
    }
  }

  Future<dynamic> getPlanetReportApi(
    int? id,
    String planetname,
    bool isKundali,
  ) async {
    log('ascendant-report detail id is here $id');
    var languageCode = supportedLanguages.contains(Get.locale?.languageCode)
        ? Get.locale?.languageCode
        : 'en';
    final modelbody = isKundali
        ? json.encode({
            "id": id,
            "language": languageCode,
            "planet": planetname,
          })
        : json.encode({
            "userId": id,
            "language": languageCode,
            "planet": planetname,
          });

    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}kundali/planet-report"),
        headers: await global.getApiHeaders(true),
        body: modelbody,
      );
      log('planet-report chart res is here ${response.body}');

      PlanetReportModel? planetreport;

      if (response.statusCode == 200) {
        planetreport = planetReportModelFromJson(response.body);
      } else {
        planetreport = null;
      }
      return planetreport;
    } catch (e) {
      print('Exception in planet-report$e');
    }
  }

  var supportedLanguages = [
    'en',
    'ta',
    'ka',
    'te',
    'hi',
    'ml',
    'mr',
    'bn',
    'sp',
    'fr',
  ];

  Future<dynamic> getChartDetailsApi(
    int? id,
    String? div,
    String? style,
    bool isKundali,
  ) async {
    log('basic detail id is here $id');
    var languageCode = supportedLanguages.contains(Get.locale?.languageCode)
        ? Get.locale?.languageCode
        : 'en';

    final modelbody = isKundali
        ? json.encode({
            "id": id,
            "div": div,
            "style": style,
            "language": languageCode,
          })
        : json.encode({
            "userId": id,
            "div": div,
            "style": style,
            "language": languageCode,
          });

    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}kundali/chart"),
        headers: await global.getApiHeaders(true),
        body: modelbody,
      );
      log('kundli chart res is here ${response.body}');
      log('kundli chart code is here ${response.statusCode}');

      dynamic kundlichartmodel;
      if (response.statusCode == 200) {
        kundlichartmodel = chartDetailModelFromJson(response.body);
      } else if (response.statusCode == 400) {
        String msg = json.decode(
          json.decode(response.body)["chartDetails"],
        )["message"];
        log('message is here $msg');
        Get.showSnackbar(GetSnackBar(message: msg));
      } else {
        kundlichartmodel = null;
      }
      return kundlichartmodel;
    } catch (e) {
      print('Exception in getChartDetailsApi$e');
    }
  }

  Future<dynamic> getDoshaApi(int? id, bool isKundali) async {
    log('getDoshaApi id is here $id');
    var languageCode = supportedLanguages.contains(Get.locale?.languageCode)
        ? Get.locale?.languageCode
        : 'en';
    final modelbody = isKundali
        ? json.encode({"id": id, "language": languageCode})
        : json.encode({"userId": id, "language": languageCode});

    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}kundali/dosha"),
        headers: await global.getApiHeaders(true),
        body: modelbody,
      );
      log('getDoshaApi res is here ${response.body}');
      log('getDoshaApi code is here ${response.statusCode}');

      dynamic doshadetailmodel;
      if (response.statusCode == 200) {
        doshadetailmodel = doshaDetailsModelFromJson(response.body);
      } else {
        doshadetailmodel = null;
      }
      return doshadetailmodel;
    } catch (e) {
      print('Exception in getDoshaApi$e');
    }
  }

  Future<dynamic> getDashaApi(int? id, bool isKundali) async {
    log('ascendant-report detail id is here $id');
    var languageCode = supportedLanguages.contains(Get.locale?.languageCode)
        ? Get.locale?.languageCode
        : 'en';
    final modelbody = isKundali
        ? json.encode({"id": id, "language": languageCode})
        : json.encode({"userId": id, "language": languageCode});

    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}kundali/dasha"),
        headers: await global.getApiHeaders(true),
        body: modelbody,
      );
      log('dasha res is here ${response.body}');
      print('dasha code is here ${response.statusCode}');

      dynamic dashdetailmodel;
      if (response.statusCode == 200) {
        dashdetailmodel = dashDetailsModelFromJson(response.body);
      } else {
        dashdetailmodel = null;
      }
      return dashdetailmodel;
    } catch (e) {
      print('Exception in getDashaApi$e');
    }
  }

  Future<AstavargaDetailModel?>? getAstaVargaApi(
    int? id,
    bool isKundali,
  ) async {
    log('getAstaVargaApi id is here $id');
    var languageCode = supportedLanguages.contains(Get.locale?.languageCode)
        ? Get.locale?.languageCode
        : 'en';
    final modelbody = isKundali
        ? json.encode({"id": id, "language": languageCode})
        : json.encode({"userId": id, "language": languageCode});

    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}kundali/astakvarga"),
        headers: await global.getApiHeaders(true),
        body: modelbody,
      );
      log('kundli astakvarga res is here ${response.body}');
      AstavargaDetailModel astavargaChartmodel;
      if (response.statusCode == 200) {
        astavargaChartmodel = astavargaDetailModelFromJson(response.body);
      } else {
        astavargaChartmodel = AstavargaDetailModel();
      }
      return astavargaChartmodel;
    } catch (e) {
      print('Exception in getAstaVargaApi $e');
    }
    return null;
  }

  Future<dynamic> getBasicDetailApi(int? id, bool isKundali) async {
    log('basic detail id is here $id');
    var languageCode = supportedLanguages.contains(Get.locale?.languageCode)
        ? Get.locale?.languageCode
        : 'en';
    final modelbody = isKundali
        ? json.encode({"id": id, "language": languageCode})
        : json.encode({
            "userId": id,
            "language": languageCode,
          });

    print('model send $modelbody');
    print("${appParameters[appMode]['apiUrl']}kundali/basic");
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}kundali/basic"),
        headers: await global.getApiHeaders(true),
        body: modelbody,
      );
      print('kundli body is getBasicDetailApi ${response.body}');

      dynamic kundlichartmodel;
      if (response.statusCode == 200) {
        kundlichartmodel = basicDetailModelFromJson(response.body);
        // kundlichartmodel = BasicDetailModel.fromJson(jsonDecode(response.body));
      } else {
        kundlichartmodel = null;
      }
      return kundlichartmodel;
    } catch (e) {
      print('Exception in getBasicDetailApi$e');
    }
  }

  Future<dynamic> logoutapi() async {
    try {
      final response = await http.post(
        Uri.parse('${appParameters[appMode]['apiUrl']}logout'),
        headers: await global.getApiHeaders(true),
      );
      print('headers : ${global.getApiHeaders(true)}');

      print('logout : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in logoutapi : -$e");
    }
  }

  Future<String?> getPrivacyUrl() async {
    try {
      final response = await http.post(
        Uri.parse("https://namastro.com/admin/privacy-policy"),
      );
      print('privacy- ${response.body}');
      String? privacyUrl;
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        privacyUrl = responseData['response'];
      } else {
        privacyUrl = null;
      }
      return privacyUrl;
    } catch (e) {
      print('Exception in getPrivacyUrl(): $e');
      return null;
    }
  }

  // getCourseOrderListApi
  Future<dynamic> getCourseOrderListApi(var astrologerid) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getCourseOrderlist"),
        body: json.encode({"astrologerId": astrologerid}),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      log("getCourseOrderListApi ${response.body}");
      if (response.statusCode == 200) {
        recordList = List<CourseOrderModel>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => CourseOrderModel.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getCourseOrderListApi():$e');
    }
  }

  // mark as read
  Future<dynamic> markcourseReadApi(var courseorderid) async {
    log("courseorderid $courseorderid");

    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}courseCompletion"),
        body: json.encode({"course_order_id": courseorderid}),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      log("markcourseReadApi ${response.body}");

      if (response.statusCode == 200) {
        recordList = response.body;
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in markcourseReadApi():$e');
    }
  }

  //getCoursesApi//
  Future<dynamic> getCoursesApi() async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getCourse"),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<CourseModel>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => CourseModel.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getCoursesApi():$e');
    }
  }

  //buyCourseApi
  Future<Map<String, dynamic>?> buyCourseApi(
    var astrologerid,
    var courseId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}addCourseOrder"),
        //astrologerId,course_id and
        body: json.encode({
          "course_id": courseId,
          "astrologerId": astrologerid,
        }),
        headers: await global.getApiHeaders(true),
      );
      log('buy order response : ${response.body}');
      log('buy order response code: ${response.statusCode}');

      Map<String, dynamic> recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = {};
      }
      return recordList;
    } catch (e) {
      print('Exception in buyCourseApi():$e');
    }
    return null;
  }

  Future<dynamic> getCourseDetailsApi(var courseId) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getCourseDetails"),
        body: json.encode({
          "course_id": courseId,
          "astrologerId": global.user.id,
        }),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)["recordList"];
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getCourseDetails():$e');
    }
  }

  Future<dynamic> getPdfPrice() async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}pdf/price"),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = response.body;
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getKundli():$e');
    }
  }

  Future<dynamic> addAmountInWallet({
    required double amount,
    required double cashback,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${appParameters[appMode]['apiUrl']}addpayment'),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "userId": global.user.id!,
          'amount': amount,
          'cashback_amount': cashback,
        }),
      );
      log('add money response:- ${response.body}');
      return json.decode(response.body);
    } catch (e) {
      print('Exception:- in addAmountInWallet $e');
    }
  }

  Future getWalletinformations() async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}withdrawlmethod/get"),
      );
      print('asd ${appParameters[appMode]['apiUrl']}/withdrawlmethod/get');
      print('getWalletinformations body : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = withdrawOptionModelFromJson(response.body).recordList;
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen -  getWalletinformations $e");
    }
  }

  Future getpaymentAmount() async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getRechargeAmount"),
        headers: await global.getApiHeaders(true),
      );
      print('asd ${appParameters[appMode]['apiUrl']}/getRechargeAmount');
      print('recharge body : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AmountModel>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => AmountModel.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - getpaymentAmount(): $e");
    }
  }

  //Signup astrologer
  Future<dynamic> signUp(CurrentUser user) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}astrologer/add"),
        headers: await global.getApiHeaders(false),
        body: json.encode(user.toJson()),
      );

      log('signup Response code : ${response.statusCode}');
      log('signup response : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        recordList = CurrentUser.fromJson(
          json.decode(response.body)["recordList"],
        );
      } else if (response.statusCode == 400) {
        global.showToast(message: json.decode(response.body)["error"]['email']);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - signUp(): $e");
    }
  }

  Future<dynamic> validateSession() async {
    try {
      final response = await http.post(
        Uri.parse(
          "${appParameters[appMode]['apiUrl']}validateSessionForAstrologer",
        ),
        headers: await global.getApiHeaders(true),
      );
      log('validate resp : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = CurrentUser.fromJson(
          json.decode(response.body)["recordList"],
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception $screen - validateSession(): $e");
    }
  }

  Future<dynamic> setRemoteId(int astroId, int remoteId) async {
    try {
      print('${appParameters[appMode]['apiUrl']}addAstrohost');
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}addAstrohost"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": "$astroId", "hostId": "$remoteId"}),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - setRemoteId(): $e");
    }
  }

  //Update astrologer
  Future astrologerUpdate(CurrentUser user) async {
    log("sending edit profile updated body ${user.toJson()}");

    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}astrologer/update"),
        headers: await global.getApiHeaders(true),
        body: json.encode(user.toJson()),
      );
      log('astrologerUpdate response  : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));

        String token = global.user.token.toString();
        String tokenType = global.user.tokenType.toString();
        recordList = CurrentUser.fromJson(
          json.decode(response.body)["recordList"],
        );
        CurrentUser.fromJson({"token": token, "token_type": tokenType});
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - astrologerUpdate(): $e");
    }
  }

  Future<dynamic> getPanchangVedic(String date) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}get/panchang"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"panchangDate": date}),
      );
      dynamic recordList;
      log("getPanchangVedic ${response.statusCode}");
      log("getPanchangVedic ${response.body}");
      if (response.statusCode == 200) {
        recordList = jsonDecode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getPanchangVedic():$e');
    }
  }

  //Check conatct number is exist
  dynamic checkExistContactNumber(String contactNo) async {
    try {
      print('${appParameters[appMode]['apiUrl']}checkContactNoExist');
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}checkContactNoExist"),
        headers: await global.getApiHeaders(false),
        body: json.encode({'contactNo': contactNo}),
      );
      print('checkExistContactNumber : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = response.body;
      } else {
        recordList = response.body;
      }
      return recordList;
    } catch (e) {
      print("Exception: $screen - checkExistContactNumber(): $e");
    }
  }

  //Login api
  Future<dynamic> login(
    String? contactNo,
    String? email,
    DeviceInfoLoginModel userDeviceDetails,
  ) async {
    try {
      print('${appParameters[appMode]['apiUrl']}loginAppAstrologer');
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}loginAppAstrologer"),
        headers: await global.getApiHeaders(false),
        body: json.encode({
          "contactNo": contactNo,
          'email': email,
          "userDeviceDetails": userDeviceDetails.toJson(),
        }),
      );
      log('responselogin:- ${response.body}');
      dynamic recordList;

      if (response.statusCode == 200) {
        log('login response:- ${response.body}');
        recordList = CurrentUser.fromJson(
          json.decode(response.body)["recordList"][0],
        );
        recordList.token = json.decode(response.body)["token"];
        recordList.tokenType = json.decode(response.body)["token_type"];
      } else if (response.statusCode == 400) {
        recordList = json.decode(response.body)["message"];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - login(): $e");
    }
  }

  DocumetModel? recordList;

  Future<DocumetModel?> getdocumetdetailsApi() async {
    //aadhar_card
    try {
      print("${appParameters[appMode]['apiUrl']}getDocumentList");
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getDocumentList"),
        headers: await global.getApiHeaders(true),
      );
      log('getdocumetdetailsApi response--> ${response.body}');
      if (response.statusCode == 200) {
        recordList = documetModelFromJson(response.body);
      } else {
        recordList = DocumetModel();
      }
      return recordList;
    } catch (e) {
      recordList = DocumetModel();
      print("Exception: $screen - getdocumetdetailsApi$e");
    }
    return null;
  }

  //Delete astrologer account
  Future<dynamic> astrologerDelete(int id) async {
    try {
      print("${appParameters[appMode]['apiUrl']}astrologer/delete");
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}astrologer/delete"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"id": id}),
      );
      log('delete account : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - astrologerDelete(): $e");
    }
  }

  //Master table
  Future getMasterTableData() async {
    try {
      log("rsponse- > ${appParameters[appMode]['apiUrl']}getMasterAstrologer");
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getMasterAstrologer"),
        headers: await global.getApiHeaders(false),
      );
      log("${global.getApiHeaders(false)}");

      print('mastertable status : ${response.statusCode}');
      log('mastertable response : ${response.body}');

      print(json.decode(response.body));
      dynamic recordList;
      if (response.statusCode == 200) {
        log("Response : ${json.decode(response.body)['status']}");
        print(json.decode(response.body));
        recordList = GetMasterTableDataModel.fromJson(
          json.decode(response.body),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - getMasterTableData(): $e");
    }
  }

  //-------------------------------- Profile details ---------------------------//

  //get profile
  Future<dynamic> getAstrologerProfile(
    int id,
    int startIndex,
    int record,
  ) async {
    log(
      'astrologer id is $id and startIndex is $startIndex and record is $record',
    );
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getAstrologerById"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "astrologerId": id,
          "startIndex": startIndex,
          "fetchRecord": record,
        }),
      );
      dynamic recordList;
      log('getAstrologerById body : ${json.encode({
            "astrologerId": id,
            "startIndex": startIndex,
            "fetchRecord": record,
          })}');

      log('getAstrologerById response : ${response.body}');
      if (response.statusCode == 200) {
        recordList = List<CurrentUser>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => CurrentUser.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getAstrologerProfile():-$e');
    }
  }

  //--------------------------------Chat ---------------------------//
  //get chat request
  Future<dynamic> getchatRequest(int id, int startIndex, int record) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}chatRequest/get"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "astrologerId": id,
          "startIndex": startIndex,
          "fetchRecord": record,
        }),
      );
      log('chat getchatRequest response ${response.body}');
      dynamic recordList;
      final responseJson = json.decode(response.body);
      Map<String, dynamic> result = {};

      if (response.statusCode == 200) {
        var recordList = responseJson['recordList'];
        List<ChatRequest> chatRequestList = List<ChatRequest>.from(
          recordList['chatRequest'].map((x) => ChatRequest.fromJson(x)),
        );
        List<Keyword> keywordList = List<Keyword>.from(
          recordList['keywords'].map((x) => Keyword.fromJson(x)),
        );

        result['chatRequestList'] = chatRequestList;
        result['keywordList'] = keywordList;

        log('chat request api 2 keywordList = $keywordList');
        log('chat request api 2 chatRequestList = $chatRequestList');

        return result;
      } else {
        result['chatRequestList'] = null;
        result['keywordList'] = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getchatRequest(): $e');
    }
  }

  //get chat reject
  Future<dynamic> chatReject(int chatId) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}chatRequest/reject"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"chatId": chatId}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.encode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - chatReject(): $e');
    }
  }

  // store-defaulter-message

  Future<dynamic> storedefaultmessageApi(
    String msg,
    int? customerid,
    int? astrouserid,
  ) async {
    try {
      log(
        'blocked keyword send to api is msg $msg, and sender is $customerid, and receiver is $astrouserid',
      );
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}store-defaulter-message"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "message": msg,
          "sender_id": astrouserid,
          "sender_type": "astrologer",
          "receiver_id": customerid,
          "receiver_type": "user",
        }),
      );
      log(
        'response storedefaultmessageApi res ${json.encode({
              "message": msg,
              "sender_id": astrouserid,
              "sender_type": "astrologer",
              "receiver_id": customerid,
              "receiver_type": "user"
            })}',
      );
      log('response storedefaultmessageApi status ${response.statusCode}');
      log('response storedefaultmessageApi ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.encode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - chatReject(): $e');
    }
  }

  Future<dynamic> acceptChatRequest(int chatId) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}chatRequest/accept"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"chatId": chatId}),
      );
      log('chat response ${response.body}');
      print('chat url ${appParameters[appMode]['apiUrl']}chatRequest/accept');
      print('chat response ${json.encode({"chatId": chatId})}');
      dynamic recordList;
      if (response.statusCode == 200) {
        // recordList = List<ChatModel>.from(json
        //     .decode(response.body)["recordList"]
        //     .map((x) => ChatModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - acceptChatRequest(): $e');
    }
  }

  Future<dynamic> getChatId() async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}chatRequest/accept"),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getChatId(): $e');
    }
  }

  Future<dynamic> addChatId(int userId, int partnerId, int chatId) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}chatRequest/storeChatId"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "userId": userId,
          "partnerId": partnerId,
          "chatId": chatId,
        }),
      );
      print("${appParameters[appMode]['apiUrl']}chatRequest/storeChatId");
      print(
        json.encode({
          "userId": userId,
          "partnerId": partnerId,
          "chatId": chatId,
        }),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - addChatId(): $e');
    }
  }

  Future<dynamic> addChatToken(
    String token,
    String channelName,
    int chatId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}chatRequest/storeToken"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "token": token,
          "channelName": channelName,
          "chatId": chatId,
        }),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.encode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - addChatToken():-$e');
    }
  }

  //-------------------------- Call --------------------------------------//
  //get call request
  Future<dynamic> getCallRequest(int id, int startIndex, int record) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}callRequest/get"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "astrologerId": id,
          "startIndex": startIndex,
          "fetchRecord": record,
        }),
      );
      log('call list reponse- > ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<CallModel>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => CallModel.fromJson(x)),
        );
      } else {
        recordList = null;
      }

      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getCallRequest(): $e');
    }
  }

  Future<dynamic> acceptCallRequest(int callId) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}callRequest/accept"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"callId": callId}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.encode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - acceptCallRequest():-$e');
    }
  }

  Future<dynamic> acceptVideoCallRequest(int callId) async {
    print('callid $callId');
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}callRequest/accept"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"callId": callId}),
      );
      print('acceptVideoCallRequest respones ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.encode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - acceptCallRequest():-$e');
    }
  }

  Future<dynamic> rejectCallRequest(int callId) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}callRequest/reject"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"callId": callId}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.encode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - rejectCallRequest():-$e');
    }
  }

  Future<Map<String, dynamic>?> addCallToken(
      String token, String channelName, dynamic callId) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}callRequest/storeToken"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "token": token,
          "channelName": channelName,
          "callId": callId,
        }),
      );
      log('live astrologer body ${json.encode({
            "token": token,
            "channelName": channelName,
            "callId": callId,
          })}');
      log('addCallToken response ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print('Exception: $screen - addCallToken():-$e');
      return null;
    }
  }

  //----------------------------- report ----------------------------------//

  Future<dynamic> getReportRequest(int id, int startIndex, int record) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getUserReport"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "astrologerId": id,
          "startIndex": startIndex,
          "fetchRecord": record,
        }),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<ReportModel>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => ReportModel.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getReportRequest():-$e');
    }
  }

  //Upload a report file
  Future sendReport(int id, String reportFile) async {
    try {
      print("${appParameters[appMode]['apiUrl']}userreport/add");
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}userreport/add"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"id": id, "reportFile": reportFile}),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)["recordList"] != null) {
          recordList = ReportModel.fromJson(
            json.decode(response.body)["recordList"],
          );
        }
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - sendReport(): $e");
    }
  }

  //----------------------------------------Astromall-----------------------------------//
  Future addAstromallProdcut(ProductModel productModel) async {
    try {
      print("${appParameters[appMode]['apiUrl']}astromallProduct/add");
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}api/getproductCategory"),
        headers: await global.getApiHeaders(true),
        body: json.encode(productModel),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {}
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - addAstromallProdcut(): $e");
    }
  }

  Future getproductCategory() async {
    try {
      print("${appParameters[appMode]['apiUrl']}getproductCategory");
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getproductCategory"),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        recordList = List<ProductCategoryListModel>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => ProductCategoryListModel.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - getproductCategory(): $e");
    }
  }

  //----------------------------------------Astrologer assistant-----------------------------------//

  //Add an astrologer assistant
  Future<dynamic> astrologerAssistantAdd(
    AstrologerAssistantModel assistantmodel,
  ) async {
    try {
      print("${appParameters[appMode]['apiUrl']}astrologerAssistant/add");
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}astrologerAssistant/add"),
        headers: await global.getApiHeaders(true),
        body: json.encode(assistantmodel.toJson()),
      );
      print('astrologerAssistantAdd rsp $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)["recordList"] != null) {
          recordList = AstrologerAssistantModel.fromJson(
            json.decode(response.body)["recordList"],
          );
        }
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - astrologerAssistantAdd(): $e");
    }
  }

  //get astrologer asssistant
  Future<dynamic> getAstrologerAssistant(int id) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getAstrologerAssistant"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": id}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstrologerAssistantModel>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => AstrologerAssistantModel.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getAstrologerAssistant():-$e');
    }
  }

  //Update astrologer assistant
  Future astrologerAssistantUpdate(
    AstrologerAssistantModel assistantmodel,
  ) async {
    try {
      print("${appParameters[appMode]['apiUrl']}astrologerAssistant/update");
      final response = await http.post(
        Uri.parse(
          "${appParameters[appMode]['apiUrl']}astrologerAssistant/update",
        ),
        headers: await global.getApiHeaders(true),
        body: json.encode(assistantmodel.toJson()),
      );

      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)["recordList"] != null) {
          recordList = AstrologerAssistantModel.fromJson(
            json.decode(response.body)["recordList"],
          );
        }
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print(
        "Exception: $screen - astrologerAssistantUpdate(): $e",
      );
    }
  }

  //get astrologer assistant chat request
  Future getAssistantChatRequest(int astrologerId) async {
    try {
      print("${appParameters[appMode]['apiUrl']}getAssistantChatRequest");
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getAssistantChatRequest"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": astrologerId}),
      );

      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)["recordList"] != null) {
          recordList = List<AssistantChatRequestModel>.from(
            json
                .decode(response.body)["recordList"]
                .map((x) => AssistantChatRequestModel.fromJson(x)),
          );
        }
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - getAssistantChatRequest(): $e");
    }
  }

  //Astrologer assistant delete
  Future<dynamic> assistantDelete(int id) async {
    try {
      final response = await http.post(
        Uri.parse(
          "${appParameters[appMode]['apiUrl']}astrologerAssistant/delete",
        ),
        headers: await global.getApiHeaders(true),
        body: json.encode({"id": id}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.encode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - assistantDelete():-$e');
    }
  }

  Future<dynamic> getHoroscope({int? horoscopeSignId}) async {
    print('horoscopeSignId-> $horoscopeSignId');
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getDailyHoroscope"),
        body: json.encode({"horoscopeSignId": horoscopeSignId}),
        headers: await global.getApiHeaders(true),
      );
      int _ncalltype = json.decode(response.body)['astroApiCallType'] ?? 2;
      Get.find<DailyHoroscopeController>().updatecalltype(_ncalltype);

      dynamic recordList;
      dynamic vedicList;

      if (_ncalltype == 3) {
        if (response.statusCode == 200) {
          print('return inside 3');
          vedicList = json.decode(response.body)['vedicList'];
          DailyHororscopeModelVedic.fromJson(json.decode(response.body));
        } else {
          vedicList = null;
        }
        return vedicList;
      } else if (_ncalltype == 2) {
        if (response.statusCode == 200) {
          print('return inside 2');

          recordList = json.decode(response.body)['recordList'];
        } else {
          recordList = null;
        }
        return recordList;
      }
    } catch (e) {
      print('Exception in getHoroscope():$e');
    }
  }

  Future<dynamic> uploadAstrologerVideo({
    required int astrologerId,
    required File videoFile,
  }) async {
    log('upload data is ${videoFile.path} and astrologer id is $astrologerId');
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${appParameters[appMode]['apiUrl']}astrologer-video"),
      );
      request.headers.addAll(
        await global.getApiHeaders(true, ismultipart: true),
      );
      request.fields['astrologerId'] = astrologerId.toString();
      request.files.add(await http.MultipartFile.fromPath(
        'astro_video',
        videoFile.path,
      ));
      var response = await request.send();
      var responseData = await http.Response.fromStream(response);
      log('upload response is ${responseData.body}');
      log('upload response statuscode ${responseData.statusCode}');
      if (responseData.statusCode == 200) {
        global.showToast(message: json.decode(responseData.body)['message']);

        return json.decode(responseData.body);
      } else if (responseData.statusCode == 400) {
        global.showToast(message: json.decode(responseData.body)['message']);
        return null;
      } else {
        return null;
      }
    } catch (e) {
      log('Exception: $screen -> $e');
      return null;
    }
  }

  //----------------------------------------astrologer review-----------------------------------//

  //get customer review for astrologer
  Future<dynamic> getCustomerReview(int id) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getAstrologerUserReview"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": id}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        recordList = List<CustomerReviewModel>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => CustomerReviewModel.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getCustomerReview():-$e');
    }
  }

  //Reply astrologer review
  Future<dynamic> astrologerReply(int id, String reply) async {
    try {
      print("${appParameters[appMode]['apiUrl']}userReview/reply");
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}userReview/reply"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"reviewId": id, "reply": reply}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - astrologerReply():-$e');
    }
  }

  //---------------------------------- Live Astrologer --------------------------------

  //send liveAstrologer token

  Future sendLiveAstrologerToken(
    dynamic astrologerId,
    String channelName,
    String token,
    String chatToken,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}liveAstrologer/add"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "astrologerId": astrologerId,
          "channelName": channelName,
          "token": token,
        }),
      );

      print(
        'liveAstrologer body is -> ${json.encode({
              "astrologerId": astrologerId,
              "channelName": channelName,
              "token": token
            })}',
      );
      print('statuscoderecord : ${response.statusCode}');
      log('liveAstrologer response is->  : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        log("data is  $data");

        // check if zegocloud exists and token is not null
        if (data["zegocloud"] != null && data["zegocloud"]["token"] != null) {
          final zegoData = data["zegocloud"];

          global.zegoAuthToken = zegoData["token"];
          global.zegoLiveID = zegoData["roomId"];
          global.zegoUserid = zegoData["user_id"];

          log("✅ Zego Token: ${global.zegoAuthToken}");
          log("✅ Zego User ID: ${global.zegoUserid}");
          log("✅ Zego Room ID: ${global.zegoLiveID}");

          // use them where needed
        }
        // ✅ Check if hms_auth_token is present
        else if (data['hms_response'] != null &&
            data['hms_response']['auth_token'] != null) {
          final authToken = data['hms_response']['auth_token'];
          log("✅ Extracted HMS Auth Token: $authToken");
          // store globally if needed
          global.hmsauthToken = authToken;
          log("✅ Extracted HMS Auth Token 2 $authToken");
          recordList = null;
        } else {
          print("No hms_response found in response");
          recordList = json.decode(response.body)['recordList'];
        }
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - addAstromallProdcut(): $e");
    }
  }

  Future<dynamic> getWaitList(String channel) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}waitlist/get"),
        body: {"channelName": channel},
      );
      dynamic recordList;
      print('jnkjnkasdnknk');
      print('${response.statusCode}');
      print('wait list reponse -> ${response.body}');

      if (response.statusCode == 200) {
        recordList = List<WaitList>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => WaitList.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getAstrologer():$e');
    }
  }

  Future<dynamic> scheduleLive({
    required DateTime dateTime,
    required String astrologerId,
  }) async {
    try {
      final date = DateFormat('yyyy-MM-dd').format(dateTime);
      final time = DateFormat('HH:mm:ss').format(dateTime);
      final bodyData = {
        "schedule_live_date": date,
        "schedule_live_time": time,
        "astrologerId": astrologerId,
      };

      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}schedule-live"),
        headers: await global.getApiHeaders(true),
        body: json.encode(bodyData), // ✅ encode as JSON string
      );
      print("schedule live body -> ${json.encode(bodyData)}");
      print("schedule live response -> ${response.body}");
      if (response.statusCode == 200) {
        return getAPIResult(response, null);
      } else {
        return getAPIResult(response, null);
      }
    } catch (e) {
      print("Exception in scheduleLive(): $e");
    }
  }

  Future<dynamic> getScheduleLiveList() async {
    try {
      final response = await http.get(
        Uri.parse("${appParameters[appMode]['apiUrl']}scheduleLive/list"),
        headers: await global.getApiHeaders(true),
      );

      print("schedule live list response -> ${response.body}");
      log("schedule statuscode ${response.statusCode} and type is ${response.statusCode.runtimeType}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        log('inside type is ${data["status"]} and type is ${data["status"].runtimeType}');
        List<ScheduleLive> schedules = [];
        if (data["data"] != null) {
          schedules = List<ScheduleLive>.from(
            data["data"].map((x) => ScheduleLive.fromJson(x)),
          );
        }

        return getAPIResult(response, schedules);
      } else {
        return getAPIResult(response, null);
      }
    } catch (e) {
      print("Exception in getScheduleLiveList(): $e");
    }
  }

  Future<dynamic> deleteScheduleLive(int itemid) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}schedule/delete"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"scheduleId": itemid}),
      );
      log('response delete is -> ${response.body}');
      return getAPIResult(response, null);
    } catch (e) {
      print("Exception in deleteScheduleLive: $e");
      return null;
    }
  }

  Future sendLiveAstrologerChatToken(
    int astrologerId,
    String channelName,
    String token,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          "${appParameters[appMode]['apiUrl']}liveAstrologer/livechattoken",
        ),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "astrologerId": astrologerId,
          "channelName": channelName,
          "liveChatToken": token,
        }),
      );
      print('sendLiveAstrologerChatToken-  $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
        log('live chat token save successfully');
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print(
        "Exception: $screen - sendLiveAstrologerChatToken(): $e",
      );
    }
  }

  Future endLiveSession(int astrologerId) async {
    try {
      final response = await http.post(
        Uri.parse(
          "${appParameters[appMode]['apiUrl']}liveAstrologer/endSession",
        ),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": astrologerId}),
      );
      log('endLiveSession response : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - endLiveSession(): $e");
    }
  }

  //-------------------------------Follower---------------------------------//
  Future<dynamic> getFollowersList(int id, int startIndex, int record) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getAstrologerFollower"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "astrologerId": id,
          "startIndex": startIndex,
          "fetchRecord": record,
        }),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        recordList = List<FollowingModel>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => FollowingModel.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getFollowersList():-$e');
    }
  }

  //-------------------------------Wallet---------------------------------//
  Future<dynamic> withdrawAdd(
    int id,
    double withdrawAmount,
    String paymentMethod,
    String upiId,
    String accountNumber,
    String ifscCode,
    String accountHolderName,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}withdrawlrequest/add"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "astrologerId": id,
          "withdrawAmount": withdrawAmount,
          "paymentMethod": paymentMethod,
          "upiId": upiId,
          "accountHolderName": accountHolderName,
          "accountNumber": accountNumber,
          "ifscCode": ifscCode,
        }),
      );
      print('withdrawAdd : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - withdrawAdd(): $e");
    }
  }

  //update withdraw
  Future<dynamic> withdrawUpdate(
    int id,
    int astrologerId,
    double withdrawAmount,
    String paymentMethod,
    String upiId,
    String accountNumber,
    String ifscCode,
    String accountHolderName,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}withdrawlrequest/update"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "id": id,
          "astrologerId": astrologerId,
          "withdrawAmount": withdrawAmount,
          "paymentMethod": paymentMethod,
          "upiId": upiId,
          "accountHolderName": accountHolderName,
          "accountNumber": accountNumber,
          "ifscCode": ifscCode,
        }),
      );
      print('withdrawUpdate : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - withdrawUpdate(): $e");
    }
  }

  //get amount
  Future<dynamic> getWithdrawAmount(int id) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}withdrawlrequest/get"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": id}),
      );
      dynamic recordList;
      log('wallet response: ${response.body}');
      if (response.statusCode == 200) {
        recordList = Withdraw.fromJson(
          json.decode(response.body)["recordList"],
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getWithdrawAmount():-$e');
    }
  }

  //-------------------------------Notification---------------------------------//
  Future<dynamic> getNotification(int startIndex, int record) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getUserNotification"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"startIndex": startIndex, "fetchRecord": record}),
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<NotificationModel>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => NotificationModel.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getNotification():-$e');
    }
  }

  Future<dynamic> checkContact(String phoneno, String logintype) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${appParameters[appMode]['apiUrl']}checkContactNoExistForUser',
        ),
        headers: await global.getApiHeaders(false),
        body: json.encode({
          "contactNo": phoneno,
          'fromApp': 'astrologer',
          'type': logintype,
        }),
      );
      dynamic recordList;
      log('checkContact respons for $logintype is ->  ${response.body}');
      recordList = response;
      return recordList;
    } catch (e) {
      print('Exception:- in checkContact $e');
    }
  }

  Future<dynamic> deleteNotification(int notificationId) async {
    try {
      final response = await http.post(
        Uri.parse(
          "${appParameters[appMode]['apiUrl']}userNotification/deleteUserNotification",
        ),
        headers: await global.getApiHeaders(true),
        body: json.encode({"id": notificationId}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - deteNotification():-$e');
    }
  }

  Future<dynamic> uploadPujaImageToServer(
    List<String> imagePath,
    String pujaName,
    String pujaDescription,
    String pujaStartDateTime,
    String pujaduration,
    String pujaPlace,
    String pujaPrice,
  ) async {
    for (var img in imagePath) {
      log('image are path: uploading is $img');
    }

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${appParameters[appMode]['apiUrl']}addAstrologerPuja"),
      );
      // Add API headers
      request.headers.addAll(
        await global.getApiHeaders(true, ismultipart: true),
      );
      request.fields['astrologerId'] = global.user.id.toString();
      request.fields['puja_title'] = pujaName;
      request.fields['long_description'] = pujaDescription;
      request.fields['puja_start_datetime'] = pujaStartDateTime;
      request.fields['puja_duration'] = pujaduration;
      request.fields['puja_place'] = pujaPlace;
      request.fields['puja_price'] = pujaPrice;
      request.fields['mediaType'] = 'image';

      // Add images to request
      for (int i = 0; i < imagePath.length; i++) {
        File imageFile = File(imagePath[i]);
        List<int> imageBytes = await imageFile.readAsBytes();
        String filename = imagePath[i].split('/').last;
        log('uploiading image name is $filename');
        http.MultipartFile imageMultipartFile = http.MultipartFile.fromBytes(
          'puja_images[]',
          imageBytes,
          filename: filename,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(imageMultipartFile);
      }

      // Send request and handle response
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      log('response status code: ${response.statusCode}');
      log('response body video: $responseBody');

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = pujaImageModelFromJson(responseBody);
      } else if (response.statusCode == 400) {
        recordList = null;
        var responseData = json.decode(responseBody);
        if (responseData['error']['puja_start_datetime'] != null) {
          global.showToast(
            message: '${responseData['error']['puja_start_datetime']}',
          );
        } else {
          global.showToast(message: '${responseData['error']['puja_place']}');
        }
        recordList = null;
      }

      return recordList;
    } catch (e) {
      log('Exception during file upload: $e');
      rethrow;
    }
  }

  Future<ImageModel> uploadImageFileToServer({
    required String id,
    List<String>? imagePath,
  }) async {
    log('rastrologer id : $id');
    for (var img in imagePath!) {
      log('image are path: uploading is $img');
    }

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${appParameters[appMode]['apiUrl']}addStory"),
      );
      // Add API headers
      request.headers.addAll(
        await global.getApiHeaders(true, ismultipart: true),
      );
      request.fields['astrologerId'] = id;
      request.fields['mediaType'] = 'image';

      // Add images to request
      for (int i = 0; i < imagePath.length; i++) {
        File imageFile = File(imagePath[i]);
        List<int> imageBytes = await imageFile.readAsBytes();
        String filename = imagePath[i].split('/').last;
        log('uploiading image name is $filename');
        http.MultipartFile imageMultipartFile = http.MultipartFile.fromBytes(
          'media[]',
          imageBytes,
          filename: filename,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(imageMultipartFile);
      }

      // Send request and handle response
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      log('response status code: ${response.statusCode}');
      log('response body video: $responseBody');

      ImageModel recordList;
      if (response.statusCode == 200) {
        recordList = imageModelFromJson(responseBody);
      } else {
        recordList = ImageModel(message: 'Failed to upload images');
      }
      return recordList;
    } catch (e) {
      log('Exception during file upload: $e');
      rethrow;
    }
  }

  Future<VideoModel> uploadFileToServer({
    required String id,
    File? videoFile,
  }) async {
    log('rastrologer id : $id');

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${appParameters[appMode]['apiUrl']}addStory"),
      );
      request.headers.addAll(
        await global.getApiHeaders(true, ismultipart: true),
      );
      request.fields['astrologerId'] = id;
      request.fields['mediaType'] = 'video';

      List<int> videoBytes = videoFile!.readAsBytesSync();
      final videoFileinBytes = http.MultipartFile.fromBytes(
        'media',
        videoBytes,
        filename: 'video.mp4',
        contentType: MediaType('video', 'mp4'),
      );
      request.files.add(videoFileinBytes);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      log('response log status code: ${response.statusCode}');
      log('response log body: $responseBody');

      VideoModel recordList;
      if (response.statusCode == 200) {
        recordList = videoModelFromJson(responseBody);
      } else {
        recordList = VideoModel(message: 'Failed to upload video');
      }
      return recordList;
    } catch (e) {
      log('Exception during file upload: $e');
      rethrow;
    }
  }

  Future<StoryTextModel> uploadTextToServer({
    required String id,
    String? txts,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}addStory"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "astrologerId": id,
          'mediaType': 'text',
          'media': txts,
        }),
      );
      log('text response ${response.body}');
      StoryTextModel recordList;
      if (response.statusCode == 200) {
        recordList = storyTextModelFromJson(response.body);
      } else {
        recordList = StoryTextModel(message: 'Failed to upload video');
      }
      return recordList;
    } catch (e) {
      log('Exception during text upload: $e');
      rethrow;
    }
  }

  // BANK IFSC VERIFY API CALL
  Future<dynamic> verifyIFSC(String? ifscCode) async {
    log('Ifcd code Id $ifscCode');

    try {
      final response = await http.get(
        Uri.parse("https://ifsc.razorpay.com/$ifscCode"),
      );
      log('verifyIFSC body ${response.body}');

      dynamic bankdetailmodel;
      if (response.statusCode == 200) {
        bankdetailmodel = bankDetailsModelFromJson(response.body);
        log('Yes Printed $bankdetailmodel');
      } else {
        bankdetailmodel = null;
      }
      return bankdetailmodel;
    } catch (e) {
      print('Exception in verifyIFSC$e');
    }
  }

  Future<dynamic> getAstroStory(String astrologerId) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getStory"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": astrologerId}),
      );
      print("getAstroStory ${jsonDecode(response.body)}");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<ViewStories>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => ViewStories.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getStory():$e');
    }
  }

  Future<dynamic> deleteStory(String storyId) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}deleteStory"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"StoryId": storyId}),
      );

      log("viewSigleStory ${jsonDecode(response.body)}");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
        log('send recordlist is -> $recordList');
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getStory():$e');
    }
  }

  Future<dynamic> deleteAllNotification(int userId) async {
    try {
      final response = await http.post(
        Uri.parse(
          "${appParameters[appMode]['apiUrl']}userNotification/deleteAllNotification",
        ),
        headers: await global.getApiHeaders(true),
        body: json.encode({"userId": userId}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - deleteAllNotification():-$e');
    }
  }

  Future<dynamic> getLiveUsers(String channelName) async {
    try {
      final response = await http.post(
        Uri.parse('${appParameters[appMode]['apiUrl']}getLiveUser'),
        body: json.encode({"channelName": channelName}),
        headers: await global.getApiHeaders(false),
      );
      print('getLiveUsers get live: ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<LiveUserModel>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => LiveUserModel.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getLiveUsers : -$e");
    }
  }

  Future<dynamic> addKundli(
    List<KundliModelAdd> basicDetails,
    bool ismatch,
    int amount,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${appParameters[appMode]['apiUrl']}kundali/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "kundali": basicDetails,
          "amount": amount,
          "is_match": ismatch,
        }),
      );

      log('kundli added ${response.body}');

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
        log('kundli recordList $recordList');
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in add-Kundli:- $e');
    }
  }

  Future<dynamic> updateKundli(int id, KundliModel basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('${appParameters[appMode]['apiUrl']}kundali/update/$id'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in updateKundli:-$e');
    }
  }

  Future<dynamic> deleteKundli(int id) async {
    try {
      final response = await http.post(
        Uri.parse('${appParameters[appMode]['apiUrl']}kundali/delete'),
        body: json.encode({"id": "$id"}),
        headers: await global.getApiHeaders(true),
      );
      print('deleteKundli : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in deleteKundli : -$e");
    }
  }

  Future<dynamic> getKundli() async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getkundali"),
        headers: await global.getApiHeaders(true),
      );
      print('get kundli by list ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<KundliModel>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => KundliModel.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getKundli():$e');
    }
  }

  Future<dynamic> getSystemFlag() async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getSystemFlag"),
        headers: await global.getApiHeaders(true),
      );
      log('getSystemFlag response ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<SystemFlag>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => SystemFlag.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getSystemFlag():-$e');
    }
  }

  Future<dynamic> addChatWaitList({
    int? astrologerId,
    String? status,
    DateTime? datetime,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}addStatus"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "astrologerId": astrologerId,
          "status": status,
          "waitTime": datetime?.toIso8601String(),
        }),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
        print('set status is: ${response.body}');
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - addChatWaitList(): $e');
    }
  }

  Future<dynamic> addCallWaitList({
    int? astrologerId,
    String? status,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}addCallStatus"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "astrologerId": astrologerId,
          "status": status,
          "waitTime": '',
        }),
      );
      log('call status response ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - addCallWaitList(): $e');
    }
  }

  Future<bool> setAstrologerOnOffBusyline(String callStatus) async {
    try {
      log("set status is: $callStatus");
      await Get.find<CallAvailabilityController>().statusCallChange(
        astroId: global.user.id!,
        callStatus: callStatus,
      );
      await Get.find<ChatAvailabilityController>().statusChatChange(
        astroId: global.user.id!,
        chatStatus: callStatus,
      );
      return true;
    } catch (error) {
      log('error $error');
      global.hideLoader();
      return false;
    }
  }

  Future<dynamic> getReport({
    int? day,
    int? month,
    int? year,
    int? hour,
    int? min,
    double? lat,
    double? lon,
    double? tzone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/general_ascendant_report"),
        body: json.encode({
          "day": day,
          "month": month,
          "year": year,
          "hour": hour,
          "min": min,
          "lat": lat,
          "lon": lon,
          "tzone": tzone,
        }),
        headers: {
          "authorization": "Basic ${base64.encode(
            "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                .codeUnits,
          )}",
          "Content-Type": 'application/json',
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getReportDasha():$e');
    }
  }

  Future<dynamic> getHororscopeSign() async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getHororscopeSign"),
        headers: await global.getApiHeaders(true),
      );
      log('getHororscopeSign response ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<HororscopeSignModel>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => HororscopeSignModel.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getHororscopeSign():$e');
    }
  }

  Future<dynamic> getMatching(int boyid, int girlid) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}KundaliMatching/report"),
        body: json.encode({
          "male_kundli_id": boyid,
          "female_kundli_id": girlid,
        }),
        headers: await global.getApiHeaders(true),
      );
      print("kundli macth:- ${json.encode({
            "male_kundli_id": boyid,
            "female_kundli_id": girlid,
          })}");
      dynamic recordList;
      print('matching res ${response.body}');
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }

      return recordList;
    } catch (e) {
      print('Exception in getDailyHororscope():$e');
    }
  }

  Future<dynamic> getManglic(
    int? dayBoy,
    int? monthBoy,
    int? yearBoy,
    int? hourBoy,
    int? minBoy,
    int? dayGirl,
    int? monthGirl,
    int? yearGirl,
    int? hourGirl,
    int? minGirl,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/match_manglik_report"),
        body: json.encode({
          "m_day": dayBoy,
          "m_month": monthBoy,
          "m_year": yearBoy,
          "m_hour": hourBoy,
          "m_min": minBoy,
          "m_lat": 19.132,
          "m_lon": 72.342,
          "m_tzone": 5.5,
          "f_day": dayGirl,
          "f_month": monthGirl,
          "f_year": yearGirl,
          "f_hour": hourGirl,
          "f_min": minGirl,
          "f_lat": 19.132,
          "f_lon": 72.342,
          "f_tzone": 5.5,
        }),
        headers: {
          "authorization": "Basic ${base64.encode(
            "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                .codeUnits,
          )}",
          "Content-Type": 'application/json',
        },
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }

      return recordList;
    } catch (e) {
      print('Exception in getDailyHororscope():$e');
    }
  }

  Future<dynamic> getKundaliPDf({required int userid}) async {
    try {
      final response = await http.post(
        Uri.parse('${appParameters[appMode]['apiUrl']}kundali/get/$userid'),
        headers: await global.getApiHeaders(true),
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
        print('response pdf $recordList');
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getKundliBasicDetails():$e');
    }
  }

  Future<dynamic> getKundliBasicDetails({
    int? day,
    int? month,
    int? year,
    int? hour,
    int? min,
    double? lat,
    double? lon,
    double? tzone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/birth_details"),
        body: json.encode({
          "day": day,
          "month": month,
          "year": year,
          "hour": hour,
          "min": min,
          "lat": lat,
          "lon": lon,
          "tzone": tzone,
        }),
        headers: {
          "authorization": "Basic ${base64.encode(
            "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                .codeUnits,
          )}",
          "Content-Type": "application/json",
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getKundliBasicDetails():$e');
    }
  }

  Future<dynamic> getKundliBasicPanchangDetails({
    int? day,
    int? month,
    int? year,
    int? hour,
    int? min,
    double? lat,
    double? lon,
    double? tzone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/basic_panchang"),
        body: json.encode({
          "day": day,
          "month": month,
          "year": year,
          "hour": hour,
          "min": min,
          "lat": lat,
          "lon": lon,
          "tzone": tzone,
        }),
        headers: {
          "authorization": "Basic ${base64.encode(
            "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                .codeUnits,
          )}",
          "Content-Type": 'application/json',
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getKundliBasicPanchangDetails():$e');
    }
  }

  Future<dynamic> getAvakhadaDetails({
    int? day,
    int? month,
    int? year,
    int? hour,
    int? min,
    double? lat,
    double? lon,
    double? tzone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/astro_details"),
        body: json.encode({
          "day": day,
          "month": month,
          "year": year,
          "hour": hour,
          "min": min,
          "lat": lat,
          "lon": lon,
          "tzone": tzone,
        }),
        headers: {
          "authorization": "Basic ${base64.encode(
            "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                .codeUnits,
          )}",
          "Content-Type": 'application/json',
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getAvakhadaDetails():$e');
    }
  }

  Future<dynamic> getPlanetsDetail({
    int? day,
    int? month,
    int? year,
    int? hour,
    int? min,
    double? lat,
    double? lon,
    double? tzone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/planets"),
        body: json.encode({
          "day": day,
          "month": month,
          "year": year,
          "hour": hour,
          "min": min,
          "lat": lat,
          "lon": lon,
          "tzone": tzone,
        }),
        headers: {
          "authorization": "Basic ${base64.encode(
            "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                .codeUnits,
          )}",
          "Content-Type": 'application/json',
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getAvakhadaDetails():$e');
    }
  }

  Future<dynamic> getSadesati({
    int? day,
    int? month,
    int? year,
    int? hour,
    int? min,
    double? lat,
    double? lon,
    double? tzone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/sadhesati_current_status"),
        body: json.encode({
          "day": day,
          "month": month,
          "year": year,
          "hour": hour,
          "min": min,
          "lat": lat,
          "lon": lon,
          "tzone": tzone,
        }),
        headers: {
          "authorization": "Basic ${base64.encode(
            "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                .codeUnits,
          )}",
          "Content-Type": 'application/json',
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getSadesati():$e');
    }
  }

  Future<dynamic> getKalsarpa({
    int? day,
    int? month,
    int? year,
    int? hour,
    int? min,
    double? lat,
    double? lon,
    double? tzone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/kalsarpa_details"),
        body: json.encode({
          "day": day,
          "month": month,
          "year": year,
          "hour": hour,
          "min": min,
          "lat": lat,
          "lon": lon,
          "tzone": tzone,
        }),
        headers: {
          "authorization": "Basic ${base64.encode(
            "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                .codeUnits,
          )}",
          "Content-Type": 'application/json',
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getKalsarpa():$e');
    }
  }

  Future<dynamic> getGemstone({
    int? day,
    int? month,
    int? year,
    int? hour,
    int? min,
    double? lat,
    double? lon,
    double? tzone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/basic_gem_suggestion"),
        body: json.encode({
          "day": day,
          "month": month,
          "year": year,
          "hour": hour,
          "min": min,
          "lat": lat,
          "lon": lon,
          "tzone": tzone,
        }),
        headers: {
          "authorization": "Basic ${base64.encode(
            "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                .codeUnits,
          )}",
          "Content-Type": 'application/json',
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getGemstone():$e');
    }
  }

  Future<dynamic> getVimshattari({
    int? day,
    int? month,
    int? year,
    int? hour,
    int? min,
    double? lat,
    double? lon,
    double? tzone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/major_vdasha"),
        body: json.encode({
          "day": day,
          "month": month,
          "year": year,
          "hour": hour,
          "min": min,
          "lat": lat,
          "lon": lon,
          "tzone": tzone,
        }),
        headers: {
          "authorization": "Basic ${base64.encode(
            "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                .codeUnits,
          )}",
          "Content-Type": 'application/json',
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = (json.decode(response.body) as List)
            .map((e) => VimshattariModel.fromJson(e))
            .toList();
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getVimshattari():$e');
    }
  }

  Future<dynamic> getAntardasha({
    String? antarDasha,
    int? day,
    int? month,
    int? year,
    int? hour,
    int? min,
    double? lat,
    double? lon,
    double? tzone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/sub_vdasha/$antarDasha"),
        body: json.encode({
          "day": day,
          "month": month,
          "year": year,
          "hour": hour,
          "min": min,
          "lat": lat,
          "lon": lon,
          "tzone": tzone,
        }),
        headers: {
          "authorization": "Basic ${base64.encode(
            "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                .codeUnits,
          )}",
          "Content-Type": 'application/json',
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = (json.decode(response.body) as List)
            .map((e) => VimshattariModel.fromJson(e))
            .toList();
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getAntardasha():$e');
    }
  }

  Future<dynamic> getPatynatarDasha({
    String? firstName,
    String? secoundName,
    int? day,
    int? month,
    int? year,
    int? hour,
    int? min,
    double? lat,
    double? lon,
    double? tzone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/sub_sub_vdasha/Mars/Rahu"),
        body: json.encode({
          "day": day,
          "month": month,
          "year": year,
          "hour": hour,
          "min": min,
          "lat": lat,
          "lon": lon,
          "tzone": tzone,
        }),
        headers: {
          "authorization": "Basic ${base64.encode(
            "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                .codeUnits,
          )}",
          "Content-Type": 'application/json',
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = (json.decode(response.body) as List)
            .map((e) => VimshattariModel.fromJson(e))
            .toList();
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getPatynatarDasha():$e');
    }
  }

  Future<dynamic> getSookshmaDasha({
    int? day,
    int? month,
    int? year,
    int? hour,
    int? min,
    double? lat,
    double? lon,
    double? tzone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          "https://json.astrologyapi.com/v1/sub_sub_sub_vdasha/Mars/Rahu/Jupiter",
        ),
        body: json.encode({
          "day": day,
          "month": month,
          "year": year,
          "hour": hour,
          "min": min,
          "lat": lat,
          "lon": lon,
          "tzone": tzone,
        }),
        headers: {
          "authorization": "Basic ${base64.encode(
            "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                .codeUnits,
          )}",
          "Content-Type": 'application/json',
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = (json.decode(response.body) as List)
            .map((e) => VimshattariModel.fromJson(e))
            .toList();
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getSookshmaDasha():$e');
    }
  }

  Future<dynamic> getPrana({
    int? day,
    int? month,
    int? year,
    int? hour,
    int? min,
    double? lat,
    double? lon,
    double? tzone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          "https://json.astrologyapi.com/v1/sub_sub_sub_sub_vdasha/Mars/Rahu/Jupiter/Saturn",
        ),
        body: json.encode({
          "day": day,
          "month": month,
          "year": year,
          "hour": hour,
          "min": min,
          "lat": lat,
          "lon": lon,
          "tzone": tzone,
        }),
        headers: {
          "authorization": "Basic ${base64.encode(
            "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                .codeUnits,
          )}",
          "Content-Type": 'application/json',
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = (json.decode(response.body) as List)
            .map((e) => VimshattariModel.fromJson(e))
            .toList();
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getPrana():$e');
    }
  }

  ///
  Future<dynamic> geoCoding({double? lat, double? long}) async {
    try {
      print(
          "astrologyapiuser id- ${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}");
      print(
          "astrologyapiuser id- ${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}");
      print("${json.encode({"latitude": lat, "longitude": long})}");
      print("${{
        "authorization": "Basic ${base64.encode(
          "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
              .codeUnits,
        )}",
        "Content-Type": 'application/json',
      }}");
      final response = await http.post(
        Uri.parse('https://json.astrologyapi.com/v1/timezone_with_dst'),
        body: json.encode({"latitude": lat, "longitude": long}),
        headers: {
          "authorization": "Basic ${base64.encode(
            "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                .codeUnits,
          )}",
          "Content-Type": 'application/json',
        },
      );
      print('geoCoding : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in geoCoding : -$e");
    }
  }

  Future<dynamic> generateRtmToken(
    String agoraAppId,
    String agoraAppCertificate,
    String chatId,
    String channelName,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${appParameters[appMode]['apiUrl']}generateToken'),
        body: json.encode({
          "appID": agoraAppId,
          "appCertificate": agoraAppCertificate,
          "user": chatId,
          "channelName": channelName,
        }),
        headers: await global.getApiHeaders(true),
      );
      log('generateRtmToken body : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in generateRtmToken : -$e");
    }
  }

  Future<dynamic> getKundliChartforChat(String id) async {
    final modelbody = json.encode({"userId": id});

    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getKundaliReportById"),
        headers: await global.getApiHeaders(true),
        body: modelbody,
      );
      log('kundli res is getKundliChartforChat ${response.body}');
      dynamic kundlichartmodel;
      if (response.statusCode == 200) {
        kundlichartmodel = kundliChartModelFromJson(response.body);
      } else {
        kundlichartmodel = null;
      }
      return kundlichartmodel;
    } catch (e) {
      print('Exception in getkundliChart original():$e');
    }
  }

  Future<dynamic> getKundliChart(KundliModel kundlimode) async {
    var id = kundlimode.id;
    var name = kundlimode.name;
    var gender = kundlimode.gender;
    var birthDate = kundlimode.birthDate;
    var birthTime = kundlimode.birthTime;
    var birthPlace = kundlimode.birthPlace;
    var latitude = kundlimode.latitude;
    var longitude = kundlimode.longitude;
    var timezone = kundlimode.timezone;
    var lang = kundlimode.lang ?? "en";
    final modelbody = json.encode({
      "kundali": [
        {
          "id": id,
          "lang": lang,
          "name": name,
          "gender": gender,
          "birthDate": birthDate.toIso8601String(),
          "birthTime": birthTime,
          "birthPlace": birthPlace,
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
          "timezone": timezone.toString(),
        },
      ],
    });
    log('kundli body is getKundliChart ${jsonEncode(modelbody)}');

    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}kundali/addnew"),
        headers: await global.getApiHeaders(true),
        body: modelbody,
      );
      log('kundli res is getKundliChart ${response.body}');
      dynamic kundlichartmodel;
      if (response.statusCode == 200) {
        kundlichartmodel = kundliChartModelFromJson(response.body);
      } else {
        kundlichartmodel = null;
      }
      return kundlichartmodel;
    } catch (e) {
      print('Exception in getkundliChart original():$e');
    }
  }

  Future<dynamic> generateRtcToken(
    String agoraAppId,
    String agoraAppCertificate,
    String chatId,
    String channelName,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${appParameters[appMode]['apiUrl']}generateRtcToken'),
        body: json.encode({
          "appID": agoraAppId,
          "appCertificate": agoraAppCertificate,
          "user": chatId,
          "channelName": channelName,
        }),
        headers: await global.getApiHeaders(true),
      );
      print('RTC token-generate : ${json.decode(response.body)}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in generateRtcToken : -$e");
    }
  }

  Future<dynamic> getBlog(
    String searchString,
    int startIndex,
    int fetchRecord,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${appParameters[appMode]['apiUrl']}getAppBlog'),
        headers: await global.getApiHeaders(false),
        body: json.encode({
          "searchString": searchString,
          "startIndex": startIndex,
          "fetchRecord": fetchRecord,
        }),
      );
      print('getBlog : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<Blog>.from(
          json.decode(response.body)["recordList"].map((x) => Blog.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getBlog : -$e");
    }
  }

  Future<dynamic> viewerCount(int id) async {
    try {
      final response = await http.post(
        Uri.parse('${appParameters[appMode]['apiUrl']}addBlogReader'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"blogId": "$id"}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in viewerCount $e');
    }
  }

  //get app review
  Future<dynamic> getAppReview() async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}appReview/get"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"appId": 2}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AppReviewModel>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => AppReviewModel.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getAppReview():$e');
    }
  }

  //boostDetails
  Future<dynamic> getBoostData() async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getProfileboost"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologer_id": global.currentUserId}),
      );
      print("boost body ${response.body}");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = GetBoostModel.fromJson(json.decode(response.body));
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getBoostDetails():$e');
    }
  }

  //.bost profile
  Future<dynamic> boostProfile() async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}boostProfile"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologer_id": global.currentUserId}),
      );
      print("boostProfile ${json.decode(response.body)['massage']}");
      Map recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else if (response.statusCode == 400) {
        recordList = json.decode(response.body);
      } else {
        recordList = {};
      }
      return recordList;
    } catch (e) {
      print('Exception in getBoostDetails():$e');
    }
  }

  //boostDetails
  Future<dynamic> getBoostHistory() async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}Profileboosthistory"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologer_id": global.currentUserId}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        print(response.body);
        recordList = ProfileboostHistory.fromJson(json.decode(response.body));
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getBoostHistory():$e');
    }
  }

  //product
  Future<dynamic> getProduct() async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getAstromallProduct"),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<ProdcutDataList>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => ProdcutDataList.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getProductScreen():$e');
    }
  }

  Future<dynamic> getpuja() async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getPujaList"),
        headers: await global.getApiHeaders(true),
      );
      log('pooja response is ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<PoojaList>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => PoojaList.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getKundli():$e');
    }
  }

  Future<dynamic> assignpujatoUserApi(dynamic userid, dynamic pojaid) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}sendPujatoUser"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "astrologerId": global.user.id,
          "userId": userid,
          "puja_id": pojaid,
        }),
      );
      print("${json.encode({
            "astrologerId": global.user.id,
            "userId": userid,
            "puja_id": pojaid,
          })}");
      log('assignpujatoUserApi response is ${response.body}');
      dynamic recordList;
      global.showToast(message: json.decode(response.body)['message']);

      Get.back();
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in assignpujatoUserApi():$e');
    }
  }

  Future<dynamic> getCustompuja() async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}astrologerPujaList"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": global.user.id}),
      );
      log('getCustompuja response is ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<CustomPujaModel>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => CustomPujaModel.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getKundli():$e');
    }
  }

  //------create ticket------------
  Future<dynamic> creaeteTicket(var basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('${appParameters[appMode]['apiUrl']}ticket/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      log("log bodydata ${json.encode(basicDetails)}");
      log("creaeteTicket body ${response.body}");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in creaetTicket:- $e');
    }
  }

  //------------Fetch Tickets--------------------
  Future<dynamic> getTickets(var bodyData) async {
    try {
      print("get Tickets body Data $bodyData");
      final response = await http.post(
        Uri.parse('${appParameters[appMode]['apiUrl']}getTicket'),
        body: json.encode(bodyData),
        headers: await global.getApiHeaders(true),
      );
      log('getTickets response body: ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstrologerTickets>.from(json
            .decode(response.body)["recordList"]
            .map((x) => AstrologerTickets.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getTickets : -$e");
    }
  }

  Future<dynamic> getTicketStatus() async {
    try {
      final response = await http.post(
        Uri.parse('${appParameters[appMode]['apiUrl']}checkOpenTicket'),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in getTicketStatus:- $e');
    }
  }

  //! Edit custom puja
  Future<dynamic> editCustompuja(
    dynamic pujaId,
    List<String> imagePath,
    dynamic pujaName,
    dynamic pujaDescription,
    dynamic pujastartdatetime,
    dynamic pujaduration,
    dynamic pujaPlace,
    dynamic pujaPrice,
  ) async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${appParameters[appMode]['apiUrl']}addAstrologerPuja"),
      );
      // Add API headers
      request.headers.addAll(
        await global.getApiHeaders(true, ismultipart: true),
      );
      request.fields["puja_id"] = pujaId.toString();
      request.fields['astrologerId'] = global.user.id.toString();
      request.fields['puja_title'] = pujaName;
      request.fields['long_description'] = pujaDescription;
      request.fields['puja_start_datetime'] = pujastartdatetime;
      request.fields['puja_duration'] = pujaduration;
      request.fields['puja_place'] = pujaPlace;
      request.fields['puja_price'] = pujaPrice;
      request.fields['mediaType'] = 'image';

      // Add images to request
      for (int i = 0; i < imagePath.length; i++) {
        File imageFile = File(imagePath[i]);
        if (imagePath[i].startsWith('http')) {
        } else {
          List<int> imageBytes = await imageFile.readAsBytes();
          String filename = imagePath[i].split('/').last;
          log('uploiading image name is $filename');
          http.MultipartFile imageMultipartFile = http.MultipartFile.fromBytes(
            'puja_images[]',
            imageBytes,
            filename: filename,
            contentType: MediaType('image', 'jpeg'),
          );
          request.files.add(imageMultipartFile);
        }
      }
      // Send request and handle response
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      log('response edit status code: ${response.statusCode}');
      log('response edit body video: $responseBody');

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = pujaImageModelFromJson(responseBody);
      } else if (response.statusCode == 400) {
        recordList = null;
        var responseData = json.decode(responseBody);

        global.showToast(
          message: '${responseData['error']['puja_start_datetime']}',
        );
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      log('Exception during file upload: $e');
      rethrow;
    }
  }

  //deletepuja
  Future<dynamic> deletepuja(dynamic pujaId) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}deleteAstrologerPuja"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"id": pujaId, "astrologerId": global.user.id}),
      );
      log('deletepuja response is ${response.body}');
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return json.decode(response.body);
    } catch (e) {
      print('Exception in deletepuja():$e');
    }
  }

  Future<dynamic> postpuja(
    String pujaName,
    String pujaDescription,
    String pujaStartDateTime,
    String pujaEndDateTime,
    String pujaPlace,
    String pujaPrice,
    File? imgeFile,
  ) async {
    var request = http.MultipartRequest('POST', Uri.parse('your_api_endpoint'));

    if (imgeFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imgeFile.path),
      );
    }
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}addAstrologerPuja"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "astrologerId": global.user.id,
          "puja_title": pujaName,
          "long_description": pujaDescription,
          "puja_start_datetime": pujaStartDateTime,
          "puja_end_datetime": pujaEndDateTime,
          "puja_place": pujaPlace,
          "puja_price": pujaPrice,
        }),
      );
      print("postpuja response  ${response.body}");
      return json.decode(response.body);
    } catch (e) {
      print('Exception in postpuja():$e');
    }
  }

  Future<dynamic> addpujatRecommend(
    String pujaid,
    String userID,
    String astroId,
  ) async {
    log(
      'addpujatRecommend id is $pujaid and user id is $userID and astro id is $astroId',
    );
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}addPujaRecommend"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "puja_id": pujaid,
          "userId": astroId,
          "astrologerId": userID,
        }),
      );
      print("addpujatRecommend response  ${response.body}");
      return json.decode(response.body);
    } catch (e) {
      print('Exception in addpujatRecommend():$e');
    }
  }

  Future<dynamic> addProductRecommend(
    String productId,
    String userID,
    String astroId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}addProductRecommend"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "productId": productId,
          "userId": astroId,
          "astrologerId": userID,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      print('Exception in addProductRecommend():$e');
    }
  }

  Future<dynamic> addAppFeedback(var basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('${appParameters[appMode]['apiUrl']}appReview/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in addAppFeedback:-$e');
    }
  }

  Future getLanguagesForMultiLanguage() async {
    try {
      final response = await http.post(
        Uri.parse("${appParameters[appMode]['apiUrl']}getAppLanguage"),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<Language>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => Language.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: getLanguagesForMultiLanguage(): $e");
    }
  }

  //get called user data
  Future<dynamic> getIntakedata(int id) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${appParameters[appMode]['apiUrl']}chatRequest/getIntakeForm',
        ),
        headers: await global.getApiHeaders(true),
        body: json.encode({"userId": "$id"}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<IntakeModel>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => IntakeModel.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getIntakedata : -$e");
    }
  }
}
