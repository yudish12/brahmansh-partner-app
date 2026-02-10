// ignore_for_file: file_names, must_be_immutable, avoid_print, prefer_interpolation_to_compose_strings, deprecated_member_use

import 'dart:developer';
import 'package:brahmanshtalk/constants/messageConst.dart';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/wallet_controller.dart';
import 'package:brahmanshtalk/views/HomeScreen/Drawer/Wallet/add_amount_screen.dart';
import 'package:brahmanshtalk/widgets/common_textfield_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:sizer/sizer.dart';
import '../../../../models/wallet_model.dart';
import '../../FloatingButton/KundliMatching/payment/AddmoneyToWallet.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});

  final walletController = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: const Color(0xFFF3A6A6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Wallet",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: GetBuilder<WalletController>(
        builder: (_) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _twoStatRow(
                  "Last 3 Months Earnings",
                  "₹${walletController.withdraw.totalEarning ?? 0}",
                  "Monthly Earnings",
                  "₹0", // ✅ FIXED — no backend field exists
                ),
                const SizedBox(height: 12),
                _rankTile(),
                const SizedBox(height: 12),
                _todayDropdown(),
                const SizedBox(height: 12),
                _twoStatRow(
                  "Available Balance",
                  "₹${walletController.withdraw.walletAmount ?? 0}",
                  "Payable Amount",
                  "₹0",
                ),
                const SizedBox(height: 12),
                _twoStatRow(
                  "Today's Astromall Earnings",
                  "₹0",
                  "Pending Earnings",
                  "₹${walletController.withdraw.totalPending ?? 0}",
                ),
                const SizedBox(height: 40),
                _emptyState(),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------- UI Widgets ----------------

  Widget _twoStatRow(String t1, String v1, String t2, String v2) {
    return Row(
      children: [
        Expanded(child: _statCard(t1, v1)),
        const SizedBox(width: 10),
        Expanded(child: _statCard(t2, v2)),
      ],
    );
  }

  Widget _statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rankTile() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: const [
          Text("Weekly Earnings",
              style: TextStyle(fontSize: 14, color: Colors.black54)),
          Spacer(),
          Text("Rank", style: TextStyle(color: Colors.orange, fontSize: 13)),
          SizedBox(width: 6),
          Text("10647", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 4),
          Icon(Icons.arrow_forward_ios, size: 14),
        ],
      ),
    );
  }

  Widget _todayDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Today",
              style:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
          SizedBox(width: 6),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Column(
      children: const [
        SizedBox(height: 80),
        Text(
          "No Transactions Available",
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ],
    );
  }
}
