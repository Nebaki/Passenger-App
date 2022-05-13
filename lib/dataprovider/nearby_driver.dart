import 'package:passengerapp/models/nearby_driver.dart';

class NearbyDriversData {
  static List<NearbyDriver> nearbyDrivers = [];
  static List ids = [];

  static void addDriver(NearbyDriver driver) {
    if (!ids.contains(driver.id.split(',')[0])) {
      ids.add(driver.id.split(',')[0]);

      nearbyDrivers.add(driver);
    }
  }

  static List getlistId() {
    return ids;
  }

  static void removeDriver(String id) {
    if (ids.contains(id.split(',')[0])) {
      int ind = ids.indexWhere((element) => element == id.split(',')[0]);
      ids.removeAt(ind);

      int index = nearbyDrivers.indexWhere((element) => element.id == id);
      nearbyDrivers.removeAt(index);
    }
  }

  static void updateDriver(NearbyDriver driver) {
    if (ids.contains(driver.id)) {
      int ind = ids.indexWhere((element) => element == driver.id);
      ids.removeAt(ind);
      int index =
          nearbyDrivers.indexWhere((element) => element.id == driver.id);
      nearbyDrivers.removeAt(index);
      addDriver(driver);
    }

    // nearbyDrivers[index].latitude = driver.latitude;
    // nearbyDrivers[index].longitude = driver.longitude;

    // print(driver.longitude);
    // print("We are Hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeesss");
  }

  static void resetList() {
    ids.clear();
    nearbyDrivers.clear();
  }

  static List getList() {
    return nearbyDrivers;
  }
}

class NerbyTrucksData {
  static List<NearbyDriver> nearbyTrucks = [];
  static List ids = [];

  static void addDriver(NearbyDriver driver) {
    if (!ids.contains(driver.id)) {
      ids.add(driver.id);

      nearbyTrucks.add(driver);
    }
  }

  static List getlistId() {
    return ids;
  }

  static void removeDriver(String id) {
    if (ids.contains(id)) {
      int ind = ids.indexWhere((element) => element == id);
      ids.removeAt(ind);

      int index = nearbyTrucks.indexWhere((element) => element.id == id);
      nearbyTrucks.removeAt(index);
    }
  }

  static void updateDriver(NearbyDriver driver) {
    if (ids.contains(driver.id)) {
      int ind = ids.indexWhere((element) => element == driver.id);
      ids.removeAt(ind);
      int index = nearbyTrucks.indexWhere((element) => element.id == driver.id);
      nearbyTrucks.removeAt(index);
      addDriver(driver);
    }
  }

  static void resetList() {
    ids.clear();
    nearbyTrucks.clear();
  }

  static List getList() {
    return nearbyTrucks;
  }
}
