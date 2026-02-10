// ignore_for_file: unnecessary_null_comparison, prefer_interpolation_to_compose_strings, avoid_print, depend_on_referenced_packages, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'dart:developer';
import 'package:brahmanshtalk/constants/imageConst.dart';
import 'package:brahmanshtalk/controllers/kundli_matchig_controller.dart';
import 'package:brahmanshtalk/models/kundli.dart';
import 'package:brahmanshtalk/models/kundliBasicModel.dart';
import 'package:brahmanshtalk/models/kundliModel.dart';
import 'package:brahmanshtalk/models/pdfModel.dart';
import 'package:brahmanshtalk/services/apiHelper.dart';
import 'package:date_format/date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/model/astavargaDetailModel.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/model/basicDetailmodel.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/model/dashdetailmodel.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/model/doshaDetailModel.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/model/planetreportmodel.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/screens/GetKundliDetailScreen.dart';
import '../models/GetPdfPrice.dart';
import '../models/kundlimodelAdd.dart';
import 'dart:ui' as ui;
import '../views/HomeScreen/FloatingButton/FreeKundli/model/chartDetailmodel.dart';
import '../views/HomeScreen/FloatingButton/FreeKundli/model/reportModel.dart';

class KundliController extends GetxController {
  TextEditingController userNameController = TextEditingController();
  TextEditingController birthKundliPlaceController = TextEditingController();
  TextEditingController editNameController = TextEditingController();
  TextEditingController editGenderController = TextEditingController();
  TextEditingController editBirthDateController = TextEditingController();
  TextEditingController editBirthTimeController = TextEditingController();
  TextEditingController editBirthPlaceController = TextEditingController();
  final kundlicontrler = Get.find<KundliMatchingController>();
  var dashaindextable = 0;
  var tableindex = 0;
  String selecteddashaoption = 'vimshottari'; // Default direction

  ui.Image? svgImageKp; // Change to nullable type
  List<String> addedItemsTable = [];
  var yagnidashaindextable = 0;
  var yagnitableindex = 0;
  List<String> yaginiaddedItemsTable = [];

  var tabIndex = 0;
  bool isNakshatraTapped = false;
  ui.Image? svgImage; // Change to nullable type
  String? rawsvg;

  AstavargaDetailModel? astavargaDetailModel;
  List<String> ashtakvargaList = [];
  List<int> ashtakvargaTotal = [];
  List<List<dynamic>> ashtakvargaPoints = [];
  int? maxRows;
  var columns;
  Map<String, List<int>>? binnashtakvargaData = {};
  ReportDetailModel? reportDeatilmodel;
  bool isDisable = true;
  var planetList = [];
  bool? isSadesati;
  bool? isKalsarpa;
  String prefix = '';
  double? lat;
  double? long;
  double? timeZone;
  bool isTimeOfBirthKnow = false;
  bool isSelectedLanEng = true;
  bool isSelectedLanHin = false;
  bool isNorthIn = true;
  bool isSouthIn = false;
  String? generalDesc;
  String? selectedGender;
  DateTime? selectedDate;
  String? selectedTime;
  KundliBasicDetail? kundliBasicDetail;
  PdfModel? kundlipdfModel;
  final Map<String, String> astrologicalMap = {
    'D1': 'Rasi',
    'D2': 'Hora',
    'D3': 'Drekkana',
    'D4': 'Chaturthamsa',
    'D5': 'Panchamamsa',
    'D6': 'Shastamsa',
    'D7': 'Saptamsa',
    'D8': 'Astamsa',
    'D9': 'Navamsa',
    'D10': 'Dasamsa',
    'D11': 'Rudramsa',
    'D12': 'Dwadasamsa',
    'D16': 'Shodasamsa',
    'D20': 'Vimsamsa',
    'D24': 'Siddhamsa',
    'D27': 'Nakshatramsa',
    'D30': 'Trimsamsa',
    'D40': 'Khavedamsa',
    'D45': 'Akshavedamsa',
    'D60': 'Shastyamsa',
    'chalit': 'Chalit',
    'sun': 'Sun',
    'moon': 'Moon',
    'kp_chalit': 'Kp Chalit',
  };

  KundliBasicPanchangDetail? kundliBasicPanchangDetail;
  KundliAvakhdaDetail? kundliAvakhadaDetail;
  KundliPlanetsDetail? kundliPlanetsDetail;
  bool isShowMore = false;
  DateTime editDOB = DateTime.now();
  var kundaliBasicList = <KundliBasicModel>[];
  var kundliList = <KundliModel>[];
  List<List<VimshattariModel>>? vimshattariList = [];
  GemstoneModel? gemstoneList;
  APIHelper apiHelper = APIHelper();
  List<KundliModel> searchKundliList = <KundliModel>[];

  int kundliTabInitialIndex = 5;

  List<KundliGender> gender = [
    KundliGender(title: 'Male', isSelected: false, image: IMAGECONST.male),
    KundliGender(title: 'Female', isSelected: false, image: IMAGECONST.female),
    KundliGender(
        title: 'other', isSelected: false, image: IMAGECONST.otherGender),
  ];
  int initialIndex = 0;
  List kundliTitle = [
    'Hey there! \nWhat is Your name ?',
    'What is your gender?',
    'Enter your birth date',
    'Enter your birth time',
    'Where were you born?'
  ];
  List<Kundli> listIcon = [
    Kundli(icon: Icons.person, isSelected: true),
    Kundli(icon: Icons.search, isSelected: false),
    Kundli(icon: Icons.calendar_month, isSelected: false),
    Kundli(icon: Icons.punch_clock_outlined, isSelected: false),
    Kundli(icon: Icons.location_city, isSelected: false),
  ];

  @override
  void onInit() async {
    _init();
    super.onInit();
  }

  _init() async {
    global.showOnlyLoaderDialog();
    await getKundliList();
    global.hideLoader();
  }

  GetPdfPrice? pdfPriceData;
  Future<int> pdfPrice() async {
    int value = 0;
    try {
      await apiHelper.getPdfPrice().then((result) {
        print("getKundaliPrice");
        print("${result.recordList}");
        print("${result.status}");
        if (result.status == "200") {
          Map<String, dynamic> data = jsonDecode(result.recordList);
          pdfPriceData = GetPdfPrice.fromJson(data);
          print("getKundaliPrice");
          print("${pdfPriceData!.recordList}");
          value = 1;
          update();
        } else {
          if (global.currentUserId != null) {
            global.showToast(
              message: 'FAil to get kundli',
            );
          }
          value = 0;
          // pdfKundaliData=null;
        }
      });
    } catch (e) {
      print("getpdfprice():- $e");
      value = 0;
    }
    return value;
  }

  // Future<int> pdfPrice() async {
  //   int value = 0;
  //   try {
  //     await apiHelper.getPdfPrice().then((result) {
  //       debugPrint("getKundaliPrice $result");
  //       debugPrint("stateus ${result.status}");
  //       debugPrint("list${result.recordList}");

  //       if (result.status == "200") {
  //         pdfPriceData = result;
  //         value = 1;
  //         update();
  //       } else {
  //         if (global.currentUserId != null) {
  //           global.showToast(
  //             message: 'FAil to get kundli',
  //           );
  //         }
  //         value = 0;
  //         // pdfKundaliData=null;
  //       }
  //     });
  //   } catch (e) {
  //     debugPrint("getpdfprice():- $e");
  //     value = 0;
  //   }
  //   return value;
  // }

  updateIcon(index) {
    listIcon[index].isSelected = true;
    for (int i = 0; i < listIcon.length; i++) {
      if (i == index) {
        listIcon[index].isSelected = true;
        continue;
      } else {
        listIcon[i].isSelected = false;
        update();
      }
    }
    update();
  }

  String? dropDownGender;
  List item = ['Male', 'Female', 'Other'];
  String innitialValue(int callId, List<String> item) {
    if (callId == 1) {
      return dropDownGender ?? item[0];
    } else {
      return 'no data';
    }
  }

  void genderChoose(String value) {
    dropDownGender = value;
    update();
  }

  BasicDetailModel? basicDeatilmodel;
  Future getBasicDetailChart(int? id, bool isKundali) async {
    print("getBasicDetailChart $id");
    try {
      await apiHelper.getBasicDetailApi(id, isKundali).then((result) {
        global.hideLoader();
        print("kundli chart status -> ${result.status}");
        if (result.status == 200) {
          basicDeatilmodel = result;
          update();
          Get.to(() => GetKundliDetailScreen(
                userid: id,
                pdflink: basicDeatilmodel?.recordList?.pdfLink,
                isKundali: isKundali,
              ));
        } else {
          if (global.currentUserId != null) {
            global.showToast(
              message: 'FAil to get kundli',
            );
          }
        }
      });
    } catch (e) {
      print("getBasicDetailChart(): Exception  $e");
    }
  }

  var reportdeatils;
  List<Map<String, String?>>? reportDetailList;
  Future getReport(int? id, bool isKundali) async {
    log("getReport $id ");
    try {
      await apiHelper.getReportApi(id, isKundali).then((result) {
        print("getReportApi");
        print("getReportApi chart status -> ${result.status}");
        if (result.status == 200) {
          reportDeatilmodel = null;
          isDataLoaded = true;
          update();

          reportDeatilmodel = result;
          reportdeatils = reportDeatilmodel?.ascendant?.response?[0];
          reportDetailList = [
            {
              'label': 'Ascendant',
              'value': reportdeatils?.ascendant.toString()
            },
            {
              'label': 'Ascendant lord',
              'value': reportdeatils?.ascendantLord.toString()
            },
            {
              'label': 'Ascendant lord location',
              'value': reportdeatils?.ascendantLordLocation.toString()
            },
            {
              'label': 'Ascendant lord house location',
              'value': reportdeatils?.ascendantLordHouseLocation.toString()
            },
            {'label': 'Symbol', 'value': reportdeatils?.symbol.toString()},
            {
              'label': 'Zoadiac Characterstics',
              'value': reportdeatils?.zodiacCharacteristics.toString()
            },
            {'label': 'Lucky Gem', 'value': reportdeatils?.luckyGem.toString()},
            {
              'label': 'Day of Fasting',
              'value': reportdeatils?.dayForFasting.toString()
            },
            {
              'label': 'Good Quality',
              'value': reportdeatils?.goodQualities.toString()
            },
            {
              'label': 'Bad Quality',
              'value': reportdeatils?.badQualities.toString()
            },
            {
              'label': 'Spiritual Advice',
              'value': reportdeatils?.spiritualityAdvice.toString()
            },
            {
              'label': 'General prediction',
              'value': reportdeatils?.generalPrediction.toString()
            },
            {
              'label': 'Personalized Prediction',
              'value': reportdeatils?.personalisedPrediction.toString()
            },
          ];

          update();
        } else {
          if (global.currentUserId != null) {
            global.showToast(
              message: 'FAil to get charts',
            );
          }
        }
      });
    } catch (e) {
      print("getChartDetails- $e");
    }
  }

  PlanetReportModel? planetreport;

  Future getPlanetReport(int? id, String planetname, bool isKundali) async {
    log("getReport $id ");
    try {
      await apiHelper
          .getPlanetReportApi(id, planetname, isKundali)
          .then((result) {
        print("getPlanetReportApi");
        print("getPlanetReportApi chart status -> ${result.status}");
        if (result.status == 200) {
          planetreport = null;
          isDataLoaded = true;
          update();

          planetreport = result;

          update();
        } else {
          if (global.currentUserId != null) {
            global.showToast(
              message: 'FAil to get getPlanetReport',
            );
          }
        }
      });
    } catch (e) {
      print("getChartDetails- $e");
    }
  }

  String selectedDirection = 'north'; // Default direction

  ChartDetailModel? chartDeatilmodel;
  Future getChartDetails(int? id, String div, String style, bool iskundli,
      {bool firstloding = false}) async {
    log("getChartDetails $id and $div and $style");
    try {
      await apiHelper
          .getChartDetailsApi(id, div, style, iskundli)
          .then((result) {
        firstloding ? global.hideLoader() : null;
        print("getChartDetails chart status -> ${result.status}");
        if (result.status == 200) {
          chartDeatilmodel = null;
          isDataLoaded = true;
          update();

          chartDeatilmodel = result;
          update();
        } else {
          if (global.currentUserId != null) {
            global.showToast(
              message: 'FAil to get charts',
            );
          }
        }
      });
    } catch (e) {
      print("getChartDetails- $e");
    }
  }

  DashDetailsModel? dashaDeatilmodel;
  bool isDataLoaded = false;

  Future getDasha(int? id, bool isKundali) async {
    log("getDasha $id ");
    try {
      await apiHelper.getDashaApi(id, isKundali).then((result) {
        print("getDashaApi");
        print("getDashaApi chart status -> ${result.status}");

        if (result.status == 200) {
          dashaDeatilmodel = null;
          isDataLoaded = true;
          update();
          dashaDeatilmodel = result;
          update();
        } else {
          if (global.currentUserId != null) {
            global.showToast(
              message: 'FAil to get getDashaApi',
            );
          }
        }
      });
    } catch (e) {
      print("getDashaApi- $e");
    }
  }

  DoshaDetailsModel? doshaDeatilmodel;
  Future getDosha(int? id, bool isKundali) async {
    log("getDosha $id ");
    try {
      await apiHelper.getDoshaApi(id, isKundali).then((result) {
        print("getDoshaApi");
        print("getDoshaApi chart status -> ${result.status}");
        if (result.status == 200) {
          doshaDeatilmodel = null;
          isDataLoaded = true;
          update();
          doshaDeatilmodel = result;
          update();
        } else {
          if (global.currentUserId != null) {
            global.showToast(
              message: 'FAil to get getDoshaApi',
            );
          }
        }
      });
    } catch (e) {
      print("getDashaApi- $e");
    }
  }

  Future<void> getAstaVarga(int? id, bool iskundali) async {
    log("getAstaVarga $id");
    try {
      AstavargaDetailModel? result =
          await apiHelper.getAstaVargaApi(id, iskundali);
      print("getAstaVarga");
      print("getAstaVarga -> ${result?.status}");
      if (result?.status == 200) {
        ashtakvargaList.clear();
        ashtakvargaTotal.clear();
        ashtakvargaPoints.clear();
        binnashtakvargaData = {};

        astavargaDetailModel = result;
        ashtakvargaList = result?.ashtakvarga?.response?.ashtakvargaOrder ?? [];
        ashtakvargaTotal =
            result?.ashtakvarga?.response?.ashtakvargaTotal ?? [];
        ashtakvargaPoints =
            result?.ashtakvarga?.response?.ashtakvargaPoints ?? [];
        // Parse binnashtakvarga
        if (result?.binnashtakvarga?.response != null) {
          final binnashtakvargaResponse = result!.binnashtakvarga!.response!;
          binnashtakvargaData = {
            'Ascendant': binnashtakvargaResponse.ascendant!,
            'Sun': binnashtakvargaResponse.sun!,
            'Moon': binnashtakvargaResponse.moon!,
            'Mars': binnashtakvargaResponse.mars!,
            'Mercury': binnashtakvargaResponse.mercury!,
            'Jupiter': binnashtakvargaResponse.jupiter!,
            'Saturn': binnashtakvargaResponse.saturn!,
            'Venus': binnashtakvargaResponse.venus!,
          };
          log('binnashtakvargaData -> $binnashtakvargaData');
        }
        columns = binnashtakvargaData?.keys.toList();
        maxRows = binnashtakvargaData?[columns[0]]!.length;
        update();
      } else {
        if (global.currentUserId != null) {
          global.showToast(
            message: 'Failed to get charts',
          );
        }
      }
    } catch (e) {
      print("getChartDetails- $e");
    }
  }

  getKundliListById(int index) async {
    try {
      editNameController.text = searchKundliList[index].name;
      editBirthDateController.text = formatDate(
          searchKundliList[index].birthDate, [dd, '-', mm, '-', yyyy]);
      editBirthTimeController.text =
          searchKundliList[index].birthTime.toString();
      editBirthPlaceController.text =
          searchKundliList[index].birthPlace.toString();
      update();
      genderChoose(searchKundliList[index].gender);
    } catch (e) {
      debugPrint('Exception in getKundliList():' + e.toString());
    }
  }

  deleteKundli(int id) async {
    await global.checkBody().then((result) async {
      if (result) {
        await apiHelper.deleteKundli(id).then((result) {
          if (result.status == "200") {
            global.showToast(message: "Deleted Successfully");
          } else {
            global.showToast(message: "Delete failed!");
          }
        });
      }
    });
  }

  getKundliDetailsPdf({required int id}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getKundaliPDf(userid: id).then((result) {
            if (result != null) {
              Map<String, dynamic> map = result;
              debugPrint('pdf details map $map');
              kundlipdfModel = PdfModel.fromJson(map);
              update();
            } else {
              global.showToast(message: 'Failed to Basic Detail');
            }
            update();
          });
        }
      });
    } catch (e) {
      debugPrint('Exception in getBasicDetail():' + e.toString());
    }
  }

  searchKundli(String kundliName) {
    List<KundliModel> result = [];
    if (kundliName.isEmpty) {
      result = kundliList;
    } else {
      result = kundliList
          .where((element) => element.name
              .toString()
              .toLowerCase()
              .contains(kundliName.toLowerCase()))
          .toList();
    }
    searchKundliList = result;
    update();
  }

  getKundliList() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getKundli().then((result) {
            debugPrint('getKundliList  -> ${result.recordList}');
            if (result.status == "200") {
              kundliList = result.recordList;
              searchKundliList = kundliList;

              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(message: "Get kundli");
              }
            }
          });
        }
      });
    } catch (e) {
      debugPrint('Exception122 in getKundliList():' + e.toString());
    }
  }

  updateIsDisable() {
    if (userNameController != null) {
      isDisable = false;
      update();
    } else {
      isDisable = true;
      update();
    }
  }

  updateCheck(value) {
    isTimeOfBirthKnow = value;
    update();
  }

  backStepForCreateKundli(int index) {
    initialIndex = index;
  }

  updateInitialIndex() {
    if (initialIndex < 5) {
      initialIndex = initialIndex + 1;
    } else {
      initialIndex = 0;
    }
    update();
  }

  updateListIndex(int index) {
    if (index < 5) {
      index += 1;
    } else {
      index = 0;
    }
  }

  langugeUpdate({bool? isEng, bool? isHin}) {
    isSelectedLanEng = isEng ?? false;
    isSelectedLanHin = isHin ?? false;
    update();
  }

  northSouthUpdate({bool? isNorth, bool? isSouth}) {
    isNorthIn = isNorth ?? false;
    isSouthIn = isSouth ?? false;
    update();
  }

  changeTapIndex(int index) {
    kundliTabInitialIndex = index;
    update();
  }

  showMoreText() {
    isShowMore = !isShowMore;
    update();
  }

  getGeoCodingLatLong(
      {double? latitude,
      double? longitude,
      int? flagId,
      KundliMatchingController? kundliMatchingController}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .geoCoding(lat: latitude,long: longitude)
              .then((result) {
                print("timezone:- ${result}");
            if (result.status == "true") {
              // timeZone = double.parse(result.recordList['timezone'].toString());
              // geoCodingList = result.recordList;
              if (flagId == 1) {
                // kundliMatchingController!.boy_timezone =
                //     double.parse(result.recordList['timezone'].toString());
                kundliMatchingController!.boy_timezone =
                    double.parse("5.5");
                kundliMatchingController.update();
              } else if (flagId == 2) {
                // kundliMatchingController!.girl_timezone =
                //     double.parse(result.recordList['timezone'].toString());
                kundliMatchingController!.girl_timezone =
                    double.parse("5.5");
                kundliMatchingController.update();
              } else {
                timeZone =
                    double.parse("5.5");
              }
              update();
            } else {
              // global.showToast(message: 'Not Available');
            }
          });
        }
      });
    } catch (e) {
      debugPrint('Exception in getGeoCodingLatLong():' + e.toString());
    }
  }

  String? userName;
  getName(String text) {
    userName = text;
    update();
  }

  String kundaliType = 'small';
  getKundaliType(String type) {
    kundaliType = type;
    debugPrint("kundali type is ->  ${kundaliType.toString()}");
    update();
  }

  getselectedDate(DateTime date) {
    DateFormat dateFormat = DateFormat("dd-MM-yyyy");

    String sDate = dateFormat.format(date);
    debugPrint('date is $sDate');

    selectedDate = dateFormat.parse(sDate);
    debugPrint('date parse $selectedDate');

    update();
  }

  updateBg(int index) {
    gender[index].isSelected = true;
    selectedGender = gender[index].title;
    update();
  }

  getSelectedTime(DateTime date) {
    selectedTime = DateFormat('HH:mm').format(date);
    update();
  }

  //47539
  bool isbasicKundli = false;

  addKundliData(bool ismatched, int amount, String languageCode) async {
    debugPrint('add kundli data');
    debugPrint('kundli type is $kundaliType');
    List<KundliModelAdd> kundliModel = [
      KundliModelAdd(
        name: userName!,
        gender: selectedGender!,
        birthDate: selectedDate ?? DateTime(1996),
        birthTime: selectedTime ?? DateFormat.jm().format(DateTime.now()),
        birthPlace: birthKundliPlaceController.text,
        latitude: lat,
        longitude: long,
        timezone: timeZone??5.5,
        pdf_type: kundaliType,
        match_type: kundlicontrler.selectedDirection,
        language: languageCode,
      )
    ];
    update();
    print("timezone- ${kundliModel[0].timezone}");
    await global.checkBody().then((result) async {
      if (result) {
        await apiHelper
            .addKundli(kundliModel, ismatched, amount)
            .then((result) {
          if (result.status == "200") {
            debugPrint('addKundli success');
            String msg = "Kundli created successfully";
            String msg1 = "Pdf has been generated successfully";
            log('is check $isbasicKundli true $msg and false $msg1');

            global.showToast(
              message: isbasicKundli ? msg : msg1,
            );
          } else {
            global.showToast(
                message: 'Failed to create kundli please try again later!');
          }
        });
      }
    });
  }

  DateTime? pickedDate;
  updateKundliData(int id) async {
    Duration offset = DateTime.now().timeZoneOffset;
    String formatedtimeZone =
        '${offset.inHours.abs().toString()}.${(offset.inMinutes % 60).obs.toString()}';
    debugPrint("Time Zone: $formatedtimeZone");
    KundliModel kundliModel = KundliModel(
        name: editNameController.text,
        gender: dropDownGender!,
        birthDate: pickedDate ?? editDOB,
        birthTime: editBirthTimeController.text,
        birthPlace: editBirthPlaceController.text,
        latitude: lat,
        longitude: long,
        timezone: formatedtimeZone
        // pdf_type: kundaliType,
        );
    update();
    await global.checkBody().then((result) async {
      if (result) {
        await apiHelper.updateKundli(id, kundliModel).then((result) {
          if (result.status == "200") {
            global.showToast(message: tr('Your kundli have been updated'));
          } else {
            global.showToast(
                message: tr('Failed to update kundli please try again later!'));
          }
        });
      }
    });
  }
}
