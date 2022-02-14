import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class Auth extends Equatable {
  String? token;
  String? id;
  String? name;
  String phoneNumber;
  String? password;
  String? email;
  String? emergencyContact;

  Auth({
    this.id,
    this.token,
    this.email,
    this.emergencyContact,
    this.name,
    required this.phoneNumber,
    this.password,
  });

  @override
  List<Object?> get props => [phoneNumber, password];

  factory Auth.fromStorage(Map<String, dynamic> storage) {
    return Auth(
        id: storage["id"],
        token: storage["token"],
        phoneNumber: storage["phone_number"],
        name: storage["name"],
        emergencyContact: storage["emergency_contact"],
        email: storage["email"]);
  }

  @override
  String toString() => 'Location {Phone Number: $phoneNumber }';
}
