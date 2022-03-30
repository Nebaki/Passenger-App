import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';

class RideRequestRepository {
  final RideRequestDataProvider dataProvider;

  RideRequestRepository({required this.dataProvider});

  Future<RideRequest> createRequest(RideRequest request) async {
    return await dataProvider.createRequest(request);
  }

  Future changeRequestStatus(String id, bool sendRequest) async {
    return await dataProvider.changeRequestStatus(id, sendRequest);
  }
}
