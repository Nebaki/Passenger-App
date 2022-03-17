import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';


class SavedLocationDataProvider {
  AuthDataProvider dp = AuthDataProvider(httpClient: http.Client());
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/locations';
  final http.Client httpClient;

  SavedLocationDataProvider({required this.httpClient});

  Future<List<Trip>> loadLocations() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/saved-location'),
      headers: <String, String>{'Content-Type': 'application/json','x-access-token':"${await dp.getToken()}"},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["saved-locations"].map((e) =>  Trip.fromMap(e)).toList();
    } else {
      throw Exception('Failed to create user.');
    }
  }

  Future<void> deleteSavedLocation(String id) async {
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
