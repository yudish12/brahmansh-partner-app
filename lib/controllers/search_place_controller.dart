import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'dart:convert';
import 'package:http/http.dart' as http;

class AutocompletePrediction {
  final String? description;
  final String? placeId;
  final String? primaryText;

  AutocompletePrediction({this.description, this.placeId, this.primaryText});

  factory AutocompletePrediction.fromJson(Map<String, dynamic> json) {
    log('prediction json is->  $json');
    return AutocompletePrediction(
      description: json['description'],
      placeId: json['place_id'],
      primaryText: json['description'],
    );
  }
}

class SearchPlaceController extends GetxController {
  double? latitude;
  double? longitude;
  List<AutocompletePrediction>? predictions = [];
  final searchController = TextEditingController();

  Future<void> autoCompleteSearch(String? value) async {
    if (value != null && value.isNotEmpty) {
      try {
        final apiKey =
            global.getSystemFlagValue(global.systemFlagNameList.googlemapKey);
        final url =
            'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$value&key=$apiKey';

        final response = await http.get(Uri.parse(url));
        final data = json.decode(response.body);

        log('API Response: $data');

        if (data['status'] == 'OK') {
          predictions = (data['predictions'] as List)
              .map((item) => AutocompletePrediction.fromJson(item))
              .toList();
        } else {
          predictions = [];
          log('Places API error: ${data['status']}');
        }

        update();
      } catch (e) {
        debugPrint('Error fetching places: $e');
        predictions = [];
        update();
      }
    } else {
      predictions = [];
      update();
    }
  }
}
