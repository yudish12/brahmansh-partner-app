// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, avoid_print, duplicate_ignore, strict_top_level_inference

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:brahmanshtalk/models/bankDetailsModel.dart';
import 'package:brahmanshtalk/models/docmodel.dart';
import 'package:date_format/date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import '../../models/Master Table Model/all_skill_model.dart';
import '../../models/Master Table Model/astrologer_category_list_model.dart';
import '../../models/Master Table Model/language_list_model.dart';
import '../../models/Master Table Model/primary_skill_model.dart';
import '../../models/ScheduleLiveModel.dart';
import '../../models/time_availability_model.dart';
import '../../models/user_model.dart';
import '../../models/week_model.dart';
import '../../services/apiHelper.dart';
import '../../utils/constantskeys.dart';
import '../../views/Authentication/OtpScreens/signup_otp_screen.dart';
import '../../views/Authentication/success_registration_screen.dart';

class SignupController extends GetxController {
//Class
  APIHelper apiHelper = APIHelper();
  String screen = 'signup_controller.dart';

  final cReply = TextEditingController();
  void clearReply() {
    cReply.text = '';
  }

  List<CurrentUser?> astrologerList = [];
  String countryCode = "+91";
  String countryName = "India";

  String phoneNumber = '';

  List<String> optionsList = [
    "Profile Video",
    "Live Schedule",
    "Offer Discounts",
    "Skill Details",
    "Other Details",
    "Assignment",
    "Availability"
  ];
  List<Color> colorsList = const [
    Colors.pink,
    Colors.green,
    Color(0xFF875E5D),
    Color(0xFF535456),
    Color.fromARGB(255, 35, 31, 29),
    Color(0xFF738B99),
    Colors.orange
  ];
  String obscureEmail(String email) {
    if (email.isEmpty) return "";
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final localPart = parts[0];
    final domainPart = parts[1];
    final obscuredLocalPart = localPart.length > 2
        ? localPart[0] +
            '*' * (localPart.length - 2) +
            localPart[localPart.length - 1]
        : localPart;

    return '$obscuredLocalPart@$domainPart';
  }

  List<String> optionsIconList = [
    "assets/images/profilescreenicons/upload_video.png",
    "assets/images/profilescreenicons/live_scheduled.png",
    "assets/images/profilescreenicons/reduce-cost.png",
    "assets/images/profilescreenicons/critical-thinking.png",
    "assets/images/profilescreenicons/otherdetail.png",
    "assets/images/profilescreenicons/assignment.png",
    "assets/images/profilescreenicons/avail.png"
  ];

  String obscurePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return "";

    final cleanedPhoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (cleanedPhoneNumber.length <= 4) return cleanedPhoneNumber;

    final visibleStart = cleanedPhoneNumber.substring(0, 2);
    final visibleEnd =
        cleanedPhoneNumber.substring(cleanedPhoneNumber.length - 2);
    final obscuredMiddle = '*' * (cleanedPhoneNumber.length - 4);
    return '$visibleStart$obscuredMiddle$visibleEnd';
  }

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

  List<ScheduleLive> scheduleList = [];

  Future<void> fetchScheduleList() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog();
          await apiHelper.getScheduleLiveList().then((result) {
            global.hideLoader();
            log('status is ${result.status} and type is ${result.status.runtimeType}');
            if (result.status == "200") {
              scheduleList = result.recordList;
              update();
            } else {
              global.showToast(message: "${result.message}");
            }
          });
        }
      });
    } catch (e) {
      print("Exception in fetchScheduleList: $e");
    }
  }

  Future<void> deleteLiveSchedule(int itemid) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog();
          await apiHelper.deleteScheduleLive(itemid).then((result) {
            global.hideLoader();
            log("✅ API Response: ${result.status} and type is ${result.status.runtimeType}");
            if (result.status == 'true') {
              scheduleList.removeWhere((e) {
                final match = e.id == itemid;
                return match;
              });
              update();
              global.showToast(
                  message: result.message ?? "Schedule deleted successfully");
            } else {
              global.showToast(message: "Delete failed");
            }
          });
        }
      });
    } catch (e) {
      print("Exception in deleteLiveSchedule: $e");
    }
  }

  updateCountryCode(String? value) {
    countryCode = value!;
    log('country code is $countryCode');
    update();
  }

  updateCountryName(String? value) {
    countryName = value!;
    log('countryName is $countryName');
    update();
  }

  updatephoneno(String? value) {
    phoneNumber = value!;
    log(' phoneNumber is $phoneNumber');
    update();
  }

  //List of checkbox
  List<AstrolgoerCategoryModel> astroId = [];
  List<PrimarySkillModel> primaryId = [];
  List<AllSkillModel> allId = [];
  List<LanguageModel> lId = [];

//static List
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

//--------------------Personal Details----------------------
//Name
  final TextEditingController cName = TextEditingController();
  final FocusNode fName = FocusNode();

  final TextEditingController dsplyName = TextEditingController();
  final FocusNode dsplyfName = FocusNode();
//Email
  final TextEditingController cEmail = TextEditingController();
  final FocusNode fEmail = FocusNode();
//Mobile Numer
  final TextEditingController cMobileNumber = TextEditingController();
  final FocusNode fMobileNumber = FocusNode();
//Terms ANd Condition
  RxBool termAndCondtion = false.obs;
//--------------------------Skills Details----------------------
//User Image
  Uint8List? tImage;
  File? selectedImage;
  var imagePath = ''.obs;
  onOpenCamera() async {
    selectedImage = await openCamera(Get.theme.primaryColor).obs();
    update();
  }

  onOpenGallery() async {
    selectedImage = await openGallery(Get.theme.primaryColor).obs();
    update();
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

          List<int> decodedbytes = base64.decode(imagePath.value);
          return File(decodedbytes.toString());
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

  bool select = false;
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
  // Account Type
  String defaultaccountType = 'Saving';
  List<String> accountTypeOptions = ['Saving', 'Current'];

  //Video usd call Charge
  final TextEditingController cusdVideoCharges = TextEditingController();
  final FocusNode fusdVideoCharges = FocusNode();
  //Charge
  final TextEditingController cReportCharges = TextEditingController();
  final FocusNode fReportCharges = FocusNode();

  //USD REPORT Charge
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

  //BANK ACCOUNT HOLDER NAME
  final TextEditingController caccountHolderName = TextEditingController();
  final FocusNode faccountHolderName = FocusNode();

  //BANK name
  final TextEditingController cbankname = TextEditingController();
  final FocusNode fbankname = FocusNode();

  //account type name
  final TextEditingController caccounttype = TextEditingController();
  final FocusNode faccounttypee = FocusNode();

  //account type name
  final TextEditingController caccountno = TextEditingController();
  final FocusNode faccountno = FocusNode();

  //comfirm account number
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

  TimeOfDay timeforInterview = TimeOfDay.now();

  final couponController = TextEditingController();
  bool? isCouponValid;

  void clearTime() {
    cStartTime.text = '';
    cEndTime.text = '';
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

// dynamic Availability Widget
  Widget dynamicWeekFieldWidget(BuildContext? context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        height: 35,
        child: Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          height: 35,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(""),
        ),
      ),
    );
  }

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
      print('Exception  - $screen - selectStartTime():' + e.toString());
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

//----------------------Button On Tap-------------------
  int index = 0;
  onStepBack() {
    try {
      if (index >= 0) {
        index -= 1;
        update();
      }
    } catch (err) {
      global.printException("singup_controller.dart", "onStepBack", err);
    }
  }

  onStepNext() {
    try {
      if (index == 0 || index > 0) {
        index += 1;
        update();
      }
    } catch (err) {
      global.printException("singup_controller.dart", "onStepNext", err);
    }
  }

  validateForm(
    int index, {
    BuildContext? context,
    String countrycode = '+91',
  }) {
    try {
//------Validation_of_Personal_Detail-----------------
      if (index == 0) {
        if (cName.text != "" &&
            (cEmail.text != '' && GetUtils.isEmail(cEmail.text)) &&
            (cMobileNumber.text != "" && cMobileNumber.text.length == 10) &&
            termAndCondtion.value == true) {
          print("index = 0");
          checkcontactExistOrNot(cMobileNumber.text, 'register');
        } else if (dsplyName.text == "") {
          //signupController.dsplyName
          global.showToast(message: "Please Enter Valid Display Name");
        } else if (cName.text == "") {
          global.showToast(message: "Please Enter Valid Name");
        } else if (cEmail.text == '' || !GetUtils.isEmail(cEmail.text)) {
          global.showToast(message: "Please Enter Valid Email Address");
        } else if (cMobileNumber.text == '' ||
            cMobileNumber.text.length != 10) {
          global.showToast(message: "Please Enter Valid Mobile Number");
        } else if (termAndCondtion.value == false) {
          global.showToast(message: "Please Agree With T&C");
        } else {
          global.showToast(message: "Something Wrong in Personal Detail Form");
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
            // New Text Field Added
            cwhatsappno.text != "" &&
            cpancard.text != "" &&
            cadharno.text != "" &&
            cIFSC.text != "" &&
            cbankname.text != "" &&
            cbankbranch.text != "" &&
            caccountHolderName.text != "" &&
            defaultaccountType != "" &&
            caccountno.text != "" &&
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
          // } else if (selectedImage == null) {
          //   global.showToast(message: "Please Select Image");
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
        } else if (cusdCharges.text == "") {
          global.showToast(message: tr("Please Enter USD Charges"));
        } else if (cVideoCharges.text == "") {
          global.showToast(message: tr("Please Enter video Charges"));
        } else if (cwhatsappno.text == "") {
          global.showToast(message: tr("Please Enter Whatsapp Number"));
        } else if (cusdVideoCharges.text == "") {
          global.showToast(message: tr("Please Enter USD video Charges"));
        } else if (cusdReportCharges.text == "") {
          global.showToast(message: tr("Please Enter USD report Charges"));
        } else if (cReportCharges.text == "") {
          global.showToast(message: tr("Please Enter report Charges"));
        } else if (cExpirence.text == "") {
          global.showToast(message: tr("Please Enter Expirence"));
        } else if (cContributionHours.text == "") {
          global.showToast(message: tr("Please Enter Contribution Hours"));
        } else if (anyOnlinePlatform == 1 && cNameOfPlatform.text == "") {
          global.showToast(message: tr("Please Enter Name Of Platform"));
        } else if (anyOnlinePlatform == 1 && cMonthlyEarning.text == "") {
          global.showToast(message: tr("Please Enter Monthly Earning"));
        } else if (cpancard.text == "") {
          global.showToast(message: tr("Please Enter Pan Card No"));
        } else if (cadharno.text == "") {
          global.showToast(message: tr("Please Enter Aadhar Card No"));
        } else if (cIFSC.text == "") {
          global.showToast(message: tr("Please Enter IFSC Code"));
        } else if (cbankbranch.text == "") {
          global.showToast(message: tr("Please Enter Bank Branch"));
        } else if (caccountHolderName.text == "") {
          global.showToast(message: tr("Please Enter Account Holder Name"));
        } else if (cbankname.text == "") {
          global.showToast(message: tr("Please Enter Bank Name"));
        } else if (defaultaccountType == "") {
          global.showToast(message: tr("Please Select Account type"));
        } else if (caccountno.text == "") {
          global.showToast(message: tr("Please Enter Account Number"));
        } else if (cconfiaccountno.text == "") {
          global.showToast(message: tr("Please Confirm Your Account Number"));
        } else if (int.parse(cconfiaccountno.text) !=
            int.parse(caccountno.text)) {
          global.showToast(message: tr("Please Use Same Account Number"));
        } else if (cupi.text == "") {
          global.showToast(message: tr("Please Enter Upi Number"));
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
        if ((selectedCurrentlyWorkingJob != "" &&
                selectedCurrentlyWorkingJob != null) &&
            cGoodQuality.text != "" &&
            cBiggestChallenge.text != "" &&
            cRepeatedQuestion.text != "") {
          print("index = 3");
          onStepNext();
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
        // signupAstrologer();
        if (cStartTime.text != '' && cEndTime.text != '') {
          signupAstrologer();
        } else {
          global.showToast(message: tr("Please select time"));
        }
      } else {
        global.showToast(message: tr("No Index Found"));
      }
    } catch (err) {
      global.printException("signup_controller.dart", "validateForm()", err);
    }
  }

//Register astrologer
  Future signupAstrologer() async {
    try {
      await global.checkBody().then(
        (networkResult) async {
          log('countryCode is seting is $countryCode');
          if (networkResult) {
            await global.getDeviceData();
            global.user.roleId = 2;
            global.user.documentmap = global.globaldocumentmap;
            global.user.countrycode = countryCode;
            global.user.country = countryName; //added latest
            global.user.cusdcharges =
                int.parse(cusdCharges.text); //added latest
            global.user.videoCallRateUsd =
                int.parse(cusdVideoCharges.text); //added latest
            global.user.reportRateUsd =
                int.parse(cusdReportCharges.text); //added latest

            global.user.name = cName.text;
            global.user.displayName = dsplyName.text; //add display name
            global.user.email = cEmail.text;
            global.user.contactNo = cMobileNumber.text;
            global.user.imagePath = imagePath.value;
            global.user.gender = selectedGender;
            global.user.birthDate = selectedDate;
            global.user.primarySkill = cPrimarySkill.text;
            global.user.astrologerCategory = cSelectCategory.text;
            global.user.allSkill = cAllSkill.text;
            global.user.languageKnown = cLanguage.text;
            global.user.charges = int.parse(cCharges.text);

            // New Text Field Added
            global.user.whatsappNo =
                int.parse(cwhatsappno.text.toString()); //int
            global.user.pancardNo = cpancard.text;
            global.user.aadharNo =
                int.parse(cadharno.text.toString()); //intcadharno.text;
            global.user.ifscCode = cIFSC.text;
            global.user.bankBranch = cbankbranch.text;
            global.user.accountHoldername = caccountHolderName.text;
            global.user.bankName = cbankname.text;
            global.user.accountType = defaultaccountType;
            global.user.accountNumber = caccountno.text;
            global.user.upi = cupi.text;

            global.user.videoCallRate = int.parse(cVideoCharges.text);
            global.user.reportRate = int.parse(cReportCharges.text);
            global.user.expirenceInYear = int.parse(cExpirence.text);
            global.user.dailyContributionHours =
                int.parse(cContributionHours.text);
            global.user.hearAboutAstroGuru = cHearAboutAstroGuru.text;
            global.user.isWorkingOnAnotherPlatform = anyOnlinePlatform;
            global.user.otherPlatformName = cNameOfPlatform.text;
            global.user.otherPlatformMonthlyEarning = cMonthlyEarning.text;
            global.user.onboardYou = cOnBoardYou.text;
            global.user.suitableInterviewTime = cTimeForInterview.text;
            global.user.currentCity = cLiveCity.text;
            global.user.mainSourceOfBusiness = selectedSourceOfBusiness;
            global.user.highestQualification = selectedHighestQualification;
            global.user.degreeDiploma = selectedDegreeDiploma;
            global.user.collegeSchoolUniversity = cCollegeSchoolUniversity.text;
            global.user.learnAstrology = cLearnAstrology.text;
            global.user.instagramProfileLink = cInsta.text;
            global.user.facebookProfileLink = cFacebook.text;
            global.user.linkedInProfileLink = cLinkedIn.text;
            global.user.youtubeProfileLink = cYoutube.text;
            global.user.webSiteProfileLink = cWebSite.text;
            global.user.isAnyBodyRefer = referPerson;
            global.user.referedPersonName = cNameOfReferPerson.text;
            global.user.expectedMinimumEarning =
                int.parse(cExptectedMinimumEarning.text);
            global.user.expectedMaximumEarning =
                int.parse(cExpectedMaximumEarning.text);
            global.user.longBio = cLongBio.text;
            global.user.foreignCountryCount = '0';
            global.user.currentlyWorkingJob = selectedCurrentlyWorkingJob;
            global.user.goodQualityOfAstrologer = cGoodQuality.text;
            global.user.biggestChallengeFaced = cBiggestChallenge.text;
            global.user.repeatedQuestion = cRepeatedQuestion.text;
            global.user.astrologerCategoryId = [];
            global.user.primarySkillId = [];
            global.user.allSkillId = [];
            global.user.languageId = [];

            for (var i = 0; i < astroId.length; i++) {
              global.user.astrologerCategoryId!.addAll(astroId);
            }
            for (var i = 0; i < primaryId.length; i++) {
              global.user.primarySkillId!.addAll(primaryId);
            }
            for (var i = 0; i < allId.length; i++) {
              global.user.allSkillId!.addAll(allId);
            }
            for (var i = 0; i < lId.length; i++) {
              global.user.languageId!.addAll(lId);
            }

            global.user.week = [];
            for (var i = 0; i < week!.length; i++) {
              if (week![i].timeAvailabilityList!.isNotEmpty) {
                global.user.week!.add(Week(
                    day: week![i].day,
                    timeAvailabilityList: week![i].timeAvailabilityList));
              }
            }
            global.user.week!.removeWhere((element) => element.day == "");
            global.showOnlyLoaderDialog();
            await apiHelper.signUp(global.user).then(
              (apiRresult) async {
                global.hideLoader();
                if (apiRresult.status == '200') {
                  global.user = apiRresult.recordList;
                  Get.offUntil(
                      MaterialPageRoute(
                          builder: (context) =>
                              const SuccessRegistrationScreen()),
                      (route) => false);
                  global.showToast(
                      message: tr("You Have Succesfully Register User"));
                } else if (apiRresult.status == '400') {
                  global.showToast(message: apiRresult.message);
                  update();
                } else {
                  global.showToast(
                      message: "Something Went Wrong, ${apiRresult.message}");
                }
              },
            );
          } else {
            global.showToast(message: tr("No Network Available"));
          }
        },
      );
    } catch (err) {
      global.showToast(
          message: tr("Something Went Wrong, Duplicate phone No Used"));
      global.printException("singup_controller.dart", "signupAstrologer", err);
    }
  }

  checkcontactExistOrNot(String contactno, String type) async {
    try {
      global.showOnlyLoaderDialog();
      await apiHelper.checkContact(contactno, type).then((response) {
        dynamic statuscode = json.decode(response.body)['status'];
        log('checkcontactExistOrNot statuscode $statuscode');
        String msg = jsonDecode(response.body)['message'];
        log('checkcontactExistOrNot msg $msg');
        log('checkcontactExistOrNot statuscode type ${statuscode.runtimeType}');

        global.hideLoader();

        log('checkcontactExistOrNot response msg $msg');
        if (statuscode == 200) {
          String _loginotp = jsonDecode(response.body)['otp'];
          log('sending otp is $_loginotp');
          Get.to(() => SignupOtpScreen(
                mobileNumber: contactno,
                otpCode: _loginotp,
                countryCode: countryCode,
              ));
        } else if (statuscode == 400) {
          global.showToast(message: msg);
        }
      });
    } catch (e) {
      print('Exception in checkcontactExistOrNot : - ${e.toString()}');
    }
  }

//----------------------OTP sent-----------------------------------//
  RxBool isLoading = false.obs;
  dynamic smsCode = "";
  Timer? countDown;

  Map<String, dynamic>? dataResponse;

  String phoneOrEmail = '';
  String otp = '';
  bool isInitIos = false;

//Astrologer profile
  ScrollController walletHistoryScrollController = ScrollController();
  ScrollController callHistoryScrollController = ScrollController();
  ScrollController chatHistoryScrollController = ScrollController();
  ScrollController reportHistoryScrollController = ScrollController();
  ScrollController poojaHistoryScrollController = ScrollController();
  int fetchRecord = 10;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;

  @override
  onInit() {
    init();
    super.onInit();
  }

  init() async {
    paginateTask();
  }

  // Future<void> deleteAccount() async {
  //   try {
  //     await FirebaseAuth.instance.currentUser!.delete();
  //     print('Account deleted successfully.firebase too');
  //   } catch (e) {
  //     print('Error deleting account: $e');
  //   }
  // }

  void paginateTask() {
    walletHistoryScrollController.addListener(() async {
      if (walletHistoryScrollController.position.pixels ==
              walletHistoryScrollController.position.maxScrollExtent &&
          !isAllDataLoaded) {
        isMoreDataAvailable = true;
        print('scroll my following');
        update();
        await astrologerProfileById(true);
        update();
      }
    });
    chatHistoryScrollController.addListener(() async {
      if (chatHistoryScrollController.position.pixels ==
              chatHistoryScrollController.position.maxScrollExtent &&
          !isAllDataLoaded) {
        isMoreDataAvailable = true;
        print('scroll my following');
        update();
        await astrologerProfileById(true);
      }
    });
    callHistoryScrollController.addListener(() async {
      if (callHistoryScrollController.position.pixels ==
              callHistoryScrollController.position.maxScrollExtent &&
          !isAllDataLoaded) {
        isMoreDataAvailable = true;
        print('scroll my following');
        update();
        await astrologerProfileById(true);
      }
    });
    reportHistoryScrollController.addListener(() async {
      if (reportHistoryScrollController.position.pixels ==
              reportHistoryScrollController.position.maxScrollExtent &&
          !isAllDataLoaded) {
        isMoreDataAvailable = true;
        print('scroll my following');
        update();
        await astrologerProfileById(true);
      }
    });
  }

  bool? oflinestatus;
  Future astrologerProfileById(bool isLazyLoading, {int? isLoading = 1}) async {
    debugPrint('calling astrolgerprofile all');
    try {
      startIndex = 0;
      if (astrologerList.isNotEmpty) {
        startIndex = astrologerList.length;
      }
      if (!isLazyLoading) {
        isDataLoaded = false;
      }
      global.checkBody().then(
        (result) {
          if (result) {
            int id = global.user.id ?? 0;
            apiHelper
                .getAstrologerProfile(id, startIndex, fetchRecord)
                .then((result) {
              if (result.status == "200") {
                try {
                  astrologerList.clear();
                  astrologerList.addAll(result.recordList);
                } on Exception catch (e) {
                  log('exception in astrologer profile $e');
                }

                // Sync fresh status back to global.user so all screens read correct values
                if (astrologerList.isNotEmpty && astrologerList[0] != null) {
                  global.user.chatStatus = astrologerList[0]!.chatStatus;
                  global.user.callStatus = astrologerList[0]!.callStatus;
                }

                update();
                astrologerList[0]?.callStatus?.trim() == "Online" ||
                        astrologerList[0]?.chatStatus?.trim() == "Online"
                    ? oflinestatus = true
                    : oflinestatus = false;
                log('online call status is ${astrologerList[0]?.callStatus}');
                log('online chat status is ${astrologerList[0]?.chatStatus}');
                log('online status is $oflinestatus');
                update();

                if (result.recordList.length == 0) {
                  isMoreDataAvailable = false;
                  isAllDataLoaded = true;
                }
                if (result.recordList.length < fetchRecord) {
                  isMoreDataAvailable = false;
                  isAllDataLoaded = true;
                }
              } else {
                global.showToast(message: result.message.toString());
              }
              update();
            });
          }
        },
      );
    } catch (e) {
      print('Exception: $screen - astrologerProfileById():-' + e.toString());
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

//Delete astrologer account
  deleteAstrologer(int id) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            await apiHelper.astrologerDelete(id).then(
              (result) async {
                global.hideLoader();
                if (result.status == "200") {
                  global.showToast(message: result.message.toString());
                  Get.back();
                } else {
                  global.showToast(message: result.message.toString());
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

//Clear astrologer data
  clearAstrologer() {
    try {
      //Astrologer category
      for (var i = 0; i < global.astrologerCategoryModelList!.length; i++) {
        global.astrologerCategoryModelList![i].isCheck = false;
      }
      //Primary skill
      for (var i = 0; i < global.skillModelList!.length; i++) {
        global.skillModelList![i].isCheck = false;
      }
      //All skill
      for (var i = 0; i < global.allSkillModelList!.length; i++) {
        global.allSkillModelList![i].isCheck = false;
      }
      //Language
      for (var i = 0; i < global.languageModelList!.length; i++) {
        global.languageModelList![i].isCheck = false;
      }
    } catch (e) {
      print("Exception - $screen - clearAstrologer():" + e.toString());
    }
  }

//send reply
  Future sendReply(int id, String reply) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            await apiHelper.astrologerReply(id, reply).then(
              (result) {
                global.hideLoader();
                if (result.status == "200") {
                  cReply.text = '';
                  global.showToast(message: result.message.toString());
                  astrologerList.clear();
                  isAllDataLoaded = false;
                  update();
                  astrologerProfileById(false);
                } else {
                  global.showToast(message: tr("Review is not send"));
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - sendReply():-' + e.toString());
    }
  }
}
