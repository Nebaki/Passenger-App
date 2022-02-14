import 'package:equatable/equatable.dart';
import 'package:passengerapp/models/models.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class UserLoad extends UserEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UserCreate extends UserEvent {
  final User user;

  const UserCreate(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'Passenger Created {user: $user}';
}

class UserUpdate extends UserEvent {
  final User user;

  const UserUpdate(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'Passenger Updated {user: $user}';
}

class UserDelete extends UserEvent {
  final User user;

  const UserDelete(this.user);

  @override
  List<Object> get props => [user];

  @override
  toString() => 'User Deleted {Passenger: $user}';
}
