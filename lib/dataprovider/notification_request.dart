import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';

class NotificationRequestDataProvider {
  final _baseUrl = 'https://fcm.googleapis.com/fcm/send';
  final _driverBaseUrl = 'https://safeway-api.herokuapp.com/api/drivers';
  final token =
      "AAAAKTCNpPU:APA91bHPscWDa8pPO5MGRj11FWo6NZkpK5tRPodi_2wuMdHhDNwlTO3l4jF50tFGiU55EWMyNss0St0l_kk2H1YmKH1z4yzWPVL25xGTt-GqOFWUdh7BgjJmiNo55eVzzJgHeEOBvHtH";
  final http.Client httpClient;
  AuthDataProvider authData = AuthDataProvider(httpClient: http.Client());

  NotificationRequestDataProvider({required this.httpClient});

  Future sendNotification(NotificationRequest request) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$token'
      },
      body: json.encode({
        "data": {
          "pickupAddress": request.pickupAddress,
          "pickupLocation": request.pickupLocation.latitude,
          "dropOffAddress": request.dropOffAddress,
          "dropOffLocation": request.pickupLocation.longitude,
          "passengerName": request.passengerName
        },
        "to": request.fcmToken,
        //request.driverToken,
        // "dIZJlO16S6aIiFoGPAg9qf:APA91bHjrxQ0I5vRqyrBFHqbYBM90rYZfmb2llmtA6q8Ps6LmIS9WwoO3ENnBGUDaax7l1eTpzh71RK9YS4fyDdPdowyalVhZXbjWxq337ZEtDvOSGihA5pyuTJeS0dqQl0I9H5MfnFp",
        "notification": {
          "title": "New-Ride Request",
          "body":
              "You have new ride request. tap on the notification to accept or cancel the request"
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = (response.body);
      //return NotificationRequest.fromJson(data);
    } else {
      throw Exception('Failed to send notification.');
    }
  }
}
