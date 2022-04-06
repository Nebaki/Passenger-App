import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/repository/repositories.dart';

class RideRequestBloc extends Bloc<RideRequestEvent, RideRequestState> {
  final RideRequestRepository rideRequestRepository;

  RideRequestBloc({required this.rideRequestRepository})
      : super(RideRequestLoading());

  @override
  Stream<RideRequestState> mapEventToState(RideRequestEvent event) async* {
    if (event is RideRequestCreate) {
      print("i'm arround here");
      yield RideRequestLoading();
      try {
        final request =
            await rideRequestRepository.createRequest(event.rideRequest);
        yield RideRequestSuccess(request);
      } catch (_) {
        print("i'm'nt arround here");

        yield RideRequestOperationFailur();
      }
    }

    if (event is RideRequestChangeStatus) {
      yield RideRequestLoading();

      try {
        await rideRequestRepository.changeRequestStatus(
            event.id, event.status, event.sendRequest);
        yield RideRequestStatusChangedSuccess();
      } catch (_) {
        yield RideRequestOperationFailur();
      }
    }

    if (event is RideRequestLoad) {
      yield RideRequestLoading();

      try {
        final rideRequests = await rideRequestRepository.getRideRequests();
        yield RideRequestLoadSuccess(rideRequests);
      } catch (_) {
        RideRequestOperationFailur();
      }
    }

    if (event is RideRequestCheckStartedTrip) {
      yield RideRequestLoading();

      try {
        final rideRequest = await rideRequestRepository.checkStartedTrip();
        yield RideRequestStartedTripChecked(rideRequest);
      } catch (_) {
        RideRequestOperationFailur();
      }
    }
  }
}
