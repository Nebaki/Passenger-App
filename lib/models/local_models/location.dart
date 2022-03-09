
class Location {
  Location(this.name, this.latitude, this.longitude);
  late String name;
  late double latitude;
  late double longitude;
  Location.fromJson(Map<String, dynamic> json){
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
