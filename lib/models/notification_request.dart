import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@immutable
class NotificationRequest extends Equatable {
  // String? id;
  String? fcmToken;
  String requestId;
  String pickupAddress;
  String dropOffAddress;
  LatLng pickupLocation;
  String passengerName;

  NotificationRequest(
      {required this.pickupAddress,
      required this.dropOffAddress,
      required this.requestId,
      required this.passengerName,
      required this.pickupLocation,
      required this.fcmToken});

  @override
  List<Object?> get props => [
        passengerName,
        pickupLocation,
      ];

  // factory NotificationRequest.fromJson(Map<String, dynamic> json) {
  //   return NotificationRequest(
  //     id: json["passenger"]["id"],
  //     driverId: json["passenger"]["name"],
  //     pickupLocation: json["passenger"]["email"],
  //     dropOffLocation: json["passenger"]["gender"],
  //     passengerName: json["passenger"]["phone_number"],
  //   );
  // }

  @override
  String toString() => 'NotificationRequest {DriverId: $dropOffAddress }';
}
