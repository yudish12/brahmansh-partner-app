// ignore_for_file: must_be_immutable, avoid_unnecessary_containers, avoid_print

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/constants/messageConst.dart';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/models/History/report_history_model.dart';
import 'package:brahmanshtalk/views/HomeScreen/Report_Module/view_report_pdf_scree.dart';
import 'package:brahmanshtalk/widgets/app_bar_widget.dart';
import 'package:brahmanshtalk/widgets/common_padding_2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:sizer/sizer.dart';

class ReportHistoryDetailScreen extends StatelessWidget {
  final ReportHistoryModel? reportHistoryData;
  ReportHistoryDetailScreen({super.key, this.reportHistoryData});
  final signupController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    log("Report History Data: ${reportHistoryData!.profile}");
    return SafeArea(
      child: GetBuilder<SignupController>(
          init: signupController,
          builder: (signupController) {
            return Scaffold(
                appBar: MyCustomAppBar(
                  height: 80,
                  iconData: IconThemeData(color: COLORS().textColor),
                  backgroundColor: COLORS().primaryColor,
                  title: Text(
                    "Report Detail's",
                    style: Get.theme.textTheme.bodyMedium!
                        .copyWith(color: COLORS().textColor, fontSize: 17.sp),
                  ).tr(),
                ),
                body: CommonPadding2(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        reportHistoryData?.profile != null &&
                                reportHistoryData?.profile != ""
                            ? Container(
                                height: 150,
                                width: 150,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: COLORS().whiteColor,
                                  borderRadius: BorderRadius.circular(100.w),
                                  border:
                                      Border.all(color: Get.theme.primaryColor),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        global.buildImageUrl(reportHistoryData!.profile)),
                                  ),
                                ),
                              )
                            : Container(
                                height: 150,
                                width: 150,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: COLORS().whiteColor,
                                  borderRadius: BorderRadius.circular(100.w),
                                  border:
                                      Border.all(color: Get.theme.primaryColor),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/images/no_customer_image.png"),
                                  ),
                                ),
                              ),
                        const Divider(
                          color: Colors.black,
                          thickness: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ListTile(
                            title: Text(
                              "Report Type",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall,
                            ).tr(),
                            trailing: SizedBox(
                              width: 190,
                              child: Text(
                                reportHistoryData?.reportType != null
                                    ? '${reportHistoryData!.reportType}'
                                    : "",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ListTile(
                            title: Text(
                              "First Name",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall,
                            ).tr(),
                            trailing: SizedBox(
                              width: 190,
                              child: Text(
                                reportHistoryData?.firstName != null &&
                                        reportHistoryData!.firstName!.isNotEmpty
                                    ? '${reportHistoryData?.firstName}'
                                    : tr('User'),
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ListTile(
                            title: Text(
                              "Last Name",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall,
                            ).tr(),
                            trailing: SizedBox(
                              width: 190,
                              child: Text(
                                reportHistoryData?.lastName != null
                                    ? '${reportHistoryData!.lastName}'
                                    : "",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ListTile(
                            title: Text(
                              "Phone Number",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall,
                            ).tr(),
                            trailing: Text(
                              reportHistoryData?.contactNo != null
                                  ? global.maskMobileNumber(
                                      '${reportHistoryData!.contactNo}')
                                  : "",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ListTile(
                            title: Text(
                              "Prefered Language",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall,
                            ).tr(),
                            trailing: Text(
                              reportHistoryData?.answerLanguage != null
                                  ? "${reportHistoryData!.answerLanguage}"
                                  : "",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ListTile(
                            title: Text(
                              "Gender",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall,
                            ).tr(),
                            trailing: Text(
                              reportHistoryData!.gender != null
                                  ? '${reportHistoryData!.gender}'
                                  : "",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ListTile(
                            title: Text(
                              "Date of Birth",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall,
                            ).tr(),
                            trailing: Text(
                              reportHistoryData!.birthDate != null
                                  ? DateFormat('dd-MM-yyyy')
                                      .format(reportHistoryData!.birthDate!)
                                  : "",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ListTile(
                            title: Text(
                              "Time of Birth",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall,
                            ).tr(),
                            trailing: Text(
                              reportHistoryData!.birthTime != null
                                  ? '${reportHistoryData!.birthTime}'
                                  : "",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ListTile(
                            title: Text(
                              "Place of Birth",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall,
                            ).tr(),
                            trailing: SizedBox(
                              width: 190,
                              child: Text(
                                reportHistoryData!.birthPlace != null
                                    ? '${reportHistoryData!.birthPlace}'
                                    : "",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        ),
                        reportHistoryData!.occupation != null &&
                                reportHistoryData!.occupation != ''
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: ListTile(
                                  title: Text(
                                    "Occupation",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .displaySmall,
                                  ).tr(),
                                  trailing: SizedBox(
                                    width: 190,
                                    child: Text(
                                      reportHistoryData!.occupation != null
                                          ? '${reportHistoryData!.occupation}'
                                          : "",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .titleMedium,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ListTile(
                            title: Text(
                              "Marital Status",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall,
                            ).tr(),
                            trailing: Text(
                              reportHistoryData?.maritalStatus != null
                                  ? '${reportHistoryData!.maritalStatus}'
                                  : "",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium,
                            ),
                          ),
                        ),
                        reportHistoryData != null
                            ? Column(
                                children: [
                                  reportHistoryData!.partnerName != null &&
                                          reportHistoryData!.partnerName != ''
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: ListTile(
                                            title: Text(
                                              "Partner name",
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .displaySmall,
                                            ).tr(),
                                            trailing: SizedBox(
                                              width: 190,
                                              child: Text(
                                                reportHistoryData!
                                                            .partnerName !=
                                                        null
                                                    ? '${reportHistoryData!.partnerName}'
                                                    : "",
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .titleMedium,
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  reportHistoryData!.partnerBirthDate != null
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: ListTile(
                                            title: Text(
                                              "Partner Date of Birth",
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .displaySmall,
                                            ).tr(),
                                            trailing: Text(
                                              reportHistoryData!
                                                          .partnerBirthDate !=
                                                      null
                                                  ? DateFormat('dd-MM-yyyy')
                                                      .format(reportHistoryData!
                                                          .partnerBirthDate!)
                                                  : "",
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .titleMedium,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  reportHistoryData!.partnerBirthTime != null &&
                                          reportHistoryData!.partnerBirthTime !=
                                              ''
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: ListTile(
                                            title: Text(
                                              "Partner Time of Birth",
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .displaySmall,
                                            ).tr(),
                                            trailing: Text(
                                              reportHistoryData!
                                                          .partnerBirthTime !=
                                                      null
                                                  ? '${reportHistoryData!.partnerBirthTime}'
                                                  : "",
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .titleMedium,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  reportHistoryData!.partnerBirthPlace !=
                                              null &&
                                          reportHistoryData!
                                                  .partnerBirthPlace !=
                                              ''
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: ListTile(
                                            title: Text(
                                              "Partner Place of Birth",
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .displaySmall,
                                            ).tr(),
                                            trailing: SizedBox(
                                              width: 190,
                                              child: Text(
                                                reportHistoryData!
                                                            .partnerBirthPlace !=
                                                        null
                                                    ? '${reportHistoryData!.partnerBirthPlace}'
                                                    : "",
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .titleMedium,
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              )
                            : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: ExpansionTile(
                            childrenPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            title: Text(
                              "Comments",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall,
                            ).tr(),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Text(
                                  reportHistoryData!.comments != null
                                      ? '${reportHistoryData!.comments}'
                                      : 'I want my full 2024 Detailed Yearly Report',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .titleMedium,
                                ).tr(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: reportHistoryData!.reportFile! != ""
                    ? Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: COLORS().primaryColor,
                            maximumSize:
                                Size(MediaQuery.of(context).size.width, 100),
                            minimumSize:
                                Size(MediaQuery.of(context).size.width, 48),
                          ),
                          onPressed: () {
                            Get.to(() => ViewReportPdfScreen(
                                  reportHistoryData: reportHistoryData,
                                ));
                          },
                          child:  Text(
                            MessageConstants.VIEW_PDF,
                            style: TextStyle(color: COLORS().textColor),
                          ).tr(),
                        ),
                      )
                    : const SizedBox());
          }),
    );
  }
}
