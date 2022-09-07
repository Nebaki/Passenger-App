import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/auth/auth.dart';
import 'package:passengerapp/helper/api_end_points.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/utils/session.dart';

class RideRequestDataProvider {
  final _fcmUrl = 'https://fcm.googleapis.com/fcm/send';

  final _baseUrl = 'https://safeway-api.herokuapp.com/api/ride-requests';

  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());

  final token =
      "AAAAKTCNpPU:APA91bHPscWDa8pPO5MGRj11FWo6NZkpK5tRPodi_2wuMdHhDNwlTO3l4jF50tFGiU55EWMyNss0St0l_kk2H1YmKH1z4yzWPVL25xGTt-GqOFWUdh7BgjJmiNo55eVzzJgHeEOBvHtH";

  RideRequestDataProvider({required this.httpClient});

  Future<RideRequest> checkStartedTrip() async {
    final http.Response response = await http.get(
        Uri.parse(RideRequestEndPoints.checkStartedTripEndPoint()),
        headers: <String, String>{
          'Content-Type': "application/json",
          'x-access-token': '${await authDataProvider.getToken()}'
        });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['isEmpty'] != true
          ? RideRequest.fromJson(data['ride_Request'])
          :  RideRequest(
              pickUpAddress: null, droppOffAddress: null, driverId: null);
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return checkStartedTrip();
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<List<RideRequest?>> getRideRequests(int skip, int top) async {
    final http.Response response = await http.get(
        Uri.parse(RideRequestEndPoints.getRideRequestsEndPoint(skip, top)),
        headers: <String, String>{
          'Content-Type': "application/json",
          'x-access-token': '${await authDataProvider.getToken()}'
        });

    if (response.statusCode == 200) {
      Session().logSession("history", response.body);
      final data = json.decode(response.body)['items'] as List;

      return data.isNotEmpty
          ? data.map((e) => RideRequest.fromJson(e)).toList()
          : [];
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return getRideRequests(skip, top);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future createRequest(RideRequest request) async {
    final response = await http.post(
      Uri.parse(RideRequestEndPoints.createRideRequestEndPoint()),
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
        'drop_off_location': [
          request.dropOffLocation!.latitude,
          request.dropOffLocation!.longitude
        ],
        'drop_off_address': request.droppOffAddress,
        'direction': direction,
        'price': int.parse(price),
        'duration': duration,
        'distance': int.parse(distance)
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      rideRequestId = data["id"];

      sendNotification(request, data["id"], false);
      // return RideRequest.fromJson(data["rideRequest"]);
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return createRequest(request);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future orderForOther(RideRequest request) async {
    final response = await http.post(
      Uri.parse(RideRequestEndPoints.orderForOtherEndPoint()),
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
        'drop_off_location': [
          request.dropOffLocation!.latitude,
          request.dropOffLocation!.longitude
        ],
        'drop_off_address': request.droppOffAddress,
        'direction': direction,
        'price': int.parse(price),
        'duration': duration,
        'distance': int.parse(distance)
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      rideRequestId = data["rideRequest"]["id"];

      sendNotification(request, data["rideRequest"]["id"], true);
      // return RideRequest.fromJson(data["rideRequest"]);
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return orderForOther(request);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception(response.statusCode);
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
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return cancelRequest(id);
      } else {
        throw Exception(response.statusCode);
      }
    }
  }

  Future sendCanceledNotification(String fcmToken) async {
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

    if (response.statusCode == 200) {
      // final data = (response.body);
    } else {
      throw Exception('Failed to send notification.');
    }
  }

  Future sendNotification(
      RideRequest request, String requestId, bool forOther) async {
    final fcmtoken = await FirebaseMessaging.instance.getToken();

    final response = await http.post(
      Uri.parse(_fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$token'
      },
      body: json.encode({
        "data": {
          "nextDrivers": nextDrivers,
          "response": "Searching",
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
          "passengerName": forOther ? request.passengerPhoneNumber : name,
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
    if (response.statusCode == 200) {

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

    if (response.statusCode == 200) {
      if (sendRequest) {
        sendCanceledNotification(driverFcm);
      }
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return changeRequestStatus(id, status, sendRequest);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception(response.statusCode);
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

    if (response.statusCode == 200) {
      if (sendRequest) {
        cancelNotification(fcmId!);
      }
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return cancelRideRequest(id, cancelReason, fcmId, sendRequest);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception(response.statusCode);
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

    if (response.statusCode == 200) {
      // final data = (response.body);
    } else {
      throw Exception('Failed to send notification.');
    }
  }
}
