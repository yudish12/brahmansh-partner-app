import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OtpService {
  static final OtpService _instance = OtpService._internal();
  late String apiKey;
  late String senderId;
  late String templateId;
  late String countryCode;

  // Private constructor for singleton
  OtpService._internal();

  factory OtpService({
    required String apiKey,
    required String senderId,
    required String templateId,
    String countryCode = '91',
  }) {
    _instance.apiKey = apiKey;
    _instance.senderId = senderId;
    _instance.templateId = templateId;
    _instance.countryCode = countryCode;
    return _instance;
  }

  // Function to send OTP
  Future<bool> sendOtp(String phoneNumber, String otp,
      {int otpExpiry = 1}) async {
    final Uri url = Uri.parse("https://api.msg91.com/api/v5/otp");

    var headers = {
      'Content-Type': 'application/json',
      'authkey': apiKey,
    };

    var body = jsonEncode({
      'template_id': templateId,
      'mobile': '$countryCode$phoneNumber',
      'otp': otp,
      'sender': senderId,
      'otp_expiry': otpExpiry.toString(),
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint("Failed to send OTP: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Error: $e");
      return false;
    }
  }

  // Function to verify OTP
  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    final Uri url = Uri.parse(
        "https://api.msg91.com/api/v5/otp/verify?mobile=$countryCode$phoneNumber&otp=$otp");

    var headers = {
      'Content-Type': 'application/json',
      'authkey': apiKey,
    };

    try {
      final response = await http.post(url, headers: headers);
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint("Failed to verify OTP: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Error: $e");
      return false;
    }
  }
}
