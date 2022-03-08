

import 'dart:convert';

import 'location.dart';

class TripStore {
  late List<Trip> trips;
  TripStore({required this.trips});

  TripStore.fromJson(List<dynamic> parsedJson){
    trips = parsedJson.map((i) => Trip.fromMap(i)).toList();
    //return TripStore(trips: states);
  }
  String toJson() {
    String data = jsonEncode(trips.map((i) => i.toJson()).toList());
    return data;
  }
}
class Trip {
  Trip({this.id, this.start, this.end, this.price});
   int? id;
   Location? start;
   Location? end;
   double? price;
   Trip.fromJson(Map<String,dynamic> json){
     id = json['id'];
     start = Location.fromJson(json['start']);
     end = Location.fromJson(json['end']);
     price = json['price'];
   }
  Trip.fromMap(Map<String, dynamic> map){
    id = map['id'];
    start = Location.fromJson(map['start']);
    end = Location.fromJson(map['end']);
    price = map['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start'] = start;
    data['end'] = end;
    data['price'] = price;
    return data;
  }
  Map<String, dynamic> toMap() {
    return {'id': id,'start': start,'end': end,'price': price};
  }
  @override
  String toString(){
    return 'Trip(id: $id, start: $start, end: $end, price: $price)';
  }

}