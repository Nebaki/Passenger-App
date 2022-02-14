import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meta/meta.dart';
import 'package:passengerapp/repository/repositories.dart';
import 'bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserLoading());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserCreate) {
      yield UserLoading();
      try {
        final users = await userRepository.createPassenger(event.user);
        yield UsersLoadSuccess(users);
      } catch (_) {
        yield UserOperationFailure();
      }
    }

    if (event is UserUpdate) {
      try {
        final passenger = await userRepository.updatePassenger(event.user);
        yield UsersLoadSuccess(passenger);
      } catch (_) {
        yield UserOperationFailure();
      }
    }

    if (event is UserDelete) {
      try {
        await userRepository.deletePassenger(event.user.id!);
        yield const UsersDeleteSuccess(true);
      } catch (_) {
        yield UserOperationFailure();
      }
    }
  }
}
