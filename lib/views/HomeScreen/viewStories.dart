// ignore_for_file: file_names, must_be_immutable, avoid_function_literals_in_foreach_calls

import 'dart:math';

import 'package:brahmanshtalk/controllers/storiescontroller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:sizer/sizer.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

import '../../constants/imageConst.dart';
import '../../constants/messageConst.dart';

class ViewStoriesScreen extends StatefulWidget {
  String profile;
  String name;
  bool isprofile;
  int astroId;
  ViewStoriesScreen({
    super.key,
    required this.profile,
    required this.name,
    required this.isprofile,
    required this.astroId,
  });

  @override
  State<ViewStoriesScreen> createState() => _ViewStoriesScreenState();
}

class _ViewStoriesScreenState extends State<ViewStoriesScreen> {
  final controller = StoryController();
  List<StoryItem> storyItems = [];
  StoriesController storiesController = Get.find<StoriesController>();
  // final BottomNavigationController bottomNavigationController =
  // Get.find<BottomNavigationController>();

  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];
  Color randomColor = Colors.pink;

  @override
  void initState() {
    super.initState();
    final random = Random();
    randomColor = colors[random.nextInt(colors.length)];

    storiesController.viewSingleStory.forEach((element) {
      if (element.mediaType.toString() == "video") {
        storyItems.add(StoryItem.pageVideo(
          "${element.media}",
          controller: controller,
          //duration: Duration(seconds: (5).toInt()),
        ));
      } else if (element.mediaType.toString() == "image") {
        storyItems.add(StoryItem.pageImage(
          url: "${element.media}",
          controller: controller,
          duration: Duration(
            seconds: (5).toInt(),
          ),
        ));
      } else if (element.mediaType.toString() == "text") {
        storyItems.add(StoryItem.text(
          title: element.media.toString(),
          // backgroundColor: Colors.black,
          backgroundColor: randomColor,
          duration: Duration(
            seconds: (5).toInt(),
          ),
        ));
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            StoryView(
                controller: controller, // pass controller here too
                repeat: false, // should the stories be slid forever
                onStoryShow: (s, index) {
                  storiesController.storyIndex = index;
                  storiesController.update;
                },
                onComplete: () async {
                  // await storiesController.getAllStories();
                  Navigator.pop(context);
                },
                onVerticalSwipeComplete: (direction) {
                  if (direction == Direction.down) {
                    Navigator.pop(context);
                  }
                },
                storyItems:
                    storyItems // To disable vertical swipe gestures, ignore this parameter.
                // Preferrably for inline story view.
                ),
            Positioned(
              top: 20,
              left: 10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  global.user.imagePath!.isNotEmpty
                      ? CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(widget.profile),
                        )
                      : Container(
                          height: 6.h,
                          width: 6.h,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Get.theme.primaryColor,
                            image: const DecorationImage(
                              image: AssetImage(
                                IMAGECONST.noCustomerImage,
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    width: 2.w,
                  ),
                  SizedBox(
                    width: 75.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                controller.pause();
                                Get.dialog(
                                  AlertDialog(
                                    title: const Text(
                                            "Do you want to delete the Story")
                                        .tr(),
                                    content: Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                              controller.play();
                                            },
                                            child:
                                                const Text(MessageConstants.No)
                                                    .tr(),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              await storiesController
                                                  .deleteStory(storiesController
                                                      .viewSingleStory[
                                                          storiesController
                                                              .storyIndex]
                                                      .id
                                                      .toString())
                                                  .then((value) {
                                                controller.next();
                                                Get.back();
                                                debugPrint('get back now');
                                              });
                                            },
                                            child:
                                                const Text(MessageConstants.YES)
                                                    .tr(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                  radius: 10.sp,
                                  backgroundColor: Colors.white,
                                  child: const Icon(Icons.delete)),
                            ),
                            GetBuilder<StoriesController>(
                                builder: (storiesController) {
                              debugPrint(
                                  'count is ${storiesController.storyIndex}');
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10.sp),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4.w, vertical: 5),
                                child: Text(
                                  "View ${storiesController.viewSingleStory[storiesController.storyIndex].storyViewCount}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
