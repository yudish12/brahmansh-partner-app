import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final signupController = Get.find<SignupController>();
Widget buildBadgesList() {
  return GridView.builder(
    shrinkWrap: true,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.9,
    ),
    itemCount: signupController.astrologerList[0]!.courseBadges?.length ?? 0,
    itemBuilder: (context, index) {
      final badge = signupController.astrologerList[0]!.courseBadges![index];
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFe3f2fd),
              Color(0xFFf3e5f5),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge icon with cosmic background
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF7986cb),
                    Color(0xFF5c6bc0),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5c6bc0).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.workspace_premium,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                badge.courseBadge ?? '',
                style: const TextStyle(
                  color: Color(0xFF3949ab),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Earned',
              style: TextStyle(
                color: Colors.green[600],
                fontSize: 8,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    },
  );
}
