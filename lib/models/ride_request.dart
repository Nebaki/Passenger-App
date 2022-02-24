import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class RideRequest extends Equatable {
  String? id;
  String? driverId;
  double pickupLocation;
  double dropOffLocation;
  String passengerName;

  RideRequest({
    this.id,
    required this.driverId,
    required this.passengerName,
    required this.pickupLocation,
    required this.dropOffLocation,
  });

  @override
  List<Object?> get props =>
      [id, driverId, passengerName, pickupLocation, dropOffLocation];

  factory RideRequest.fromJson(Map<String, dynamic> json) {
    return RideRequest(
      id: json["passenger"]["id"],
      driverId: json["passenger"]["name"],
      pickupLocation: json["passenger"]["email"],
      dropOffLocation: json["passenger"]["gender"],
      passengerName: json["passenger"]["phone_number"],
    );
  }

  @override
  String toString() => 'RideRequest {DriverId: $driverId }';
}
