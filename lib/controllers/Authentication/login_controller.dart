// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, no_leading_underscores_for_local_identifiers
import 'dart:convert';
import 'dart:developer';
import 'package:brahmanshtalk/utils/constantskeys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../models/device_detail_model.dart';
import '../../services/apiHelper.dart';
import '../../views/Authentication/OtpScreens/login_otp_screen.dart';
import '../../views/Authentication/login_screen.dart';
import '../../views/HomeScreen/home_screen.dart';
import '../HomeController/call_controller.dart';
import '../HomeController/chat_controller.dart';
import '../HomeController/live_astrologer_controller.dart';
import '../HomeController/report_controller.dart';
import '../HomeController/wallet_controller.dart';
import '../following_controller.dart';
import 'login_otp_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  String screen = 'login_controller.dart';
  final apiHelper = APIHelper();
  final chatController = Get.find<ChatController>();
  final callController = Get.find<CallController>();
  final reportController = Get.find<ReportController>();
  final followingController = Get.find<FollowingController>();
  final walletController = Get.find<WalletController>();
  final liveAstrologerController = Get.find<LiveAstrologerController>();
  final loginOtpController = Get.put(LoginOtpController());
  final pinEditingController = TextEditingController(text: '');
  String signupText = tr('By signin up you agree to our');
  String termsConditionText = tr('Terms of Services');
  String andText = tr('and');
  String privacyPolicyText = tr('Privacy Policy');
  String notaAccountText = tr("Don't have an account?");
  var loaderVisibility = true;
  final urlTextContoller = TextEditingController();
  Map<String, dynamic>? dataResponse;

  String phoneOrEmail = '';
  String otp = '';
  bool isInitIos = false;
  final apihelper = APIHelper();

  String? phonenois;

  int loginTypeis = 0;
  @override
  void onInit() async {
    await init();
    super.onInit();
  }

  init() {
    signupText = tr('By signin up you agree to our');
    termsConditionText = tr('Terms of Services');
    andText = tr('and');
    privacyPolicyText = tr('Privacy Policy');
    notaAccountText = tr("Don't have an account?");

    update();
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      googleSignIn.signOut(); 
      GoogleSignInAccount? googleUser;
      try {
        googleUser = await googleSignIn.signIn();
      } catch (error, stacktrace) {
        print("❌ Google Sign-In failed before selecting account");
        print("Error: $error");
        print("Stacktrace: $stacktrace");
        return null;
      }

      if (googleUser == null) {
        print("⚠️ User cancelled Google Sign-In");
        return null;
      }

      // Step 2: Authentication tokens
      GoogleSignInAuthentication googleAuth;
      try {
        googleAuth = await googleUser.authentication;
      } catch (error, stacktrace) {
        print("❌ Failed to get Google authentication tokens");
        print("Error: $error");
        print("Stacktrace: $stacktrace");
        return null;
      }

      // Step 3: Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Step 4: Firebase Sign-In
      try {
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } on FirebaseAuthException catch (e, stacktrace) {
        print("❌ Firebase Auth Error");
        print("Code: ${e.code}");
        print("Message: ${e.message}");
        print("Stacktrace: $stacktrace");
        return null;
      }
    } catch (e, stacktrace) {
      print("❌ Unexpected error in signInWithGoogle()");
      print("Error: $e");
      print("Stacktrace: $stacktrace");
      return null;
    }
  }

  checkcontactExistOrNot(
      String contactno, BuildContext context, String type) async {
    try {
      global.showOnlyLoaderDialog();
      await apiHelper.checkContact(contactno, type).then((response) {
        dynamic rspnse1 = json.decode(response.body)['status'];
        log('checkcontactExistOrNot response status $rspnse1');
        String msg = jsonDecode(response.body)['message'];
        log('checkcontactExistOrNot response msg $msg');
        if (rspnse1 == 200) {
          String _loginotp = jsonDecode(response.body)['otp'];
          Get.to(() => LoginOtpScreen(
                mobileNumber: contactno,
                otpCode: _loginotp,
                countryCode: loginOtpController.countryCode,
              ));
        } else if (rspnse1 == 400) {
          global.hideLoader();
          global.showToast(message: msg);
        }
      });
    } catch (e) {
      print('Exception in checkcontactExistOrNot : - ${e.toString()}');
    }
  }

  Future loginAstrologer({String? phoneNumber, String? email}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.getDeviceData();
          DeviceInfoLoginModel deviceInfoLoginModel = DeviceInfoLoginModel(
              appId: "2",
              appVersion: global.appVersion,
              deviceId: global.deviceId,
              deviceManufacturer: global.deviceManufacturer,
              deviceModel: global.deviceModel,
              fcmToken: global.fcmToken,
              deviceLocation: "",
              onesignalSubscriptionID: OneSignal.User.pushSubscription.id);

          await apiHelper
              .login(phoneNumber, email, deviceInfoLoginModel)
              .then((result) async {
            if (result.status == "200") {
              global.user = result.recordList;
              await global.sp!.setString(
                  ConstantsKeys.CURRENTUSER, json.encode(global.user.toJson()));
              log('GLOBALLY SET VALUE ${global.user}');
              log('isverified  ${global.user.isVerified}');
              print('success');
              await Future.wait<void>([
                global.getCurrentUserId(),
                chatController.getChatList(false),
                callController.getCallList(true),
                reportController.getReportList(false),
                followingController.followingList(false),
                walletController.getAmountList(),
              ]);
              FutureBuilder(
                future: liveAstrologerController.endLiveSession(true),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      debugPrint('error ${snapshot.error}');
                    }
                    debugPrint('Live Session Ended Successfully');
                    return const SizedBox();
                  } else {
                    return const SizedBox();
                  }
                },
              );
              global.hideLoader();
              Get.to(() => HomeScreen());
            } else if (result.status == "400") {
              global.hideLoader();
              global.showToast(message: result.message.toString());
              print('statuscode400 ${result.message.toString()}');
              await Future.delayed(const Duration(seconds: 1));
              Get.offAll(() => const LoginScreen());
            } else {
              global.hideLoader();
              global.showToast(message: result.message.toString());
              print('statuscode${result.status}');
              Get.offAll(() => const LoginScreen());
            }
          });
        } else {
          global.showToast(message: tr('No network connection!'));
        }
      });
      update();
    } catch (e) {
      print('Exception - $screen - loginAstrologer(): ' + e.toString());
    }
  }
}
