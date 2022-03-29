import 'package:passengerapp/models/nearby_driver.dart';

class NearbyDriversData {
  static List<NearbyDriver> nearbyDrivers = [];
  static List ids = [];

  static void addDriver(NearbyDriver driver) {
    if (!ids.contains(driver.id)) {
      ids.add(driver.id);

      nearbyDrivers.add(driver);
    }
  }

  static List getlistId() {
    return ids;
  }

  static void removeDriver(String id) {
    if (ids.contains(id)) {
      int ind = ids.indexWhere((element) => element == id);
      ids.removeAt(ind);

      int index = nearbyDrivers.indexWhere((element) => element.id == id);
      nearbyDrivers.removeAt(index);
    }
  }

  static void updateDriver(NearbyDriver driver) {
    print(
        "Yow this is the id $ids , ${nearbyDrivers.map((e) => (e.id)).toList()}");

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
