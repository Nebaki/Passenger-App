import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/nearby_driver.dart';

class NearbyTrucksRepository {
  List getNearbyDrivers() {
    return NerbyTrucksData.getList();
  }

  List getIdList() {
    return NerbyTrucksData.getlistId();
  }

  void addDriver(NearbyDriver driver) {
    NerbyTrucksData.addDriver(driver);
  }

  void removeDriver(String id) {
    NerbyTrucksData.removeDriver(id);
  }

  void updateDriver(NearbyDriver driver) {
    NerbyTrucksData.updateDriver(driver);
  }

  void resetList() {
    NerbyTrucksData.resetList();
  }
}
