import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:passengerapp/repository/repositories.dart';

class SavedLocationBloc extends Bloc<SavedLocationEvent, SavedLocationState> {
  SavedLocationRepository savedLocationRepository;
  SavedLocationBloc({required this.savedLocationRepository})
      : super(SavedLocationsLoading());

  @override
  Stream<SavedLocationState> mapEventToState(SavedLocationEvent event) async* {
    if (event is SavedLocationsLoad) {
      yield SavedLocationsLoading();
      try {
        final savedLocations =
            await savedLocationRepository.getSavedLocations();
        yield SavedLocationsLoadSuccess(savedLocations);
      } catch (_) {
        yield SavedLocationOperationFailure(404);
      }
    }
    if (event is SavedLocationCreate) {
      yield SavedLocationsLoading();
      try {
        final savedLocation = await savedLocationRepository
            .createSavedLocation(event.savedLocation);
        yield SavedLocationsSuccess(savedLocation);
      } catch (_) {
        print('Heyyyyy ${_.toString()}');
        yield SavedLocationOperationFailure(
            int.parse(_.toString().split(" ")[1]));
      }
    }

    if (event is SavedLocationDelete) {
      yield SavedLocationsLoading();
      try {
        await savedLocationRepository.deleteSavedLocationById(event.id);
      } catch (_) {
        yield SavedLocationOperationFailure(404);
      }
    }
    if (event is SavedLocationUpdate) {
      yield SavedLocationsLoading();
      try {
        final savedLocation = await savedLocationRepository
            .updateSavedLocation(event.savedLocation);
        yield SavedLocationsSuccess(savedLocation);
      } catch (_) {
        yield SavedLocationOperationFailure(404);
      }
    }

    if (event is SavedLocationClearAll) {
      yield SavedLocationsLoading();
      try {
        await savedLocationRepository.cleateSavedLocations();
        yield SavedLocationOperationsuccess();
      } catch (_) {
        yield SavedLocationOperationFailure(404);
      }
    }
  }
}

abstract class SavedLocationEvent extends Equatable {
  const SavedLocationEvent();
}

class SavedLocationsLoad extends SavedLocationEvent {
  @override
  List<Object?> get props => [];
}

class SavedLocationCreate extends SavedLocationEvent {
  final SavedLocation savedLocation;

  const SavedLocationCreate(this.savedLocation);
  @override
  List<Object?> get props => [savedLocation];
  @override
  String toString() => 'SavedLocation Created {user: $savedLocation}';
}

class SavedLocationDelete extends SavedLocationEvent {
  final String id;
  const SavedLocationDelete(this.id);
  @override
  List<Object?> get props => [id];
  @override
  String toString() => 'SavedLocation Deleted {user: $id}';
}

class SavedLocationClearAll extends SavedLocationEvent {
  @override
  List<Object?> get props => [];
}

class SavedLocationUpdate extends SavedLocationEvent {
  final SavedLocation savedLocation;

  const SavedLocationUpdate(this.savedLocation);
  @override
  List<Object?> get props => [savedLocation];
  @override
  String toString() => 'SavedLocation Updated {user: $savedLocation}';
}

class SavedLocationState extends Equatable {
  const SavedLocationState();
  @override
  List<Object?> get props => [];
}

class SavedLocationsLoading extends SavedLocationState {}

class SavedLocationsLoadSuccess extends SavedLocationState {
  final List<SavedLocation> savedLocation;

  const SavedLocationsLoadSuccess(this.savedLocation);
  @override
  List<Object?> get props => [savedLocation];
}

class SavedLocationsSuccess extends SavedLocationState {
  final SavedLocation savedLocation;

  const SavedLocationsSuccess(this.savedLocation);
  @override
  List<Object?> get props => [savedLocation];
}

class SavedLocationOperationFailure extends SavedLocationState {
  final int statusCode;
  const SavedLocationOperationFailure(this.statusCode);
  @override
  List<Object?> get props => [statusCode];
}

class SavedLocationOperationsuccess extends SavedLocationState {}
