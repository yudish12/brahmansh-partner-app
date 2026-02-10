// ignore_for_file: file_names, prefer_interpolation_to_compose_strings, avoid_print

import 'package:brahmanshtalk/models/customerReview_model.dart';
import 'package:brahmanshtalk/services/apiHelper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;

class CustomerReviewController extends GetxController {
  String screen = 'customerReview_controller.dart';
  APIHelper apiHelper = APIHelper();
  List<CustomerReviewModel> customerReviewList = [];

  final cReply = TextEditingController();

  @override
  void onInit() async {
    _init();
    super.onInit();
  }

  _init() async {
    ///   await getCustomerReviewList();
  }

  void clearReply() {
    cReply.text = '';
  }

//Report list
  Future getCustomerReviewList() async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            int id = global.user.id ?? 0;
            await apiHelper.getCustomerReview(id).then(
              (result) {
                global.hideLoader();
                if (result.status == "200") {
                  customerReviewList = result.recordList;
                  update();
                } else {
                  global.showToast(
                      message: tr("No customer review list is here"));
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - getCustomerReviewList():-' + e.toString());
    }
  }
}
