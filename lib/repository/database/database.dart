import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';

class DataBaseHelperRepository {
  final DatabaseHelper dataProvider;

  DataBaseHelperRepository({required this.dataProvider});

  Future<List<LocationPrediction>> inserToDatabase(
      LocationPrediction request) async {
    return await dataProvider.insert(request);
  }

  Future<List<LocationPrediction>> getData() async {
    return await dataProvider.queryLocation();
  }


  Future clearHistory() async {
    await dataProvider.clearLocations();
  }

  Future<List<SavedLocation?>> inserToFavoriteDatabase(
      SavedLocation request) async {
    return await dataProvider.insertFavoriteLocation(request);
  }

  Future<List<SavedLocation?>> getFavoriteData() async {
    return await dataProvider.queryFavoriteLocation();
  }

  Future clearLocations() async {
    await dataProvider.clearFavoriteLocations();
  }

  Future deleteLocation(int id) async {
    await dataProvider.deleteFavoriteLocation(id);
  }

  Future<List<SavedLocation?>> deleteLocationByPlaceID(String placeID) async {
    return await dataProvider.deleteFavoriteLocationByPLaceId(placeID);
  }

  Future updateLocation(SavedLocation location) async {
    await dataProvider.updateFavoriteLocation(location);
  }
}
