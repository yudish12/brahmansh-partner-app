// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings
import 'dart:developer';
import 'dart:io';
import 'package:brahmanshtalk/models/viewStoryModel.dart';
import 'package:brahmanshtalk/services/apiHelper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import '../views/HomeScreen/Profile/mediapickerDialog.dart';
import '../views/HomeScreen/Profile/picker.dart';
import '../views/HomeScreen/Profile/stories_screen.dart';
import '../views/HomeScreen/Profile/trimmerview.dart';
import 'Authentication/signup_controller.dart';
import 'HomeController/home_controller.dart';

class StoriesController extends GetxController {
  String screen = 'StoriesController.dart';
  APIHelper apiHelper = APIHelper();
  final picker = ImagePicker();
  List<XFile> pickedMedia = [];
  var imageList = <String>[];
  var viewSingleStory = <ViewStories>[];

  int storyIndex = 0;
  final signupController = Get.find<SignupController>();

  var pickerController = MultiImagePickerController(
    maxImages: 3,
    images: <ImageFile>[],
    picker: (bool allowMultiple) async {
      return await pickImagesUsingImagePicker(allowMultiple);
    },
  );

  Future<void> pickMedia(BuildContext context, MediaTypes mediaType) async {
    if (mediaType == MediaTypes.image) {
      log('inside pick image clicked');
      pickerController.clearImages(); //clear previous images
      await pickerController.pickImages(); //pick images
      global.showOnlyLoaderDialog();

      //delay for 2 seconds
      Future.delayed(
        const Duration(seconds: 3),
        () {
          global.hideLoader();
          pickerController.images.every((element) {
            log('inside pickerController ${element.path!}');
            imageList.add(element.path!);
            update();
            return true;
          });
        },
      );
      log('pick image clicked');
      Get.to(() => const StoriesScreen());
    } else if (mediaType == MediaTypes.video) {
      XFile? pickedVideo = await picker.pickVideo(source: ImageSource.gallery);

      if (pickedVideo != null) {
        String videoPath = pickedVideo.path;
        pickedMedia.add(pickedVideo);
        log('Picked videoPath Paths: $videoPath');
        File file = File(videoPath);

        await Get.to(() => TrimmerView(file: file))!.then((value) {
          // Get.back();
        });
      }
    }
    log('Picked Media storires controller-> $pickedMedia');
    // Get.back();
  }

  Future<void> uploadAstroVideo(File videoFile) async {
    log('video for upload is ${videoFile.path}');
    try {
      var response = await apiHelper.uploadAstrologerVideo(
        astrologerId: global.currentUserId!,
        videoFile: videoFile,
      );
      if (response != null) {
        log('Upload response: $response');
      }
    } catch (e) {
      log("uploadAstroVideo() error: $e");
      global.showToast(message: "Something went wrong!");
    }
  }

  Future uploadText(String texts) async {
    print('astrologer id ${global.currentUserId}');

    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            await apiHelper
                .uploadTextToServer(
              id: global.currentUserId.toString(), // astrologer id
              txts: texts,
            )
                .then(
              (textresponse) {
                print("textReponse");
                print("${textresponse.status}");
                print("$textresponse");
                global.hideLoader();
                if (textresponse.status == 200) {
                  global.showToast(message: textresponse.message.toString());
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    log('Screen closed, switching to ProfileScreen');
                    await getAstroStory(
                        signupController.astrologerList[0]!.id.toString());
                    Get.back();
                  });
                } else {
                  global.showToast(message: tr('something went wrong'));
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - uploadVideo:-' + e.toString());
    }
  }

  Future uploadImage(List<String> imagepathList) async {
    print('astrologer id ${global.currentUserId}');

    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            await apiHelper
                .uploadImageFileToServer(
              id: global.currentUserId.toString(), // astrologer id
              imagePath: imagepathList,
            )
                .then(
              (imageResponse) {
                global.hideLoader();
                if (imageResponse.status == 200) {
                  global.showToast(message: imageResponse.message.toString());
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    log('Screen closed, switching to ProfileScreen');
                    await getAstroStory(
                        signupController.astrologerList[0]!.id.toString());
                    Get.back();
                  });
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
      print('Exception: $screen - uploadVideo:-' + e.toString());
    }
  }

  final homeController = Get.find<HomeController>();

  Future uploadVideo(File file) async {
    log('getting video path is ${file.path}');
    log('astrologer video id ${global.currentUserId}');

    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            await apiHelper
                .uploadFileToServer(
              id: global.currentUserId.toString(), // astrologer id
              videoFile: file,
            )
                .then(
              (videomodel) {
                global.hideLoader();
                if (videomodel.status == 200) {
                  global.showToast(message: videomodel.message.toString());
                  log('Upload done going to 2 tab');
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    log('Screen closed, switching to ProfileScreen');
                    await getAstroStory(
                        signupController.astrologerList[0]!.id.toString());
                    Get.back();
                  });
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
      print('Exception: $screen - uploadVideo:-' + e.toString());
    }
  }

  Future<List> getAstroStory(String astroId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAstroStory(astroId).then((result) {
            if (result.status == "200") {
              viewSingleStory.clear();
              viewSingleStory = result.recordList;
              update();
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getClientsTestimonals:-" + e.toString());
    }
    return viewSingleStory;
  }

  Future<List> deleteStory(String storyId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.deleteStory(storyId).then((result) {
            log('recordlist delete is sstatus is ${result.status}');
            if (result.status == "200") {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                log('Screen deleteStory, switching to ProfileScreen');
                if (storyIndex <= 0) {
                  storyIndex = 0;
                } else {
                  storyIndex = storyIndex - 1;
                }
                update();
                print('new story index is $storyIndex');
                await getAstroStory(
                    signupController.astrologerList[0]!.id.toString());
              });
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getClientsTestimonals:-" + e.toString());
    }
    return viewSingleStory;
  }
}
