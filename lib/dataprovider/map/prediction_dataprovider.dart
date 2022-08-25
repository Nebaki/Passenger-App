import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/models/models.dart';

class LocationPredictionDataProvider {
  final http.Client httpClient;

  LocationPredictionDataProvider({required this.httpClient});

  Future<List<LocationPrediction>> predictLocation(String location) async {
    final _baseUrl =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$location&location=8.9806%2C38.7578&radius=500&types=establishment&key=$apiKey";

    final response = await httpClient.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List places = data["predictions"];
      return places.map((e) => LocationPrediction.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load loaction');
    }
  }
}
