import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:brahmanshtalk/views/HomeScreen/call/agora/CallRejoiningBanner.dart';
import 'package:brahmanshtalk/views/HomeScreen/chat/chatrejoinbanner.dart';
import 'package:brahmanshtalk/views/HomeScreen/live/onetoone_video/videoCallRejoiningBanner.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MovableRejoinBanner extends StatefulWidget {
  const MovableRejoinBanner({super.key});

  @override
  State<MovableRejoinBanner> createState() => _MovableRejoinBannerState();
}

class _MovableRejoinBannerState extends State<MovableRejoinBanner> {
  double bottom = 8.h;
  double left = 20;
  bool isPositionInitialized = false;
  final double bannerHeight = 70.0;
  final double bannerPadding = 8.0;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bannerWidth = screenWidth * 0.9;

    if (!isPositionInitialized) {
      left = (screenWidth - bannerWidth) / 2;
      isPositionInitialized = true;
    }

    return Positioned(
      bottom: bottom,
      left: left,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            left =
                (left + details.delta.dx).clamp(0.0, screenWidth - bannerWidth);
            bottom = (bottom - details.delta.dy)
                .clamp(0.0, screenHeight - bannerHeight - 80);
          });
        },
        child: SizedBox(
          width: bannerWidth,
          child: (global.isCallOrChat == 1)
              ? const ChatRejoinBanner()
              : (global.isCallOrChat == 2)
                  ? const Callrejoiningbanner()
                  : (global.isCallOrChat == 3)
                      ? const videoCallrejoiningbanner()
                      : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
