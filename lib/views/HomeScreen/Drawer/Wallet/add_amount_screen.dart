// ignore_for_file: must_be_immutable

import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/HomeController/wallet_controller.dart';
import 'package:brahmanshtalk/widgets/app_bar_widget.dart';
import 'package:brahmanshtalk/widgets/common_textfield_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:sizer/sizer.dart';

class AddAmountScreen extends StatelessWidget {
  AddAmountScreen({super.key});
  WalletController walletController = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: MyCustomAppBar(
          height: 80,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 17.sp,
            ),
          ),
          title: Text(
            "Withdraw Funds",
            style: Get.theme.textTheme.bodyMedium!.copyWith(
              fontSize: 15.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ).tr(),
          backgroundColor: COLORS().primaryColor,
        ),
        body: GetBuilder<WalletController>(
          builder: (walletController) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              COLORS().primaryColor.withOpacity(0.1),
                              Colors.blue[50]!,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet,
                                  color: COLORS().primaryColor,
                                  size: 22.sp,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "Withdraw Amount",
                                  style:
                                      Get.theme.textTheme.titleLarge!.copyWith(
                                    color: Colors.grey[800],
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ).tr(),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "Enter the amount you want to withdraw from your wallet",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12.sp,
                              ),
                            ).tr(),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Amount Input Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Amount to Withdraw",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ).tr(),
                            const SizedBox(height: 12),
                            CommonTextFieldWidget(
                              textEditingController:
                                  walletController.cWithdrawAmount,
                              hintText: tr("Enter amount"),
                              keyboardType: TextInputType.number,
                              formatter: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              maxLength: 10,
                              counterText: '',
                              prefix: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: global.isCoinWallet()
                                    ? global.buildCoinIcon()
                                    : Icon(
                                        Icons.currency_rupee,
                                        color: COLORS().primaryColor,
                                        size: 22,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Payment Method Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.payment,
                                  color: COLORS().primaryColor,
                                  size: 20.sp,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Payment Method",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ).tr(),
                              ],
                            ),
                            const SizedBox(height: 15),

                            DottedBorder(
                              color: COLORS().primaryColor.withOpacity(0.5),
                              strokeWidth: 1.5,
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(8),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color:
                                      COLORS().primaryColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Choose a Bank account or UPI ID',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ).tr(),
                              ),
                            ),

                            const SizedBox(height: 15),

                            // Payment Methods
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: walletController.withdrawList.length,
                                itemBuilder: (context, index) {
                                  final walletItem =
                                      walletController.withdrawList[index];
                                  return walletItem.isActive == 1
                                      ? Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: ListTile(
                                            leading: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: COLORS()
                                                    .primaryColor
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                walletItem.methodId == 1
                                                    ? Icons.account_balance
                                                    : Icons.payment,
                                                color: COLORS().primaryColor,
                                              ),
                                            ),
                                            title: Text(
                                              walletItem.methodName ?? 'N/A',
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ).tr(),
                                            trailing: Radio(
                                              activeColor:
                                                  COLORS().primaryColor,
                                              value: walletItem.methodId ?? 0,
                                              groupValue:
                                                  walletController.wallet,
                                              onChanged: (value) {
                                                walletController
                                                    .changeAccount(value);
                                                walletController.update();
                                              },
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bank/UPI Details Section
                    if (walletController.wallet == 1 ||
                        walletController.wallet == 2)
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(top: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: walletController.wallet == 1
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Bank Account Details",
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ).tr(),
                                      const SizedBox(height: 16),
                                      _buildDetailField(
                                        "Account Number",
                                        walletController.cBankNumber,
                                        TextInputType.number,
                                        [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        16,
                                        Icons.account_balance,
                                      ),
                                      _buildDetailField(
                                        "IFSC Code",
                                        walletController.cIfscCode,
                                        TextInputType.text,
                                        null,
                                        null,
                                        Icons.code,
                                      ),
                                      _buildDetailField(
                                        "Account Holder Name",
                                        walletController.cAccountHolder,
                                        TextInputType.text,
                                        [
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[a-zA-Z ]"))
                                        ],
                                        null,
                                        Icons.person,
                                      ),
                                    ],
                                  )
                                : walletController.wallet == 2
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "UPI Details",
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ).tr(),
                                          const SizedBox(height: 16),
                                          _buildDetailField(
                                            "UPI ID",
                                            walletController.cUPI,
                                            TextInputType.text,
                                            null,
                                            null,
                                            Icons.payment,
                                          ),
                                        ],
                                      )
                                    : Container(),
                          ),
                        ),
                      ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          height: 10.h,
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
          child: Center(
            child: SizedBox(
              width: 70.w, // More compact width
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: COLORS().primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15), // More rounded corners
                  ),
                  padding: EdgeInsets.symmetric(vertical: 1.8.h),
                ),
                onPressed: () async {
                  // Your existing onPressed logic
                  try {
                    if (walletController.updateAmountId != null) {
                      if (walletController.cWithdrawAmount.text != "" &&
                          double.parse(walletController.cWithdrawAmount.text
                                  .toString()) <=
                              double.parse(walletController
                                  .withdraw.walletAmount
                                  .toString())) {
                        walletController.validateUpdateAmount(
                            walletController.updateAmountId!);
                      } else if (walletController.cWithdrawAmount.text != "" &&
                          int.parse(walletController.cWithdrawAmount.text) <=
                              int.parse(
                                  walletController.cWithdrawAmount.text)) {
                        walletController.validateUpdateAmount(
                            walletController.updateAmountId!);
                      } else {
                        global.showToast(
                            message: tr("Please enter a valid amount"));
                      }
                    } else {
                      debugPrint(
                          "writen amount:- ${double.parse(walletController.cWithdrawAmount.text)}");
                      debugPrint(
                          "wallet amount${double.parse(walletController.withdraw.walletAmount.toString())}");
                      if (walletController.cWithdrawAmount.text != "" &&
                          double.parse(walletController.cWithdrawAmount.text) <=
                              double.parse(walletController
                                  .withdraw.walletAmount
                                  .toString())) {
                        walletController.validateAmount();
                      } else {
                        global.showToast(
                            message: tr("Please enter a valid amount"));
                      }
                    }
                    await walletController.getAmountList();
                    walletController.update();
                  } catch (e) {
                    debugPrint(
                        'Exception in add_amount_screen :- SUBMIT button:- $e');
                  }
                },
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, size: 18.sp),
                    const SizedBox(width: 8),
                    Text(
                      "SUBMIT",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ).tr(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailField(
    String label,
    TextEditingController controller,
    TextInputType keyboardType,
    List<TextInputFormatter>? formatter,
    int? maxLength,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: COLORS().primaryColor, size: 16.sp),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ).tr(),
            ],
          ),
          const SizedBox(height: 8),
          CommonTextFieldWidget(
            hintText: tr(label),
            textEditingController: controller,
            keyboardType: keyboardType,
            formatter: formatter,
            maxLength: maxLength,
            counterText: '',
          ),
        ],
      ),
    );
  }
}
