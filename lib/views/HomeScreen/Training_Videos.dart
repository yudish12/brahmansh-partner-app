import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/YoutubeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrainingVideosScreen extends StatelessWidget {
  TrainingVideosScreen({super.key});
  final youtubeController = Get.put(YoutubeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Training Videos',
          style: Get.theme.textTheme.bodyMedium!.copyWith(
              color: Colors.white,
              fontSize: 17.sp,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: ListView.builder(
        itemCount: youtubeController.controllers.length,
        itemBuilder: (context, index) {
          return Container(
            width: 80.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.w),
                color: Get.theme.primaryColor.withOpacity(0.8)),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(2.w),
                        topRight: Radius.circular(2.w)),
                    child: YoutubePlayer(
                      aspectRatio: 16 / 9,
                      controller: youtubeController.controllers[index],
                      showVideoProgressIndicator: true,
                      progressColors: const ProgressBarColors(
                        playedColor: Colors.red,
                        handleColor: Colors.grey,
                      ),
                      bottomActions: const [
                        CurrentPosition(),
                        ProgressBar(
                          isExpanded: true,
                        ),
                        RemainingDuration(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.w,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Text(
                          'Id: RLzC55ai0eo',
                          style: Get.theme.textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: COLORS().whiteColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.w))),
                        onPressed: () {
                          youtubeController.launchYouTubeVideo(youtubeController
                              .controllers[index].initialVideoId);
                        },
                        icon: Icon(
                          Icons.play_arrow_sharp,
                          size: 10.sp,
                          color: COLORS().whiteColor,
                        ),
                        label: Text(
                          'Play in YouTube',
                          style: Get.theme.textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
