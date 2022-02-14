import 'dart:convert';

import 'package:meta/meta.dart';

import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/auth/auth.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/repository/auth.dart';

class UserDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/users';
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());
  UserDataProvider({required this.httpClient}) : assert(httpClient != null);

  Future<User> createPassenger(User user) async {
    print(
        "_____________________________________________________________________");
    //print(user.firstName);
    final response = await http.post(
      Uri.parse('$_baseUrl/create-passenger'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        'first_name': user.firstName,
        'last_name': user.lastName,
        'email': user.email,
        'gender': user.gender,
        'password': user.password,
        'phone_number': user.phoneNumber,
        'emergency_contact': user.emergencyContact,
      }),
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user.');
    }
  }

  Future<void> deletePassenger(String id) async {
    final http.Response response = await httpClient.delete(
      Uri.parse('$_baseUrl/delete-passenger/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user.');
    }
  }

  Future<User> updatePassenger(User user) async {
    print("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");

    final http.Response response = await http.post(
      Uri.parse('https://safeway-api.herokuapp.com/api/users/update-profile'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-access-token': '${await authDataProvider.getToken()}'
      },
      body: jsonEncode(<String, dynamic>{
        'first_name': user.firstName,
        'last_name': user.lastName,
        'email': user.email,
        'gender': user.gender,
        'phone_number': user.phoneNumber,
        'emergency_contact': user.emergencyContact
      }),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      authDataProvider.updateUserData(user);
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode != 204) {
      throw Exception('204 Failed to update user.');
    } else {
      throw Exception('Failed to update user.');
    }
  }
}
