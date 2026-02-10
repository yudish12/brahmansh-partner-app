// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/model/kundlichartModel.dart';
import 'package:sizer/sizer.dart';

class Personalcharacterscreen extends StatefulWidget {
  PersonalCharacteristics? character;
  Personalcharacterscreen({super.key, required this.character});

  @override
  State<Personalcharacterscreen> createState() =>
      _PersonalcharacterscreenState();
}

class _PersonalcharacterscreenState extends State<Personalcharacterscreen> {
  List<String> predictionList = [];

  @override
  void initState() {
    super.initState();
    final Map<dynamic, dynamic>? kundlipersonalchar =
        widget.character?.toJson();
    // log('prediction data is ${kundlipersonalchar?['response']}');
    for (var item in kundlipersonalchar?['response']) {
      predictionList.add(item['personalised_prediction']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 1.h),
          Container(
            width: 100.w,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              'Prediction',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            primary: false,
            separatorBuilder: (context, index) => SizedBox(height: 2.w),
            itemCount: predictionList.length,
            itemBuilder: (context, index) {
              final detail = predictionList[index];
              final isEven = index % 2 == 0;

              return Container(
                color: isEven ? Colors.grey[200] : Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // circular icon with index in it
                    CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      radius: 15,
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '$detail:',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(
            height: 2.h,
          ),
        ],
      ),
    );
  }
}
