import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';

class SavedLocationRepository {
  final SavedLocationDataProvider savedLocationDataProvider;

  SavedLocationRepository({required this.savedLocationDataProvider});

  Future<List<SavedLocation>> getSavedLocations() async {
    return await savedLocationDataProvider.getSavedLocations();
  }

  Future<SavedLocation> createSavedLocation(SavedLocation savedLocation) async {
    return await savedLocationDataProvider.createSavedLocation(savedLocation);
  }

  Future cleateSavedLocations() async {
    await savedLocationDataProvider.clearSavedLocations();
  }

  Future<SavedLocation> updateSavedLocation(SavedLocation savedLocation) async {
    return await savedLocationDataProvider.updateSavedLocation(savedLocation);
  }

  Future deleteSavedLocationById(String id) async {
    await savedLocationDataProvider.deleteSavedLocationById(id);
  }
}
