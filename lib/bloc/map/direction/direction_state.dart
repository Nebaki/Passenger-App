import 'package:equatable/equatable.dart';
import 'package:passengerapp/models/models.dart';

class DirectionState extends Equatable {
  const DirectionState();

  @override
  List<Object> get props => [];
}

class DirectionInitialState extends DirectionState {
  final bool loadCurrentLocation;
  final bool listenToNearbyDriver;
  const DirectionInitialState(
      {required this.loadCurrentLocation, required this.listenToNearbyDriver});
  @override
  List<Object> get props => [loadCurrentLocation];
}

class DirectionLoading extends DirectionState {}

class DirectionLoadSuccess extends DirectionState {
  final Direction direction;

  const DirectionLoadSuccess({required this.direction});

  @override
  List<Object> get props => [direction];
}

class DirectionOperationFailure extends DirectionState {}
