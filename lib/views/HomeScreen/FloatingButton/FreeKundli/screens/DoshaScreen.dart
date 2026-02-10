// ignore_for_file: unrelated_type_equality_checks, file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/controllers/free_kundli_controller.dart';
import 'package:sizer/sizer.dart';

class DoshaScreen extends StatefulWidget {
  final bool isKundali;
  final int? userid;
  const DoshaScreen({super.key, required this.userid, required this.isKundali});

  @override
  State<DoshaScreen> createState() => _DoshaScreenState();
}

class _DoshaScreenState extends State<DoshaScreen> {
  final kundlicontroller = Get.find<KundliController>();

  @override
  void initState() {
    super.initState();

    loadDatafromApi();
  }

  loadDatafromApi() async {
    await kundlicontroller.getDosha(widget.userid, widget.isKundali);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<KundliController>(
        builder: (kundlicontroller) =>
            kundlicontroller.doshaDeatilmodel == null ||
                    kundlicontroller.doshaDeatilmodel == ""
                ? SizedBox(
                    height: 100.h,
                    width: 100.w,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SizedBox(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 3.h),
                          _buildtitlewidget('Mangal Dosh'),
                          _buildmangalDoshwidget(),
                          // kaalsharp details
                          SizedBox(height: 5.h),
                          _buildtitlewidget('Kaal Sharp Dosh'),
                          SizedBox(height: 2.h),
                          _buildKaalsharpWidget(),
                          SizedBox(height: 3.h),
                          _buildtitlewidget(tr('Manglik Dosh')),
                          SizedBox(height: 2.h),
                          //manglik dosh
                          _buildManglikWidget(),
                          SizedBox(height: 2.h),
                          _buildtitlewidget(tr('Pitra Dosh')),
                          SizedBox(height: 0.h),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 3.w),
                            child: Text(
                              '${kundlicontroller.doshaDeatilmodel?.pitraDosh?.response?.botResponse}',
                              style: Get.theme.textTheme.bodySmall!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          _buildtitlewidget(tr('Papasamaya Dosh')),
                          // SizedBox(height: 2.h),
                          Container(
                            width: 100.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 0.5,
                                )),
                            margin: EdgeInsets.symmetric(horizontal: 3.w),
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text('Planet',
                                          style: Get.theme.primaryTextTheme
                                              .titleMedium!
                                              .copyWith(color: Colors.black))
                                      .tr(),
                                ),
                                const VerticalDivider(
                                  color: Colors.black,
                                  thickness: 0.5,
                                ),
                                Expanded(
                                  child: Text('Papa Score',
                                          style: Get.theme.primaryTextTheme
                                              .titleMedium!
                                              .copyWith(color: Colors.black))
                                      .tr(),
                                ),
                              ],
                            ),
                          ),

                          //
                          Column(
                            children: List.generate(
                                4, (index) => _buildpapasamayaWidget(index)),
                          ),

                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildmangalDoshwidget() {
    return Column(
      children: [
        SizedBox(height: 1.h),
        // Container(
        //   width: 100.w,
        //   margin: EdgeInsets.symmetric(horizontal: 3.w),
        //   child: RichText(
        //     text: TextSpan(
        //       children: [
        //         TextSpan(
        //           text: tr('Mars'),
        //           style: TextStyle(
        //               fontWeight: FontWeight.bold,
        //               color: Colors.black,
        //               fontSize: 13.sp),
        //         ),
        //         TextSpan(
        //             text: tr(': '),
        //             style: Theme.of(context).textTheme.bodySmall!.copyWith(
        //                 fontWeight: FontWeight.bold,
        //                 color: Colors.black,
        //                 fontSize: 13.sp)),
        //         TextSpan(
        //           text:
        //               '${kundlicontroller.doshaDeatilmodel?.mangalDosh?.response?.factors?.mars}',
        //           style: const TextStyle(
        //             color: Colors.black,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // SizedBox(height: 1.w),
        // Container(
        //   width: 100.w,
        //   margin: EdgeInsets.symmetric(horizontal: 3.w),
        //   child: RichText(
        //     text: TextSpan(
        //       children: [
        //         TextSpan(
        //           text: tr('Venus'),
        //           style: TextStyle(
        //               fontWeight: FontWeight.bold,
        //               color: Colors.black,
        //               fontSize: 13.sp),
        //         ),
        //         TextSpan(
        //             text: tr(': '),
        //             style: Theme.of(context).textTheme.bodySmall!.copyWith(
        //                 fontWeight: FontWeight.bold,
        //                 color: Colors.black,
        //                 fontSize: 13.sp)),
        //         TextSpan(
        //           text:
        //               '${kundlicontroller.doshaDeatilmodel?.mangalDosh?.response?.factors?.venus}',
        //           style: const TextStyle(
        //             color: Colors.black,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // SizedBox(height: 2.h),
        // Container(
        //   width: 100.w,
        //   margin: EdgeInsets.symmetric(horizontal: 3.w),
        //   child: RichText(
        //     text: TextSpan(
        //       children: [
        //         TextSpan(
        //           text: tr('Dosha Present'),
        //           style: TextStyle(
        //               fontWeight: FontWeight.bold,
        //               color: Colors.black,
        //               fontSize: 13.sp),
        //         ),
        //         TextSpan(
        //             text: tr(': '),
        //             style: Theme.of(context).textTheme.bodySmall!.copyWith(
        //                 fontWeight: FontWeight.bold,
        //                 color: Colors.black,
        //                 fontSize: 13.sp)),
        //         TextSpan(
        //           text: kundlicontroller.doshaDeatilmodel?.mangalDosh?.response
        //                       ?.isDoshaPresent ==
        //                   true
        //               ? 'Yes'
        //               : 'No',
        //           style: const TextStyle(
        //             color: Colors.black,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        Container(
          width: 100.w,
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: tr('Anshik'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 13.sp),
                ),
                TextSpan(
                    text: tr(': '),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 13.sp)),
                TextSpan(
                  text: kundlicontroller.doshaDeatilmodel?.mangalDosh?.response
                              ?.isAnshik ==
                          true
                      ? 'Yes'
                      : 'No',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 100.w,
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: tr('Score response'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 13.sp),
                ),
                TextSpan(
                    text: tr(': '),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 13.sp)),
                TextSpan(
                  text:
                      '${kundlicontroller.doshaDeatilmodel?.mangalDosh?.response?.botResponse}',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildManglikWidget() {
    return Column(
      children: [
        Container(
          width: 100.w,
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: tr('Manglik by mars'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 13.sp),
                ),
                TextSpan(
                    text: tr(': '),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 13.sp)),
                TextSpan(
                  text: kundlicontroller.doshaDeatilmodel?.manglikDosh?.response
                              ?.manglikByMars ==
                          true
                      ? 'Yes'
                      : 'No',
                  style: Get.theme.textTheme.bodySmall!.copyWith(
                      color: Colors.black,
                      // fontWeight: FontWeight.w400,
                      fontSize: 11.sp),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 100.w,
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: tr('Manglik by rahu ketu'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 13.sp),
                ),
                TextSpan(
                    text: tr(': '),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 13.sp)),
                TextSpan(
                  text: kundlicontroller.doshaDeatilmodel?.manglikDosh?.response
                              ?.manglikByRahuketu ==
                          true
                      ? 'Yes'
                      : 'No',
                  style: Get.theme.textTheme.bodySmall!.copyWith(
                      color: Colors.black,
                      // fontWeight: FontWeight.w400,
                      fontSize: 11.sp),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 100.w,
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: tr('Response'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 13.sp),
                ),
                TextSpan(
                    text: tr(': '),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 13.sp)),
                TextSpan(
                  text:
                      '${kundlicontroller.doshaDeatilmodel?.manglikDosh?.response?.botResponse}',
                  style: Get.theme.textTheme.bodySmall!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 11.sp),
                ),
              ],
            ),
          ),
        ),
        Column(
            children: List.generate(
                kundlicontroller.doshaDeatilmodel?.manglikDosh?.response
                        ?.factors?.length ??
                    0, (index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            child: Text(
              '${index + 1}. ${kundlicontroller.doshaDeatilmodel?.manglikDosh?.response?.factors?[index]}',
              style: Get.theme.textTheme.bodySmall!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp),
            ),
          );
        })),
      ],
    );
  }

  Widget _buildKaalsharpWidget() {
    return Column(children: [
      Container(
        width: 100.w,
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: tr('Dosha Present'),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 13.sp),
              ),
              TextSpan(
                  text: tr(': '),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 13.sp)),
              TextSpan(
                text: kundlicontroller.doshaDeatilmodel?.kaalsarpDosh?.response
                            ?.isDoshaPresent ==
                        true
                    ? 'Yes'
                    : 'No',
                style: Get.theme.textTheme.bodySmall!.copyWith(
                    color: Colors.black,
                    // fontWeight: FontWeight.w500,
                    fontSize: 11.sp),
              ),
            ],
          ),
        ),
      ),

      Container(
        width: 100.w,
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: tr('Response'),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 13.sp),
              ),
              TextSpan(
                  text: tr(': '),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 13.sp)),
              TextSpan(
                text:
                    '${kundlicontroller.doshaDeatilmodel?.kaalsarpDosh?.response?.botResponse}',
                style: Get.theme.textTheme.bodySmall!.copyWith(
                    color: Colors.black,
                    // fontWeight: FontWeight.w500,
                    fontSize: 11.sp),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 2.h),
      //remedies kaalsharp dosh
      Column(
        children: List.generate(
          kundlicontroller
                  .doshaDeatilmodel?.kaalsarpDosh?.response?.remedies?.length ??
              0,
          (index) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3.w),
                    border: Border.all(color: Colors.grey, width: 0.5),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Text(
                    '${index + 1} . ${kundlicontroller.doshaDeatilmodel?.kaalsarpDosh?.response?.remedies?[index]}',
                    style: Get.theme.textTheme.bodySmall!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 11.sp),
                  ),
                ),
                SizedBox(height: 1.h)
              ],
            );
          },
        ),
      ),
    ]);
  }

  Container _buildtitlewidget(String title) {
    return Container(
      height: 6.h,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      child: Text(
        tr(title),
        style: Get.theme.primaryTextTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w600, color: Colors.black, fontSize: 12.sp),
      ).tr(),
    );
  }

  Widget _buildpapasamayaWidget(int index) {
    return Container(
      width: 100.w,
      height: 5.h,
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade400, width: 0.5),
      ),
      child: index == 0
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Rahu',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                  ).tr(),
                ),
                VerticalDivider(
                  color: Colors.grey.shade400,
                  thickness: 0.5,
                ),
                Expanded(
                  child: Text(
                    kundlicontroller.doshaDeatilmodel?.papasamayaDosh?.response
                            ?.rahuPapa
                            .toString() ??
                        '',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
              ],
            )
          : index == 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Sun',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.black,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                      ).tr(),
                    ),
                    VerticalDivider(
                      color: Colors.grey.shade400,
                      thickness: 0.5,
                    ),
                    Expanded(
                      child: Text(
                        kundlicontroller.doshaDeatilmodel?.papasamayaDosh
                                ?.response?.sunPapa
                                .toString() ??
                            '',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.black,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),
                  ],
                )
              : index == 2
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Saturn',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                          ).tr(),
                        ),
                        VerticalDivider(
                          color: Colors.grey.shade400,
                          thickness: 0.5,
                        ),
                        Expanded(
                          child: Text(
                            kundlicontroller.doshaDeatilmodel?.papasamayaDosh
                                    ?.response?.saturnPapa
                                    .toString() ??
                                '',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
                        ),
                      ],
                    )
                  : index == 3
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Mars',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ).tr(),
                            ),
                            VerticalDivider(
                              color: Colors.grey.shade400,
                              thickness: 0.5,
                            ),
                            Expanded(
                              child: Text(
                                kundlicontroller.doshaDeatilmodel
                                        ?.papasamayaDosh?.response?.marsPapa
                                        .toString() ??
                                    '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
    );
  }
}
