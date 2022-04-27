import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passengerapp/models/models.dart';
import 'dart:io';

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

class UploadProfile extends UserEvent {
  final XFile file;

  const UploadProfile(this.file);

  @override
  List<Object> get props => [file];

  @override
  String toString() => 'Image Uploaded {user: $file}';
}

class UserUpdate extends UserEvent {
  final User user;

  const UserUpdate(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'Passenger Updated {user: $user}';
}

class UserPreferenceUpdate extends UserEvent {
  final User user;

  const UserPreferenceUpdate(this.user);

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

class UserChangePassword extends UserEvent {
  final Map<String, String> passwordInfo;
  const UserChangePassword(this.passwordInfo);
  @override
  List<Object?> get props => [passwordInfo];
}
