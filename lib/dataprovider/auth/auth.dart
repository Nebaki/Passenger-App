import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:passengerapp/models/models.dart';

class AuthDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/auth';
  final http.Client httpClient;
  final secure_storage = new FlutterSecureStorage();
  AuthDataProvider({required this.httpClient});

  Future<void> loginUser(Auth user) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login-with-phone-number'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        'phone_number': user.phoneNumber,
        'password': user.password,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      await secure_storage.write(key: 'id', value: output['user']['id']);
      await secure_storage.write(key: 'token', value: output['user']['token']);
      await secure_storage.write(
          key: 'phone_number', value: output['user']['phone_number']);
      await secure_storage.write(
          key: 'name',
          value:
              output['user']['first_name'] + " " + output['user']['last_name']);
      await secure_storage.write(key: 'token', value: output['token']);
      await secure_storage.write(key: "email", value: output['user']['email']);
      await secure_storage.write(
          key: "emergency_contact", value: output['user']['emergency_contact']);

      //return User.fromJson(output);
    } else {
      throw Exception('Failed to login.');
    }
  }

  Future<Auth> getUserData() async {
    final token = await secure_storage.readAll();
    return Auth.fromStorage(token);
  }

  Future updateUserData(User user) async {
    await secure_storage.write(key: 'phone_number', value: user.phoneNumber);
    await secure_storage.write(
        key: 'name', value: user.firstName + " " + user.lastName);
    await secure_storage.write(key: "email", value: user.email);
    await secure_storage.write(
        key: "emergency_contact", value: user.emergencyContact);
  }

  Future logOut() async {
    await secure_storage.deleteAll();
  }

  Future<String?> getToken() async {
    return await secure_storage.read(key: "token");
  }
}
