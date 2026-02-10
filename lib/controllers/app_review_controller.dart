// ignore_for_file: avoid_print

import 'package:brahmanshtalk/services/apiHelper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import '../models/app_review_model.dart';

class AppReviewController extends GetxController {
  final TextEditingController feedbackController = TextEditingController();
  APIHelper apiHelper = APIHelper();
  var clientReviews = <AppReviewModel>[];

  getAppReview() async {
    global.showOnlyLoaderDialog();
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAppReview().then((result) {
            if (result.status == "200") {
              clientReviews = result.recordList;
              update();
            } else {
              global.showToast(message: tr('Failed to get client testimonals'));
            }
          });
          global.hideLoader();
        }
      });
    } catch (e) {
      print("Exception in  getAppReview:-$e");
    }
  }

  addFeedback(String review) async {
    var appReviewModel = {
      "appId": global.reviewAppId,
      "review": review,
    };
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.addAppFeedback(appReviewModel).then((result) async {
            if (result.status == "200") {
              feedbackController.text = '';
              global.showToast(message: tr('Thank you!'));
              await getAppReview();
            } else {
              global.showToast(message: tr('Failed to add feedback'));
            }
          });
        }
      });
    } catch (e) {
      print("Exception in addFeedback():- $e");
    }
  }
}
