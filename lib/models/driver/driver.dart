import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class DriverModel extends Equatable {
  String id;
  String firstName;
  String lastName;
  String phoneNumber;
  String gender;
  String profileImage;
  String fcmId;

  DriverModel(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.gender,
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
      ];

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
        id: json["driver"]["id"],
        firstName: json["driver"]["first_name"],
        lastName: json["driver"]["last_name"],
        gender: json["driver"]["gender"],
        phoneNumber: json["driver"]["phone_number"],
        profileImage: json["driver"]["profile_image"] ?? '',
        fcmId: json['driver']['fcm_id']);
  }

  @override
  String toString() => 'DriverModel {First Name: $firstName }';
}
