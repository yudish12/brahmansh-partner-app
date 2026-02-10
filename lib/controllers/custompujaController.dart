import 'dart:developer';
import 'package:brahmanshtalk/controllers/HomeController/productController.dart';
import 'package:brahmanshtalk/services/apiHelper.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:brahmanshtalk/views/HomeScreen/Profile/mediapickerDialog.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class CustomPujaController extends GetxController {
  APIHelper apiHelper = APIHelper();
  var imageList = <String>[];
  bool? isLoading = false;

  var pickerController = MultiImagePickerController(
    maxImages: 3,
    images: <ImageFile>[],
    picker: (bool allowMultiple) async {
      return await pickImagesforpuja(allowMultiple);
    },
  );
  Future<void> pickMedia(BuildContext context, MediaTypes mediaType) async {
    if (mediaType == MediaTypes.image) {
      log('inside pick image clicked');
      pickerController.clearImages(); //clear previous images
      await pickerController.pickImages(); //pick images
      isLoading = true;
      update();
      //delay for 2 seconds
      Future.delayed(
        const Duration(seconds: 3),
        () {
          isLoading = false;
          update();
          pickerController.images.every((element) {
            log('inside pickerController ${element.path!}');
            imageList.add(element.path!);
            update();
            return true;
          });
        },
      );
      log('pick image clicked');
    }

    /// Remove image by index
  }

  void removeImageAt(int index) {
    if (index >= 0 && index < imageList.length) {
      imageList.removeAt(index);
      update(); // Update UI
    }
  }

  Future addpujaServer(
    List<String> imagepathList, {
    required pujaName,
    required pujaDescription,
    required pujaStartDateTime,
    required pujaduration,
    required pujaPlace,
    required pujaPrice,
  }) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            await apiHelper
                .uploadPujaImageToServer(
                    imagepathList,
                    pujaName,
                    pujaDescription,
                    pujaStartDateTime,
                    pujaduration,
                    pujaPlace,
                    pujaPrice)
                .then(
              (imageResponse) {
                global.hideLoader();
                if (imageResponse.status == 200) {
                  global.showToast(message: imageResponse.message.toString());
                  Get.find<Productcontroller>().getCustomPujaList();
                  Get.back();
                } else {
                  global.showToast(message: 'something went wrong');
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      debugPrint('Exception: $screen - uploadVideo:-$e');
    }
  }
}
