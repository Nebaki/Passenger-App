import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@immutable
class RideRequest extends Equatable {
  String? id;
  String? driverId;
  String? driverFcm;
  LatLng? pickupLocation;
  LatLng? dropOffLocation;
  String passengerName;
  String pickUpAddress;
  String passengerPhoneNumber;
  String droppOffAddress;

  RideRequest({
    this.id,
    this.driverFcm,
    required this.passengerPhoneNumber,
    required this.pickUpAddress,
    required this.droppOffAddress,
    required this.driverId,
    required this.passengerName,
    this.pickupLocation,
    this.dropOffLocation,
  });

  @override
  List<Object?> get props =>
      [id, driverId, passengerName, pickupLocation, dropOffLocation];

  factory RideRequest.fromJson(Map<String, dynamic> json) {
    print("this is the response data ${json["rideRequest"]["id"]}");
    return RideRequest(
      id: json["rideRequest"]["id"],
      driverId: json["rideRequest"]["driverId"],
      // pickupLocation: json["rideRequest"]["pickupLocation"],
      // dropOffLocation: json["passenger"]["gender"],
      passengerPhoneNumber: json["rideRequest"]["passengerName"],
      pickUpAddress: json["rideRequest"]["id"],
      droppOffAddress: json["rideRequest"]["id"],
      passengerName: json["rideRequest"]["passengerName"],
    );
  }

  @override
  String toString() => 'RideRequest {DriverId: $driverId, $id }';
}
