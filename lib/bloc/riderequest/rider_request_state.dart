import 'package:equatable/equatable.dart';
import 'package:passengerapp/models/models.dart';

class RideRequestState extends Equatable {
  const RideRequestState();
  @override
  List<Object?> get props => [];
}

class InitState extends RideRequestState {}

class RideRequestLoading extends RideRequestState {}

class RideRequestSuccess extends RideRequestState {}

class RideRequestLoadSuccess extends RideRequestState {
  final List<RideRequest> rideRequests;
  const RideRequestLoadSuccess(this.rideRequests);
  @override
  List<Object> get props => [rideRequests];
}

class RideRequestOperationFailur extends RideRequestState {}

class RideRequestStatusChangedSuccess extends RideRequestState {}

class RideRequestStartedTripChecked extends RideRequestState {
  final RideRequest rideRequest;
  const RideRequestStartedTripChecked(this.rideRequest);
  @override
  List<Object> get props => [rideRequest];
}

class RideRequestNotificationSent extends RideRequestState {}

class RideRequestCancelled extends RideRequestState {}

class RideRequestTokentExpired extends RideRequestState {}