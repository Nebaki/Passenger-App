import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';

class UserRepository {
  final UserDataProvider dataProvider;

  UserRepository({required this.dataProvider});

  Future<User> createPassenger(User user) async {
    return await dataProvider.createPassenger(user);
  }

  Future<User> updatePassenger(User user) async {
    return await dataProvider.updatePassenger(user);
  }

  Future<void> deletePassenger(String id) async {
    await dataProvider.deletePassenger(id);
  }
}
