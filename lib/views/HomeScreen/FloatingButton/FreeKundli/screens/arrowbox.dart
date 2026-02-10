import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/screens/arrowclipper.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constants/colorConst.dart';

class ArrowBoxWidget extends StatelessWidget {
  final List<String> datatitle;
  final int index;
  const ArrowBoxWidget(
      {super.key, required this.datatitle, required this.index});
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ArrowClipper(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
            decoration: BoxDecoration(
              color: COLORS().primaryColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(datatitle[index],
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 11.sp,
                    )).tr(),
          ),
        ],
      ),
    );
  }
}
