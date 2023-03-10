import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/repository/repositories.dart';

class RideRequestBloc extends Bloc<RideRequestEvent, RideRequestState> {
  final RideRequestRepository rideRequestRepository;

  RideRequestBloc({required this.rideRequestRepository}) : super(InitState());

  @override
  Stream<RideRequestState> mapEventToState(RideRequestEvent event) async* {
    if (event is RideRequestCreate) {
      yield RideRequestLoading();
      try {
        await rideRequestRepository.createRequest(event.rideRequest);
        yield RideRequestSuccess();
      } catch (e) {
        if (e.toString().split(" ")[1] == "401") {
          yield RideRequestTokentExpired();
        } else {
          yield (RideRequestOperationFailur());
        }
      }
    }

    if (event is RideRequestOrderForOther) {
      yield RideRequestLoading();
      try {
        await rideRequestRepository.orderForOther(event.request);
        yield RideRequestSuccess();
      } catch (e) {
        if (e.toString().split(" ")[1] == "401") {
          yield RideRequestTokentExpired();
        } else {
          yield (RideRequestOperationFailur());
        }
      }
    }

    if (event is RideRequestChangeStatus) {
      yield RideRequestLoading();

      try {
        await rideRequestRepository.changeRequestStatus(
            event.id, event.status, event.sendRequest);
        yield RideRequestStatusChangedSuccess();
      } catch (e) {
        if (e.toString().split(" ")[1] == "401") {
          yield RideRequestTokentExpired();
        } else {
          yield (RideRequestOperationFailur());
        }
      }
    }

    // if (event is RideRequestLoad) {
    //   yield RideRequestLoading();

    //   try {
    //     final rideRequests = await rideRequestRepository.getRideRequests();
    //     yield RideRequestLoadSuccess(rideRequests);
    //   } catch (_) {
    //     RideRequestOperationFailur();
    //   }
    // }

    if (event is RideRequestCheckStartedTrip) {
      yield RideRequestLoading();

      try {
        final rideRequest = await rideRequestRepository.checkStartedTrip();
        yield RideRequestStartedTripChecked(rideRequest);
      } catch (_) {
        if (_.toString().split(" ")[1] == "401") {
          yield RideRequestTokentExpired();
        } else {
          yield RideRequestOperationFailur();
        }
      }
    }

    // if (event is RideRequestSendNotification) {
    //   yield RideRequestLoading();

    //   try {
    //     await rideRequestRepository.sendNotification(event.request, event.id);
    //     yield RideRequestNotificationSent();
    //   } catch (e) {
    //     if (e.toString().split(" ")[1] == "401") {
    //       yield RideRequestTokentExpired();
    //     } else {
    //       yield (RideRequestOperationFailur());
    //     }
    //   }
    // }
    if (event is RideRequestCancell) {
      yield RideRequestLoading();
      try {
        await rideRequestRepository.cancelRideRequest(event.id,
            event.cancelReason, event.passengerFcm, event.sendRequest);
        yield RideRequestCancelled();
      } catch (e) {
        if (e.toString().split(" ")[1] == "401") {
          yield RideRequestTokentExpired();
        } else {
          yield (RideRequestOperationFailur());
        }
      }
    }
  }
}
