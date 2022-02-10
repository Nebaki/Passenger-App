import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';

class ReverseLocationRepository {
  final ReverseGocoding dataProvider;

  ReverseLocationRepository({required this.dataProvider});

  Future<ReverseLocation> getLocationByLatlng() async {
    return await dataProvider.getLocationByLtlng();
  }
}
