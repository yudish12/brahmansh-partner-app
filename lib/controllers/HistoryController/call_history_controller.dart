import 'package:brahmanshtalk/controllers/HomeController/home_controller.dart';
import 'package:get/get.dart';

import '../../models/History/call_history_model.dart';
import '../../services/apiHelper.dart';
import '../Authentication/signup_controller.dart';

class CallHistoryController extends GetxController {
  String screen = 'call_history_controller.dart';
  APIHelper apiHelper = APIHelper();
  List<CallHistoryModel> callHistoryList = [];
  SignupController signupController = Get.find<SignupController>();
  HomeController homeController = Get.find<HomeController>();

  @override
  void onInit() async {
    _init();
    super.onInit();
  }

  _init() async {
    signupController.astrologerProfileById(false);
  }
}
