import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/models/trips/models.dart';

import 'header/header.dart';


class SendFeedback {
  AuthDataProvider dp = AuthDataProvider(httpClient: http.Client());
  final _baseUrl = RequestHeader.baseURL+'feedbacks';
  final http.Client httpClient;
  final secure_storage = const FlutterSecureStorage();
  SendFeedback({required this.httpClient});
  Future<String> sendFeedback(message,description) async {
    var user_phone = await secure_storage.read(key: "phone_number");
    print("$message : $description : $user_phone");
    final http.Response response = await httpClient.post(
        Uri.parse('$_baseUrl/create-feedback'),
        headers: await RequestHeader().authorisedHeader(),
        body: json.encode({
          "phone_number": user_phone.toString(),
          "name": "message",
          "email": "help@safeway.com",
          "subject": message,
          "description": description
        }));
    if(response.statusCode == 200){
      return "We Received Your Feedback, Thank You!";
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
          print("unknown error: ${response.statusCode} ${response.body}");
          return "unknown error: ${response.statusCode} ${response.body}";
      }
    }else {
      return "Unable to process your request";
    }
  }
}
