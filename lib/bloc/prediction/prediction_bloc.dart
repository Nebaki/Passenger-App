import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/prediction/bloc.dart';
import 'package:passengerapp/bloc/reverselocation/bloc.dart';
import 'package:passengerapp/repository/repositories.dart';

class LocationPredictionBloc
    extends Bloc<LocationPredictionEvent, LocationPredictionState> {
  final LocationPredictionRepository locationPredictionRepository;
  LocationPredictionBloc({required this.locationPredictionRepository})
      : super(LocationPredictionLoading());

  @override
  Stream<LocationPredictionState> mapEventToState(
      LocationPredictionEvent event) async* {
    if (event is LocationPredictionLoad) {
      yield LocationPredictionLoading();

      try {
        final placeList =
            await locationPredictionRepository.getPrediction(event.placeName);
        yield LocationPredictionLoadSuccess(placeList: placeList);
      } catch (_) {
        yield LocationPredictionOperationFailure();
      }
    }
  }
}
