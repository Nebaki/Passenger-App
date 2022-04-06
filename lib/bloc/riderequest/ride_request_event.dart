import 'package:equatable/equatable.dart';
import 'package:passengerapp/models/models.dart';

class RideRequestEvent extends Equatable {
  const RideRequestEvent();
  @override
  List<Object?> get props => [];
}

class RideRequestCreate extends RideRequestEvent {
  final RideRequest rideRequest;

  const RideRequestCreate(this.rideRequest);
  @override
  List<Object> get props => [rideRequest];

  @override
  String toString() => 'Request Created {user: $rideRequest}';
}

class RideRequestChangeStatus extends RideRequestEvent {
  final String id;
  final bool sendRequest;
  final String status;

  const RideRequestChangeStatus(this.id, this.status, this.sendRequest);

  @override
  List<Object> get props => [id, status, sendRequest];
}

class RideRequestLoad extends RideRequestEvent {
  @override
  List<Object?> get props => [];
}

class RideRequestCheckStartedTrip extends RideRequestEvent {
  @override
  List<Object?> get props => [];
}
