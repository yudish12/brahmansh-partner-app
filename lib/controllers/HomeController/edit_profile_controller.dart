// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings, avoid_print, use_build_context_synchronously, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/models/Master%20Table%20Model/all_skill_model.dart';
import 'package:brahmanshtalk/models/Master%20Table%20Model/astrologer_category_list_model.dart';
import 'package:brahmanshtalk/models/Master%20Table%20Model/language_list_model.dart';
import 'package:brahmanshtalk/models/Master%20Table%20Model/primary_skill_model.dart';
import 'package:brahmanshtalk/models/bankDetailsModel.dart';
import 'package:brahmanshtalk/models/docmodel.dart';
import 'package:brahmanshtalk/models/time_availability_model.dart';
import 'package:brahmanshtalk/models/user_model.dart';
import 'package:brahmanshtalk/models/week_model.dart';
import 'package:brahmanshtalk/services/apiHelper.dart';
import 'package:brahmanshtalk/utils/constantskeys.dart';
import 'package:date_format/date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;

class EditProfileController extends GetxController {
  String screen = 'edit_profile__controller.dart';
  int index = 0;
  APIHelper apiHelper = APIHelper();
  CurrentUser user = CurrentUser();
  final signupController = Get.find<SignupController>();
  int? updateId;
  List<AstrolgoerCategoryModel> astroId = [];
  List<PrimarySkillModel> primaryId = [];
  List<AllSkillModel> allId = [];
  List<LanguageModel> lId = [];
  String countryCode = "+91";

  updateCountryCode(String? value) {
    countryCode = value ?? "+91";
    log('country code is $countryCode');
    update();
  }

//--------------------Personal Details----------------------
//Name
  final TextEditingController cName = TextEditingController();
  final FocusNode fName = FocusNode();
//Email
  final TextEditingController cEmail = TextEditingController();
  final FocusNode fEmail = FocusNode();
//Mobile Numer
  final TextEditingController cMobileNumber = TextEditingController();
  final FocusNode fMobileNumber = FocusNode();
//Terms ANd Condition
  RxBool termAndCondtion = true.obs;
//--------------------------Skills Details----------------------
//User Image
  Uint8List? tImage;
  File? selectedImage;
  File? imageFile;
  File? userFile;
  String profile = "";

  var imagePath = ''.obs;
  onOpenCamera() async {
    selectedImage = await openCamera(Get.theme.primaryColor).obs();
    update();
  }

  onOpenGallery() async {
    selectedImage = await openGallery(Get.theme.primaryColor).obs();
    update();
  }

  Future<File> imageService(ImageSource imageSource) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? selectedImage = await picker.pickImage(source: imageSource);
      imageFile = File(selectedImage!.path);

      if (selectedImage != null) {
        imageFile;
      }
    } catch (e) {
      print("Exception - businessRule.dart - _openGallery() ${e.toString()}");
    }
    return imageFile!;
  }

  Future<File?> openCamera(Color color, {bool isProfile = true}) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? _selectedImage =
          await picker.pickImage(source: ImageSource.camera);

      if (_selectedImage != null) {
        CroppedFile? _croppedFile = await ImageCropper().cropImage(
          sourcePath: _selectedImage.path,
          aspectRatio:
              isProfile ? const CropAspectRatio(ratioX: 1, ratioY: 1) : null,
          uiSettings: [
            AndroidUiSettings(
              initAspectRatio: isProfile
                  ? CropAspectRatioPreset.square
                  : CropAspectRatioPreset.original,
              backgroundColor: Colors.grey,
              toolbarColor: Colors.grey[100],
              toolbarWidgetColor: color,
              activeControlsWidgetColor: color,
              cropFrameColor: color,
              lockAspectRatio: isProfile ? true : false,
            ),
          ],
        );
        if (_croppedFile != null) {
          return File(_croppedFile.path);
        }
      }
    } catch (e) {
      print("Exception - $screen - openCamera():" + e.toString());
    }
    return null;
  }

  Future<File?> openGallery(Color color, {bool isProfile = true}) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? _selectedImage =
          await picker.pickImage(source: ImageSource.gallery);

      if (_selectedImage != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: _selectedImage.path,
          aspectRatio:
              isProfile ? const CropAspectRatio(ratioX: 1, ratioY: 1) : null,
          uiSettings: [
            AndroidUiSettings(
              initAspectRatio: isProfile
                  ? CropAspectRatioPreset.square
                  : CropAspectRatioPreset.original,
              backgroundColor: Colors.grey,
              toolbarColor: Colors.grey[100],
              toolbarWidgetColor: color,
              activeControlsWidgetColor: color,
              cropFrameColor: color,
              lockAspectRatio: isProfile ? true : false,
            ),
          ],
        );

        if (croppedFile != null) {
          selectedImage = File(croppedFile.path);
          List<int> imageBytes = selectedImage!.readAsBytesSync();
          print(imageBytes);
          imagePath.value = base64Encode(imageBytes);
          update();

          return File(imagePath.value);
        }
      }
    } catch (e) {
      print("Exception - $screen - openGallery()" + e.toString());
    }
    return null;
  }

//Date oF Birth
  final TextEditingController cBirthDate = TextEditingController();
  DateTime? selectedDate;
  onDateSelected(DateTime? picked) {
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      cBirthDate.text = selectedDate.toString();
      cBirthDate.text = formatDate(selectedDate!, [dd, '-', mm, '-', yyyy]);
    }
    update();
  }

//Gender List
  String selectedGender = "Male";
  //Choose category
  final cSelectCategory = TextEditingController();
//Primary Skills
  final TextEditingController cPrimarySkill = TextEditingController();
//All Skills
  final TextEditingController cAllSkill = TextEditingController();
//Language
  final TextEditingController cLanguage = TextEditingController();
//Charge
  final TextEditingController cCharges = TextEditingController();
  final FocusNode fCharges = FocusNode();

  //usd charges
  final TextEditingController cusdCharges = TextEditingController();
  final FocusNode fusdCharges = FocusNode();

  //Video call Charge
  final TextEditingController cVideoCharges = TextEditingController();
  final FocusNode fVideoCharges = FocusNode();

  //Video USD call Charge
  final TextEditingController cusdVideoCharges = TextEditingController();
  final FocusNode fusdVideoCharges = FocusNode();
  //Charge
  final TextEditingController cReportCharges = TextEditingController();
  final FocusNode fReportCharges = FocusNode();

  //Charge usd report
  final TextEditingController cusdReportCharges = TextEditingController();
  final FocusNode fusdReportCharges = FocusNode();
//Expirence
  final TextEditingController cExpirence = TextEditingController();
  final FocusNode fExpirence = FocusNode();
//Contribution Hours
  final TextEditingController cContributionHours = TextEditingController();
  final FocusNode fContributionHours = FocusNode();
//Contribution Hours
  final TextEditingController cwhatsappno = TextEditingController();
  final FocusNode fwhatsappno = FocusNode();

  //pancard Hours
  final TextEditingController cpancard = TextEditingController();
  final FocusNode fpancard = FocusNode();

  final TextEditingController cadharno = TextEditingController();
  final FocusNode fadharno = FocusNode();

  //IFSC
  final TextEditingController cIFSC = TextEditingController();
  final FocusNode fIFSC = FocusNode();

  //BANK branch
  final TextEditingController cbankbranch = TextEditingController();
  final FocusNode fbankbranch = FocusNode();

  //BANK name
  final TextEditingController cbankname = TextEditingController();
  final FocusNode fbankname = FocusNode();

  //BANK ACCOUNT HOLDER NAME
  final TextEditingController caccountHolderName = TextEditingController();
  final FocusNode faccountHolderName = FocusNode();

  // Account Type
  String defaultaccountType = 'Saving';
  List<String> accountTypeOptions = ['Saving', 'Current'];

  //account type name
  final TextEditingController caccounttype = TextEditingController();
  final FocusNode faccounttypee = FocusNode();

  //account type name
  final TextEditingController caccountno = TextEditingController();
  final FocusNode faccountno = FocusNode();

  //account type name
  final TextEditingController cconfiaccountno = TextEditingController();
  final FocusNode fconfiaccountno = FocusNode();

  //account type name
  final TextEditingController cupi = TextEditingController();
  final FocusNode fupi = FocusNode();

//Hear about astrotalk
  final TextEditingController cHearAboutAstroGuru = TextEditingController();
  final FocusNode fHearAboutAstroGuru = FocusNode();

//Working on Any Other Platform
  final TextEditingController cNameOfPlatform = TextEditingController();
  final FocusNode fNameOfPlatform = FocusNode();
  final TextEditingController cMonthlyEarning = TextEditingController();
  final FocusNode fMonthlyEarning = FocusNode();
  int? anyOnlinePlatform;
  void setOnlinePlatform(int? index) {
    anyOnlinePlatform = index;
    update();
  }

//----------------Other Details--------------

//on board you
  final TextEditingController cOnBoardYou = TextEditingController();
  final FocusNode fOnBoardYou = FocusNode();
//time for interview
  final TextEditingController cTimeForInterview = TextEditingController();
  final FocusNode fTimeForInterview = FocusNode();
//live city
  final TextEditingController cLiveCity = TextEditingController();
  final FocusNode fLiveCity = FocusNode();
//source of business
  String? selectedSourceOfBusiness;
//source of business
  String? selectedHighestQualification;
//source of business
  String? selectedDegreeDiploma;
//College/School/university
  final TextEditingController cCollegeSchoolUniversity =
      TextEditingController();
  final FocusNode fCollegeSchoolUniversity = FocusNode();
//Learn Astrology
  final TextEditingController cLearnAstrology = TextEditingController();
  final FocusNode fLearnAstroLogy = FocusNode();
//Insta
  final TextEditingController cInsta = TextEditingController();
  final FocusNode fInsta = FocusNode();
//Facebook
  final TextEditingController cFacebook = TextEditingController();
  final FocusNode fFacebook = FocusNode();
//LinkedIn
  final TextEditingController cLinkedIn = TextEditingController();
  final FocusNode fLinkedIn = FocusNode();
//Youtube
  final TextEditingController cYoutube = TextEditingController();
  final FocusNode fYoutube = FocusNode();
//Website
  final TextEditingController cWebSite = TextEditingController();
  final FocusNode fWebSite = FocusNode();
//refer
  final TextEditingController cNameOfReferPerson = TextEditingController();
  final FocusNode fNameOfReferPerson = FocusNode();
  int? referPerson;
  void setReferPerson(int? index) {
    referPerson = index;
    update();
  }

//Expected Minimum Earning from Astroguru
  final TextEditingController cExptectedMinimumEarning =
      TextEditingController();
  final FocusNode fExpectedMinimumEarning = FocusNode();
//Expected Maximum Earning
  final TextEditingController cExpectedMaximumEarning = TextEditingController();
  final FocusNode fExpectedMaximumEarning = FocusNode();
//Long Bio
  final TextEditingController cLongBio = TextEditingController();
  final FocusNode fLongBio = FocusNode();

//-------------------------Assignment----------------------------

//foreign country
  String? selectedForeignCountryCount;
//currently working as job
  String? selectedCurrentlyWorkingJob;

//Facebook
  final TextEditingController cGoodQuality = TextEditingController();
  final FocusNode fGoodQuality = FocusNode();
//LinkedIn
  final TextEditingController cBiggestChallenge = TextEditingController();
  final FocusNode fBiggestChallenge = FocusNode();
//Youtube
  final TextEditingController cRepeatedQuestion = TextEditingController();
  final FocusNode fRepeatedQuestion = FocusNode();

//--------------------------time------------------------------------
  List<Week>? week = [];
  List<TimeAvailabilityModel>? timeAvailabilityList = [];
  List<String?> daysList = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];

  void clearTime() {
    cStartTime.text = '';
    cEndTime.text = '';
  }

//---------------------------Availability---------------------------
  final TextEditingController cSunday = TextEditingController();
  final TextEditingController cMonday = TextEditingController();
  final TextEditingController cTuesday = TextEditingController();
  final TextEditingController cWednesday = TextEditingController();
  final TextEditingController cThursday = TextEditingController();
  final TextEditingController cFriday = TextEditingController();
  final TextEditingController cSaturday = TextEditingController();

  final cStartTime = TextEditingController();
  final cEndTime = TextEditingController();

  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  //Available Time Start
  selectStartTime(BuildContext context) async {
    try {
      final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: selectedStartTime,
        initialEntryMode: TimePickerEntryMode.dial,
      );

      if (timeOfDay != null) {
        selectedStartTime = timeOfDay;
        cStartTime.text = timeOfDay.format(context);
      }
      update();
    } catch (e) {
      print('Exception - $screen - selectStartTime():' + e.toString());
    }
  }

  TimeOfDay timeforInterview = TimeOfDay.now();
  timeforInterView(BuildContext context) async {
    try {
      final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: timeforInterview,
        initialEntryMode: TimePickerEntryMode.dial,
      );
      if (timeOfDay != null) {
        timeforInterview = timeOfDay;
        cTimeForInterview.text = timeOfDay.format(context);
      }
      update();
    } catch (e) {
      print('Exception  - $screen - timeforInterView():' + e.toString());
    }
  }

  BankDetailsModel? bankDetailsModel;
  Future getBankDetails(String? ifscCode) async {
    print("Your bank isfc code $ifscCode");
    try {
      await apiHelper.verifyIFSC(ifscCode).then((result) {
        log("my resultstatus $result");
        if (result != null) {
          bankDetailsModel = result;
          log("Print my Bank name ${bankDetailsModel!.bank}");
          cbankbranch.text = bankDetailsModel!.branch.toString();
          cbankname.text = bankDetailsModel!.bank.toString();
          // update();
        } else {
          global.showToast(
            message: 'Failed To Fetch BankDetails',
          );
        }
      });
    } catch (e) {
      print("getBankDetails(): Exception  $e");
    }
  }

  //Available Time End
  selectEndTime(BuildContext context) async {
    try {
      final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: selectedEndTime,
        initialEntryMode: TimePickerEntryMode.dial,
      );
      if (timeOfDay != null) {
        selectedEndTime = timeOfDay;
        cEndTime.text = timeOfDay.format(context);
      }
      update();
    } catch (e) {
      print('Exception - $screen - selectEndTime():' + e.toString());
    }
  }

//----------Button On Tap---------
  onStepBack() {
    if (index >= 0) {
      index -= 1;
      update();
    }
  }

  onStepNext() {
    if (index == 0 || index > 0) {
      index += 1;
      update();
    }
  }

  List<DocList>? documentList = [];
  getdocumentsDetail() async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            await apiHelper.getdocumetdetailsApi().then(
              (result) async {
                global.hideLoader();
                if (result?.status == 200) {
                  documentList?.clear();
                  if (result?.recordList != null) {
                    documentList!.addAll(result!.recordList!);
                  }
                  log('document list size ${documentList!.length}');

                  update();
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - rejectCallRequest(): ' + e.toString());
    }
  }

  //Fill data
  fillAstrologer(CurrentUser user) {
    log('edit-fill-Astrologer body -> ${json.encode(user.toJson())}');

    try {
      if (global.user.name != null && global.user.name != '') {
        cName.text = global.user.name!;
      }
      if (global.user.email != null && global.user.email != '') {
        cEmail.text = global.user.email!;
      }
      if (global.user.contactNo != null && global.user.contactNo != '') {
        cMobileNumber.text = global.user.contactNo!;
      }
      if (global.user.imagePath != null && global.user.imagePath != '') {
        selectedImage = File(global.user.imagePath.toString());
        profile = global.user.imagePath!;
      }
      if (global.user.gender != null && global.user.gender != '') {
        selectedGender = global.user.gender!;
      }
      if (global.user.birthDate != null) {
        cBirthDate.text = DateFormat('dd-MM-yyyy')
            .format(DateTime.parse(global.user.birthDate.toString()));
        selectedDate = DateTime.parse(global.user.birthDate.toString());
      }
      if (global.user.astrologerCategoryId != null &&
          global.user.astrologerCategoryId != []) {
        cSelectCategory.text = global.user.astrologerCategoryId!
            .map((e) => e.name)
            .toList()
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', '');
        for (var i = 0; i < global.astrologerCategoryModelList!.length; i++) {
          global.astrologerCategoryModelList![i].isCheck = false;
          for (var j = 0; j < global.user.astrologerCategoryId!.length; j++) {
            if (global.user.astrologerCategoryId![j].id ==
                global.astrologerCategoryModelList![i].id) {
              global.astrologerCategoryModelList![i].isCheck = true;
            }
          }
        }
      }

      if (global.user.primarySkillId != null &&
          global.user.primarySkillId != []) {
        cPrimarySkill.text = global.user.primarySkillId!
            .map((e) => e.name)
            .toList()
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', '');
        for (var i = 0; i < global.skillModelList!.length; i++) {
          global.skillModelList![i].isCheck = false;
          for (var j = 0; j < global.user.primarySkillId!.length; j++) {
            if (global.user.primarySkillId![j].id ==
                global.skillModelList![i].id) {
              global.skillModelList![i].isCheck = true;
            }
          }
        }
      }
      if (global.user.allSkillId != null && global.user.allSkillId != []) {
        cAllSkill.text = global.user.allSkillId!
            .map((e) => e.name)
            .toList()
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', '');
        for (var i = 0; i < global.allSkillModelList!.length; i++) {
          global.allSkillModelList![i].isCheck = false;
          for (var j = 0; j < global.user.allSkillId!.length; j++) {
            if (global.user.allSkillId![j].id ==
                global.allSkillModelList![i].id) {
              global.allSkillModelList![i].isCheck = true;
            }
          }
        }
      }
      if (global.user.languageId != null && global.user.languageId != []) {
        cLanguage.text = global.user.languageId!
            .map((e) => e.name)
            .toList()
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', '');
        for (var i = 0; i < global.languageModelList!.length; i++) {
          global.languageModelList![i].isCheck = false;
          for (var j = 0; j < global.user.languageId!.length; j++) {
            if (global.user.languageId![j].id ==
                global.languageModelList![i].id) {
              global.languageModelList![i].isCheck = true;
            }
          }
        }
      }
      if (global.user.aadharNo != null && global.user.aadharNo != '') {
        cadharno.text = global.user.aadharNo!.toString();
        log('set edit adhar card no is ${cadharno.text}');
      }

      if (global.user.whatsappNo != null && global.user.whatsappNo != '') {
        cwhatsappno.text = global.user.whatsappNo!.toString();
      }
      if (global.user.pancardNo != null && global.user.pancardNo != '') {
        cpancard.text = global.user.pancardNo!.toString();
      }
      if (global.user.ifscCode != null && global.user.ifscCode != '') {
        cIFSC.text = global.user.ifscCode!.toString();
      }
      if (global.user.bankBranch != null && global.user.bankBranch != '') {
        cbankbranch.text = global.user.bankBranch!.toString();
      }
      if (global.user.bankName != null && global.user.bankName != '') {
        cbankname.text = global.user.bankName!.toString();
      }
      if (global.user.accountType != null && global.user.accountType != '') {
        defaultaccountType = global.user.accountType!.toString();
      }

      log("My Account Number ${global.user.accountNumber}");
      if (global.user.accountNumber != null &&
          global.user.accountNumber != '') {
        caccountno.text = global.user.accountNumber!.toString();
      }
      if (global.user.accountHoldername != null &&
          global.user.accountHoldername != "") {
        caccountHolderName.text = global.user.accountHoldername!.toString();
      }

      log("My Upi ${global.user.upi}");
      if (global.user.upi != null && global.user.upi != '') {
        cupi.text = global.user.upi!.toString();
      }
      if (global.user.charges != null) {
        cCharges.text = global.user.charges.toString();
      }
      if (global.user.cusdcharges != null) {
        cusdCharges.text = global.user.cusdcharges.toString();
      }
      if (global.user.videoCallRate != null) {
        cVideoCharges.text = global.user.videoCallRate.toString();
      }
      if (global.user.videoCallRateUsd != null) {
        cusdVideoCharges.text = global.user.videoCallRateUsd.toString();
      }
      if (global.user.reportRate != null) {
        cReportCharges.text = global.user.reportRate.toString();
      }
      if (global.user.reportRateUsd != null) {
        cusdReportCharges.text = global.user.reportRateUsd.toString();
      }
      if (global.user.expirenceInYear != null) {
        cExpirence.text = global.user.expirenceInYear.toString();
      }
      if (global.user.dailyContributionHours != null) {
        cContributionHours.text = global.user.dailyContributionHours.toString();
      }
      if (global.user.hearAboutAstroGuru != null &&
          global.user.hearAboutAstroGuru != '') {
        cHearAboutAstroGuru.text = global.user.hearAboutAstroGuru!;
      }
      if (global.user.isWorkingOnAnotherPlatform != null) {
        anyOnlinePlatform = global.user.isWorkingOnAnotherPlatform;
      }
      if (global.user.otherPlatformName != null &&
          global.user.otherPlatformName != '') {
        cNameOfPlatform.text = global.user.otherPlatformName!;
      }
      if (global.user.otherPlatformMonthlyEarning != null &&
          global.user.otherPlatformMonthlyEarning != '') {
        cMonthlyEarning.text = global.user.otherPlatformMonthlyEarning!;
      }
      if (global.user.onboardYou != null && global.user.onboardYou != '') {
        cOnBoardYou.text = global.user.onboardYou!;
      }
      if (global.user.suitableInterviewTime != null &&
          global.user.suitableInterviewTime != '') {
        cTimeForInterview.text = global.user.suitableInterviewTime!;
      }
      if (global.user.currentCity != null && global.user.currentCity != '') {
        cLiveCity.text = global.user.currentCity!;
      }
      if (global.user.mainSourceOfBusiness != null &&
          global.user.mainSourceOfBusiness != '') {
        selectedSourceOfBusiness = global.user.mainSourceOfBusiness!;
      }
      if (global.user.highestQualification != null &&
          global.user.highestQualification != '') {
        selectedHighestQualification = global.user.highestQualification!;
      }
      if (global.user.degreeDiploma != null &&
          global.user.degreeDiploma != '') {
        selectedDegreeDiploma = global.user.degreeDiploma!;
      }
      if (global.user.collegeSchoolUniversity != null &&
          global.user.collegeSchoolUniversity != '') {
        cCollegeSchoolUniversity.text = global.user.collegeSchoolUniversity!;
      }
      if (global.user.learnAstrology != null &&
          global.user.learnAstrology != '') {
        cLearnAstrology.text = global.user.learnAstrology!;
      }
      if (global.user.instagramProfileLink != null &&
          global.user.instagramProfileLink != '') {
        cInsta.text = global.user.instagramProfileLink!;
      }
      if (global.user.facebookProfileLink != null &&
          global.user.facebookProfileLink != '') {
        cFacebook.text = global.user.facebookProfileLink!;
      }
      if (global.user.linkedInProfileLink != null &&
          global.user.linkedInProfileLink != '') {
        cLinkedIn.text = global.user.linkedInProfileLink!;
      }
      if (global.user.youtubeProfileLink != null &&
          global.user.youtubeProfileLink != '') {
        cYoutube.text = global.user.youtubeProfileLink!;
      }
      if (global.user.webSiteProfileLink != null &&
          global.user.webSiteProfileLink != '') {
        cWebSite.text = global.user.webSiteProfileLink!;
      }
      if (global.user.isAnyBodyRefer != null) {
        referPerson = global.user.isAnyBodyRefer;
      }
      if (global.user.referedPersonName != null &&
          global.user.referedPersonName != '') {
        cNameOfReferPerson.text = global.user.referedPersonName!;
      }
      if (global.user.expectedMinimumEarning != null) {
        cExptectedMinimumEarning.text =
            global.user.expectedMinimumEarning.toString();
      }
      if (global.user.expectedMaximumEarning != null) {
        cExpectedMaximumEarning.text =
            global.user.expectedMaximumEarning.toString();
      }
      if (global.user.longBio != null && global.user.longBio != '') {
        cLongBio.text = global.user.longBio!;
      }
      if (global.user.foreignCountryCount != null &&
          global.user.foreignCountryCount != '') {
        selectedForeignCountryCount = global.user.foreignCountryCount!;
      }
      if (global.user.currentlyWorkingJob != null &&
          global.user.currentlyWorkingJob != '') {
        selectedCurrentlyWorkingJob = global.user.currentlyWorkingJob!;
      }
      if (global.user.goodQualityOfAstrologer != null &&
          global.user.goodQualityOfAstrologer != '') {
        cGoodQuality.text = global.user.goodQualityOfAstrologer!;
      }
      if (global.user.biggestChallengeFaced != null &&
          global.user.biggestChallengeFaced != '') {
        cBiggestChallenge.text = global.user.biggestChallengeFaced!;
      }
      if (global.user.repeatedQuestion != null &&
          global.user.repeatedQuestion != '') {
        cRepeatedQuestion.text = global.user.repeatedQuestion!;
      }
      week = [];
      if (global.user.week != null && global.user.week != []) {
        for (var i = 0; i < global.user.week!.length; i++) {
          week!.add(Week(
              day: global.user.week![i].day,
              timeAvailabilityList: global.user.week![i].timeAvailabilityList));
        }
      }
    } catch (e) {
      print("Exception - $screen - fillAstrologer(): " + e.toString());
    }
  }

  updateValidateForm(int index, {BuildContext? context}) {
    try {
//------Validation_of_Personal_Detail-----------------
      if (index == 0) {
        if (cName.text != "" &&
            (cEmail.text != '' && GetUtils.isEmail(cEmail.text)) &&
            (cMobileNumber.text != "" && cMobileNumber.text.length == 10) &&
            termAndCondtion.value == true) {
          print("index = 0");
          onStepNext();
        } else if (cName.text == "") {
          global.showToast(message: tr("Please Enter Valid Name"));
        } else if (cEmail.text == '' || !GetUtils.isEmail(cEmail.text)) {
          global.showToast(message: tr("Please Enter Valid Email Address"));
        } else if (cMobileNumber.text == '' ||
            cMobileNumber.text.length != 10) {
          global.showToast(message: tr("Please Enter Valid Mobile Number"));
        } else if (termAndCondtion.value == false) {
          global.showToast(message: tr("Please Agree With T&C"));
        } else {
          global.showToast(
              message: tr("Something Wrong in Personal Detail Form"));
        }
      }
//------Validation_of_Skill_Detail-----------------
      else if (index == 1) {
        if (selectedGender != "" &&
            selectedDate != null &&
            cSelectCategory.text != "" &&
            cPrimarySkill.text != "" &&
            cAllSkill.text != "" &&
            cLanguage.text != "" &&
            cwhatsappno.text != "" &&
            cpancard.text != "" &&
            caccountHolderName.text != "" &&
            cadharno.text != "" &&
            cIFSC.text != "" &&
            cbankname.text != "" &&
            cbankbranch.text != "" &&
            defaultaccountType != "" &&
            caccountno.text != "" &&
            cconfiaccountno.text != "" &&
            cupi.text != "" &&
            cCharges.text != "" &&
            cusdCharges.text != "" &&
            cVideoCharges.text != "" &&
            cusdVideoCharges.text != "" &&
            cReportCharges.text != "" &&
            cusdReportCharges.text != "" &&
            cExpirence.text != "" &&
            cContributionHours.text != "" &&
            (int.parse(cconfiaccountno.text) == int.parse(caccountno.text)) &&
            (anyOnlinePlatform == 1 && cNameOfPlatform.text != "" ||
                anyOnlinePlatform == 2 ||
                anyOnlinePlatform == null) &&
            (anyOnlinePlatform == 1 && cMonthlyEarning.text != "" ||
                anyOnlinePlatform == 2 ||
                anyOnlinePlatform == null)) {
          print("index = 1");
          onStepNext();
        } else if (selectedGender == "") {
          global.showToast(message: tr("Please Select Gender"));
        } else if (selectedDate == null) {
          global.showToast(message: tr("Please Select Date of Birth"));
        } else if (cSelectCategory.text == "") {
          global.showToast(message: tr("Please Select astrologer category"));
        } else if (cPrimarySkill.text == "") {
          global.showToast(message: tr("Please Select Primary Skill"));
        } else if (cAllSkill.text == "") {
          global.showToast(message: tr("Please Select All Skill"));
        } else if (cLanguage.text == "") {
          global.showToast(message: tr("Please Select Language"));
        } else if (cCharges.text == "") {
          global.showToast(message: tr("Please Enter Charges"));
        } else if (cwhatsappno.text == "") {
          global.showToast(message: tr("Please Enter whatsapp No"));
        } else if (cpancard.text == "") {
          global.showToast(message: tr("Please Enter Pan Card No"));
        } else if (cadharno.text == "") {
          global.showToast(message: tr("Please Enter Aadhar Card No"));
        } else if (cIFSC.text == "") {
          global.showToast(message: tr("Please Enter IFSC Code"));
        } else if (cbankbranch.text == "") {
          global.showToast(message: tr("Please Enter Bank Branch"));
        } else if (cbankname.text == "") {
          global.showToast(message: tr("Please Enter Bank Name"));
        } else if (defaultaccountType == "") {
          global.showToast(message: tr("Please Enter Account type"));
        } else if (caccountHolderName.text == "") {
          global.showToast(message: tr("Please Enter Account Holder Name"));
        } else if (caccountno.text == "") {
          global.showToast(message: tr("Please Enter Account Number"));
        } else if (cconfiaccountno.text == "") {
          global.showToast(message: tr("Please Confirm Your Account Number"));
        } else if (int.parse(cconfiaccountno.text) !=
            int.parse(caccountno.text)) {
          global.showToast(message: tr("Please Use Same Account Number"));
        } else if (cupi.text == "") {
          global.showToast(message: tr("Please Enter Upi Number"));
        } else if (cusdCharges.text == "") {
          global.showToast(message: tr("Please Enter USD Charges"));
        } else if (cVideoCharges.text == "") {
          global.showToast(message: tr("Please Enter video Charges"));
        } else if (cusdVideoCharges.text == "") {
          global.showToast(message: tr("Please Enter USD video Charges"));
        } else if (cReportCharges.text == "") {
          global.showToast(message: tr("Please Enter report Charges"));
        } else if (cusdReportCharges.text == "") {
          global.showToast(message: tr("Please Enter USD report Charges"));
        } else if (cExpirence.text == "") {
          global.showToast(message: tr("Please Enter Expirence"));
        } else if (cContributionHours.text == "") {
          global.showToast(message: tr("Please Enter Contribution Hours"));
        } else if (anyOnlinePlatform == 1 && cNameOfPlatform.text == "") {
          global.showToast(message: tr("Please Enter Name Of Platform"));
        } else if (anyOnlinePlatform == 1 && cMonthlyEarning.text == "") {
          global.showToast(message: tr("Please Enter Monthly Earning"));
        } else {
          global.showToast(message: tr("Something Wrong in Skill Detail Form"));
        }
      }
//------Validation_of_Other_Detail-----------------
      else if (index == 2) {
        if (cOnBoardYou.text != "" &&
            cTimeForInterview.text != "" &&
            (selectedSourceOfBusiness != "" &&
                selectedSourceOfBusiness != null) &&
            (selectedHighestQualification != "" &&
                selectedHighestQualification != null) &&
            (selectedDegreeDiploma != "" && selectedDegreeDiploma != null) &&
            cExptectedMinimumEarning.text != "" &&
            cExpectedMaximumEarning.text != "" &&
            cLongBio.text != "") {
          print("index = 2");
          onStepNext();
        } else if (cOnBoardYou.text == "") {
          global.showToast(message: ConstantsKeys.WHYONBOARDYOU);
        } else if (cTimeForInterview.text == "") {
          global.showToast(message: ConstantsKeys.SUITABLETIME);
        } else if (selectedSourceOfBusiness == null ||
            selectedSourceOfBusiness == "") {
          global.showToast(message: ConstantsKeys.SOURCEOFBUSINESS);
        } else if (selectedHighestQualification == null ||
            selectedHighestQualification == "") {
          global.showToast(message: ConstantsKeys.HIGHESTQUALIFICATION);
        } else if (selectedDegreeDiploma == null ||
            selectedDegreeDiploma == "") {
          global.showToast(message: ConstantsKeys.DEGREEDIPLOMA);
        } else if (cExptectedMinimumEarning.text == "") {
          global.showToast(message: ConstantsKeys.MINIMUMEARNING);
        } else if (cExpectedMaximumEarning.text == "") {
          global.showToast(message: ConstantsKeys.MAXEARNING);
        } else if (cLongBio.text == "") {
          global.showToast(message: ConstantsKeys.LONGBIO);
        } else {
          global.showToast(message: ConstantsKeys.OTHERDETAIL);
        }
      }
//------Validation_of_Assignment-----------------
      else if (index == 3) {
        if ((selectedForeignCountryCount != "" &&
                selectedForeignCountryCount != null) &&
            (selectedCurrentlyWorkingJob != "" &&
                selectedCurrentlyWorkingJob != null) &&
            cGoodQuality.text != "" &&
            cBiggestChallenge.text != "" &&
            cRepeatedQuestion.text != "") {
          print("index = 3");
          onStepNext();
        } else if (selectedForeignCountryCount == "" ||
            selectedForeignCountryCount == null) {
          global.showToast(message: ConstantsKeys.NOOFFOREIGNCOUNTRIES);
        } else if (selectedCurrentlyWorkingJob == "" ||
            selectedCurrentlyWorkingJob == null) {
          global.showToast(message: ConstantsKeys.CURRENTWORKING);
        } else if (cGoodQuality.text == "") {
          global.showToast(message: ConstantsKeys.GOODQUALITY);
        } else if (cBiggestChallenge.text == "") {
          global.showToast(message: ConstantsKeys.BIGGESTCHALLENGE);
        } else if (cRepeatedQuestion.text == "") {
          global.showToast(message: ConstantsKeys.REPORTEDQUESTION);
        } else {
          global.showToast(message: ConstantsKeys.SOMETHINGWRONG);
        }
      } else if (index == 4) {
        onStepNext();
      }
//------Validation_of_Availability_Detail-----------------
      else if (index == 5) {
        updateAstrologer(updateId!);
      } else {
        global.showToast(message: tr("No Index Found"));
      }
    } catch (err) {
      global.printException(
          "edit_profile_controller.dart", "updateValidateForm()", err);
    }
  }

//Update astrologer
  CurrentUser updateUser = CurrentUser();
  Future updateAstrologer(int id) async {
    try {
      await global.checkBody().then(
        (networkResult) async {
          if (networkResult) {
            int a = global.user.userId!;
            updateUser.id = id;
            updateUser.userId = a;
            updateUser.roleId = 2;
            updateUser.name = cName.text;
            updateUser.email = cEmail.text;
            updateUser.contactNo = cMobileNumber.text;
            if (userFile != null) {
              updateUser.imagePath = userFile!.path;
            } else {
              updateUser.imagePath = global.user.imagePath;
            }
            log('profile pic in update is ${updateUser.imagePath}');
            if (profile != null && profile != '') {
              updateUser.imagePath = profile;
            }
            updateUser.gender = selectedGender;
            updateUser.birthDate = selectedDate;
            updateUser.primarySkill = cPrimarySkill.text;
            updateUser.astrologerCategory = cSelectCategory.text;
            updateUser.allSkill = cAllSkill.text;
            updateUser.languageKnown = cLanguage.text;
            updateUser.charges = int.parse(cCharges.text);
            updateUser.cusdcharges = int.parse(cusdCharges.text); //added new
            updateUser.videoCallRate = int.parse(cVideoCharges.text);
            updateUser.videoCallRateUsd =
                int.parse(cusdVideoCharges.text); //added new
            updateUser.reportRate = int.parse(cReportCharges.text);
            updateUser.reportRateUsd =
                int.parse(cusdReportCharges.text); //added new
            updateUser.expirenceInYear = int.parse(cExpirence.text);
            updateUser.dailyContributionHours =
                int.parse(cContributionHours.text);
            updateUser.hearAboutAstroGuru = cHearAboutAstroGuru.text;
            updateUser.isWorkingOnAnotherPlatform = anyOnlinePlatform;
            updateUser.otherPlatformName = cNameOfPlatform.text;
            updateUser.otherPlatformMonthlyEarning = cMonthlyEarning.text;
            updateUser.onboardYou = cOnBoardYou.text;
            updateUser.suitableInterviewTime = cTimeForInterview.text;
            updateUser.currentCity = cLiveCity.text;
            updateUser.mainSourceOfBusiness = selectedSourceOfBusiness;
            updateUser.highestQualification = selectedHighestQualification;
            updateUser.degreeDiploma = selectedDegreeDiploma;
            updateUser.collegeSchoolUniversity = cCollegeSchoolUniversity.text;
            updateUser.learnAstrology = cLearnAstrology.text;
            updateUser.instagramProfileLink = cInsta.text;
            updateUser.facebookProfileLink = cFacebook.text;
            updateUser.linkedInProfileLink = cLinkedIn.text;
            updateUser.youtubeProfileLink = cYoutube.text;
            updateUser.webSiteProfileLink = cWebSite.text;
            updateUser.isAnyBodyRefer = referPerson;
            updateUser.referedPersonName = cNameOfReferPerson.text;
            updateUser.expectedMinimumEarning =
                int.parse(cExptectedMinimumEarning.text);
            updateUser.expectedMaximumEarning =
                int.parse(cExpectedMaximumEarning.text);
            updateUser.longBio = cLongBio.text;
            updateUser.foreignCountryCount = selectedForeignCountryCount;
            updateUser.currentlyWorkingJob = selectedCurrentlyWorkingJob;
            updateUser.goodQualityOfAstrologer = cGoodQuality.text;
            updateUser.biggestChallengeFaced = cBiggestChallenge.text;
            updateUser.repeatedQuestion = cRepeatedQuestion.text;
            updateUser.token = global.user.token;
            updateUser.tokenType = global.user.tokenType;
            updateUser.week = [];
            updateUser.documentmap = global.globaldocumentmap;
            updateUser.whatsappNo =
                int.parse(cwhatsappno.text.toString()); //int
            updateUser.pancardNo = cpancard.text;
            updateUser.aadharNo =
                int.parse(cadharno.text.toString()); //intcadharno.text;
            updateUser.ifscCode = cIFSC.text;
            updateUser.bankBranch = cbankbranch.text;
            updateUser.bankName = cbankname.text;
            updateUser.accountHoldername = caccountHolderName.text;
            updateUser.accountType = defaultaccountType;
            updateUser.accountNumber = caccountno.text;
            updateUser.upi = cupi.text;
            // log('document editing is ${updateUser.documentmap}');
            for (var i = 0; i < week!.length; i++) {
              if (week![i].timeAvailabilityList!.isNotEmpty) {
                updateUser.week!.add(Week(
                    day: week![i].day,
                    timeAvailabilityList: week![i].timeAvailabilityList));
              }
            }

            //Astrologer category
            updateUser.astrologerCategoryId = [];
            if (astroId.isEmpty) {
              for (var i = 0;
                  i < global.user.astrologerCategoryId!.length;
                  i++) {
                updateUser.astrologerCategoryId!
                    .add(global.user.astrologerCategoryId![i]);
              }
            } else {
              for (var i = 0; i < astroId.length; i++) {
                updateUser.astrologerCategoryId!.add(astroId[i]);
              }
            }

            //Primary skill
            updateUser.primarySkillId = [];
            if (primaryId.isEmpty) {
              for (var i = 0; i < global.user.primarySkillId!.length; i++) {
                updateUser.primarySkillId!.add(global.user.primarySkillId![i]);
              }
            } else {
              for (var i = 0; i < primaryId.length; i++) {
                updateUser.primarySkillId!.add(primaryId[i]);
              }
            }

            //All skill
            updateUser.allSkillId = [];
            if (allId.isEmpty) {
              for (var i = 0; i < global.user.allSkillId!.length; i++) {
                updateUser.allSkillId!.add(global.user.allSkillId![i]);
              }
            } else {
              for (var i = 0; i < allId.length; i++) {
                updateUser.allSkillId!.add(allId[i]);
              }
            }

            //language known
            updateUser.languageId = [];
            if (lId.isEmpty) {
              for (var i = 0; i < global.user.languageId!.length; i++) {
                updateUser.languageId!.add(global.user.languageId![i]);
              }
            } else {
              for (var i = 0; i < lId.length; i++) {
                updateUser.languageId!.add(lId[i]);
              }
            }

            await apiHelper.astrologerUpdate(updateUser).then(
              (apiResult) async {
                log('apiResult status is ${apiResult.status}');

                if (apiResult.status == '200') {
                  String token=global.user.token.toString();
                  String tokenType=global.user.tokenType.toString();
                  global.user = apiResult.recordList;
                  global.user.tokenType=tokenType;
                  global.user.token=token;
                  signupController.astrologerList.clear();
                  await signupController.astrologerProfileById(false);
                  update();
                  await global.sp!.setString(ConstantsKeys.CURRENTUSER,
                      json.encode(global.user.toJson()));
                  global.showToast(
                      message: tr("Your profile has been updated"));

                  Get.back();
                } else if (apiResult.status == '400') {
                  global.showToast(message: apiResult.message.toString());
                } else {
                  global.showToast(
                      message:
                          tr("Something Went Wrong, Please Try Again Later"));
                }
                Get.find<EditProfileController>().update();
              },
            );
          } else {
            global.showToast(message: tr("No Network Available"));
          }
        },
      );
      update();
    } catch (err) {
      global.printException(
          "edit_profile_controller.dart", "updateAstrologer", err);
    }
  }
}
