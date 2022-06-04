import 'package:equatable/equatable.dart';
import 'package:passengerapp/models/models.dart';

class FavoriteLocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoriteLocationLoading extends FavoriteLocationState {}

class FavoriteLocationLoadSuccess extends FavoriteLocationState {
  final List<SavedLocation?> savedLocation;
  FavoriteLocationLoadSuccess({required this.savedLocation});
  @override
  List<Object?> get props => savedLocation;
}

class FavoriteLocationOperationFailure extends FavoriteLocationState {}

class FavoriteLocationOperationSuccess extends FavoriteLocationState {}
