import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class DriverModel extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String gender;
  final String profileImage;
  final String fcmId;
  final double rating;
  final Vehicle? vehicle;

  const DriverModel(
      {required this.id,
      this.vehicle,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.gender,
      required this.rating,
      required this.profileImage,
      required this.fcmId});

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        fcmId,
        profileImage,
        phoneNumber,
        gender,
        vehicle
      ];

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        gender: json["gender"],
        phoneNumber: json["phone_number"],
        profileImage: json["profile_image"] ?? '',
        fcmId: json['fcm_id'],
        rating: double.parse(json['avg_rate']['score'].toString()),
        vehicle: json.containsKey('vehicle')
            ? Vehicle.fromJson(json['vehicle'])
        /*
        {
                'model': json['vehicle']['model'],
                'plate_number': json['vehicle']['plate_number'],
                "color": json['vehicle']['color']
              }*/
            : null);
  }

  @override
  String toString() => 'DriverModel {First Name: $firstName }';
}
class Vehicle{
  final String model;
  final String plateNumber;
  final String color;
  Vehicle({
    required this.model,
    required this.plateNumber,
    required this.color
  });
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
        model: json["model"],
        plateNumber: json["plate_number"],
        color: json["color"]);
  }

}
