// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/Authentication/signup_controller.dart';

class CouponInputScreen extends StatefulWidget {
  const CouponInputScreen({super.key});

  @override
  _CouponInputScreenState createState() => _CouponInputScreenState();
}

class _CouponInputScreenState extends State<CouponInputScreen> {
  final signupController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 3.h),
        SizedBox(
          width: 60.w,
          child: TextField(
            controller: signupController.couponController,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: 'Enter Coupon Code',
              floatingLabelBehavior: FloatingLabelBehavior.never,
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.blue),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              suffixIcon: GetBuilder<SignupController>(
                builder: (signupController) => IconButton(
                  icon: signupController.isCouponValid == null
                      ? const Icon(Icons.clear)
                      : Icon(
                          signupController.isCouponValid!
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: signupController.isCouponValid!
                              ? Colors.green
                              : Colors.red,
                        ),
                  onPressed: () {
                    signupController.couponController.clear();
                    signupController.isCouponValid = null;
                    signupController.update();
                  },
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        // Apply button
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            ),
          ),
          onPressed: () {},
          child: const Text('Apply Coupon'),
        ),
      ],
    );
  }
}
