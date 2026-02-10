// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';
import 'package:brahmanshtalk/Courses/model/Detailmodel.dart';
import 'package:brahmanshtalk/Courses/model/coursemodel.dart';
import 'package:brahmanshtalk/services/apiHelper.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/KundliMatching/payment/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import '../model/courseorderlistmodel.dart';
import '../screen/OrderSuccessDialog.dart';

class CoursesController extends GetxController {
  var apiHelper = APIHelper();
  List<CourseModel>? courselist;
  ChapterDetailmodel? detailchapterlist;
  List<CourseOrderModel>? coursedetaillist;
  Future<int> getCoursesList() async {
    int value = 0;
    global.showOnlyLoaderDialog();
    try {
      await apiHelper.getCoursesApi().then((result) {
        debugPrint("getCoursesApi");
        global.hideLoader();
        if (result.status == "200") {
          courselist = result.recordList;
          update();
        } else {
          if (global.currentUserId != null) {
            global.showToast(
              message: 'Fail to get getCourses list',
            );
          }
          value = 0;
        }
      });
    } catch (e) {
      debugPrint("getpdfprice():- $e");
      value = 0;
    }
    return value;
  }

  Future<void> getCourseDetailsList(var courseId) async {
    global.showOnlyLoaderDialog();
    try {
      await apiHelper.getCourseDetailsApi(courseId).then((result) {
        debugPrint("getCourseDetailsApi");
        global.hideLoader();
        if (result is Map<String, dynamic>) {
          detailchapterlist = ChapterDetailmodel.fromJson(result);
        } else {
          log('Unexpected result type: ${result.runtimeType}');
        }

        update();
      });
    } catch (e) {
      debugPrint("getCourseDetailsApi():- $e");
    }
  }
  //buyCourse

  Future<int> buyCourse(var astrologerid, var courseId) async {
    int value = 0;
    try {
      await apiHelper.buyCourseApi(astrologerid, courseId).then((response) {
        debugPrint("buyCourse");
        log('buyCourse result is $response');
        log('buyCourse result is ${response.runtimeType}');
        log('buyCourse status is ${response?['status']}');

        if (response?['status'] == 200) {
          if (response?['message'] == "Pay Online.") {
            Get.to(() => PaymentScreen(url: response?['redirect']));
          } else if (response?['message'] == "Order Placed sucessfully!") {
            showOrderSuccessDialog(Get.context!, response, courseId);
            update();
          }
        } else {
          log('Unexpected result type: ${response.runtimeType}');
        }

        update();
      });
    } catch (e) {
      debugPrint("buyCourse():- $e");
      value = 0;
    }
    return value;
  }

//getCourseOrderList
  Future<void> getCourseOrderList(var astrologerid) async {
    try {
      await apiHelper.getCourseOrderListApi(astrologerid).then((response) {
        debugPrint("buyCourse");
        global.hideLoader();
        if (response.status == "200") {
          coursedetaillist = response.recordList;
        } else {
          if (global.currentUserId != null) {
            global.showToast(message: 'Fail to get Details');
          }
        }
        update();
      });
    } catch (e) {
      debugPrint("getCourseOrderListApi():- $e");
    }
  }

//mark as complete course
  markcourseRead(var courseorderid) async {
    global.showOnlyLoaderDialog();
    try {
      await apiHelper.markcourseReadApi(courseorderid).then((response) async {
        global.hideLoader();

        debugPrint("buyCourse");
        Map<String, dynamic> jsonResponse = json.decode(response);
        log('markcourseReadApi result is $jsonResponse');
        if (jsonResponse['status'] == 200) {
          Get.showSnackbar(GetBar(
            message: jsonResponse["message"],
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.TOP,
          ));
          await getCourseOrderList(global.currentUserId);
          update();
        } else {
          if (global.currentUserId != null) {
            global.showToast(message: 'Fail to set');
          }
        }

        update();
      });
    } catch (e) {
      debugPrint("getCourseOrderListApi():- $e");
    }
  }
}
