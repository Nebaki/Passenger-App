import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../models/map/location_prediction.dart';
class PredictionTile extends StatelessWidget {
  final String mapKey = "AIzaSyBiN3WdGwl7XJXMO_J7mpwzzK6iWFEWsIQ";
  //final PlacePredictions? placePredictions;
  final LocationPrediction? locationPrediction;
  const PredictionTile({Key? key, /*this.placePredictions, */this.locationPrediction}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        /*getPlaceAddressDetails(
            (placePredictions?.place_id).toString(), context);
        */
      },
      child: Column(
        children: [
          const SizedBox(
            width: 10.0,
          ),
          Row(
            children: [
              const Icon(Icons.add_location),
              const SizedBox(
                width: 14.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      (locationPrediction?.mainText).toString(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      (locationPrediction?.secondaryText).toString(),
                      overflow: TextOverflow.ellipsis,
                      style:
                      const TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 10.0),
        ],
      ),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            ProgressDialog(message: "Setting Dropoff..."));
    String placeDetailUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    var res = await RequestAssistant.getRequest(placeDetailUrl);
    Navigator.pop(context);
    if (res == "failed") {
      return;
    }
    if (res["status"] == "OK") {
      Address address = Address();
      address.placeName = res["result"]["name"];
      address.placeId = placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];
      Provider.of<AppData>(context, listen: false)
          .updateDropOffLocationAddress(address);
      Navigator.pop(context, "obtainDirection");
    }
  }
}
class PlacePredictions {
  String? place_id;
  String? main_text;
  String? secondary_text;
  PlacePredictions({this.place_id, this.main_text, this.secondary_text});
  PlacePredictions.fromJson(Map<String, dynamic> json) {
    place_id = json["place_id"];
    main_text = json["structured_formatting"]["main_text"];
    secondary_text = json["structured_formatting"]["secondary_text"];
  }
}

class ProgressDialog extends StatelessWidget {
  String message;
  ProgressDialog({required this.message});
  //const ProgressDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.yellow,
      child: Container(
        margin: const EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(6.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(
                width: 6.0,
              ),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
              const SizedBox(
                width: 26.0,
              ),
              Text(
                message,
                style: const TextStyle(color: Colors.black, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RequestAssistant {
  static Future<dynamic> getRequest(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        String jsonData = response.body;
        var decodeData = jsonDecode(jsonData);
        return decodeData;
      } else {
        return "Failed, no response";
      }
    } catch (exp) {
      return "Failed";
    }
  }
}
class Address {
  String? placeFormattedAddress;
  String? placeName;
  String? placeId;
  double? latitude;
  double? longitude;

  Address(
      {this.placeId,
        this.placeFormattedAddress,
        this.placeName,
        this.latitude,
        this.longitude});
}


class AppData extends ChangeNotifier {
  Address pickUpLocation = Address();
  Address dropOfLocation = Address();
  void updatePickUpLocationAddress(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropOffAddress) {
    dropOfLocation = dropOffAddress;
    notifyListeners();
  }
}

class DividerWidget extends StatelessWidget {
  const DividerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1.0,
      color: Colors.black12,
      thickness: 1.0,
    );
  }
}
