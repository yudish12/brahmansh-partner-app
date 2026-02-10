import 'dart:developer';
import 'package:brahmanshtalk/models/kundliBasicModel.dart';
import 'package:brahmanshtalk/models/panchangModel.dart';
import 'package:brahmanshtalk/models/vadicPanchangModel.dart';
import 'package:brahmanshtalk/services/apiHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:intl/intl.dart';

class PanchangController extends GetxController {
  APIHelper apiHelper = APIHelper();
  PanchangModel? panchangList;
  VedicPanchangModel? vedicPanchangModel;
  KundliBasicPanchangDetail? kundliBasicPanchangDetail;

  @override
  void onInit() {
    _inIt();
    super.onInit();
  }

  DateTime now = DateTime.now();
  late String formattedDate = DateFormat('MMM d, EEEE').format(now);

  // final AstromallController astromallController =
  //     Get.find<AstromallController>();
  _inIt() async {
    getPanchangVedic(DateTime.now());
    // astromallController.getAstromallCategory(false);
    debugPrint("nextDay");
    debugPrint("${DateTime.now().add(const Duration(days: -1))}");
  }

  // getPanchangDetail(
  //     {int? day,
  //     int? month,
  //     int? year,
  //     int? hour,
  //     int? min,
  //     double? lat,
  //     double? lon,
  //     double? tzone}) async {
  //   try {
  //     await global.checkBody().then((result) async {
  //       if (result) {
  //         await apiHelper
  //             .getAdvancedPanchang(
  //                 day: day,
  //                 month: month,
  //                 year: year,
  //                 hour: hour,
  //                 min: min,
  //                 lat: lat,
  //                 lon: lon,
  //                 tzone: tzone)
  //             .then((result) {
  //           if (result.status == "200") {
  //             Map<String, dynamic> map = result;
  //             panchangList = PanchangModel.fromJson(map);
  //             update();
  //           } else {
  //             global.showToast(
  //               message: 'Failed to get Panchang',
  //               textColor: global.textColor,
  //               bgColor: global.toastBackGoundColor,
  //             );
  //           }
  //           update();
  //         });
  //       }
  //     });
  //   } catch (e) {
  //     print('Exception in getPanchangDetail():' + e.toString());
  //   }
  // }

  getBasicPanchangDetail(
      {int? day,
      int? month,
      int? year,
      int? hour,
      int? min,
      double? lat,
      double? lon,
      double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getKundliBasicPanchangDetails(
                  day: day,
                  month: month,
                  year: year,
                  hour: hour,
                  min: min,
                  lat: lat,
                  lon: lon,
                  tzone: tzone)
              .then((result) {
            if (result != null) {
              Map<String, dynamic> map = result;
              kundliBasicPanchangDetail =
                  KundliBasicPanchangDetail.fromJson(map);
              update();
            } else {
              // global.showToast(
              //   message: 'Fail to getKundliBasicPanchangDetails',
              // );
            }
            update();
          });
        }
      });
    } catch (e) {
      debugPrint('Exception in getBasicPanchangDetail():$e');
    }
  }

  getPanchangVedic(DateTime date, {bool isloadingshowing = false}) async {
    isloadingshowing ? global.showOnlyLoaderDialog() : null;
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getPanchangVedic(date.toString().split(" ").first)
              .then((result) {
            isloadingshowing ? global.hideLoader() : null;
            if (result['status'].toString() == "200") {
              Map<String, dynamic> map = result;
              vedicPanchangModel = VedicPanchangModel.fromJson(map);
              update();
            } else {
              global.showToast(
                message: 'Failed to get Panchang',
              );
            }
            update();
          });
        }
      });
    } catch (e) {
      debugPrint('Exception in getPanchangDetailVedic():$e');
    }
  }

  int commondate = 0;
  nextDate(bool nextDay) {
    nextDay ? commondate++ : commondate--;
    update();

    log('set commondate is  $commondate');

    nextDay
        ? getPanchangVedic(DateTime.now().add(Duration(days: commondate)),
            isloadingshowing: true)
        : getPanchangVedic(DateTime.now().add(Duration(days: commondate)),
            isloadingshowing: true);
  }
}
