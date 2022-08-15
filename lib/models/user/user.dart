import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class User extends Equatable {
  final String? id;
  final String? name;
  final String? password;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final String? emergencyContact;
  final String? profileImage;
  final Map<String, dynamic>? preference;

  const User(
      {this.id,
      this.name,
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
        name,
        password,
        email,
        phoneNumber,
        gender,
        emergencyContact,
        profileImage,
      ];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["passenger"]["id"],
      name: json["passenger"]["name"],
      email: json["passenger"]["email"],
      gender: json["passenger"]["gender"],
      phoneNumber: json["passenger"]["phone_number"],
      emergencyContact: json["passenger"]["emergency_contact"] ?? '',
      profileImage: json["passenger"]["profile_image"] ?? '',
    );
  }

  @override
  String toString() => 'User {First Name: $name }';
}
