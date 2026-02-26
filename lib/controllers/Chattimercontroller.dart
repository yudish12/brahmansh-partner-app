// ignore_for_file: avoid_print

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChattimerController extends GetxController {
  bool isTimerStarted = false;
  int startTime = 0;
  int endTime = 0;
  int remainingTime = 0;
  bool newIsStartTimer = false;
  int? currentTime;
  int totalDuration = 0;
  void restartTimer(int newDuration) {
    log('Received duration: $newDuration seconds');
    newDuration = newDuration * 1000;
    debugPrint("newDuration:- $newDuration");
    debugPrint("isTimerStarted:- ${!isTimerStarted}");
    if (!isTimerStarted) {
      currentTime = DateTime.now().millisecondsSinceEpoch;
      log('Inside isTimerStarted $isTimerStarted');
      startTime = currentTime!;
      totalDuration = newDuration;
      endTime = startTime + newDuration;
      isTimerStarted = true;
      log('Timer started: StartTime = ${(startTime)}, EndTime = ${(endTime)}');
    } else {
      remainingTime = startTime - (DateTime.now().millisecondsSinceEpoch);
      //new duration - remaining time jabse start hua tabse ab tak ka time gap
      log('Time gap since start: $remainingTime seconds');
      if (remainingTime > 0) {
        endTime = newDuration - remainingTime;
        totalDuration = endTime;
        log('Time extended: New EndTime = ${(endTime ~/ 1000)} seconds');
        update();
      } else {
        endTime = currentTime! + newDuration;
        log('Timer reset: New EndTime = ${(endTime ~/ 1000)} seconds');
        update();
      }
    }

    update();
  }

  void extendTimer(int newDurationSeconds) {
    log('Received duration: $newDurationSeconds seconds');
    final now = DateTime.now().millisecondsSinceEpoch;
    startTime = now;
    totalDuration = newDurationSeconds * 1000;
    endTime = now + totalDuration;
    isTimerStarted = true;
    log('Timer started: StartTime = ${(startTime ~/ 1000)}, EndTime = ${(endTime ~/ 1000)}, totalDuration = ${totalDuration ~/ 1000}s');
    update();
  }

  void resetTimer() {
    isTimerStarted = false;
    startTime = 0;
    endTime = 0;
    remainingTime = 0;
    log('Timer has been reset');
    update();
  }
}