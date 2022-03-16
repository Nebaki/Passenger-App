import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/models/models.dart';

class ReviewDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/reviews';
  final http.Client httpClient;
  ReviewDataProvider({required this.httpClient});
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());
  Future<void> createRideRequest(Review review) async {
    print("creating the review");

    http.Response response = await httpClient.post(
        Uri.parse("$_baseUrl/create-review"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-access-token': '${await authDataProvider.getToken()}'
        },
        body: json.encode({
          "rate": review.rating,
          "description": review.description,
          "driver": driverId
        }));
    print("you know this is the statusCode ${response.statusCode}");
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to create review.');
    }
  }
}
