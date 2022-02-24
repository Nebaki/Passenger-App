import 'package:passengerapp/models/nearby_driver.dart';

class NearbyDriversData {
  static List<NearbyDriver> nearbyDrivers = [];

  static void addDriver(NearbyDriver driver) {
    nearbyDrivers.add(driver);
  }

  static void removeDriver(String id) {
    int index = nearbyDrivers.indexWhere((element) => element.id == id);
    nearbyDrivers.removeAt(index);
  }

  static void updateDriver(NearbyDriver driver) {
    int index = nearbyDrivers.indexWhere((element) => element.id == driver.id);
    nearbyDrivers.removeAt(index);
    addDriver(driver);
    // nearbyDrivers[index].latitude = driver.latitude;
    // nearbyDrivers[index].longitude = driver.longitude;

    // print(driver.longitude);
    // print("We are Hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeesss");
  }

  static void resetList() {
    nearbyDrivers.clear();
  }

  static List getList() {
    return nearbyDrivers;
  }
}
