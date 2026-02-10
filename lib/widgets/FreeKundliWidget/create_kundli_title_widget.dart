import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CreateKundliTitleWidget extends StatelessWidget {
  final String? title;
  const CreateKundliTitleWidget({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title!,
            style: Get.textTheme.headlineSmall!.copyWith(fontSize: 14.sp))
        .tr();
  }
}
