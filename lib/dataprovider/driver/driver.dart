import 'dart:convert';

// import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/auth/auth.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/repository/auth.dart';

class DriverDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/drivers';
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());
  DriverDataProvider({required this.httpClient}) : assert(httpClient != null);

  Future<DriverModel> getDriverById(String id) async {
    print("in hereeeeeeeee");
    final response = await http
        .get(Uri.parse('$_baseUrl/get-driver/$id'), headers: <String, String>{
      'Content-Type': "application/json",
      'x-access-token': '${await authDataProvider.getToken()}',
    });

    print(response.statusCode);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body)['driver'];
      return DriverModel.fromJson(responseData);
    } else {
      throw Exception('Failed to get driver.');
    }
  }
}
