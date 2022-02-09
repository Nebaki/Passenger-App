import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';

class PlaceDetailRepository {
  final PlaceDetailDataProvider dataProvider;

  PlaceDetailRepository({required this.dataProvider});

  Future<PlaceDetail> getPlaceAddressDetails(String placeId) async {
    return await dataProvider.getPlaceAddressDetails(placeId);
  }
}
