import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';

class DataBaseHelperRepository {
  final DatabaseHelper dataProvider;

  DataBaseHelperRepository({required this.dataProvider});

  Future<int> inserToDatabase(LocationPrediction request) async {
    return await dataProvider.insert(request);
  }

  Future<List<LocationPrediction>> getData() async {
    return await dataProvider.queryLocation();
  }
}
