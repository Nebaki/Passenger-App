import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/repository/repositories.dart';

class LocationHistoryBloc
    extends Bloc<LocationHistoryEvent, LocationHistoryState> {
  final DataBaseHelperRepository dataBaseHelperRepository;
  LocationHistoryBloc({required this.dataBaseHelperRepository})
      : super(LocationHistoryLoading());

  @override
  Stream<LocationHistoryState> mapEventToState(
      LocationHistoryEvent event) async* {
    if (event is LocationHistoryLoad) {
      print("yow yow yow");
      yield LocationHistoryLoading();

      try {
        final data = await dataBaseHelperRepository.getData();
        yield LocationHistoryLoadSuccess(data);
      } catch (_) {
        yield LocationHistoryLoadFailure();
      }
    }

    if (event is LocationHistoryAdd) {
      yield LocationHistoryLoading();
      try {
        final data =
            await dataBaseHelperRepository.inserToDatabase(event.location);
        yield LocationHistoryLoadSuccess(data);
      } catch (_) {
        yield LocationHistoryLoadFailure();
      }
    }

    if (event is LocationHistoryClear) {
      try {
        final data = await dataBaseHelperRepository.clearHistory();
      } catch (_) {}
    }
  }
}

abstract class LocationHistoryEvent extends Equatable {
  const LocationHistoryEvent();
}

class LocationHistoryLoad extends LocationHistoryEvent {
  @override
  List<Object?> get props => [];
}

class LocationHistoryAdd extends LocationHistoryEvent {
  final LocationPrediction location;
  const LocationHistoryAdd({required this.location});
  @override
  List<Object?> get props => [location];
}

class LocationHistoryClear extends LocationHistoryEvent {
  @override
  List<Object?> get props => [];
}

class LocationHistoryState extends Equatable {
  const LocationHistoryState();

  @override
  List<Object?> get props => [];
}

class LocationHistoryLoading extends LocationHistoryState {}

class LocationHistoryLoadSuccess extends LocationHistoryState {
  final List<LocationPrediction> locationHistory;

  const LocationHistoryLoadSuccess(this.locationHistory);
  @override
  List<Object?> get props => [locationHistory];
}

class LocationHistoryLoadFailure extends LocationHistoryState {}

class LocationHistoryAdded extends LocationHistoryState {}
