// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EditProfileUploadScreen extends StatefulWidget {
  const EditProfileUploadScreen({
    super.key,
    required this.listName,
    required this.listPath,
    required this.onFileSelected,
    this.flag = false,
  });

  final String listName;
  final String listPath;
  final bool flag;
  final Function(String filePath, String uploadKey) onFileSelected;

  @override
  _EditProfileUploadScreenState createState() =>
      _EditProfileUploadScreenState();
}

class _EditProfileUploadScreenState extends State<EditProfileUploadScreen> {
  String? selectedFilePath;

  @override
  void initState() {
    super.initState();
    log('Document: ${widget.listName}');
    log('Path: ${widget.listPath}');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildUploadButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            formatText(widget.listName),
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
        ),
        _buildImagePreview(),
      ],
    );
  }

  String formatText(String text) {
    return text
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '')
        .join(' ');
  }

  Widget _buildImagePreview() {
    return Container(
      height: 10.h,
      width: 10.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: selectedFilePath != null
            ? DecorationImage(
                image: FileImage(File(selectedFilePath!)),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: selectedFilePath == null
          ? CachedNetworkImage(
              imageUrl: widget.listPath,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Image.asset(
                "assets/images/2022Image.png",
                fit: BoxFit.cover,
              ),
            )
          : null,
    );
  }

  Widget _buildUploadButton() {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: _pickFile,
          icon: Icon(Icons.attach_file, size: 14.sp),
          label: Text("Choose File", style: TextStyle(fontSize: 11.sp)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFilePath = result.files.single.path;
      });
      widget.onFileSelected(selectedFilePath!, widget.listName);
    }
  }
}
