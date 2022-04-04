import 'package:equatable/equatable.dart';
import 'package:passengerapp/models/models.dart';

class RideRequestState extends Equatable {
  const RideRequestState();
  @override
  List<Object?> get props => [];
}

class RideRequestLoading extends RideRequestState {}

class RideRequestSuccess extends RideRequestState {
  final RideRequest request;

  const RideRequestSuccess(this.request);

  @override
  List<Object> get props => [request];
}

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
