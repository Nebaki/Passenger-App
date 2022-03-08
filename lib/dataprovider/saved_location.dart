import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';

import '../models/local_models/trips.dart';

class RideRequestDataProvider {
  AuthDataProvider dp = AuthDataProvider(httpClient: http.Client());
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/savedLocation';
  final http.Client httpClient;

  RideRequestDataProvider({required this.httpClient});

  Future<Trip> createRequest(Trip request) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/create-request'),
      headers: <String, String>{'Content-Type': 'application/json','x-access-token':"${await dp.getToken()}"},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Trip.fromJson(data);
    } else {
      throw Exception('Failed to create user.');
    }
  }

  Future<void> deleteRequest(String id) async {
    final http.Response response = await httpClient.delete(
        Uri.parse('$_baseUrl/delete-request/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: {});

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user.');
    }
  }
}
