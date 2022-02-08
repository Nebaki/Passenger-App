import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class LocationPrediction extends Equatable {
  String mainText;
  String secondaryText;

  LocationPrediction({required this.mainText, required this.secondaryText});

  @override
  List<Object> get props => [mainText, secondaryText];

  factory LocationPrediction.fromJson(Map<String, dynamic> json) {
    return LocationPrediction(
        mainText: json["structured_formatting"]["main_text"],
        secondaryText: json["structured_formatting"]["secondary_text"]);
  }

  @override
  String toString() =>
      'Location {Main Text: $mainText, Secondary Text: $secondaryText }';
}
