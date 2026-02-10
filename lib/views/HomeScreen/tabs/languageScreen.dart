// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'dart:developer';
import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/HomeController/home_controller.dart';
import 'package:brahmanshtalk/controllers/splashController.dart';
import 'package:brahmanshtalk/utils/constantskeys.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key});
  final homecontroller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: const Color(0xFFFFEDF3),
            title: const Text(
              'App language',
              style: TextStyle(color: Colors.black),
            ).tr()),
        body: Container(
          decoration: scafdecoration,
          child: GetBuilder<HomeController>(builder: (homecontroller) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.builder(
                itemCount: homecontroller.lan.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.8,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      homecontroller.updateLan(index);
                    },
                    child: LanguageTile(
                      name: homecontroller.lan[index].title,
                      script: homecontroller.lan[index].subTitle,
                      initial: homecontroller.lan[index].subTitle[0],
                      isSelected: homecontroller.lan[index].isSelected,
                    ),
                  );
                },
              ),
            );
          }),
        ),
        bottomSheet: Container(
          width: double.infinity,
          color: const Color(0xFFD7EBFF),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: COLORS().primaryColor,
              ),
              onPressed: () async {
                try {
                  // Show loading indicator
                  Get.dialog(
                    const Center(child: CircularProgressIndicator()),
                    barrierDismissible: false,
                  );

                  final index = homecontroller.selectedIndex;
                  if (index < 0 || index >= homecontroller.lan.length) {
                    Get.back(); // Close loading
                    return;
                  }
                  final langCode = homecontroller.lan[index].lanCode;
                  final locale = _getLocaleFromCode(langCode);
                  await context.setLocale(locale);
                  final splashController = Get.find<SplashController>();
                  splashController.currentLanguageCode = langCode;
                  global.spLanguage = await SharedPreferences.getInstance();
                  await global.spLanguage!
                      .setString(ConstantsKeys.CURRENTLANGUAGE, langCode);
                  log('Language saved: $langCode');
                  Get.updateLocale(locale);
                  splashController.update();
                  homecontroller.update();
                  Get.back();
                  Get.back();
                } catch (e) {
                  Get.back(); // Close loading if error
                  log('Error updating language: $e');
                  Get.snackbar('Error', 'Failed to update language');
                }
              },
              child: Text(
                "Save Language",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400,
                color: COLORS().textColor),
              ).tr(),
            ),
          ),
        ),
      ),
    );
  }
}

class LanguageTile extends StatelessWidget {
  final String name;
  final String script;
  final String initial;
  final bool isSelected;

  const LanguageTile({
    super.key,
    required this.name,
    required this.script,
    required this.initial,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? COLORS().primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: COLORS().primaryColor.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 10,
            bottom: -20,
            child: Text(
              initial,
              style: TextStyle(
                fontSize: 80,
                color: isSelected
                    ? COLORS().textColor.withValues(alpha: 0.6)
                    : Colors.black.withOpacity(0.03),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? COLORS().textColor : Colors.black,
                  ),
                ),
                Text(
                  script,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected
                        ? COLORS().textColor.withValues(alpha: 0.6)
                        : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: isSelected
                ?  Icon(Icons.check_circle, color:COLORS().textColor)
                : const Icon(Icons.circle_outlined, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

Future<void> updateLocale(
    int index, HomeController homeController, BuildContext context) async {
  if (index < 0 || index >= homeController.lan.length) return;
  final langCode = homeController.lan[index].lanCode;
  final locale = _getLocaleFromCode(langCode);
  await context.setLocale(locale);
  Get.updateLocale(locale);
  await refreshIt(homeController);
}

Locale _getLocaleFromCode(String code) {
  switch (code.toLowerCase()) {
    case 'en':
      return const Locale('en', 'US');
    case 'gu':
      return const Locale('gu', 'IN');
    case 'hi':
      return const Locale('hi', 'IN');
    case 'mr':
      return const Locale('mr', 'IN');
    case 'bn':
      return const Locale('bn', 'IN');
    case 'kn':
      return const Locale('kn', 'IN');
    case 'ml':
      return const Locale('ml', 'IN');
    case 'ta':
      return const Locale('ta', 'IN');
    case 'te':
      return const Locale('te', 'IN');
    default:
      return const Locale('en', 'US');
  }
}

Future<void> refreshIt(HomeController homeController) async {
  final splashController = Get.find<SplashController>();
  splashController.currentLanguageCode =
      homeController.lan[homeController.selectedIndex].lanCode;
  global.spLanguage = await SharedPreferences.getInstance();
  await global.spLanguage!.setString(
      ConstantsKeys.CURRENTLANGUAGE, splashController.currentLanguageCode);
  log('language code is  :- ${global.spLanguage}');
  splashController.update();
  homeController.update();
  Get.back();
}
