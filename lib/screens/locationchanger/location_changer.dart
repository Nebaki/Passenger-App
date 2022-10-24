import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_place_picker/google_maps_place_picker.dart';

import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/locationchanger/setting_location_dialog.dart';
import '../../utils/place_picker/src/place_picker.dart';
import 'predicted_address-list.dart';

class LocationChanger extends StatelessWidget {
  static const routName = '/locationChanger';
  final LocationChangerArgument args;

  LocationChanger({Key? key, required this.args}) : super(key: key);
  final _textEdittingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    switch (args.fromWhere) {
      case 'DroppOff':
        _textEdittingController.text = args.droppOffLocationAddressName;

        break;
      case 'PickUp':
        _textEdittingController.text = args.pickupLocationAddressName;

        break;
      default:
    }
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 40),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 1)),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      // color: Colors.black,
                      icon: const Icon(Icons.clear))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              onChanged: (value) {
                findPlace(context, value);
              },
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        _textEdittingController.clear();
                      },
                      icon: const Icon(
                        Icons.clear,
                        // color: Colors.black,
                        size: 15,
                      )),
                  labelText: args.fromWhere == 'DroppOff'
                      ? getTranslation(context, "where_are_you_going")
                      : getTranslation(context, "pickup_address")),
              controller: _textEdittingController,
            ),
          ),
          ListTile(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PlacePicker(
                      apiKey: apiKey,
                      initialPosition: initialPosition,
                      useCurrentLocation: true,
                      selectInitialPosition: true,
                      onPlacePicked: (result) {
                        switch (args.fromWhere) {
                          case "DroppOff":
                            droppOffAddress = result.formattedAddress!;
                            DirectionEvent event =
                                DirectionLoadFromDiffrentPickupLocation(
                                    pickup: args.pickupLocationLatLng,
                                    destination: LatLng(
                                        result.geometry!.location.lat,
                                        result.geometry!.location.lng));
                            BlocProvider.of<DirectionBloc>(context).add(event);
                            droppOffLatLng = LatLng(
                                result.geometry!.location.lat,
                                result.geometry!.location.lng);
                            break;
                          case "PickUp":
                            pickupAddress = result.formattedAddress!;
                            pickupLatLng = LatLng(result.geometry!.location.lat,
                                result.geometry!.location.lng);

                            DirectionEvent event =
                                DirectionLoadFromDiffrentPickupLocation(
                                    pickup: LatLng(
                                        result.geometry!.location.lat,
                                        result.geometry!.location.lng),
                                    destination: args.droppOffLocationLatLng);
                            BlocProvider.of<DirectionBloc>(context).add(event);

                            break;
                        }

                        Navigator.of(context).pop();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              );
            },
            dense: true,
            horizontalTitleGap: 0,
            leading: const Icon(
              Icons.location_on,
            ),
            title: Text(getTranslation(context, "pick_location_from_map")),
          ),
          const Divider(),
          const PredictedItems(),
          SettingLocationDialog(
            args: args,
          )
        ],
      ),
    );
  }

  void findPlace(BuildContext context, String placeName) {
    if (placeName.length>=2) {
      LocationPredictionEvent event =
          LocationPredictionLoad(placeName: placeName);
      BlocProvider.of<LocationPredictionBloc>(context).add(event);
    }
  }
}
