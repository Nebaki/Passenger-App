import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/models/trips/models.dart';


class SendFeedback {
  AuthDataProvider dp = AuthDataProvider(httpClient: http.Client());
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/locations';
  final http.Client httpClient;
  final secure_storage = const FlutterSecureStorage();
  SendFeedback({required this.httpClient});
  Future<String> sendFeedback(message,description) async {
    var user_phone = secure_storage.read(key: "phone_number");
    final http.Response response = await httpClient.post(
        Uri.parse('$_baseUrl/feedbacks/create-feedback'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'driver_id': 'waiting',
          'sender_phone': user_phone,
          'subject': message,
          'description': description,
        }));
    if(response.statusCode == 200){
      return response.body;
    }else if(response.statusCode != 200){
      switch(response.statusCode){
        case 401:
          return "Unauthorized use";
        case 403:
          return "Access forbidden";
        case 404:
          return "Not Found";
        case 500:
          return "Server error";
        default:
          return "unknown error";
      }
    }else {
      return "Unable to process your request";
    }
  }
}
