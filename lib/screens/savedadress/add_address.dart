import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/placepicker/place_picker.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/widgets.dart';

import '../../bloc/bloc.dart';
import '../../models/models.dart';

class AddAddressScreen extends StatefulWidget {
  static const routeName = 'addaddress';
  final AddAdressScreenArgument args;

  AddAddressScreen({required this.args, Key? key}) : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  String? placeId;
  String? name;
  String? address;
  PickResult? selectedPlace;
  GlobalKey<FormState> _formState = GlobalKey<FormState>();

  @override
  void initState() {
    widget.args.edit ? placeId = widget.args.savedLocation!.placeId : null;
    widget.args.edit ? address = widget.args.savedLocation!.address : null;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<SavedLocationBloc, SavedLocationState>(
            builder: (context, state) => _buildScreen(),
            listener: (context, state) {
              if (state is SavedLocationsSuccess) {
                BlocProvider.of<SavedLocationBloc>(context)
                    .add(SavedLocationsLoad());
                Navigator.pushReplacementNamed(context, SavedAddress.routeName);
              }
            }));
  }

  void findPlace(String placeName) {
    if (placeName.isNotEmpty) {
      LocationPredictionEvent event =
          LocationPredictionLoad(placeName: placeName);
      BlocProvider.of<LocationPredictionBloc>(context).add(event);
    }
  }

  void getPlaceDetail(String placeId) {
    PlaceDetailEvent event = PlaceDetailLoad(placeId: placeId);
    BlocProvider.of<PlaceDetailBloc>(context).add(event);
  }

  Widget _buildScreen() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 80.0, left: 30, right: 90),
          child: ListView(
            children: [
              Form(
                key: _formState,
                child: TextFormField(
                  initialValue:
                      widget.args.edit ? widget.args.savedLocation!.name : null,
                  decoration: const InputDecoration(
                    label: Text('Name'),
                    // hintText: "Name",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black45),
                    fillColor: Colors.white,
                    // filled: true,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    name = value;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (value) {
                  findPlace(value);
                },
                initialValue: widget.args.edit
                    ? widget.args.savedLocation!.address
                    : selectedPlace != null
                        ? selectedPlace!.formattedAddress ?? ""
                        : "",
                decoration: const InputDecoration(
                  label: Text('Search Location'),

                  // hintText: "Name",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black45),
                  fillColor: Colors.white,
                  // filled: true,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter The Old password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return PlacePicker(
                                apiKey: apiKey,
                                initialPosition: initialPosition,
                                useCurrentLocation: true,
                                selectInitialPosition: true,

                                //usePlaceDetailSearch: true,
                                onPlacePicked: (result) {
                                  placeId = result.placeId;
                                  address = result.formattedAddress;
                                  selectedPlace = result;
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                                //forceSearchOnZoomChanged: true,
                                //automaticallyImplyAppBarLeading: false,
                                //autocompleteLanguage: "ko",
                                //region: 'au',
                                //selectInitialPosition: true,
                                // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
                                //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
                                //   return isSearchBarFocused
                                //       ? Container()
                                //       : FloatingCard(
                                //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                                //           leftPosition: 0.0,
                                //           rightPosition: 0.0,
                                //           width: 500,
                                //           borderRadius: BorderRadius.circular(12.0),
                                //           child: state == SearchingState.Searching
                                //               ? Center(child: CircularProgressIndicator())
                                //               : RaisedButton(
                                //                   child: Text("Pick Here"),
                                //                   onPressed: () {
                                //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                                //                     //            this will override default 'Select here' Button.
                                //                     print("do something with [selectedPlace] data");
                                //                     Navigator.of(context).pop();
                                //                   },
                                //                 ),
                                //         );
                                // },
                                // pinBuilder: (context, state) {
                                //   if (state == PinState.Idle) {
                                //     return Icon(Icons.favorite_border);
                                //   } else {
                                //     return Icon(Icons.favorite);
                                //   }
                                // },
                              );
                            },
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.black,
                      )),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text("Pick Location from map"),
                ],
              ),
              const Divider(),
              BlocBuilder<LocationPredictionBloc, LocationPredictionState>(
                  builder: (context, state) {
                if (state is LocationPredictionLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is LocationPredictionLoadSuccess) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      // height: 200,
                      constraints:
                          const BoxConstraints(maxHeight: 400, minHeight: 30),

                      width: double.infinity,
                      child: ListView.separated(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (cont, index) {
                            return _buildPredictedItem(
                                state.placeList[index], context);
                          },
                          separatorBuilder: (context, index) => const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(color: Colors.black38),
                              ),
                          itemCount: state.placeList.length),
                    ),
                  );
                }

                if (state is LocationPredictionOperationFailure) {}

                return const Center(
                  child: Text("Enter The location"),
                );
              }),
              BlocConsumer<PlaceDetailBloc, PlaceDetailState>(
                listener: (_, state) {
                  if (state is PlaceDetailLoadSuccess) {
                    print("Yeah Yeah it's succesfull");
                    setState(() {
                      placeId = state.placeDetail.placeId;
                      address = state.placeDetail.placeName;
                    });
                  }
                },
                builder: (_, state) {
                  return Container();
                },
              )
            ],
          ),
        ),
        CustomeBackArrow(),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
              onPressed: placeId != null
                  ? () {
                      final form = _formState.currentState;
                      if (form!.validate()) {
                        form.save();
                        print(placeId);
                        print(name);
                        print(address);

                        SavedLocationEvent event = widget.args.edit
                            ? SavedLocationUpdate(SavedLocation(
                                id: widget.args.savedLocation!.id,
                                name: name!,
                                address: address!,
                                placeId: placeId!))
                            : SavedLocationCreate(SavedLocation(
                                name: name!,
                                address: address!,
                                placeId: placeId!));
                        BlocProvider.of<SavedLocationBloc>(context).add(event);
                      }
                    }
                  : null,
              child: Text("Save")),
        )
      ],
    );
  }

  Widget _buildPredictedItem(LocationPrediction prediction, con) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          getPlaceDetail(prediction.placeId);
          // settingDropOffDialog(con);
          // LocationHistoryEvent event = LocationHistoryAdd(location: prediction);
          // BlocProvider.of<LocationHistoryBloc>(context).add(event);
        },
        child: Container(
          color: Colors.black.withOpacity(0),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 12,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(prediction.mainText),
            ],
          ),
        ),
      ),
    );
  }
}
