import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/auth/auth.dart';
import 'package:passengerapp/models/models.dart';

class SavedLocationDataProvider {
  final http.Client httpClient;
  final _baseUrl = "https://safeway-api.herokuapp.com/api/passengers";
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());

  SavedLocationDataProvider({required this.httpClient});

  Future<SavedLocation> createSavedLocation(SavedLocation savedLocation) async {
    http.Response response =
        await httpClient.post(Uri.parse('$_baseUrl/create-saved-location'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'x-access-token': '${await authDataProvider.getToken()}'
            },
            body: json.encode({
              'name': savedLocation.name,
              'address': savedLocation.address,
              'place_id': savedLocation.placeId
            }));

    if (response.statusCode == 200) {
      final savedlocation = json.decode(response.body);
      return SavedLocation.fromJson(savedlocation);
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<List<SavedLocation>> getSavedLocations() async {
    http.Response response = await httpClient.get(
        Uri.parse('$_baseUrl/get-my-saved-locations'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-access-token': '${await authDataProvider.getToken()}'
        });

    if (response.statusCode == 200) {
      final savedlocations = json.decode(response.body)['items'] as List;

      List<SavedLocation> list =
          savedlocations.map((e) => SavedLocation.fromJson(e)).toList();
      return list;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future clearSavedLocations() async {
    http.Response response = await httpClient.delete(
        Uri.parse('$_baseUrl/clear-saved-locations'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-access-token': '${await authDataProvider.getToken()}'
        });

    if (response.statusCode == 204) {
    } else {
      throw '';
    }
  }

  Future deleteSavedLocationById(String id) async {
    http.Response response = await httpClient.delete(
        Uri.parse('$_baseUrl/delete-saved-location/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-access-token': '${await authDataProvider.getToken()}'
        });
    if (response.statusCode == 200) {
    } else {
      throw '';
    }
  }

  Future<SavedLocation> updateSavedLocation(SavedLocation savedLocation) async {
    http.Response response =
        await httpClient.post(Uri.parse('$_baseUrl/update-saved-location'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'x-access-token': '${await authDataProvider.getToken()}'
            },
            body: json.encode({
              'id': savedLocation.id,
              'name': savedLocation.name,
              'address': savedLocation.address,
              'place_id': savedLocation.placeId
            }));
    if (response.statusCode == 200) {
      final savedlocation = json.decode(response.body);
      return SavedLocation.fromJson(savedlocation);
    } else {
      throw '';
    }
  }
}
