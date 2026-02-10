// ignore_for_file: avoid_print, file_names

import 'dart:developer';
import 'dart:io';
import 'package:brahmanshtalk/models/productModelScreen.dart';
import 'package:brahmanshtalk/services/apiHelper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import '../../models/PoojaList.dart';
import '../custompujaModel.dart';

class Productcontroller extends GetxController {
  APIHelper apiHelper = APIHelper();
  var productData = <ProdcutDataList>[];
  bool isloading = false;

  int? selectedProduct = -1, selectpuja = -1, suggestpuja = -1;
  void selectProduct(int index) {
    index == selectedProduct ? selectedProduct = -1 : selectedProduct = index;
    update();
  }

  void selectPuja(int index) {
    index == selectpuja ? selectpuja = -1 : selectpuja = index;
    update();
  }

  void suggestPuja(int index) {
    index == suggestpuja ? suggestpuja = -1 : suggestpuja = index;
    update();
  }

  getProductList() async {
    global.showOnlyLoaderDialog();
    try {
      await apiHelper.getProduct().then((result) {
        if (result.status == "200") {
          global.hideLoader();
          print("after 200:- ${result.recordList}");
          productData = result.recordList;
          update();
        } else {
          global.showToast(message: tr('failed to getProduct List'));
        }
      });
    } catch (e) {
      print("Exception in  getProductList:-$e");
    }
  }

  List<PoojaList>? poojalist;

  getPoojaList() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          update();
          await apiHelper.getpuja().then((result) {
            log('pooja list status is ${result.status.runtimeType}');
            if (result.status == "200") {
              poojalist = result.recordList;
              log("poojalist ${poojalist?.length}");
              update();
            } else {
              global.showToast(
                message: 'FAil to get Pooja List',
              );
              update();
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getPoojaList():$e');
    }
  }

  pujaRecommend(String pujaId, String astroId) async {
    try {
      await apiHelper
          .addpujatRecommend(pujaId, global.currentUserId.toString(), astroId)
          .then((result) {
        print("pujatRecommend");
        if (result['status'] == 200) {
          Get.back();
          global.showToast(
            message: tr("Puja Recommended Successfully"),
          );
        } else {
          global.showToast(message: tr("Puja not Recommended"));
        }
      });
    } catch (e) {
      print("Exception in  pujaRecommend:-$e");
    }
  }

  postpujatoAdmin({
    required pujaName,
    required pujaDescription,
    required pujaStartDateTime,
    required pujaEndDateTime,
    required pujaPlace,
    required pujaPrice,
    required File? pujaImageBase64,
  }) async {
    try {
      global.showOnlyLoaderDialog();
      await apiHelper
          .postpuja(pujaName, pujaDescription, pujaStartDateTime,
              pujaEndDateTime, pujaPlace, pujaPrice, pujaImageBase64)
          .then((result) {
        global.hideLoader();
        print("postpujatoAdmin result-> ${result['status']}");
        if (result['status'] == 200) {
          global.showToast(message: result['message'].toString());
          getCustomPujaList();
          update();
          Get.back();
        } else {
          global.showToast(message: result['message'].toString());
        }
      });
    } catch (e) {
      print("Exception in  pujaRecommend:-$e");
    }
  }

  productRecommend(String productId, String astroId) async {
    try {
      await apiHelper
          .addProductRecommend(
              productId, global.currentUserId.toString(), astroId)
          .then((result) {
        print("addRecommend");
        if (result['status'] == 200) {
          global.showToast(
            message: tr("Product Recommended Successfully"),
          );
          global.hideLoader();
        } else {
          global.showToast(message: tr("Product not Recommended"));
        }
      });
    } catch (e) {
      print("Exception in  getAppReview:-$e");
    }
  }

  assignedToUser(dynamic userId, dynamic pojaid) async {
    try {
      await apiHelper.assignpujatoUserApi(userId, pojaid).then((result) {
        print("assignedToUser result-> ${result['status']}");
      });
    } catch (e) {
      print("Exception in  getAppReview:-$e");
    }
  }

  //Edit puja
  editCustomPuja(
    List<String> imagepathList, {
    required pujaId,
    required pujaName,
    required pujaDescription,
    required pujaStartDateTime,
    required pujaduration,
    required pujaPlace,
    required pujaPrice,
  }) async {
    log('pujaId $pujaId nTitle $pujaName nDesc $pujaDescription nStart $pujaStartDateTime nEnd $pujaduration nPlace $pujaPlace nPrice $pujaPrice');
    try {
      await apiHelper
          .editCustompuja(pujaId, imagepathList, pujaName, pujaDescription,
              pujaStartDateTime, pujaduration, pujaPlace, pujaPrice)
          .then((imageResponse) {
        global.showToast(message: imageResponse.message.toString());
        Get.find<Productcontroller>().getCustomPujaList();
        Get.back();
      });
    } catch (e) {
      print("Exception in  editCustomPuja:-$e");
    }
  }

  //deelete puja
  deleteCustomPuja(dynamic pujaId) async {
    try {
      await apiHelper.deletepuja(pujaId).then((result) {
        print("deletepuja result-> ${result['status']}");
        if (result['status'] == 200) {
          global.showToast(message: tr("Puja Deleted Successfully"));
          getCustomPujaList();
        } else {
          global.showToast(message: tr("Puja not Deleted"));
        }
      });
    } catch (e) {
      print("Exception in  deleteCustomPuja:-$e");
    }
  }

  List<CustomPujaModel>? custompoojalist;

  getCustomPujaList() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          isloading = true;
          update();
          await apiHelper.getCustompuja().then((result) {
            if (result.status == "200") {
              custompoojalist = result.recordList;
              log("getCustompuja poojalist ${custompoojalist?.length}");
              isloading = false;
              update();
            } else {
              global.showToast(message: 'FAil to get CustomPujaList');
              update();
            }
          });
        }
      });
    } catch (e) {
      isloading = false;
      update();
      print('Exception in getCustomPujaList():$e');
    }
  }
}
