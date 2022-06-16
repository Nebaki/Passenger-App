import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class Review extends Equatable {
  final String? id;
  final String description;
  final double rating;

  const Review({this.id, required this.description, required this.rating});

  @override
  List<Object?> get props => [
        id,
        description,
        rating,
      ];

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json["reviews"]["id"],
      description: json["passenger"]["name"],
      rating: json["reviews"]["email"],
    );
  }

  @override
  String toString() => 'Review {description: $description }';
}
