import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizer/sizer.dart';

class AppVersionWidget extends StatelessWidget {
  const AppVersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(
            "Loading version...",
            style: TextStyle(
              color: Colors.orangeAccent,
              fontWeight: FontWeight.w300,
              fontSize: 12,
            ),
          ).tr();
        } else if (snapshot.hasError) {
          return const Text(
            "Error finding version",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w300,
              fontSize: 12,
            ),
          ).tr();
        } else {
          final version = snapshot.data?.version ?? "Unknown";
          return Text(
            "App Version:",
            style: TextStyle(
              color: Colors.orangeAccent,
              fontWeight: FontWeight.w300,
              fontSize: 13.sp,
            ),
          ).tr(args: [version]);
        }
      },
    );
  }
}
