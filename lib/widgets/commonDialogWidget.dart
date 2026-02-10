import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

void showCommonDialog({
  String? title,
  String? subtitle,
  String? primaryButtonText,
  TextStyle? primaryButtonTextStyle,
  Color? secondaryButtonColor,
  Color? primaryButtonColor,
  required VoidCallback? onPrimaryPressed,
  String? secondaryButtonText,
  TextStyle? secondaryButtonTextStyle,
  VoidCallback? onSecondaryPressed,
}) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: Get.theme.textTheme.bodyMedium!.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.start,
                ).tr(),
              ),
            if (subtitle != null) ...[
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: Get.theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.start,
              ).tr(),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (secondaryButtonText != null)
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(
                        color: secondaryButtonColor ?? Get.theme.primaryColor,
                      ),
                    ),
                    onPressed: onSecondaryPressed ?? () => Get.back(),
                    child: Text(
                      secondaryButtonText,
                      style: secondaryButtonTextStyle ??
                          Get.theme.textTheme.bodyMedium!.copyWith(
                            color:
                                secondaryButtonColor ?? Get.theme.primaryColor,
                          ),
                    ).tr(),
                  ),
                SizedBox(width: 3.w),
                if (primaryButtonText != null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          primaryButtonColor ?? Get.theme.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: onPrimaryPressed ?? () => Get.back(),
                    child: Text(
                      primaryButtonText,
                      style: primaryButtonTextStyle ??
                          Get.theme.textTheme.bodyMedium!.copyWith(
                            color: secondaryButtonColor ?? Colors.white,
                          ),
                    ).tr(),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
