import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';

class RideRequestRepository {
  final RideRequestDataProvider dataProvider;

  RideRequestRepository({required this.dataProvider});

  Future createRequest(RideRequest request) async {
    await dataProvider.createRequest(request);
  }

  Future changeRequestStatus(String id, String status, bool sendRequest) async {
    return await dataProvider.changeRequestStatus(id, status, sendRequest);
  }

  Future<List<RideRequest>> getRideRequests(int skip, int top) async {
    return await dataProvider.getRideRequests(skip, top);
  }

  Future<RideRequest> checkStartedTrip() async {
    return await dataProvider.checkStartedTrip();
  }

  Future<void> sendNotification(RideRequest request, String requestId) async {
    return await dataProvider.sendNotification(request, requestId);
  }

  Future cancelRideRequest(String id, String cancelReason, String? passengerFcm,
      bool sendRequest) async {
    return await dataProvider.cancelRideRequest(
        id, cancelReason, passengerFcm, sendRequest);
  }

  Future orderForOther(RideRequest request) async {
    await dataProvider.orderForOther(request);
  }
}
