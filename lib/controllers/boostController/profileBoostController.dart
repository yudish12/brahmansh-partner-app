// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, file_names
import 'package:brahmanshtalk/models/boostModel.dart';
import 'package:brahmanshtalk/models/profileBoostHistory.dart';
import 'package:brahmanshtalk/services/apiHelper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;

class Profileboostcontroller extends GetxController {
  APIHelper apiHelper = APIHelper();
  BoostData? boostData;
  List<ProfileboosthistoryData> profileboosthistoryData = [];

  getBoostDetials() async {
    global.showOnlyLoaderDialog();
    try {
      await apiHelper.getBoostData().then((result) {
        if (result.status == 200) {
          boostData = result.recordList;
          print("boost Data $boostData");
          print("boost comission ${boostData!.callCommission}");
          global.hideLoader();
        } else {
          global.hideLoader();
          global.showToast(message: 'failed to getBoost Details');
        }
        update();
      });
    } catch (e) {
      print("Exception in  getboostdetials:-$e");
    }
  }

  var boostResponse;
  boostProfileScreen() async {
    global.showOnlyLoaderDialog();
    try {
      await apiHelper.boostProfile().then((result) {
        print("$result");
        if (result['status'] == 200) {
          boostResponse = result;
          global.showToast(
            message: "${boostResponse['massage']}",
          );
          getBoostDetials();
          global.hideLoader();
          global.hideLoader();
          update();
        } else if (result['status'] == 400) {
          boostResponse = result;
          global.showToast(
              bgcolors: Colors.red, message: "${boostResponse['error']}");
          global.hideLoader();
          global.hideLoader();
          update();
        } else {
          global.hideLoader();
          global.showToast(
              bgcolors: Colors.red, message: tr('failed to get Boost Details'));
        }
      });
    } catch (e) {
      print("Exception in  getboostdetials:-$e");
    }
  }

  profileBoostHistory() async {
    global.showOnlyLoaderDialog();
    try {
      await apiHelper.getBoostHistory().then((result) {
        if (result.status == 200) {
          profileboosthistoryData = result.recordList;
          global.hideLoader();
          update();
        } else {
          global.hideLoader();

          global.showToast(message: tr('failed to get Boost History'));
        }
      });
    } catch (e) {
      print("Exception in  getboosthistory:-$e");
    }
  }
}
