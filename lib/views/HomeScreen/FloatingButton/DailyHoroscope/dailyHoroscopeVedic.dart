import 'package:brahmanshtalk/controllers/dailyHoroscopeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/controllers/splashController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:screenshot/screenshot.dart';
import 'package:sizer/sizer.dart';
import '../../../../constants/colorConst.dart';
import 'HoroscopeRotateAnimation.dart';
import 'LinearProgressCard.dart';

class DailyHoroscopeVedic extends StatefulWidget {
  const DailyHoroscopeVedic({super.key});

  @override
  State<DailyHoroscopeVedic> createState() => _DailyHoroscopeScreenState();
}

class _DailyHoroscopeScreenState extends State<DailyHoroscopeVedic> {
  final splashController = Get.find<SplashController>();

  int selectHoroscope = 1;
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:  Text('Daily Horoscope',
          style: TextStyle(
            color: COLORS().textColor
          ),).tr(),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon:  Icon(Icons.arrow_back,
            color: COLORS().textColor,),
          ),
          actions: const []),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GetBuilder<DailyHoroscopeController>(
              builder: (dailyHoroscopeController) {
            return dailyHoroscopeController.vedicdailyList == null
                ? const SizedBox()
                : SizedBox(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //-------Horizontal List of RasiSymbols---------
                      (global.hororscopeSignList.isNotEmpty)
                          ? SizedBox(
                              height: 13.h,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: global.hororscopeSignList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              global.showOnlyLoaderDialog();
                                              await dailyHoroscopeController
                                                  .selectZodic(index);
                                              await dailyHoroscopeController
                                                  .getHoroscopeList(
                                                      horoscopeId:
                                                          dailyHoroscopeController
                                                              .signId);
                                              global.hideLoader();
                                            },
                                            child: Container(
                                              width: global
                                                      .hororscopeSignList[index]
                                                      .isSelected
                                                  ? 68.0
                                                  : 54.0,
                                              height: global
                                                      .hororscopeSignList[index]
                                                      .isSelected
                                                  ? 68.0
                                                  : 54.0,
                                              padding: const EdgeInsets.all(0),
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(7)),
                                                border: Border.all(
                                                  color: Colors.transparent,
                                                  width: 1.0,
                                                ),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: global
                                                    .hororscopeSignList[index]
                                                    .image,
                                                placeholder: (context, url) =>
                                                    const Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(
                                                            Icons.no_accounts,
                                                            size: 20),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            global
                                                .hororscopeSignList[index].name,
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(fontSize: 10),
                                          ).tr()
                                        ],
                                      ),
                                    );
                                  }),
                            )
                          : const SizedBox(),

                      //---------daily,yearly,monthly--------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                dailyHoroscopeController.getProgressValue(
                                    index: 0, type: 'todayHoroscope');
                                setState(() {
                                  selectHoroscope = 0;
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(18, 8, 18, 8),
                                decoration: BoxDecoration(
                                  color: selectHoroscope == 0
                                      ? const Color.fromARGB(255, 247, 243, 214)
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: selectHoroscope == 0
                                          ? Get.theme.primaryColor
                                          : Colors.grey),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0)),
                                ),
                                child: Text("Today \n Horoscope",
                                        textAlign: TextAlign.center,
                                        style: Get.textTheme.titleMedium!
                                            .copyWith(fontSize: 12))
                                    .tr(),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                dailyHoroscopeController.getProgressValue(
                                    index: 0, type: 'weeklyHoroScope');
                                dailyHoroscopeController.update();
                                setState(() {
                                  selectHoroscope = 1;
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(18, 8, 18, 8),
                                decoration: BoxDecoration(
                                  color: selectHoroscope == 1
                                      ? const Color.fromARGB(255, 247, 243, 214)
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: selectHoroscope == 1
                                          ? Get.theme.primaryColor
                                          : Colors.grey),
                                ),
                                child: Text("Weekly \n Horoscope",
                                        textAlign: TextAlign.center,
                                        style: Get.textTheme.titleMedium!
                                            .copyWith(fontSize: 12))
                                    .tr(),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                dailyHoroscopeController.getProgressValue(
                                    index: 0, type: 'yearlyHoroScope');
                                setState(() {
                                  selectHoroscope = 2;
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(18, 8, 18, 8),
                                decoration: BoxDecoration(
                                  color: selectHoroscope == 2
                                      ? const Color.fromARGB(255, 247, 243, 214)
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: selectHoroscope == 2
                                          ? Get.theme.primaryColor
                                          : Colors.grey),
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0)),
                                ),
                                child: Text("Yearly \n Horoscope",
                                        textAlign: TextAlign.center,
                                        style: Get.textTheme.titleMedium!
                                            .copyWith(fontSize: 12))
                                    .tr(),
                              ),
                            ),
                          )
                        ],
                      ),

                      selectHoroscope == 0
                          ? dailyHoroscopeController
                                  .vedicdailyList!.todayHoroscope!.isNotEmpty
                              ? Screenshot(
                                  controller: dailyHoroscopeController
                                      .screenshotController,
                                  child: Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffFAEAE2),
                                            border: Border.all(
                                                color: Get.theme.primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Stack(
                                            alignment: Alignment.centerRight,
                                            children: [
                                              const Positioned(
                                                  bottom: -60,
                                                  right: -60,
                                                  child:
                                                      HoroscopeRotateAnimation(
                                                          size: 160)),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                    vertical:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.02),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(DateTime.parse(
                                                              dailyHoroscopeController
                                                                  .vedicdailyList!
                                                                  .todayHoroscope![
                                                                      0]
                                                                  .date
                                                                  .toString())),
                                                      style: Get.textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  Colors.black),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ).tr(),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "Today Horoscope",
                                                      style: Get.textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.black),
                                                    ).tr(),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "Lucky Color",
                                                              style: Get
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                            ).tr(),
                                                            dailyHoroscopeController
                                                                        .vedicdailyList!
                                                                        .todayHoroscope![
                                                                            0]
                                                                        .colorCode
                                                                        .toString() ==
                                                                    ""
                                                                ? const SizedBox()
                                                                : CircleAvatar(
                                                                    backgroundColor: Color(int.parse(dailyHoroscopeController
                                                                        .vedicdailyList!
                                                                        .todayHoroscope![
                                                                            0]
                                                                        .colorCode
                                                                        .toString())),
                                                                    radius: 7,
                                                                  )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          width: 1,
                                                          height: 20,
                                                          color: Colors.black,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "Lucky Number",
                                                              style: Get
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                            ).tr(),
                                                            Text(
                                                              dailyHoroscopeController
                                                                  .vedicdailyList!
                                                                  .todayHoroscope![
                                                                      0]
                                                                  .luckyNumber!
                                                                  .replaceAll(
                                                                      "[", "")
                                                                  .replaceAll(
                                                                      "]", ""),
                                                              style: Get
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          "Today Horoscrope of",
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ).tr(args: [
                                          tr(dailyHoroscopeController
                                              .vedicdailyList!
                                              .todayHoroscope![0]
                                              .zodiac
                                              .toString())
                                        ]),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        LinearProgressCard(
                                            dailyHoroscopeController:
                                                dailyHoroscopeController,
                                            horoscopetype: 'todayHoroscope'),
                                        const SizedBox(height: 10),
                                        Text(
                                          "${dailyHoroscopeController.vedicdailyList!.todayHoroscope![0].botResponse}",
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ).tr(),
                                        const SizedBox(height: 50),
                                      ],
                                    ),
                                  ),
                                )
                              : Center(
                                  child: const Text("NO HOROSCOPE").tr(),
                                )
                          : const Center(),

                      selectHoroscope == 1
                          ? dailyHoroscopeController.vedicdailyList!
                                      .weeklyHoroScope!.length ==
                                  0
                              ? Center(
                                  child: const Text("NO HOROSCOPE").tr(),
                                )
                              : RepaintBoundary(
                                  key: globalKey,
                                  child: Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffFAEAE2),
                                            border: Border.all(
                                                color: Get.theme.primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Stack(
                                            alignment: Alignment.centerRight,
                                            children: [
                                              const Positioned(
                                                  bottom: -60,
                                                  right: -60,
                                                  child:
                                                      HoroscopeRotateAnimation(
                                                          size: 160)),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                    vertical:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.02),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          DateFormat(
                                                                  'dd-MM-yyyy')
                                                              .format(DateTime.parse(
                                                                  dailyHoroscopeController
                                                                      .vedicdailyList!
                                                                      .weeklyHoroScope![
                                                                          0]
                                                                      .startDate
                                                                      .toString())),

                                                          // "${dailyHoroscopeController.vedicdailyList!['vedicList']['weeklyHoroScope'][0]['start_date'].toString().split(" ").first}",
                                                          style: Get.textTheme
                                                              .titleMedium!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .black),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ).tr(),
                                                        Text(
                                                          ' - ',
                                                          style: Get.textTheme
                                                              .titleMedium!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        Text(
                                                          DateFormat(
                                                                  'dd-MM-yyyy')
                                                              .format(DateTime.parse(
                                                                  dailyHoroscopeController
                                                                      .vedicdailyList!
                                                                      .weeklyHoroScope![
                                                                          0]
                                                                      .endDate
                                                                      .toString())),
                                                          style: Get.textTheme
                                                              .titleMedium!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .black),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ).tr(),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      "Weekly Horoscope",
                                                      style: Get.textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.black),
                                                    ).tr(),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "Lucky Color",
                                                              style: Get
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                            ).tr(),
                                                            dailyHoroscopeController
                                                                        .vedicdailyList!
                                                                        .weeklyHoroScope![
                                                                            0]
                                                                        .colorCode
                                                                        .toString() ==
                                                                    ""
                                                                ? const SizedBox()
                                                                : CircleAvatar(
                                                                    backgroundColor: Color(int.parse(dailyHoroscopeController
                                                                        .vedicdailyList!
                                                                        .weeklyHoroScope![
                                                                            0]
                                                                        .colorCode
                                                                        .toString())),
                                                                    radius: 7,
                                                                  )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          width: 1,
                                                          height: 20,
                                                          color: Colors.black,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "Lucky Number",
                                                              style: Get
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                            ).tr(),
                                                            Text(
                                                              dailyHoroscopeController
                                                                  .vedicdailyList!
                                                                  .weeklyHoroScope![
                                                                      0]
                                                                  .luckyNumber!
                                                                  .replaceAll(
                                                                      "[", "")
                                                                  .replaceAll(
                                                                      "]", ""),
                                                              style: Get
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          11,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          "Weekly Horoscope of",
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ).tr(args: [
                                          tr(dailyHoroscopeController
                                              .vedicdailyList!
                                              .weeklyHoroScope![0]
                                              .zodiac
                                              .toString())
                                        ]),
                                        const SizedBox(height: 10),
                                        LinearProgressCard(
                                            dailyHoroscopeController:
                                                dailyHoroscopeController,
                                            horoscopetype: 'weeklyHoroScope'),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          "${dailyHoroscopeController.vedicdailyList!.weeklyHoroScope![0].botResponse}",
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ).tr(),
                                        const SizedBox(height: 50),
                                      ],
                                    ),
                                  ),
                                )
                          : const SizedBox(),

                      selectHoroscope == 2
                          ? dailyHoroscopeController.vedicdailyList!
                                      .yearlyHoroScope!.length ==
                                  0
                              ? Center(
                                  child: const Text("NO HOROSCOPE").tr(),
                                )
                              : Container(
                                  color: Colors.white,
                                  child: RepaintBoundary(
                                    key: globalKey,
                                    child: Column(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffFAEAE2),
                                            border: Border.all(
                                                color: Get.theme.primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              const Positioned(
                                                  bottom: -60,
                                                  right: -60,
                                                  child:
                                                      HoroscopeRotateAnimation(
                                                          size: 160)),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                    vertical:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.02),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      DateFormat('yyyy').format(
                                                          DateTime.parse(
                                                              dailyHoroscopeController
                                                                  .vedicdailyList!
                                                                  .yearlyHoroScope![
                                                                      0]
                                                                  .date
                                                                  .toString()
                                                                  .split(" ")
                                                                  .first)),
                                                      style: Get.textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  Colors.black),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ).tr(),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      "Yearly Horoscope",
                                                      style: Get.textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.black),
                                                    ).tr(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          "Yearly Horoscope of",
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ).tr(args: [
                                          tr(dailyHoroscopeController
                                              .vedicdailyList!
                                              .yearlyHoroScope![0]
                                              .zodiac
                                              .toString())
                                        ]),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        LinearProgressCard(
                                            dailyHoroscopeController:
                                                dailyHoroscopeController,
                                            horoscopetype: 'yearlyHoroScope'),
                                        Text(
                                          "${dailyHoroscopeController.vedicdailyList!.yearlyHoroScope![0].botResponse}",
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ).tr(),
                                        const SizedBox(height: 50),
                                      ],
                                    ),
                                  ),
                                )
                          : const SizedBox(),
                    ],
                  ));
          }),
        ),
      ),
    );
  }
}
