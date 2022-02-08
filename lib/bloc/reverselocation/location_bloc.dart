import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/reverselocation/bloc.dart';
import 'package:passengerapp/repository/repositories.dart';

class LocationBloc extends Bloc<ReverseLocationEvent, ReverseLocationState> {
  final ReverseLocationRepository reverseLocationRepository;
  LocationBloc({required this.reverseLocationRepository})
      : super(ReverseLocationLoading());

  @override
  Stream<ReverseLocationState> mapEventToState(
      ReverseLocationEvent event) async* {
    if (event is ReverseLocationLoad) {
      yield ReverseLocationLoading();

      try {
        final location = await reverseLocationRepository.getLocationByLatlng();
        yield ReverseLocationLoadSuccess(location: location);
      } catch (_) {
        yield ReverseLocationOperationFailure();
      }
    }
  }
}
