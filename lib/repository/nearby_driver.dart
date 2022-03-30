import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/nearby_driver.dart';

class NearbyDriverRepository {
  List getNearbyDrivers() {
    return NearbyDriversData.getList();
  }

  List getIdList() {
    return NearbyDriversData.getlistId();
  }

  void addDriver(NearbyDriver driver) {
    NearbyDriversData.addDriver(driver);
  }

  void removeDriver(String id) {
    NearbyDriversData.removeDriver(id);
  }

  void updateDriver(NearbyDriver driver) {
    NearbyDriversData.updateDriver(driver);
  }

  void resetList() {
    NearbyDriversData.resetList();
  }
}
