import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/auth/auth.dart';
import 'package:passengerapp/models/models.dart';

class DriverDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/drivers';
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());
  DriverDataProvider({required this.httpClient});

  Future<DriverModel> getDriverById(String id) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/get-driver/$id'), headers: <String, String>{
      'Content-Type': "application/json",
      'x-access-token': '${await authDataProvider.getToken()}',
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return DriverModel.fromJson(responseData);
    } else {
      throw Exception('Failed to get driver.');
    }
  }
}
