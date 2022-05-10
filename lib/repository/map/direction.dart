import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';

class DirectionRepository {
  final DirectionDataProvider dataProvider;

  DirectionRepository({required this.dataProvider});

  Future<Direction> getDirection(LatLng destination) async {
    return await dataProvider.getDirection(destination);
  }

  Future<Direction> getDirectionFromDifferentPickupLocation(
      LatLng pickup, LatLng destination) async {
    return await dataProvider.getDirectionFromDifrentPickupLocation(
        pickup, destination);
  }
}
