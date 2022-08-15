import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';

class LocationPredictionRepository {
  final LocationPredictionDataProvider dataProvider;

  LocationPredictionRepository({required this.dataProvider});

  Future<List<LocationPrediction>> getPrediction(String placeName) async {
    return await dataProvider.predictLocation(placeName);
  }
}
