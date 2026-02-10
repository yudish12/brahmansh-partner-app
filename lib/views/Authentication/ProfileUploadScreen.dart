// ignore_for_file: library_private_types_in_public_api

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../models/docmodel.dart';

class ProfileUploadScreen extends StatefulWidget {
  const ProfileUploadScreen({
    super.key,
    required this.indexdata,
    required this.onFileSelected,
    this.flag = false,
  });
  final DocList indexdata;
  final bool flag;
  final Function(String filepath, String uploadkey) onFileSelected;

  @override
  _ProfileUploadScreenState createState() => _ProfileUploadScreenState();
}

class _ProfileUploadScreenState extends State<ProfileUploadScreen> {
  String? selectedFilePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: widget.flag == true ? 20.h : 10.h,
                child: Row(
                  children: [
                    Text(
                      "${widget.indexdata.name}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Profile Upload Section
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Implement file picker logic here
                      _pickFile();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 2.w, horizontal: 2.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4.w),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.attach_file,
                            color: Colors.black,
                            size: 14.sp,
                          ), // File icon
                          const SizedBox(width: 5),
                          Text(
                            "Choose File",
                            style:
                                TextStyle(color: Colors.black, fontSize: 11.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      selectedFilePath ?? "No file chosen",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedFilePath = result.files.single.path;
      });
      String createakey =
          widget.indexdata.name!.replaceAll(' ', '_').toLowerCase();
      widget.onFileSelected(
          selectedFilePath!, createakey); // Pass file path to parent
    }
  }
}
