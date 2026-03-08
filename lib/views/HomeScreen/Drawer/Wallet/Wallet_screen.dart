// ignore_for_file: file_names, must_be_immutable, avoid_print, prefer_interpolation_to_compose_strings, deprecated_member_use

import 'package:brahmanshtalk/controllers/HomeController/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletScreen extends StatefulWidget {
  WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final walletController = Get.find<WalletController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      walletController.getAstroEarnings();
    });
  }

  Future<void> _onRefresh() async {
    await walletController.getAstroEarnings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
        builder: (wc) {
          if (wc.isEarningsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _twoStatRow(
                    "Last 3 Months Earnings",
                    "₹${wc.earningsLast3Months.toStringAsFixed(2)}",
                    "Monthly Earnings",
                    "₹${wc.earningsMonthly.toStringAsFixed(2)}",
                  ),
                  const SizedBox(height: 12),
                  _twoStatRow(
                    "Today's Earnings",
                    "₹${wc.earningsToday.toStringAsFixed(2)}",
                    "Yesterday's Earnings",
                    "₹${wc.earningsYesterday.toStringAsFixed(2)}",
                  ),
                  const SizedBox(height: 12),
                  _weeklyEarningsRow(wc),
                  const SizedBox(height: 12),
                  _twoStatRow(
                    "Available Balance",
                    "₹${wc.currentBalance.toStringAsFixed(2)}",
                    "Total Withdrawn",
                    "₹${wc.totalWithdrawn.toStringAsFixed(2)}",
                  ),
                  const SizedBox(height: 12),
                  _twoStatRow(
                    "Today's Calls",
                    "${wc.todayCallsCount}",
                    "Today's Chats",
                    "${wc.todayChatsCount}",
                  ),
                  const SizedBox(height: 12),
                  _twoStatRow(
                    "Pending Earnings",
                    "₹${wc.withdraw.totalPending ?? 0}",
                    "Payable Amount",
                    "₹${wc.withdraw.walletAmount ?? 0}",
                  ),
                  const SizedBox(height: 40),
                  _emptyState(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

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

  Widget _weeklyEarningsRow(WalletController wc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Text("Weekly Earnings",
              style: TextStyle(fontSize: 14, color: Colors.black54)),
          const Spacer(),
          Text(
            "₹${wc.earningsWeekly.toStringAsFixed(2)}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.green,
            ),
          ),
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
