// ignore_for_file: file_names

import 'package:flutter/material.dart';

class COLORS {
  Color primaryColor = const Color(0xffea6c10);//ffcc33 //0xfff57f17
  Color blackColor = const Color(0xFF000000);
  Color whiteColor = const Color(0xFFF5F5F5);
  Color bodyTextColor = const Color(0xFF333333);
  Color errorColor = const Color(0xFFe60000);
  Color? greyBackgroundColor = Colors.grey[200];
  Color textColor=Colors.white;
}

BoxDecoration scafdecoration = const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFEDF3), Color(0xFFD7EBFF)],
  ),
);
