import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';

class DriverRepository {
  final DriverDataProvider dataProvider;

  DriverRepository({required this.dataProvider});

  Future<DriverModel> getDriverById(String id) async {
    return await dataProvider.getDriverById(id);
  }
}
