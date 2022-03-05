

import 'dart:convert';

import 'location.dart';

class TripStore {
  late List<Trip> trips;
  TripStore({required this.trips});

  TripStore.fromJson(List<dynamic> parsedJson){
    trips = parsedJson.map((i) => Trip.fromJson(i)).toList();
    //return TripStore(trips: states);
  }
  String toJson() {
    String data = jsonEncode(trips.map((i) => i.toJson()).toList());
    return data;
  }
}
class Trip {
  Trip(this.id, this.start, this.end, this.price);
  late int id;
  late Location start;
  late Location end;
  late double price;

  Trip.fromJson(Map<String, dynamic> json){
    id = json['id'];
    start = Location.fromJson(json['start']);
    end = Location.fromJson(json['end']);
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start'] = start;
    data['end'] = end;
    data['price'] = price;
    return data;
  }
}