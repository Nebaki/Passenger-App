import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/auth/auth.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/models/models.dart';

class RideRequestDataProvider {
  final _fcmUrl = 'https://fcm.googleapis.com/fcm/send';

  final _baseUrl = 'https://safeway-api.herokuapp.com/api/ride-requests';
  final _maintenanceUrl =
      'https://mobiletaxi-api.herokuapp.com/api/ride-requests';
  final _secondUrl = 'https://mobiletaxi-api.herokuapp.com/api/ride-requests';
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());

  final token =
      "AAAAKTCNpPU:APA91bHPscWDa8pPO5MGRj11FWo6NZkpK5tRPodi_2wuMdHhDNwlTO3l4jF50tFGiU55EWMyNss0St0l_kk2H1YmKH1z4yzWPVL25xGTt-GqOFWUdh7BgjJmiNo55eVzzJgHeEOBvHtH";

  RideRequestDataProvider({required this.httpClient});

  Future<RideRequest> checkStartedTrip() async {
    final http.Response response = await http.get(
        Uri.parse(
            'https://mobiletaxi-api.herokuapp.com/api/ride-requests/check-started-trip'),
        headers: <String, String>{
          'Content-Type': "application/json",
          'x-access-token': '${await authDataProvider.getToken()}'
        });

    print('status code ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return data['isEmpty'] != true
          ? RideRequest.fromJson(data['ride_Request'])
          : RideRequest(
              pickUpAddress: null, droppOffAddress: null, driverId: null);
    } else {
      throw 'Unable to get Started Trips';
    }
  }

  Future<List<RideRequest>> getRideRequests() async {
    final http.Response response = await http.get(
        Uri.parse('$_maintenanceUrl/get-ride-requests'),
        headers: <String, String>{
          'Content-Type': "application/json",
          'x-access-token': '${await authDataProvider.getToken()}'
        });

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['items'] as List;
      print("e is $data");
      return data.map((e) => RideRequest.fromJson(e)).toList();
    } else {
      throw 'Unable to fetch RideRequests';
    }
  }

  Future createRequest(RideRequest request) async {
    print("yow yow ");
    final response = await http.post(
      Uri.parse('$_secondUrl/create-ride-request'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "x-access-token": "${await authDataProvider.getToken()}"
      },
      body: json.encode({
        "pickup_address": request.pickUpAddress,
        'pickup_location': [
          request.pickupLocation!.latitude,
          request.pickupLocation!.longitude
        ],
        'droppoff_location': [
          request.dropOffLocation!.longitude,
          request.dropOffLocation!.latitude
        ],
        'droppoff_address': request.droppOffAddress,
        'direction': direction,
        'price': int.parse(price),
        'duration': duration,
        'distance': int.parse(distance)
      }),
    );
    print('my datas are this bruhhh ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      rideRequestId = data["rideRequest"]["id"];
      print('my data is this bruhhh $rideRequestId');

      sendNotification(request, data["rideRequest"]["id"]);
      // return RideRequest.fromJson(data["rideRequest"]);
    } else {
      throw Exception('Failed to create request.');
    }
  }

  Future orderForOther(RideRequest request) async {
    print("yow yow ");
    final response = await http.post(
      Uri.parse('$_secondUrl/order-for-other'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "x-access-token": "${await authDataProvider.getToken()}"
      },
      body: json.encode({
        "pickup_address": request.pickUpAddress,
        'pickup_location': [
          request.pickupLocation!.latitude,
          request.pickupLocation!.longitude
        ],
        'droppoff_location': [
          request.dropOffLocation!.longitude,
          request.dropOffLocation!.latitude
        ],
        'droppoff_address': request.droppOffAddress,
        'direction': direction,
        'price': int.parse(price),
        'duration': duration,
        'distance': int.parse(distance)
      }),
    );
    print('my datas are this bruhhh ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      rideRequestId = data["rideRequest"]["id"];
      print('my data is this bruhhh $rideRequestId');

      sendNotification(request, data["rideRequest"]["id"]);
      // return RideRequest.fromJson(data["rideRequest"]);
    } else {
      throw Exception('Failed to create request.');
    }
  }

  Future<void> cancelRequest(String id) async {
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

  Future sendCanceledNotification(String fcmToken) async {
    print(
        "come on come on turn the radio on it;s friday night status ${driverFcm}");
    final response = await http.post(
      Uri.parse(_fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$token'
      },
      body: json.encode({
        "data": {'response': 'Cancelled'},
        "android": {"priority": "high"},
        "to": driverFcm,
        "notification": {
          "title": "RideRequest Cancelled",
          "body": "The rider has canceled the request"
        }
      }),
    );
    print(
        "come on come on turn the radio on it;s friday night status ${response.statusCode}");

    if (response.statusCode == 200) {
      print("Bodyyyyyyyyyyyyyyyyyyy ${response.body}");
      final data = (response.body);
      //return NotificationRequest.fromJson(data);
    } else {
      throw Exception('Failed to send notification.');
    }
  }

  Future sendNotification(RideRequest request, String requestId) async {
    final fcmtoken = await FirebaseMessaging.instance.getToken();

    print("Sending notification $nextDrivers");
    print(fcmtoken);
    print(request.driverFcm);
    print(requestId);
    final response = await http.post(
      Uri.parse(_fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$token'
      },
      body: json.encode({
        "data": {
          "nextDrivers": nextDrivers,
          "response": "Cancelled",
          "requestId": requestId,
          "passengerFcm": fcmtoken,
          "pickupLocation": [
            request.pickupLocation!.latitude,
            request.pickupLocation!.longitude
          ],
          "droppOffLocation": [
            request.dropOffLocation!.latitude,
            request.dropOffLocation!.longitude
          ],
          "passengerName": name,
          "pickupAddress": request.pickUpAddress,
          "droppOffAddress": request.droppOffAddress,
          "passengerPhoneNumber": request.passengerPhoneNumber,
          "price": price,
          "duration": duration,
          "distance": distance,
          "profilePictureUrl": "someurl"
        },
        "android": {"priority": "high"},
        "to": request.driverFcm,
        "notification": {
          "title": "New RideRequest",
          "body":
              "You have new ride request open it by tapping the nottification."
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

  Future<void> changeRequestStatus(
      String id, String status, bool sendRequest) async {
    final response = await http.post(
        Uri.parse('$_baseUrl/set-ride-request-status/$rideRequestId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "x-access-token": '${await authDataProvider.getToken()}'
        },
        body: json.encode({'status': 'Canceled'}));

    print("this is the status codesssssssss: ${response.statusCode}");
    if (response.statusCode == 200) {
      print("finally we are here: ${response.statusCode} ${sendRequest}");

      if (sendRequest) {
        print("finally we are here and here: ${response.statusCode}");

        sendCanceledNotification(driverFcm);
      }
    } else {
      throw Exception('Failed to respond to the request.');
    }
  }

  Future cancelRideRequest(
      String id, String cancelReason, String? fcmId, bool sendRequest) async {
    final http.Response response =
        await http.post(Uri.parse('$_baseUrl/cancel-ride-request/$id'),
            headers: <String, String>{
              "Content-Type": "application/json",
              "x-access-token": "${await authDataProvider.getToken()}"
            },
            body: json.encode({'cancel_reason': cancelReason}));

    print("response ${response.statusCode} ${response.body}");

    if (response.statusCode == 200) {
      if (sendRequest) {
        cancelNotification(fcmId!);
      }
    } else {
      throw 'Unable to cancel the request';
    }
  }

  Future cancelNotification(String fcmId) async {
    final response = await http.post(
      Uri.parse(_fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$token'
      },
      body: json.encode({
        "data": {'response': 'Cancelled'},
        "to": fcmId,
        "notification": {
          "title": "RideRequest Cancelled",
          "body": "Your ride request has been Cancelled."
        }
      }),
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      final data = (response.body);
    } else {
      throw Exception('Failed to send notification.');
    }
  }
}
