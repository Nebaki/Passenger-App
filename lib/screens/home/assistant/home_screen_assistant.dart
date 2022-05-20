// void checkDriver(message) {}
import 'dart:collection';

import 'package:geolocator/geolocator.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/models/nearby_driver.dart';
import 'package:passengerapp/repository/repositories.dart';

NearbyDriverRepository repo = NearbyDriverRepository();

late Function requestAccepted;
late int costPerKilloMeterAssistant;
late int costPerMinuteAssistant;
late int initialFareAssistant;
enum SelectedCar { taxi, truck, none }
late SelectedCar selectedCar = SelectedCar.none;
bool whereToClicked = false;
List newDriversList = [];
List? searchNearbyDriversList(String category) {
  if (repo.getNearbyDrivers().isEmpty) {
    return null;
  }

  List a = repo
      .getNearbyDrivers()
      .where((element) => element.id.contains(category))
      .toList();
  Map<String, double> distanceList = {};
  for (NearbyDriver driver in a) {
    double distance = Geolocator.distanceBetween(pickupLatLng.latitude,
        pickupLatLng.longitude, driver.latitude, driver.longitude);
    distanceList[driver.id.split(',')[0]] = distance;
  }

  return SplayTreeMap.from(distanceList,
          (key1, key2) => distanceList[key1]!.compareTo(distanceList[key2]!))
      .keys
      .toList();
}

String? searchNearbyDriver(String category) {
  if (repo.getNearbyDrivers().isEmpty) {
    return null;
  }

  List a = repo
      .getNearbyDrivers()
      .where((element) => element.id.contains(category))
      .toList();
  var nearest;
  var nearestDriver;

  Map<String, double> distanceList = {};
  for (NearbyDriver driver in a) {
    print("drivers ::");
    print(driver.id.split(',')[0]);
    double distance = Geolocator.distanceBetween(pickupLatLng.latitude,
        pickupLatLng.longitude, driver.latitude, driver.longitude);

    nearest ??= distance;
    distanceList[driver.id] = distance;

    print(distance);

    if (distance <= nearest) {
      nearest = distance;
      nearestDriver = driver;
    }
  }

  return nearestDriver != null ? nearestDriver.id.split(',')[0] : null;
}

//// new updates
bool showCarIcons = true;
