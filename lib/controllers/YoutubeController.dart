import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeController extends GetxController {
  final List<YoutubePlayerController> controllers = [];

  @override
  void onInit() async {
    initControllers(['Gg-eDsqk6wA', 'lBvbNxiVmZA', 'KUpwupYj_tY']);
    super.onInit();
  }

  void initControllers(List<String> videoIds) {
    controllers.addAll(videoIds.map((id) => YoutubePlayerController(
          initialVideoId: id,
          flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
        )));
  }

  Future<void> launchYouTubeVideo(String videoId) async {
    final url = 'https://www.youtube.com/watch?v=$videoId';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Error $url';
    }
  }

  @override
  void onClose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
