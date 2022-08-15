import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';

@immutable
class SavedLocation extends Equatable {
  final int? id;
  final String name;
  final String address;
  final String placeId;
  const SavedLocation(
      {this.id,
      required this.name,
      required this.address,
      required this.placeId});

  @override
  List<Object?> get props => [name];

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "id": id,
      "placeId": placeId,
      "name": name,
      "address": address
    };

    return map;
  }

  factory SavedLocation.fromJson(Map<String, dynamic> json) {
    return SavedLocation(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        placeId: json['placeId']);
  }
  @override
  String toString() => 'SavedLocation {name: $name }';
}
