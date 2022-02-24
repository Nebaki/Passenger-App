import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:passengerapp/models/models.dart';

class RideRequestDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/riderequests';
  final http.Client httpClient;

  RideRequestDataProvider({required this.httpClient});

  Future<RideRequest> createRequest(RideRequest request) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create-request'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        'driver_id': 'waiting',
        'passenger_name': request.passengerName,
        'pickup_location': request.pickupLocation,
        'dropoff_location': request.dropOffLocation,
      }),
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return RideRequest.fromJson(data);
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
