import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/helper/api_end_points.dart' as api;

import '../../utils/session.dart';

class AuthDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/auth';
  final _imageBaseUrl = 'https://safeway-api.herokuapp.com/';

  final http.Client httpClient;
  static const secureStorage = FlutterSecureStorage();
  AuthDataProvider({required this.httpClient});
  Dio dio = Dio();

  Future<http.Response> refreshToken() async {
    http.Response response = await httpClient.get(
        Uri.parse(api.AuthEndPoints.refreshTokenEndPoint()),
        headers: <String, String>{
          'Cookie': '${await secureStorage.read(key: "refresh_token")}'
        });
    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      secureStorage.write(key: "token", value: token);
    } else {}
    return response;
  }

  void updateCookie(http.Response response) async {
    final rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      await secureStorage.write(
          key: "refresh_token",
          value: (index == -1) ? rawCookie : rawCookie.substring(0, index));
    }
  }

  Future<void> loginUser(Auth user) async {
    final fcmId = await FirebaseMessaging.instance.getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/passenger-login'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        'phone_number': user.phoneNumber,
        'password': user.password,
        'fcm_id': fcmId
      }),
    );
    Session().logSession("login", response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);

      updateCookie(response);

      await secureStorage.write(key: 'id', value: output['passenger']['id']);
      await secureStorage.write(
          key: 'phone_number', value: output['passenger']['phone_number']);
      await secureStorage.write(
          key: 'name', value: output['passenger']['name']);
      await secureStorage.write(key: 'token', value: output['token']);
      await secureStorage.write(
          key: "email", value: output['passenger']['email'] ?? "");
      await secureStorage.write(
          key: "emergency_contact",
          value: output['passenger']['emergency_contact'] ?? "");

      await secureStorage.write(
          key: 'profile_image',
          value: _imageBaseUrl + output['passenger']['profile_image']);

    } else {
      throw Exception('Failed to login.');
    }
  }

  Future<Auth> getUserData() async {
    final token = await secureStorage.readAll();
    return Auth.fromStorage(token);
  }

  Future updateUserData(User user) async {
    await secureStorage.write(key: 'phone_number', value: user.phoneNumber);
    await secureStorage.write(key: 'name', value: user.name!);
    await secureStorage.write(key: "email", value: user.email ?? "");
    await secureStorage.write(
        key: "emergency_contact", value: user.emergencyContact ?? "");
  }

  Future updateProfile(String url) async {
    await secureStorage.write(key: 'profile_image', value: _imageBaseUrl + url);
  }

  Future updatePreference(String gender, String rate, String carType) async {
    await secureStorage.write(key: "driver_gender", value: gender);
    await secureStorage.write(key: "min_rate", value: rate);
    await secureStorage.write(key: "car_type", value: carType);
  }

  Future logOut() async {
    await secureStorage.deleteAll();
  }

  Future<String?> getToken() async {
    return await secureStorage.read(key: "token");
  }

  static Future updateToken(token) async {
    await secureStorage.write(key: 'token', value: token);
  }
  Future<String?> getUserId() async {
    return await secureStorage.read(key: "id");
  }

  Future<String?> getImageUrl() async {
    return await secureStorage.read(key: "profile_image");
  }
}
