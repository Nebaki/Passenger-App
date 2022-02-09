import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/direction/bloc.dart';
import 'package:passengerapp/repository/repositories.dart';

class DirectionBloc extends Bloc<DirectionEvent, DirectionState> {
  final DirectionRepository directionRepository;
  DirectionBloc({required this.directionRepository})
      : super(DirectionLoading());

  @override
  Stream<DirectionState> mapEventToState(DirectionEvent event) async* {
    if (event is DirectionLoad) {
      yield DirectionLoading();

      try {
        final direction =
            await directionRepository.getDirection(event.destination);
        yield DirectionLoadSuccess(direction: direction);
      } catch (_) {
        yield DirectionOperationFailure();
      }
    }
  }
}
