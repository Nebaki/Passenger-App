import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';

class AuthRepository {
  final AuthDataProvider dataProvider;

  AuthRepository({required this.dataProvider});

  Future<void> loginUser(Auth auth) async {
    return await dataProvider.loginUser(auth);
  }

  Future<Auth> getUserData() async {
    return await dataProvider.getUserData();
  }

  Future logOut() async {
    return await dataProvider.logOut();
  }

  Future getToken() async {
    return await dataProvider.getToken();
  }
}
