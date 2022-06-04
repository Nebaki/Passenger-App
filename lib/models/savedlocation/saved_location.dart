import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';

@immutable
class SavedLocation extends Equatable {
  int? id;
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
