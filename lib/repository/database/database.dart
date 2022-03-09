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

  Future<int> insertToSaveLocation(Trip request) async {
    return await dataProvider.insertLocation(request);
  }

  Future<List<Trip>> loadSavedLocations() async {
    return await dataProvider.loadSavedLocations();
  }

}
