import 'dart:convert';
import 'dart:io';
import 'package:retry/retry.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/helper/api_end_points.dart' as api;
import '../../models/models.dart';

class SettingsDataProvider {
  final secureStorage = const FlutterSecureStorage();
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());
  SettingsDataProvider({required this.httpClient});

  Future<http.Response> refreshToken() async {
    print("refresh token method called");
    http.Response response = await httpClient
        .get(Uri.parse(api.AuthEndPoints.refreshTokenEndPoint()));
    print("refresh token response code: ${response.statusCode}");
    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      secureStorage.write(key: "token", value: token);
    }
    return response;
  }

  Future<Settings> getSettings() async {
    http.Response response = await httpClient.get(
        Uri.parse(api.SettingsEndPoint.getSettingsEndPoint()),
        headers: <String, String>{
          'x-access-token': "${await authDataProvider.getToken()}"
        });

    if (response.statusCode == 200) {
      print("no  need to refresh token");
      final data = jsonDecode(response.body);
      return Settings.fromJson(data['items']);
    } else if (response.statusCode == 401) {
      final res = await refreshToken();
      if (res.statusCode == 200) {
        return getSettings();
      } else {
        print(response.body);
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception(response.statusCode);
    }
  }

  void updateCookie(http.Response response) {
    final rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      // Cookie.fromSetCookieValue(value)
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }

  Map<String, String> headers = {};
}
