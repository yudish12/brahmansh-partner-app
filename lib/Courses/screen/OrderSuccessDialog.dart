// ignore_for_file: must_be_immutable, file_names

import 'dart:math';
import 'package:brahmanshtalk/Courses/screen/MyCoursesListScreen.dart';
import 'package:confetti/confetti.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controller/courseController.dart';

class OrderSuccessDialog extends StatefulWidget {
  final dynamic jsonResponse;
  dynamic courseid;

  OrderSuccessDialog({
    super.key,
    required this.jsonResponse,
    required this.courseid,
  });

  @override
  State<OrderSuccessDialog> createState() => _OrderSuccessDialogState();
}

class _OrderSuccessDialogState extends State<OrderSuccessDialog> {
  final courseController = Get.find<CoursesController>();
  late ConfettiController controllerTopCenter;

  @override
  void dispose() {
    super.dispose();
    controllerTopCenter.dispose();
  }

  @override
  void initState() {
    super.initState();
    controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 2));
    controllerTopCenter.play();

    getcoursedetailList();
  }

  getcoursedetailList() async {
    await courseController.getCourseDetailsList(widget.courseid);
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.jsonResponse['recordList']['course_total_price'];
    final paymentType = widget.jsonResponse['recordList']['payment_type'];
    return ConfettiWidget(
      confettiController: controllerTopCenter,
      blastDirectionality: BlastDirectionality.explosive,
      emissionFrequency: 0.05,
      numberOfParticles: 70,
      gravity: 0.05,
      shouldLoop: true,
      colors: const [
        Colors.green,
        Colors.blue,
        Colors.pink,
        Colors.orange,
        Colors.purple
      ],
      createParticlePath: drawStar, // define a custom shape/path.
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(
                'Order Placed Successfully!',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 2.h),
              Column(
                children: [
                  Text(
                    'Payment Type:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                    ),
                  ).tr(
                    args: [paymentType],
                  ),
                  Text(
                    'Total Price:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                    ),
                  ).tr(
                    args: [totalPrice.toString()],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 6.h,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () {
                    Get.to(() => const MyCoursesListScreen());
                  },
                  child: Text(
                    'View Courses',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ).tr(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void showOrderSuccessDialog(
    BuildContext context, dynamic jsonResponse, dynamic courseid) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return OrderSuccessDialog(jsonResponse: jsonResponse, courseid: courseid);
    },
  );
}

Path drawStar(Size size) {
  double degToRad(double deg) => deg * (pi / 180.0);

  const numberOfPoints = 5;
  final halfWidth = size.width / 2;
  final externalRadius = halfWidth;
  final internalRadius = halfWidth / 2.5;
  final degreesPerStep = degToRad(360 / numberOfPoints);
  final halfDegreesPerStep = degreesPerStep / 2;
  final path = Path();
  final fullAngle = degToRad(360);
  path.moveTo(size.width, halfWidth);

  for (double step = 0; step < fullAngle; step += degreesPerStep) {
    path.lineTo(halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step));
    path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep));
  }
  path.close();
  return path;
}
