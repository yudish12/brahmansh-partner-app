import 'package:flutter/material.dart';

import '../../../../constants/imageConst.dart';

class HoroscopeRotateAnimation extends StatefulWidget {
  final double size; // allows you to control size from outside
  final Duration duration; // control speed

  const HoroscopeRotateAnimation({
    super.key,
    this.size = 200, // default size
    this.duration = const Duration(seconds: 20), // default speed
  });

  @override
  State<HoroscopeRotateAnimation> createState() =>
      _HoroscopeRotateAnimationState();
}

class _HoroscopeRotateAnimationState extends State<HoroscopeRotateAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: RotationTransition(
        turns: _rotationController,
        child: Image.asset(
          IMAGECONST.callBackImage,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
