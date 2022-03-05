import 'package:equatable/equatable.dart';
import 'package:passengerapp/models/models.dart';

class RideRequestState extends Equatable {
  const RideRequestState();
  @override
  List<Object?> get props => throw UnimplementedError();
}

class RideRequestLoading extends RideRequestState {}

class RideRequestSuccess extends RideRequestState {
  final RideRequest request;

  const RideRequestSuccess(this.request);

  @override
  List<Object> get props => [request];
}

class RideRequestOperationFailur extends RideRequestState {}

class RideRequestDeleteSuccess extends RideRequestState {}