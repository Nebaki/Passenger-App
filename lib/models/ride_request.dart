import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:passengerapp/models/models.dart';

@immutable
class RideRequest extends Equatable {
  final String? id;
  final String? driverId;
  final String? driverFcm;
  final LatLng? pickupLocation;
  final LatLng? dropOffLocation;
  final String? passengerName;
  final String? pickUpAddress;
  final String? passengerPhoneNumber;
  final String? droppOffAddress;
  final String? status;
  final String? cancelReason;
  final String? price;
  final String? distance;
  final String? duration;
  final String? direction;
  final String? date;
  final String? time;
  Uint8List? picture;
  final DriverModel? driver;

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
      this.driver,
      this.picture});

  @override
  List<Object?> get props =>
      [id, driverId, passengerName, pickupLocation, dropOffLocation];

  factory RideRequest.fromJson(Map<String, dynamic> json) {
    DateTime? now = DateTime.parse(json["created_at"] ?? DateTime.now());

    return RideRequest(
        id: json["id"],
        driver: json.containsKey("driver")
            ? DriverModel.fromJson(json["driver"])
            : null,
        pickupLocation:
            LatLng(json["pickup_location"][0], json["pickup_location"][1]),
        dropOffLocation:
            LatLng(json["drop_off_location"][0], json["drop_off_location"][1]),
        direction: json['direction'],
        pickUpAddress: json["pickup_address"] ?? '',
        droppOffAddress: json["drop_off_address"] ?? '',
        status: json['status'],
        price: json['price'].toString(),
        distance: json['distance'].toString(),
        date: DateFormat.yMMMEd().format(now),
        time: DateFormat.jm().format(now)
    );
  }

  @override
  String toString() =>
      'RideRequest {DriverId: $driverId, $id , PickupLocation: $pickupLocation, DroppOffLocaiton: $dropOffLocation, PickupAddress:$pickUpAddress, DroppOffLocation: $droppOffAddress,Direction:$direction,Status: $status,Price:$price,Distance:$distance,Date:$date,Time:$time}';
}
class Driver{
  final String? id;
  final String? driverName;
  final String? driverPhone;
  final LatLng? driverEmail;
  final LatLng? driverGender;
  Driver(
      {this.id,
        this.driverName,
        this.driverPhone,
        this.driverEmail,
        this.driverGender});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
        id: json["id"],
        driverName: json['first_name']+' '+json['last_name'],
        driverPhone: json["phone_number"] ?? '',
        driverEmail: json["email"] ?? '',
        driverGender: json['status']
    );
  }

  @override
  String toString() => '';
}
