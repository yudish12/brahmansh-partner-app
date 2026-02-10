// Place this function inside a class or as a top-level function in your file
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/global.dart' as global;
import 'package:brahmanshtalk/constants/colorConst.dart';

Widget _buildDetailRow(BuildContext context,
    {required IconData icon, required String label, required String value}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: COLORS().primaryColor, size: 28),
      const SizedBox(width: 20.0),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ],
  );
}

// --- Place the dialog function here, outside the class ---
void showPersonalDetailsDialog(BuildContext context) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Personal Detail",
              style: Get.theme.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ).tr(),
            const SizedBox(height: 20.0),
            _buildDetailRow(
              context,
              icon: Icons.person,
              label: tr("Name"),
              value: global.user.name != null && global.user.name != ''
                  ? '${global.user.name}'
                  : tr("Astologer name"),
            ),
            const Divider(height: 32.0, color: Colors.grey),
            _buildDetailRow(
              context,
              icon: Icons.email,
              label: tr("Email"),
              value: global.user.email != null && global.user.email != ''
                  ? '${global.user.email}'
                  : "astri@gmail.com",
            ),
            const Divider(height: 32.0, color: Colors.grey),
            _buildDetailRow(
              context,
              icon: Icons.phone,
              label: tr("Mobile Number"),
              value: global.user.contactNo != ''
                  ? '+91 ${global.user.contactNo}'
                  : "+91 35345345345",
            ),
          ],
        ),
      ),
    ),
  );
}
