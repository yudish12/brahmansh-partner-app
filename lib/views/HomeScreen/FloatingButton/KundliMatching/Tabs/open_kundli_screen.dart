import 'dart:math';

import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/constants/messageConst.dart';
import 'package:brahmanshtalk/controllers/free_kundli_controller.dart';
import 'package:brahmanshtalk/controllers/kundli_matchig_controller.dart';
import 'package:brahmanshtalk/widgets/common_padding_2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;

class OpenKundliScreen extends StatelessWidget {
  OpenKundliScreen({super.key});
  final KundliMatchingController kundliMatchingController =
      Get.find<KundliMatchingController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
      ),
      child: CommonPadding2(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Section
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: GetBuilder<KundliController>(builder: (kundliController) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    onChanged: (value) {
                      kundliController.searchKundli(value);
                    },
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    keyboardType: TextInputType.text,
                    cursorColor: COLORS().primaryColor,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                      helperStyle: TextStyle(color: COLORS().primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: COLORS().primaryColor,
                          width: 2,
                        ),
                      ),
                      hintText: tr("Search kundli by name"),
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.search_rounded,
                          color: Colors.grey.shade600,
                          size: 24,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const Divider(
              height: 20,
              thickness: 1,
              color: Colors.grey,
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, top: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.history_rounded,
                    color: COLORS().primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Recently Opened",
                    style: Theme.of(context)
                        .primaryTextTheme
                        .titleMedium
                        ?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                  ).tr(),
                ],
              ),
            ),

            Expanded(
              child: GetBuilder<KundliController>(builder: (kundliController) {
                return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  itemCount: kundliController.searchKundliList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            kundliMatchingController.openKundliData(
                                kundliController.searchKundliList, index);
                            kundliMatchingController
                                .onHomeTabBarIndexChanged(1);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Avatar
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors
                                            .primaries[Random().nextInt(
                                                Colors.primaries.length)]
                                            .shade600,
                                        Colors
                                            .primaries[Random().nextInt(
                                                Colors.primaries.length)]
                                            .shade400,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      kundliController
                                          .searchKundliList[index].name[0],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Kundli Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        kundliController
                                            .searchKundliList[index].name,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .displaySmall
                                            ?.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today_rounded,
                                            size: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${DateFormat("dd MMM yyyy").format(kundliController.searchKundliList[index].birthDate)},${kundliController.searchKundliList[index].birthTime}",
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  fontSize: 13,
                                                  color: Colors.grey.shade700,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_rounded,
                                            size: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              kundliController
                                                  .searchKundliList[index]
                                                  .birthPlace,
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade700,
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Delete Button
                                IconButton(
                                  onPressed: () {
                                    Get.dialog(
                                      AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        title: const Text(
                                          "Are you sure you want to permanently delete this kundli?",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ).tr(),
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  side: BorderSide(
                                                      color:
                                                          Colors.grey.shade400),
                                                ),
                                                child: Text(
                                                  MessageConstants.CANCEL,
                                                  style: TextStyle(
                                                    color: Colors.grey.shade700,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ).tr(),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.red.shade500,
                                                      Colors.red.shade400,
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    global
                                                        .showOnlyLoaderDialog();
                                                    await kundliController
                                                        .deleteKundli(
                                                            kundliController
                                                                .searchKundliList[
                                                                    index]
                                                                .id!);
                                                    await kundliController
                                                        .getKundliList();
                                                    Get.back();
                                                    global.hideLoader();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    shadowColor:
                                                        Colors.transparent,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 12),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    MessageConstants.YES,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ).tr(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.red.shade600,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
