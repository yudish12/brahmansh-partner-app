// ignore_for_file: file_names, use_build_context_synchronously
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controllers/HomeController/wallet_controller.dart';
import '../../../../../controllers/splashController.dart';
import '../../../../../services/apiHelper.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'payment_screen.dart';

class PaymentInformationScreen extends StatefulWidget {
  final double amount;
  final int? flag;
  final int? cashback;
  const PaymentInformationScreen({
    super.key,
    required this.amount,
    this.flag,
    this.cashback,
  });
  @override
  State<PaymentInformationScreen> createState() =>
      _PaymentInformationScreenState();
}

class _PaymentInformationScreenState extends State<PaymentInformationScreen> {
  final walletController = Get.find<WalletController>();
  final splashController = Get.find<SplashController>();
  APIHelper apiHelper = APIHelper();

  int? paymentMode;

  // Color scheme
  final Color _primaryColor = const Color(0xFFFF6B35);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1C0F02);
  final Color _accentColor = const Color(0xFFFF8C42);
  final Color _successColor = const Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    final totalAmount = widget.amount;
    final gstAmount = totalAmount *
        double.parse(global.getSystemFlagValue(global.systemFlagNameList.gst)) /
        100;
    final cashbackAmount =
        widget.cashback != null ? totalAmount * widget.cashback! / 100 : 0;
    final totalPayable = totalAmount + gstAmount;

    return SafeArea(
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          backgroundColor: _primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Payment Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ).tr(),
        ),
        body: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryColor, _accentColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.payment,
                    color: Colors.white,
                    size: 40.sp,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Payment Summary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ).tr(),
                  const SizedBox(height: 5),
                  Text(
                    'Complete your wallet recharge',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12.sp,
                    ),
                  ).tr(),
                ],
              ),
            ),

            // Payment Details Card
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Amount Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _primaryColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.account_balance_wallet,
                                  color: _primaryColor,
                                  size: 20.sp,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Recharge Amount',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: _textColor,
                                ),
                              ).tr(),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Total Amount
                          _buildAmountRow(
                            'Base Amount',
                            _buildAmountWithIcon(totalAmount),
                            Icons.money,
                          ),

                          // GST
                          _buildAmountRow(
                            'GST ${global.getSystemFlagValue(global.systemFlagNameList.gst)}%',
                            _buildAmountWithIcon(gstAmount),
                            Icons.receipt,
                          ),

                          // Cashback
                          if (widget.cashback != null && widget.cashback! > 0)
                            _buildAmountRow(
                              'Cashback ${widget.cashback}%',
                              _buildAmountWithIcon(cashbackAmount.toDouble()),
                              Icons.card_giftcard,
                              isPositive: true,
                            ),

                          const Divider(height: 30, thickness: 1),

                          // Total Payable
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Payable',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: _textColor,
                                ),
                              ).tr(),
                              _buildAmountRowWidget(
                                  totalPayable, _primaryColor, 18.sp),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Benefits Section
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Benefits',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: _textColor,
                            ),
                          ).tr(),
                          const SizedBox(height: 10),
                          _buildBenefitItem(Icons.security, 'Secure Payment'),
                          _buildBenefitItem(
                              Icons.flash_on, 'Instant Activation'),
                          _buildBenefitItem(
                              Icons.support_agent, '24/7 Support'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 8.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: _cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () async {
              global.showOnlyLoaderDialog();
              log('payable amount is $totalPayable');
              await apiHelper
                  .addAmountInWallet(
                amount: totalPayable,
                cashback: cashbackAmount.toDouble(),
              )
                  .then((value) {
                global.hideLoader();
                if (value['status'] == 200) {
                  log("Payment URL: ${value['url']}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(url: value['url']),
                    ),
                  );
                } else {
                  global.showToast(
                      message: 'Payment failed. Please try again.');
                }
              }).catchError((error) {
                global.hideLoader();
                global.showToast(message: 'Error processing payment.');
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, size: 18.sp),
                const SizedBox(width: 8),
                Text(
                  'Proceed to Pay',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ).tr(),
                const SizedBox(width: 8),
                _buildAmountRowWidget(totalPayable, Colors.white, 14.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountRow(String title, dynamic amountWidget, IconData icon,
      {bool isPositive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16.sp, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade700,
                ),
              ).tr(),
            ],
          ),
          amountWidget is Widget
              ? amountWidget
              : Text(
                  amountWidget.toString(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isPositive ? _successColor : _textColor,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildAmountRowWidget(double amount, Color color, double fontSize) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Text(
            global.getSystemFlagValue(global.systemFlagNameList.currency),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        Text(
          amount.toStringAsFixed(1),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildAmountWithIcon(double amount) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Text(
            global.getSystemFlagValue(global.systemFlagNameList.currency),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          amount.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: _successColor),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey.shade700,
            ),
          ).tr(),
        ],
      ),
    );
  }
}
