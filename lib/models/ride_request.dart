import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:passengerapp/models/models.dart';

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
  String? date;
  String? time;
  DriverModel? driver;

  RideRequest(
      {this.id,
      this.date,
      this.time,
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
      this.driverId,
      this.passengerName,
      this.pickupLocation,
      this.dropOffLocation,
      this.driver});

  @override
  List<Object?> get props =>
      [id, driverId, passengerName, pickupLocation, dropOffLocation];

  factory RideRequest.fromJson(Map<String, dynamic> json) {
    DateTime? now = DateTime.parse(json["created_at"] ?? DateTime.now());
    print("this is the response data ${json["driver_id"]}");

    return RideRequest(
        id: json["id"],
        driver: json["driver_id"] != null
            ? DriverModel.fromJson(json["driver_id"])
            : DriverModel(
                id: 'id',
                firstName: 'firstName',
                lastName: 'lastName',
                phoneNumber: 'phoneNumber',
                gender: 'gender',
                rating: 4,
                profileImage: 'profileImage',
                fcmId: 'fcmId'),
        // pickupLocation: LatLng(json["pickup_location"][0],json["pickup_location"][1]),
        // dropOffLocation: LatLng(json["droppoff_location"][0],json["droppoff_location"][1]),
        direction: json['direction'],
        pickUpAddress: json["pickup_address"] ?? '',
        droppOffAddress: json["droppoff_address"] ?? '',
        status: json['status'],
        price: json['price'].toString(),
        distance: json['distance'].toString(),
        date: DateFormat.yMMMMEEEEd().format(now),
        time: DateFormat.jm().format(now));
  }

  @override
  String toString() => 'RideRequest {DriverId: $driverId, $id }';
}
