import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:passengerapp/repository/repositories.dart';

const rt = "fdsa";

void res() {}
NearbyDriverRepository repo = NearbyDriverRepository();

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
