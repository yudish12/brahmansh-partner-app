// ignore_for_file: file_names, prefer_interpolation_to_compose_strings, avoid_print, non_constant_identifier_names

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:brahmanshtalk/models/dailyHoroscopeModel.dart';
import 'package:brahmanshtalk/services/apiHelper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../models/dailyHororscopeModelVedic.dart';

class DailyHoroscopeController extends GetxController {
  APIHelper apiHelper = APIHelper();
  List zodiac = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricornus',
    'Aquarius',
    'Pisces'
  ];

  List dailyHoroscopeCate = ['Love', 'Career', 'Money', 'Health', 'Travel'];
  List borderColor = [
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.purple
  ];
  List containerColor = const [
    Color.fromARGB(255, 241, 223, 220),
    Color.fromARGB(255, 248, 233, 211),
    Color.fromARGB(255, 226, 248, 227),
    Color.fromARGB(255, 218, 234, 247),
    Color.fromARGB(255, 242, 227, 245)
  ];
  bool isToday = true;
  bool isYesterday = false;
  bool isTomorrow = false;
  bool isMonth = true;
  bool isWeek = false;
  bool isYear = false;
  int? signId;
  String SignName = "Pisces";
  int day = 2;
  DailyscopeModel? dailyList;
  VedicList? vedicdailyList;

  int zodiacindex = 0;
  Map<String, dynamic> dailyHororscopeData = {};

  updateDaily(int flag) {
    day = flag;
    update();
  }

  int calltype = 3;
  updatecalltype(int index) {
    calltype = index;
    update();
  }

  int linearprogressvalue = 0;
  String remarkvalue = "";
  String labelText = "";
  int selectedIndex = 0;

  void getProgressValue({
    required int index,
    String type = "weeklyHoroScope",
    String key = "physicque",
    String remarkkey = "health_remark",
  }) {
    try {
      log("Received keys for Progress type: $type, key: $key, remarkkey: $remarkkey");

      // Select the correct list based on type
      List<Scope>? selectedList;
      switch (type) {
        case "todayHoroscope":
          selectedList = vedicdailyList?.todayHoroscope;
          break;
        case "weeklyHoroScope":
          selectedList = vedicdailyList?.weeklyHoroScope;
          break;
        case "yearlyHoroScope":
          selectedList = vedicdailyList?.yearlyHoroScope;
          break;
        default:
          throw Exception("Invalid type: $type");
      }

      if (selectedList == null || selectedList.isEmpty) {
        throw Exception("No data found for type: $type");
      }

      // Extract progress and remark safely
      final scope = selectedList.first;

      final progressValue = scope.toJson()[key] ?? 0;
      final remark = scope.toJson()[remarkkey] ?? "N/A";

      linearprogressvalue = progressValue is int
          ? progressValue
          : int.tryParse(progressValue.toString()) ?? 0;

      remarkvalue = remark.toString();
      labelText = key;
      selectedIndex = index;

      update();
    } catch (e, st) {
      log('Error accessing horoscope data for key $key: $e\n$st');
    }
  }

  final ScreenshotController screenshotController = ScreenshotController();
  @override
  Future onInit() async {
    super.onInit();
    await getHororScopeSignData();
    await getDefaultDailyHororscope();
    if (global.hororscopeSignList.isNotEmpty) {
      debugPrint('horoscopeId-> ${global.hororscopeSignList[0].id}');

      await getHoroscopeList(horoscopeId: global.hororscopeSignList[0].id);
    }
  }

  updateTimely({bool? month, bool? year, bool? week}) {
    isMonth = month!;
    isWeek = week!;
    isYear = year!;
    update();
  }

  Future getDefaultDailyHororscope() async {
    try {
      if (global.hororscopeSignList.isNotEmpty) {
        global.hororscopeSignList[0].isSelected = true;
      }
    } catch (e) {
      print('Exception in getDefaultDailyHororscope():' + e.toString());
    }
  }

  Future<void> initHoroscopeFlow() async {
    // Step 1: Ensure zodiac list is loaded only once
    await _ensureHoroscopeSignsLoaded();

    // Step 2: Select first zodiac
    selectZodicQuick(0);

    // Step 3: Fetch horoscope data for selected zodiac
    await getHoroscopeList(horoscopeId: signId);
  }

  Future<void> _ensureHoroscopeSignsLoaded() async {
    if (global.hororscopeSignList.isNotEmpty) return; // Already cached

    try {
      if (await global.checkBody()) {
        final result = await apiHelper.getHororscopeSign();
        if (result.status == "200") {
          global.hororscopeSignList = result.recordList;
        } else {
          global.showToast(message: tr("No daily horoscope"));
        }
      }
    } catch (e) {
      print('Exception in _ensureHoroscopeSignsLoaded(): $e');
    }
    update();
  }

// ⚡ Quick local selection (no unnecessary API call)
  void selectZodicQuick(int index) {
    for (final e in global.hororscopeSignList) {
      e.isSelected = false;
    }
    global.hororscopeSignList[index].isSelected = true;

    zodiacindex = index;
    signId = global.hororscopeSignList[index].id;
    SignName = global.hororscopeSignList[index].name;

    update();
  }

  Future<void> getHoroscopeList({int? horoscopeId}) async {
    try {
      dailyList = null;
      vedicdailyList = null;

      if (!await global.checkBody()) return;

      final result = await apiHelper.getHoroscope(horoscopeSignId: horoscopeId);

      if (result == null) {
        if (global.currentUserId != null) {
          global.showToast(message: tr('Not show daily horoscope'));
        }
        return;
      }

      // ✅ Use `this.calltype` or rename the local variable
      final currentType = calltype;

      if (currentType == 2) {
        dailyList = DailyscopeModel.fromJson(result);
      } else if (currentType == 3) {
        vedicdailyList = VedicList.fromJson(result);
      }

      update();
    } catch (e) {
      print('Exception in getHoroscopeList(): $e');
    }
  }

  selectZodic(int index) async {
    await getHororScopeSignData();
    global.hororscopeSignList.map((e) => e.isSelected = false).toList();
    global.hororscopeSignList[index].isSelected = true;
    zodiacindex = index;
    signId = global.hororscopeSignList[index].id;
    SignName = global.hororscopeSignList[index].name;
    update();
  }

  Future getHororScopeSignData() async {
    try {
      if (global.hororscopeSignList.isEmpty) {
        await global.checkBody().then((result) async {
          if (result) {
            await apiHelper.getHororscopeSign().then((result) {
              if (result.status == "200") {
                global.hororscopeSignList = result.recordList;
                update();
              } else {
                global.showToast(message: tr("No daily hororScope"));
              }
            });
          }
        });
      }
    } catch (e) {
      print('Exception in getHororScopeSignData():' + e.toString());
    }
  }

  // getHoroscopeList({int? horoscopeId}) async {
  //   try {
  //     dailyList = null;
  //     vedicdailyList = null;

  //     await global.checkBody().then((result) async {
  //       if (result) {
  //         await apiHelper
  //             .getHoroscope(horoscopeSignId: horoscopeId)
  //             .then((result) {
  //           if (result != null) {
  //             if (Get.find<DailyHoroscopeController>().calltype == 2) {
  //               Map<String, dynamic> map = result;
  //               dailyList = DailyscopeModel.fromJson(map);
  //             } else if (Get.find<DailyHoroscopeController>().calltype == 3) {
  //               Map<String, dynamic> nmap = result;
  //               vedicdailyList = VedicList.fromJson(nmap);
  //             }
  //             update();
  //           } else {
  //             if (global.currentUserId != null) {
  //               global.showToast(message: tr('Not show daily horoscope'));
  //             }
  //           }
  //         });
  //       }
  //     });
  //   } catch (e) {
  //     print('Exception in getHoroscopeList():' + e.toString());
  //   }
  // }

  Future<void> takeHoroscopeScreenshotAndShare() async {
    // Capture the screenshot
    final Uint8List? image =
        await screenshotController.capture(pixelRatio: 5.0);
    if (image == null) return;

    // Save the image temporarily
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/screenshot1.png';
    final File imageFile = File(imagePath)..writeAsBytesSync(image);
    await SharePlus.instance.share(
      ShareParams(
        text:
            "Check out your free daily horoscope on ${global.getSystemFlagValue(global.systemFlagNameList.appName)} & plan your day batter  ${global.appUrl}",
        files: [XFile(imageFile.path)],
      ),
    );
    // Share the image via WhatsApp
    //   await Share.shareFiles(
    //     [imageFile.path],
    //     text:
    //         "Check out your free daily horoscope on ${global.getSystemFlagValue(global.systemFlagNameList.appName)} & plan your day batter  ${global.appUrl}",
    //   );
    // } catch (e) {
    //   print("Error capturing and sharing screenshot: $e");
  }
}
