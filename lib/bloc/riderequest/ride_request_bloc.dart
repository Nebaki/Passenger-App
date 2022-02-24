import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/repository/repositories.dart';

class RideRequestBloc extends Bloc<RideRequestEvent, RideRequestState> {
  final RideRequestRepository rideRequestRepository;

  RideRequestBloc({required this.rideRequestRepository})
      : super(RideRequestLoading());

  @override
  Stream<RideRequestState> mapEventToState(RideRequestEvent event) async* {
    if (event is RideRequestCreate) {
      yield RideRequestLoading();
      try {
        final request =
            await rideRequestRepository.createRequest(event.rideRequest);
        yield RideRequestSuccess(request);
      } catch (_) {
        yield RideRequestOperationFailur();
      }
    }

    if (event is RideRequestDelete) {
      yield RideRequestLoading();

      try {
        await rideRequestRepository.deleteRequest(event.id);
        yield RideRequestDeleteSuccess();
      } catch (_) {
        yield RideRequestOperationFailur();
      }
    }
  }
}
