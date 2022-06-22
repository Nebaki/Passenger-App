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
    http.Response response = await httpClient.post(
        Uri.parse("$_baseUrl/create-review"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-access-token': '${await authDataProvider.getToken()}'
        },
        body: json.encode({
          "rate": review.rating,
          "description": review.description,
          "driver_id": driverId
        }));
    if (response.statusCode == 200) {
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();
      if (res.statusCode == 200) {
        return createRideRequest(review);
      } else {
        // print(response.body);
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception(response.statusCode);
    }
  }
}
