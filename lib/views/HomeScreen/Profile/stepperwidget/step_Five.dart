import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:brahmanshtalk/views/HomeScreen/Profile/stepper_one.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../../../../constants/colorConst.dart';
import '../../../../controllers/HomeController/edit_profile_controller.dart';
import '../../../../utils/global.dart' as global;
import '../../../Authentication/editprofileuploadscreen.dart';

class StepFiveWidget extends StatefulWidget {
  const StepFiveWidget({super.key, required this.editProfileController});

  final EditProfileController editProfileController;

  @override
  State<StepFiveWidget> createState() => _StepFiveWidgetState();
}

class _StepFiveWidgetState extends State<StepFiveWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          // Header Card
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF667eea).withOpacity(0.1),
                  const Color(0xFF764ba2).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: COLORS().primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.upload_file_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upload Required Documents",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Please upload all necessary documents for verification",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Documents List
          Expanded(
            child: GetBuilder<EditProfileController>(
              builder: (editProfileController) {
                return ListView(
                  children: [
                    // Document Upload Cards
                    ...global.user.documentmap!.entries.map((entry) {
                      formatDocumentName(entry.key);
                      bool isUploaded =
                          global.globaldocumentmap?.containsKey(entry.key) ==
                              true;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: isUploaded
                                ? const Color(0xFF10B981).withOpacity(0.3)
                                : Colors.grey[200]!,
                            width: isUploaded ? 2 : 1,
                          ),
                        ),
                        child: EditProfileUploadScreen(
                          listName: entry.key,
                          listPath: entry.value ?? '',
                          flag: true,
                          onFileSelected: (filepath, createakey) {
                            log('| Key: $createakey  selected-image: $filepath ');

                            // Convert file to Base64
                            File myselectedImage = File(filepath);
                            List<int> imageBytes =
                                myselectedImage.readAsBytesSync();
                            global.globaldocumentmap?[createakey] =
                                base64Encode(imageBytes);

                            log('Updated document map: ${global.globaldocumentmap}');

                            // Update UI by refreshing controller
                            editProfileController.update();
                          },
                        ),
                      );
                    }),

                    // Help Text
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFDBEAFE)),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: Color(0xFF3B82F6),
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Make sure all documents are clear, readable, and valid. Supported formats: JPG, PNG, PDF",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
