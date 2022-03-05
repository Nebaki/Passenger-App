import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/repository/repositories.dart';
import '../../models/models.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
  final DriverRepository driverRepository;
  DriverBloc({required this.driverRepository}) : super(const DriverState());

  @override
  Stream<DriverState> mapEventToState(DriverEvent event) async* {
    if (event is DriverLoad) {
      yield DriverLoading();
      try {
        final driver = await driverRepository.getDriverById(event.id);
        yield DriverLoadSuccess(driver);
      } catch (_) {
        yield DriverOperationFailure();
      }
    }
  }
}

abstract class DriverEvent extends Equatable {
  const DriverEvent();
}

class DriverLoad extends DriverEvent {
  final String id;
  const DriverLoad(this.id);
  @override
  List<Object?> get props => [id];
}

class DriverState extends Equatable {
  const DriverState();
  @override
  List<Object?> get props => [];
}

class DriverLoading extends DriverState {}

class DriverLoadSuccess extends DriverState {
  final DriverModel driver;

  const DriverLoadSuccess(this.driver);

  @override
  List<Object?> get props => [driver];
}

class DriverOperationFailure extends DriverState {}
