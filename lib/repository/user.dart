import 'package:image_picker/image_picker.dart';
import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';
import 'dart:io';

class UserRepository {
  final UserDataProvider dataProvider;

  UserRepository({required this.dataProvider});

  Future<User> createPassenger(User user) async {
    return await dataProvider.createPassenger(user);
  }

  Future<User> updatePassenger(User user) async {
    return await dataProvider.updatePassenger(user);
  }

  Future<User> updatePreference(User user) async {
    return await dataProvider.updatePreference(user);
  }

  Future<void> deletePassenger(String id) async {
    await dataProvider.deletePassenger(id);
  }

  Future uploadProfilePicture(XFile file) async {
    await dataProvider.uploadImage(file);
  }
}
