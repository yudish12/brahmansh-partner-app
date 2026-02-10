// ignore_for_file: must_be_immutable, depend_on_referenced_packages
import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/constants/messageConst.dart';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/widgets/app_bar_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/config.dart';

class SettingListScreen extends StatelessWidget {
  SettingListScreen({super.key});
  SignupController signupController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(
          height: 80,
          backgroundColor: COLORS().primaryColor,
          iconData:  IconThemeData(color: COLORS().textColor),
          title:  Text("Settings", style: TextStyle(color: COLORS().textColor))
              .tr(),
        ),
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                launchUrl(Uri.parse(termsconditionurl));
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: const Text(
                      "Terms and Condition",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ).tr(),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                launchUrl(Uri.parse(privacyUrl));
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: const Text(
                      "Privacy Policy",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ).tr(),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await launchUrl(
                    Uri.parse("https://phpstack-1555706-6027586.cloudwaysapps.com/refundPolicy"));
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: const Text(
                      "Return Policy",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ).tr(),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text("Are you sure you want to logout?").tr(),
                    content: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              height: 5.h,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 1.h
                              ),
                              decoration: BoxDecoration(
                                  color: COLORS().primaryColor,
                                  borderRadius: BorderRadius.circular(10.sp)
                              ),

                              child:  Text(MessageConstants.No,
                              style:TextStyle(
                                color: COLORS().textColor
                              ),).tr(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 4,
                          child: InkWell(
                            onTap:() async {
                              // final loginController =
                              //     Get.put(LoginController());
                              // final LoginOtpController loginOtpController =
                              //     Get.put(LoginOtpController());
                              // loginOtpController.cMobileNumber.clear();
                              // await loginController.init();
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) async {
                                await global.logoutUser(context);
                              });
                            },
                            child: Container(
                              height:5.h,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 1.h
                              ),
                              decoration: BoxDecoration(
                                color: COLORS().primaryColor,
                                borderRadius: BorderRadius.circular(10.sp)
                              ),
                              child:  Text(MessageConstants.YES,
                              style: TextStyle(
                                color: COLORS().textColor
                              ),).tr(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: const Text(
                            "Logout my account",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ).tr(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // GestureDetector(
            //   onTap: () {
            //     Get.dialog(
            //       AlertDialog(
            //         title: const Text(
            //                 "Are you sure you want to delete this Account?")
            //             .tr(),
            //         content: Row(
            //           children: [
            //             Expanded(
            //               flex: 4,
            //               child: ElevatedButton(
            //                 onPressed: () {
            //                   Get.back();
            //                 },
            //                 child: const Text(MessageConstants.No).tr(),
            //               ),
            //             ),
            //             const SizedBox(
            //               width: 10,
            //             ),
            //             Expanded(
            //               flex: 4,
            //               child: ElevatedButton(
            //                 onPressed: () {
            //                   int id = global.user.id ?? 0;
            //                   debugPrint('user dlete id is $id');
            //                   if (id == 132) {
            //                     global.showToast(
            //                         message:
            //                             'Unable to delete testing account');
            //                     Get.back();
            //                   } else {
            //                     signupController.deleteAstrologer(id);
            //
            //                     Get.offUntil(
            //                         MaterialPageRoute(
            //                             builder: (context) =>
            //                                 const LoginScreen()),
            //                         (route) => false);
            //                   }
            //                 },
            //                 child: const Text(MessageConstants.YES).tr(),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     );
            //   },
            //   child: SizedBox(
            //     width: MediaQuery.of(context).size.width,
            //     child: Card(
            //       elevation: 2,
            //       child: Padding(
            //         padding: const EdgeInsets.all(15.0),
            //         child: Row(
            //           children: [
            //             Icon(
            //               Icons.delete,
            //               color: COLORS().errorColor,
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.only(left: 12.0),
            //               child: Text(
            //                 "Delete my account",
            //                 style: TextStyle(
            //                     color: COLORS().errorColor,
            //                     fontWeight: FontWeight.w500,
            //                     fontSize: 16),
            //               ).tr(),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
