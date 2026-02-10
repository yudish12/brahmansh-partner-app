// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class CommonTextFieldWidget extends StatelessWidget {
  const CommonTextFieldWidget({
    super.key,
    this.hintText,
    this.textEditingController,
    this.onEditingComplete,
    this.obscureText,
    this.readOnly,
    this.suffixIcon,
    this.onTap,
    this.keyboardType,
    this.focusNode,
    this.onFieldSubmitted,
    this.maxLines, // Change this to support auto-expand
    this.enabledBorder,
    this.prefix,
    this.onChanged,
    this.textCapitalization,
    this.formatter,
    this.maxLength,
    this.counterText,
    this.contentPadding,
    this.textAlignVertical,
    this.minLines, // Add minLines
  });

  // ... other parameters

  final int? maxLines;
  final int? minLines;
  final String? hintText;
  final TextEditingController? textEditingController;
  final VoidCallback? onEditingComplete;
  final bool? obscureText;
  final bool? readOnly;
  final IconData? suffixIcon;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final InputBorder? enabledBorder;
  final Widget? prefix;
  final ValueChanged<String>? onChanged;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? formatter;
  final int? maxLength;
  final String? counterText;
  final EdgeInsetsGeometry? contentPadding;
  final TextAlignVertical? textAlignVertical;

  // ... other parameters

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      onEditingComplete: onEditingComplete,
      focusNode: focusNode,
      maxLength: maxLength,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      maxLines: maxLines, // Allow null for auto-expand
      minLines: minLines ?? 1, // Start with 1 line
      onFieldSubmitted: onFieldSubmitted,
      obscureText: obscureText ?? false,
      readOnly: readOnly ?? false,
      onTap: readOnly == true ? null : onTap,
      cursorColor: const Color(0xFF757575),
      style:  TextStyle(fontSize: 14.sp, color: Colors.black),
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: formatter,
      onChanged: onChanged,
      textAlignVertical: textAlignVertical ?? TextAlignVertical.center,
      decoration: InputDecoration(
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 12.sp),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        fillColor: readOnly == true ? Colors.grey.shade200 : Colors.white,
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        counterText: counterText,
        hintText: hintText,
        prefixIcon: prefix,
        suffixIcon: suffixIcon != null 
            ? Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Icon(
                  suffixIcon,
                  size: 25,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : null,
        isDense: maxLines == 1, // Only dense for single line
      ),
    );
  }
}