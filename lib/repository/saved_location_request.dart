import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/dataprovider/saved_location.dart';
import 'package:passengerapp/models/models.dart';

class SavedLocationRepository {
  final SavedLocationDataProvider dataProvider;

  SavedLocationRepository({required this.dataProvider});

  Future<List<Trip>> loadLocations(RideRequest request) async {
    return await dataProvider.loadLocations();
  }

  Future deleteRequest(String id) async {
    return await dataProvider.deleteSavedLocation(id);
  }
}
