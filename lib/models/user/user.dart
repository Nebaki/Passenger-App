import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class User extends Equatable {
  String? id;
  String? firstName;
  String? lastName;
  String? password;
  String? email;
  String? phoneNumber;
  String? gender;
  String? emergencyContact;
  String? profileImage;
  Map<String, dynamic>? preference;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.phoneNumber,
      this.gender,
      this.emergencyContact,
      this.preference,
      this.profileImage});

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        password,
        email,
        phoneNumber,
        gender,
        // emergencyContact,
        // profileImage,
      ];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["passenger"]["id"],
      firstName: json["passenger"]["name"],
      email: json["passenger"]["email"],
      gender: json["passenger"]["gender"],
      phoneNumber: json["passenger"]["phone_number"],
      emergencyContact: json["passenger"]["emergency_contact"] ?? '',
      profileImage: json["passenger"]["profile_image"] ?? '',
    );
  }

  @override
  String toString() => 'User {First Name: $firstName }';
}
