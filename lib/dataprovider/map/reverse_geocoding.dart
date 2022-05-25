import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/user/user.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/models/models.dart';

String geolocator =
    "https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=AIzaSyB8z8UeyROt2-ay24jiHrrcMXaEAlPUvdQ";

String reverseGeocoding =
    "https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=AIzaSyB8z8UeyROt2-ay24jiHrrcMXaEAlPUvdQ";

class ReverseGocoding {
  UserDataProvider udp = UserDataProvider(httpClient: http.Client());
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error("NoLocation Enabled");
      }

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        SystemNavigator.pop();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  final http.Client httpClient;

  ReverseGocoding({required this.httpClient});

  Future<ReverseLocation> getLocationByLtlng() async {
    Position p = await _determinePosition();
    pickupLatLng = LatLng(p.latitude, p.longitude);

    final _baseUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${p.latitude},${p.longitude}&key=AIzaSyB8z8UeyROt2-ay24jiHrrcMXaEAlPUvdQ";

    final response = await httpClient.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final location = jsonDecode(response.body);
      udp.setPassengerAvailablity([p.latitude, p.longitude]);
      return ReverseLocation.fromJson(location);
    } else {
      throw Exception('Failed to load loaction');
    }
  }
}
