import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/rout.dart';

class SettingLocationDialog extends StatelessWidget {
  final LocationChangerArgument args;

  const SettingLocationDialog({Key? key, required this.args}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlaceDetailBloc, PlaceDetailState>(
      builder: (context, state) => Container(),
      listener: (context, state) {
        if (state is PlaceDetailLoadSuccess) {
          switch (args.fromWhere) {
            case "DroppOff":
              droppOffAddress = state.placeDetail.placeName;
              DirectionEvent event = DirectionLoadFromDiffrentPickupLocation(
                  pickup: args.pickupLocationLatLng,
                  destination:
                      LatLng(state.placeDetail.lat, state.placeDetail.lng));
              BlocProvider.of<DirectionBloc>(context).add(event);
              droppOffLatLng =
                  LatLng(state.placeDetail.lat, state.placeDetail.lng);
              break;
            case "PickUp":
              pickupAddress = state.placeDetail.placeName;
              pickupLatLng =
                  LatLng(state.placeDetail.lat, state.placeDetail.lng);

              DirectionEvent event = DirectionLoadFromDiffrentPickupLocation(
                  pickup: LatLng(state.placeDetail.lat, state.placeDetail.lng),
                  destination: args.droppOffLocationLatLng);
              BlocProvider.of<DirectionBloc>(context).add(event);

              break;
          }
          Navigator.pop(context);
          Navigator.pop(context);
        }
        if (state is PlaceDetailLoading) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
              content: Row(
                children: [
                  const Flexible(
                    flex: 1,
                    child:  SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  Flexible(flex: 5, child: Text(getTranslation(context, "settingup_pickup_message"),)),
                ], 
              ),
            );
              });
        }
      },
    );
  }
}
