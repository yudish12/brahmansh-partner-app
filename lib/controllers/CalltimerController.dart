import 'dart:developer';
import 'dart:math' hide log;

import 'package:get/get.dart';

class CalltimerController extends GetxController {
  bool isTimerStarted = false;
  int startTime = 0;
  int callendTime = 1;
  int remainingTime = 0;
  bool newIsStartTimer = false;
  int? currentTime;
  int totalDuration = 0; // Add this to track total duration
  void restartTimer(int durationInSeconds) {
    int now = DateTime.now().millisecondsSinceEpoch;
    int newDurationMs = durationInSeconds * 1000;

    // This is a RESTART, not an extension → reset timer!
    startTime = now;
    totalDuration = newDurationMs;
    callendTime = now + newDurationMs;
    isTimerStarted = true;

    log('Timer restarted with duration: $durationInSeconds s');
    log('Timer callendTime: $callendTime');

    update();
  }

  void extendTimer(int extraSeconds) {
    int now = DateTime.now().millisecondsSinceEpoch;
    int elapsed = now - startTime;
    int remaining = max(0, totalDuration - elapsed);

    totalDuration = remaining + (extraSeconds * 1000);
    startTime = now;
    callendTime = startTime + totalDuration;

    log('Timer extended - Remaining: ${totalDuration ~/ 1000}s');
    log('Timer extended - callendTime: $callendTime');
    update();
  }



  void resetTimer() {
     isTimerStarted = false;
    startTime = 0;
    callendTime = 0;
    remainingTime = 0;
    totalDuration = 0;
    log('Timer reset');
    update();
  }
}
