import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../controllers/Authentication/signup_controller.dart';
import '../../../models/docmodel.dart';
import '../../../utils/global.dart' as global;
import '../../HomeScreen/Profile/CustomStepper.dart';
import '../../HomeScreen/Profile/StepperConfig.dart';
import '../ProfileUploadScreen.dart';

class SignupStepFive extends StatefulWidget {
  const SignupStepFive({super.key, required this.signupController});

  final SignupController signupController;

  @override
  State<SignupStepFive> createState() => _SignupStepFiveState();
}

class _SignupStepFiveState extends State<SignupStepFive> {
  // Map to store selected file paths for each document
  final Map<String, String> _selectedFilePaths = {};

  void _onFileSelected(String filepath, String documentKey) {
    log('file selected is $filepath and key is $documentKey');
    setState(() {
      _selectedFilePaths[documentKey] = filepath;
    });
    File myselectedImage = File(filepath);
    List<int> imageBytes = myselectedImage.readAsBytesSync();
    // Encode the bytes into base64
    global.globaldocumentmap?[documentKey] = base64Encode(imageBytes);
    //log('map document is 0-->  ${global.globaldocumentmap}');
  }

  // Generate a unique key for each document based on its properties
  String _getDocumentKey(dynamic document, int index) {
    if (document is DocList) {
      return 'doc_${document.id}_${document.name}';
    } else if (document is Map) {
      return 'doc_${document['id']}_${document['name']}';
    } else {
      return 'doc_$index';
    }
  }

  // Get document name for display
  String _getDocumentName(dynamic document) {
    if (document is DocList) {
      return document.name ?? 'Document';
    } else if (document is Map) {
      return document['name'] ?? 'Document';
    } else {
      return 'Document';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            children: [
              // Stepper
              CustomStepper(
                currentIndex: widget.signupController.index,
                stepTitle: StepperConfig.stepConfigs[4]!['title'] as String,
                stepIcon: StepperConfig.stepConfigs[4]!['icon'] as IconData,
                stepLabels:
                    StepperConfig.stepConfigs[4]!['labels'] as List<String>,
              ),
              SizedBox(height: 2.h),
              
              // Header Section
              _buildHeaderSection(),
              SizedBox(height: 2.h),
              
              // Documents List
              _buildDocumentsList(),
              SizedBox(height: 1.h),
              
              // Help Text
              _buildHelpSection(),
              SizedBox(height: 1.h),
            ],
          ),
        ),
      ),
    );
  }

  // Header Section
  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.withOpacity(0.1),
            Colors.green.withOpacity(0.05),
        ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.folder_open_outlined,
            size: 48,
            color: Colors.blue[700],
          ),
         const SizedBox(height: 16),
          Text(
            "Document Verification",
            style: Get.theme.primaryTextTheme.displayMedium?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.blue[800],
            ),
          ).tr(),
         const SizedBox(height: 8),
          Text(
            "Upload all required documents for verification process",
            style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ).tr(),
        const  SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue[100]!),
            ),
            child: Text(
              "${widget.signupController.documentList!.length} documents required",
              style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
                color: Colors.blue[700],
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Documents List
  Widget _buildDocumentsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 8),
          child: Row(
            children: [
              Icon(
                Icons.checklist_outlined,
                color: Colors.grey[700],
                size: 20,
              ),
             const SizedBox(width: 8),
              Text(
                "Required Documents",
                style: Get.theme.primaryTextTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ).tr(),
            ],
          ),
        ),
        
        // Documents Grid
        Column(
          children: List.generate(
            widget.signupController.documentList!.length,
            (index) {
              final document = widget.signupController.documentList![index];
              final documentKey = _getDocumentKey(document, index);
              final documentName = _getDocumentName(document);
              final hasSelectedFile = _selectedFilePaths.containsKey(documentKey);
              
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    // Document Upload Section
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: ProfileUploadScreen(
                        indexdata: document,
                        onFileSelected: (filepath, createakey) {
                          _onFileSelected(filepath, documentKey);
                        },
                      ),
                    ),
                    
                    // Selected Image Preview
                    if (hasSelectedFile)
                      _buildImagePreview(_selectedFilePaths[documentKey]!, documentName),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Image Preview Widget
  Widget _buildImagePreview(String filePath, String documentName) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        border: Border(
          top: BorderSide(color: Colors.green[100]!),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green[600],
            size: 20,
          ),
         const SizedBox(width: 8),
          Text(
            "$documentName:",
            style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
              color: Colors.green[700],
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        const  SizedBox(width: 8),
          Expanded(
            child: Text(
              _getFileName(filePath),
              style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
                color: Colors.green[700],
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
       const   SizedBox(width: 8),
          // Small Square Image Preview
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[300]!),
              image: DecorationImage(
                image: FileImage(File(filePath)),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get file name from path
  String _getFileName(String filePath) {
    try {
      return filePath.split('/').last;
    } catch (e) {
      return 'Document';
    }
  }

  // Help Section
  Widget _buildHelpSection() {
    return Container(
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
            Icons.info_outline_rounded,
            color: Colors.orange[700],
            size: 24,
          ),
       const   SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Important Information",
                  style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ).tr(),
              const  SizedBox(height: 8),
                Text(
                  "• Ensure all documents are clear and readable\n• Supported formats: JPG, PNG, PDF\n• Maximum file size: 5MB per document\n• All documents must be valid and current",
                  style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
                    color: Colors.orange[700],
                    fontSize: 13,
                    height: 1.5,
                  ),
                ).tr(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}