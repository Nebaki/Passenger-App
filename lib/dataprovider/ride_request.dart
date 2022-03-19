import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:passengerapp/models/models.dart';

class RideRequestDataProvider {
  final _fcmUrl = 'https://fcm.googleapis.com/fcm/send';

  final _baseUrl = 'https://safeway-api.herokuapp.com/api/ride-requests';
  final http.Client httpClient;
  final token =
      "AAAAKTCNpPU:APA91bHPscWDa8pPO5MGRj11FWo6NZkpK5tRPodi_2wuMdHhDNwlTO3l4jF50tFGiU55EWMyNss0St0l_kk2H1YmKH1z4yzWPVL25xGTt-GqOFWUdh7BgjJmiNo55eVzzJgHeEOBvHtH";

  RideRequestDataProvider({required this.httpClient});

  Future<RideRequest> createRequest(RideRequest request) async {
    print("yow yow ");
    final response = await http.post(
      Uri.parse('$_baseUrl/create-ride-request'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "x-access-token":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MjJiMGE3MGM3OWY2MjZiODZhMmU2NTEiLCJuYW1lIjoibWlraSIsInBob25lX251bWJlciI6IisyNTE5MzQ1NDAyMTciLCJyb2xlIjpbIlBhc3NlbmdlciJdLCJpYXQiOjE2NDY5ODc4ODgsImV4cCI6MTY0NzA3NDI4OH0.wGZrmWayn6ZGmm8YgL5bGHC8fMxj7mIRZ6sNOyc-aX8"
      },
      body: json.encode({
        'driverId': 'waiting',
        'passengerName': request.passengerName,
        'passengerPhoneNumber': request.passengerPhoneNumber,
        "pickupAddress": request.pickUpAddress,
        'pickupLocation': [
          request.pickupLocation!.latitude,
          request.pickupLocation!.longitude
        ],
        'droppoffLocation': [
          request.dropOffLocation!.longitude,
          request.dropOffLocation!.latitude
        ],
      }),
    );
    print(' this is the response Status coed: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      sendNotification(request, data["rideRequest"]["id"]);
      print('my data is this bruhhh $data');
      return RideRequest.fromJson(data);
    } else {
      throw Exception('Failed to create request.');
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

  Future sendNotification(RideRequest request, String requestId) async {
    final fcmtoken = await FirebaseMessaging.instance.getToken();

    print("Sending notification");
    print(fcmtoken);
    print(requestId);
    final response = await http.post(
      Uri.parse(_fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$token'
      },
      body: json.encode({
        "data": {
          "pickupAddress": "request.pickupAddress",
          "pickupLocation": [
            request.pickupLocation!.latitude,
            request.pickupLocation!.longitude
          ],
          "dropOffAddress": "request.dropOffAddress",
          "droppoffLocation": [
            request.dropOffLocation!.latitude,
            request.dropOffLocation!.longitude
          ],
          "passengerName": request.passengerName,
          "requestId": requestId,
          "passengerFcm": fcmtoken
        },
        "to": request.driverFcm,
        //request.driverToken,
        // "dIZJlO16S6aIiFoGPAg9qf:APA91bHjrxQ0I5vRqyrBFHqbYBM90rYZfmb2llmtA6q8Ps6LmIS9WwoO3ENnBGUDaax7l1eTpzh71RK9YS4fyDdPdowyalVhZXbjWxq337ZEtDvOSGihA5pyuTJeS0dqQl0I9H5MfnFp",
        "notification": {
          "title": "New-Ride Request",
          "body":
              "You have new ride request. tap on the notification to accept or cancel the request"
        }
      }),
    );
// 622ef747b9eb9b904c5d2210

    // dxGQlHGETnWjGYmlVy8Utn:APA91bErJaqPmsqfQOcStX6MYcBxfIAMr9kofXqF7bOBhftlZ3qo327e3PQ1jinm6o7FmtTy1LX4e0SE-dCUc2NwcyL6OJqKW7dagp6uTs8k-m6ynhp7NBotpPMaioTNxBuJFPz_RUif

    print("Status code is ${response.body}");

    if (response.statusCode == 200) {
      print("come on come on turn the radio on it;s friday night");
      final data = (response.body);
      //return NotificationRequest.fromJson(data);
    } else {
      throw Exception('Failed to send notification.');
    }
  }
}
