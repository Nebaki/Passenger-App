import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:passengerapp/models/trips/models.dart';
import '../utils/session.dart';
import 'header/header.dart';


class SendFeedback {
  final _baseUrl = RequestHeader.baseURL+'feedbacks';
  final http.Client httpClient;
  final secureStorage = const FlutterSecureStorage();
  SendFeedback({required this.httpClient});
  Future<Result> sendFeedback(message,description) async {
    var userPhone = await secureStorage.read(key: "phone_number");
    Session().logSession("feedback","$message : $description : $userPhone");
    final http.Response response = await httpClient.post(
        Uri.parse('$_baseUrl/create-feedback'),
        headers: await RequestHeader().authorisedHeader(),
        body: json.encode({
          "phone_number": userPhone.toString(),
          "name": "message",
          "email": "help@safeway.com",
          "subject": message,
          "description": description
        }));
    if(response.statusCode == 200){
      return Result(true, "We Received Your Feedback, Thank You!");
    }else{
      return RequestResult().requestResult(response.statusCode,response.body);
    }
  }
}
