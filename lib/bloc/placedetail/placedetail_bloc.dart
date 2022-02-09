import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/placedetail/bloc.dart';
import 'package:passengerapp/repository/repositories.dart';

class PlaceDetailBloc extends Bloc<PlaceDetailEvent, PlaceDetailState> {
  final PlaceDetailRepository placeDetailRepository;
  PlaceDetailBloc({required this.placeDetailRepository})
      : super(PlaceDetailLoading());

  @override
  Stream<PlaceDetailState> mapEventToState(PlaceDetailEvent event) async* {
    if (event is PlaceDetailLoad) {
      yield PlaceDetailLoading();

      try {
        final placeDetail =
            await placeDetailRepository.getPlaceAddressDetails(event.placeId);
        print("Yeah Here");

        yield PlaceDetailLoadSuccess(placeDetail: placeDetail);
      } catch (_) {
        yield PlaceDetailOperationFailure();
      }
    }
  }
}
