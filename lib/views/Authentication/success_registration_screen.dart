import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/constants/messageConst.dart';
import 'package:brahmanshtalk/views/Authentication/login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/config.dart';

class SuccessRegistrationScreen extends StatelessWidget {
  const SuccessRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Success Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.green[400]!,
                        Colors.green[600]!,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  "Registration Successful!",
                  style: Theme.of(context)
                      .primaryTextTheme
                      .displayMedium
                      ?.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.green[700],
                      ),
                  textAlign: TextAlign.center,
                ).tr(),

                const SizedBox(height: 16),

                // Subtitle
                Text(
                  "Your application has been submitted successfully",
                  style:
                      Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                  textAlign: TextAlign.center,
                ).tr(),

                const SizedBox(height: 40),

                // Info Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue[100]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Info Icon
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.blue[700],
                        size: 32,
                      ),
                      const SizedBox(height: 16),

                      // Info Text
                      Text(
                        "What happens next?",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .titleLarge
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[800],
                              fontSize: 18,
                            ),
                      ).tr(),
                      const SizedBox(height: 12),

                      Text(
                        "Thank you for submitting your details with Us. Our team shall reach out to you for an interview within 5-7 business days if your profile gets shortlisted.",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium
                            ?.copyWith(
                              color: Colors.blue[700],
                              fontSize: 14,
                              height: 1.5,
                            ),
                        textAlign: TextAlign.center,
                      ).tr(),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Contact Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orange[100]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.email_outlined,
                        color: Colors.orange[700],
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Need Help?",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange[800],
                                  ),
                            ).tr(),
                            const SizedBox(height: 4),
                            Text(
                              "Write to us at:",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.orange[700],
                                    fontSize: 13,
                                  ),
                            ).tr(),
                            const SizedBox(height: 2),
                            GestureDetector(
                              onTap: () {
                                // Add email launch functionality
                              },
                              child: Text(
                                contactsupportEmail,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.orange[700],
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  COLORS().primaryColor,
                  COLORS().primaryColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: COLORS().primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Get.offAll(() => const LoginScreen());
                },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.login_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        MessageConstants.LOGIN,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .titleLarge
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                      ).tr(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
