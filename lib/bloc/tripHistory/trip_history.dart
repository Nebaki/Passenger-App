import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/repository/repositories.dart';

class TripHistoryBloc extends Bloc<TripHistoryEvent, TripHistoryState> {
  final RideRequestRepository rideRequestRepository;
  TripHistoryBloc({required this.rideRequestRepository})
      : super(TripHistoriesLoading());

  @override
  Stream<TripHistoryState> mapEventToState(TripHistoryEvent event) async* {
    if (event is TripHistoryLoad) {
      yield TripHistoriesLoading();
      try {
        final requestes =
            await rideRequestRepository.getRideRequests(event.skip, event.top);

        yield TripHstoriesLoadSuccess(requestes);
      } catch (_) {
        yield TripHistoryOperationFailure();
      }
    }
  }
}

abstract class TripHistoryEvent extends Equatable {
  const TripHistoryEvent();
}

class TripHistoryLoad extends TripHistoryEvent {
  final int skip;
  final int top;
  const TripHistoryLoad({required this.skip, required this.top});
  @override
  List<Object?> get props => [skip, top];
}

class TripHistoryState extends Equatable {
  const TripHistoryState();
  @override
  List<Object?> get props => [];
}

class TripHistoriesLoading extends TripHistoryState {}

class TripHstoriesLoadSuccess extends TripHistoryState {
  final List<RideRequest?> requestes;
  const TripHstoriesLoadSuccess(this.requestes);

  @override
  List<Object?> get props => requestes;
}

class TripHistoryOperationFailure extends TripHistoryState {}
