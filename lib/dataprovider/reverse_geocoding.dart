import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:passengerapp/models/models.dart';

String geolocator =
    "https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=AIzaSyB8z8UeyROt2-ay24jiHrrcMXaEAlPUvdQ";

String reverseGeocoding =
    "https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=AIzaSyB8z8UeyROt2-ay24jiHrrcMXaEAlPUvdQ";

class ReverseGocoding {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  final http.Client httpClient;

  ReverseGocoding({required this.httpClient});

  Future<ReverseLocation> getLocationByLtlng() async {
    print(
        "Loadinggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg");
    Position p = await _determinePosition();
    final _baseUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${p.latitude},${p.longitude}&key=AIzaSyB8z8UeyROt2-ay24jiHrrcMXaEAlPUvdQ";

    final response = await httpClient.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      print(
          "Loadingggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggs");
      final location = jsonDecode(response.body);

      print(location);
      return ReverseLocation.fromJson(location);
    } else {
      throw Exception('Failed to load loaction');
    }
  }
}
