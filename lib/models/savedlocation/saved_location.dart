import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';

@immutable
class SavedLocation extends Equatable {
  String? id;
  String name;
  String address;
  String placeId;
  SavedLocation(
      {this.id,
      required this.name,
      required this.address,
      required this.placeId});

  @override
  List<Object?> get props => [name];

  factory SavedLocation.fromJson(Map<String, dynamic> json) {
    return SavedLocation(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        placeId: json['place_id']);
  }
  @override
  String toString() => 'SavedLocation {name: $name }';
}
