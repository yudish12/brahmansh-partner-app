// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/wallet_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controllers/HistoryController/call_history_controller.dart';

class WalletHistoryScreen extends StatefulWidget {
  const WalletHistoryScreen({super.key});

  @override
  State<WalletHistoryScreen> createState() => _WalletHistoryScreenState();
}

class _WalletHistoryScreenState extends State<WalletHistoryScreen> {
  final walletController = Get.find<WalletController>();
  final signupController = Get.find<SignupController>();
  final callcontrller = Get.find<CallHistoryController>();

  @override
  void initState() {
    super.initState();
    walletController.getAmountList();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<SignupController>(
      builder: (signupController) {
        return signupController.astrologerList.isEmpty
            ? SizedBox(
                child: Center(
                  child: const Text('Please Wait!!!!').tr(),
                ),
              )
            : signupController.astrologerList[0]!.wallet!.isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, right: 10, bottom: 200),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: COLORS().primaryColor,
                          ),
                          onPressed: () async {
                            try {
                              signupController.astrologerList.clear();
                              await signupController
                                  .astrologerProfileById(false);
                              log('Data loaded successfully');
                            } catch (e) {
                              log('Error loading data: $e');
                            } finally {
                              signupController.update();
                              log('signupController Updated Finally');
                            }
                          },
                          child: const Icon(
                            Icons.refresh_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Center(
                        child:
                            const Text("You don't have any history yet!").tr(),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 10, right: 10),
                        child: Text("Available Balance",
                                style: TextStyle(
                                    color: COLORS().blackColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15))
                            .tr(),
                      ),
                      if (!global.isCoinWallet())
                        GetBuilder<WalletController>(
                          builder: (walletController) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                walletController.withdraw.walletAmount != null
                                    ? '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${walletController.withdraw.walletAmount!.toStringAsFixed(2)}'
                                    : " 0",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontSize: 20),
                              ),
                            );
                          },
                        )
                      else
                        GetBuilder<WalletController>(
                          builder: (walletController) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CachedNetworkImage(
                                      imageUrl: global.getSystemFlagValue(
                                          global.systemFlagNameList.coinIcon),
                                      height: 20,
                                      width: 20,
                                      fit: BoxFit.cover),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    walletController.withdraw.walletAmount !=
                                            null
                                        ? walletController
                                            .withdraw.walletAmount!
                                            .toStringAsFixed(2)
                                        : " 0",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      Divider(
                        height: 1.w,
                        color: Colors.grey.shade400,
                      ),
                      Expanded(
                        child: GetBuilder<SignupController>(
                          builder: (signupController) {
                            return RefreshIndicator(
                              onRefresh: () async {
                                await signupController
                                    .astrologerProfileById(false);
                                //! WALLET
                                await walletController.getAmountList();
                                signupController.update();
                              },
                              child: ListView.builder(
                                itemCount: signupController
                                    .astrologerList[0]!.wallet!.length,
                                controller: signupController
                                    .walletHistoryScrollController,
                                physics: const ClampingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    width: width,
                                    child: Column(
                                      children: [
                                        Card(
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          Get.width * 0.68, //
                                                      child: signupController
                                                                  .astrologerList[
                                                                      0]!
                                                                  .wallet![
                                                                      index]
                                                                  .transactionType ==
                                                              'KundliView'
                                                          ? Text(
                                                              'You Created/viewed Kundli',
                                                              style: Get
                                                                  .theme
                                                                  .primaryTextTheme
                                                                  .displaySmall!
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                              textAlign:
                                                                  TextAlign
                                                                      .justify,
                                                            ).tr()
                                                          : signupController
                                                                      .astrologerList[0]!
                                                                      .wallet![index]
                                                                      .transactionType ==
                                                                  'Gift'
                                                              ? Text(
                                                                  signupController
                                                                              .astrologerList[0]!
                                                                              .wallet![index]
                                                                              .name !=
                                                                          null
                                                                      ? 'Recived gift from'
                                                                      : tr("Recived gift from User"),
                                                                  style: Get
                                                                      .theme
                                                                      .primaryTextTheme
                                                                      .displaySmall!
                                                                      .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .justify,
                                                                ).tr(args: [signupController.astrologerList[0]!.wallet![index].name.toString()])
                                                              : signupController.astrologerList[0]!.wallet![index].transactionType == 'Call'
                                                                  ? Text(
                                                                      signupController.astrologerList[0]!.wallet![index].name !=
                                                                              null
                                                                          ? 'calledwithuser'
                                                                          // ? '${signupController.astrologerList[0]!.wallet![index].transactionType}ed with ${signupController.astrologerList[0]!.wallet![index].name == '' ? 'user' : signupController.astrologerList[0]!.wallet![index].name} for ${signupController.astrologerList[0]!.wallet![index].totalMin!} minutes'
                                                                          : tr(
                                                                              "Recived gift"),
                                                                      style: Get
                                                                          .theme
                                                                          .primaryTextTheme
                                                                          .displaySmall!
                                                                          .copyWith(
                                                                              fontWeight: FontWeight.normal),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .justify,
                                                                    ).tr(args: [
                                                                      signupController.astrologerList[0]?.wallet?[index].name?.isNotEmpty ??
                                                                              false
                                                                          ? signupController
                                                                              .astrologerList[0]!
                                                                              .wallet![index]
                                                                              .name
                                                                              .toString()
                                                                          : 'User',
                                                                      (signupController.astrologerList[0]?.wallet?[index].totalMin ??
                                                                              0)
                                                                          .toString(),
                                                                    ])
                                                                  : signupController.astrologerList[0]!.wallet![index].transactionType == 'Chat'
                                                                      ? Text(
                                                                          signupController.astrologerList[0]!.wallet![index].name != null
                                                                              ? 'chatwithuser'
                                                                              : tr("Recived gift"),
                                                                          style: Get
                                                                              .theme
                                                                              .primaryTextTheme
                                                                              .displaySmall!
                                                                              .copyWith(fontWeight: FontWeight.normal),
                                                                          textAlign:
                                                                              TextAlign.justify,
                                                                        ).tr(args: [
                                                                          signupController.astrologerList[0]?.wallet?[index].name?.isNotEmpty ?? false
                                                                              ? signupController.astrologerList[0]!.wallet![index].name.toString()
                                                                              : 'User',
                                                                          (signupController.astrologerList[0]?.wallet?[index].totalMin ?? 0)
                                                                              .toString(),
                                                                        ])
                                                                      : signupController.astrologerList[0]!.wallet![index].transactionType == 'Cashback'
                                                                          ? Text(
                                                                              "${signupController.astrologerList[0]!.wallet![index].transactionType}",
                                                                              style: Get.theme.primaryTextTheme.displaySmall!.copyWith(fontWeight: FontWeight.normal),
                                                                            )
                                                                          : signupController.astrologerList[0]!.wallet![index].transactionType == 'Report'
                                                                              ? Text(
                                                                                  signupController.astrologerList[0]!.wallet![index].name != null ? '${signupController.astrologerList[0]!.wallet![index].transactionType} Request from ${signupController.astrologerList[0]!.wallet![index].name == '' ? 'user' : signupController.astrologerList[0]!.wallet![index].name}' : tr("Report request from user"),
                                                                                  style: Get.theme.primaryTextTheme.displaySmall!.copyWith(fontWeight: FontWeight.normal),
                                                                                ).tr()
                                                                              : signupController.astrologerList[0]!.wallet![index].transactionType == 'ProductRefCommission'
                                                                                  ? Text(
                                                                                      signupController.astrologerList[0]!.wallet![index].productRefName.toString() == "" ? "Commission of Product Refered to" "User" : "Commission of Product Refered to ${signupController.astrologerList[0]!.wallet![index].productRefName.toString()}",
                                                                                      style: Get.theme.primaryTextTheme.displaySmall!.copyWith(fontWeight: FontWeight.normal),
                                                                                    ).tr()
                                                                                  : signupController.astrologerList[0]!.wallet![index].transactionType == 'courseOrder'
                                                                                      ? Text(
                                                                                          "You have Purchased Course",
                                                                                          style: Get.theme.primaryTextTheme.displaySmall!.copyWith(fontWeight: FontWeight.normal),
                                                                                        ).tr()
                                                                                      : Text(
                                                                                          signupController.astrologerList[0]!.wallet![index].name != null ? 'otherliveaudivideo' : tr("Recived gift"),
                                                                                          style: Get.theme.primaryTextTheme.displaySmall!.copyWith(fontWeight: FontWeight.normal),
                                                                                          textAlign: TextAlign.justify,
                                                                                        ).tr(
                                                                                          args: [
                                                                                            signupController.astrologerList[0]!.wallet![index].transactionType.toString(),
                                                                                            signupController.astrologerList[0]?.wallet?[index].name?.isNotEmpty ?? false ? signupController.astrologerList[0]!.wallet![index].name.toString() : 'User',
                                                                                            (signupController.astrologerList[0]?.wallet?[index].totalMin ?? 0).toString(),
                                                                                          ],
                                                                                        ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 2),
                                                      child: Text(
                                                        DateFormat(
                                                                'dd MMM yyyy , hh:mm a')
                                                            .format(DateTime.parse(signupController
                                                                    .astrologerList[
                                                                        0]!
                                                                    .wallet![
                                                                        index]
                                                                    .createdAt!
                                                                    .toString())
                                                                .toLocal()),
                                                        style: Get
                                                            .theme
                                                            .primaryTextTheme
                                                            .titleSmall,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${signupController.astrologerList[0]!.wallet![index].isCredit == 1 ? '+' : '-'} ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: signupController
                                                                    .astrologerList[
                                                                        0]!
                                                                    .wallet![
                                                                        index]
                                                                    .isCredit ==
                                                                1
                                                            ? Colors.green
                                                            : Colors.red,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    if (!global.isCoinWallet())
                                                      Text(
                                                        '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: signupController
                                                                      .astrologerList[
                                                                          0]!
                                                                      .wallet![
                                                                          index]
                                                                      .isCredit ==
                                                                  1
                                                              ? Colors.green
                                                              : Colors.red,
                                                          fontSize: 16,
                                                        ),
                                                      )
                                                    else
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 4),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: global
                                                              .getSystemFlagValue(
                                                                  global
                                                                      .systemFlagNameList
                                                                      .coinIcon),
                                                          height: 18,
                                                          width: 18,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    Text(
                                                      signupController
                                                          .astrologerList[0]!
                                                          .wallet![index]
                                                          .amount!
                                                          .toStringAsFixed(2),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: signupController
                                                                    .astrologerList[
                                                                        0]!
                                                                    .wallet![
                                                                        index]
                                                                    .isCredit ==
                                                                1
                                                            ? Colors.green
                                                            : Colors.red,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        signupController.isMoreDataAvailable ==
                                                    true &&
                                                !signupController
                                                    .isAllDataLoaded &&
                                                signupController
                                                            .astrologerList[0]!
                                                            .wallet!
                                                            .length -
                                                        1 ==
                                                    index
                                            ? const CircularProgressIndicator()
                                            : const SizedBox(),
                                        index ==
                                                signupController
                                                        .astrologerList[0]!
                                                        .wallet!
                                                        .length -
                                                    1
                                            ? const SizedBox(
                                                height: 20,
                                              )
                                            : const SizedBox()
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
      },
    );
  }
}
