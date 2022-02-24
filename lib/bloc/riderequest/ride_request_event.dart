import 'package:equatable/equatable.dart';
import 'package:passengerapp/models/models.dart';

class RideRequestEvent extends Equatable {
  const RideRequestEvent();
  @override
  List<Object?> get props => throw UnimplementedError();
}

class RideRequestCreate extends RideRequestEvent {
  final RideRequest rideRequest;

  const RideRequestCreate(this.rideRequest);
  @override
  List<Object> get props => [rideRequest];

  @override
  String toString() => 'Request Created {user: $rideRequest}';
}

class RideRequestDelete extends RideRequestEvent {
  final String id;

  const RideRequestDelete(this.id);

  @override
  List<Object> get props => [id];
}
