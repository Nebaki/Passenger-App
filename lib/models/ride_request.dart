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
  String? passengerName;
  String? pickUpAddress;
  String? passengerPhoneNumber;
  String? droppOffAddress;
  String? status;
  String? cancelReason;
  String? price;
  String? distance;
  String? duration;
  String? direction;

  RideRequest({
    this.id,
    this.driverFcm,
    this.direction,
    this.duration,
    this.price,
    this.status,
    this.distance,
    this.cancelReason,
    this.passengerPhoneNumber,
    required this.pickUpAddress,
    required this.droppOffAddress,
    required this.driverId,
    this.passengerName,
    this.pickupLocation,
    this.dropOffLocation,
  });

  @override
  List<Object?> get props =>
      [id, driverId, passengerName, pickupLocation, dropOffLocation];

  factory RideRequest.fromJson(Map<String, dynamic> json) {
    print("this is the response data ${json["id"]}");
    return RideRequest(
        id: json["id"],
        driverId: json["driver_id"] ?? '',
        // pickupLocation: json["rideRequest"]["pickupLocation"],
        // dropOffLocation: json["passenger"]["gender"],
        // passengerPhoneNumber: json["rideRequest"]["passengerName"],
        direction: json['direction'],
        pickUpAddress: json["pickup_address"] ?? '',
        droppOffAddress: json["droppoff_address"] ?? '',
        status: json['status'],
        price: json['price'].toString(),
        distance: json['distance'].toString()
        // passengerName: json["rideRequest"]["passengerName"],
        );
  }

  @override
  String toString() => 'RideRequest {DriverId: $driverId, $id }';
}
