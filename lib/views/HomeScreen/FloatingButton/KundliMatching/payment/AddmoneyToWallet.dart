// ignore_for_file: file_names
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controllers/HomeController/wallet_controller.dart';
import '../../../../../controllers/splashController.dart';
import '../../../../BaseRoute/baseRoute.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'PaymentInformationScreen.dart';

class AddmoneyToWallet extends BaseRoute {
  AddmoneyToWallet({super.key, super.a, super.o})
      : super(r: 'AddMoneyToWallet');
  final walletController = Get.find<WalletController>();

  // Color scheme
  final Color _primaryColor = const Color(0xFFea6c10);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1C0F02);
  final Color _accentColor = const Color(0xFFFF8C42);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20.sp,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: GetBuilder<SplashController>(builder: (splash) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_primaryColor, _accentColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                        size: 32.sp,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Recharge Your Wallet Now',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ).tr(),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Available Balance',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ).tr(),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (global.isCoinWallet())
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: global.buildCoinIcon(),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Text(
                                      global.getSystemFlagValue(
                                          global.systemFlagNameList.currency),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                Text(
                                  walletController.withdraw.walletAmount != null
                                      ? walletController.withdraw.walletAmount!
                                          .toStringAsFixed(0)
                                      : "0",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ), // Amount Selection Grid
                Text(
                  'Choose Amount',
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ).tr(),
                const SizedBox(height: 15),

                GetBuilder<WalletController>(builder: (c) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemCount: walletController.paymentAmount.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          debugPrint("country 0:- ${global.user.countrycode}");
                          debugPrint(
                              "INR TO COIN - ${global.getSystemFlagValue(global.systemFlagNameList.InrToCoin)}");
                          debugPrint(
                              "USD TO COIN - ${global.getSystemFlagValue(global.systemFlagNameList.UsdToCoin)}");
                          if (global.isCoinWallet()) {
                            Get.to(() => PaymentInformationScreen(
                                  amount: global.user.countrycode.toString() == "+91"
                                      ? double.parse(walletController.paymentAmount[index].amount.toString()) /
                                          double.parse(global
                                              .getSystemFlagValue(global
                                                  .systemFlagNameList.InrToCoin)
                                              .toString())
                                      : double.parse(walletController
                                              .paymentAmount[index].amount
                                              .toString()) /
                                          double.parse(global
                                              .getSystemFlagValue(global
                                                  .systemFlagNameList.UsdToCoin)
                                              .toString()),
                                  cashback: walletController
                                      .paymentAmount[index].cashback,
                                ));
                          } else {
                            Get.to(
                              () => PaymentInformationScreen(
                                amount: double.parse(walletController
                                    .paymentAmount[index].amount
                                    .toString()),
                                cashback: walletController
                                    .paymentAmount[index].cashback,
                              ),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _cardColor,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: Border.all(
                              color: _primaryColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Main Amount
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (global.isCoinWallet())
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
                                      child: global.buildCoinIcon(),
                                    )
                                  else
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
                                      child: Text(
                                        global.getSystemFlagValue(
                                            global.systemFlagNameList.currency),
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          color: _textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  Text(
                                    walletController.paymentAmount[index].amount
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: _textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),

                              // Cashback Badge
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [_primaryColor, _accentColor],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.local_offer,
                                      color: Colors.white,
                                      size: 10.sp,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        "+${walletController.paymentAmount[index].cashback.toString()}% Extra",
                                        style: TextStyle(
                                          fontSize: 9.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Subtle hint
                              const SizedBox(height: 8),
                              Text(
                                'Tap to recharge',
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),

                // Additional Info
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: _primaryColor,
                        size: 16.sp,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Instant recharge • Secure payment • 24/7 support',
                          style: TextStyle(
                            color: _textColor.withOpacity(0.8),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ).tr(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
