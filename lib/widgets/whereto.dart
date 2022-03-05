import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';

import '../models/models.dart';

class WhereTo extends StatefulWidget {
  final Function setIsSelected;
  final Function callback;
  final Widget service;
  WhereTo(
      {Key? key,
      required this.setIsSelected,
      required this.callback,
      required this.service})
      : super(key: key);

  @override
  _WhereToState createState() => _WhereToState();
}

class _WhereToState extends State<WhereTo> {
  late String currentLocation = "fdf";
  late LatLng destinationLtlng;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 3.0,
      left: 2.0,
      right: 2.0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        padding:
            const EdgeInsets.only(top: 10, left: 50, right: 50, bottom: 10),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: Offset(0, -4),
                  color: Colors.grey)
            ],
            color: const Color.fromRGBO(240, 241, 241, 1),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: InkWell(
                onTap: () {},
                child: BlocBuilder<LocationBloc, ReverseLocationState>(
                    builder: (context, state) {
                  if (state is ReverseLocationLoadSuccess) {
                    List addresses = state.location.address1.split(",");
                    currentLocation = addresses[1];
                    // return Text(addresses[0]);
                  }

                  return Container();
                }),
                // const Text(
                //   "Meskel Flower,Addis Ababa",
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontWeight: FontWeight.bold,
                //       fontSize: 16),
                // ),
              ),
            ),
            Icon(
              Icons.location_on,
              color: Colors.blue.shade600,
            ),
            const SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      enableDrag: true,
                      backgroundColor: Colors.white.withOpacity(0),
                      builder: (BuildContext context) {
                        return Stack(
                          children: [
                            BlocBuilder<LocationPredictionBloc,
                                    LocationPredictionState>(
                                builder: (context, state) {
                              if (state is LocationPredictionLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (state is LocationPredictionLoadSuccess) {
                                return Positioned(
                                  top: 180,
                                  left: 70,
                                  right: 70,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 30, bottom: 20),
                                      // height: 200,
                                      constraints: const BoxConstraints(
                                          maxHeight: 400, minHeight: 30),
                                      color: Colors.white,
                                      width: double.infinity,
                                      child: ListView.separated(
                                          physics:
                                              const ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (cont, index) {
                                            return _buildPredictedItem(
                                                state.placeList[index],
                                                context);
                                          },
                                          separatorBuilder: (context, index) =>
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                child: Divider(
                                                    color: Colors.black38),
                                              ),
                                          itemCount: state.placeList.length),
                                    ),
                                  ),
                                );

                                // SizedBox(
                                //   height:
                                //       MediaQuery.of(context).size.height -
                                //           260,
                                //   child: Container(
                                //     color: Colors.white,
                                //     child: ListView.separated(
                                //         physics:
                                //             const ClampingScrollPhysics(),
                                //         shrinkWrap: true,
                                //         itemBuilder: (context, index) {
                                //           return _buildPredictedItem(
                                //               state.placeList[index]);
                                //         },
                                //         separatorBuilder: (context,
                                //                 index) =>
                                //             const Padding(
                                //               padding:
                                //                   EdgeInsets.symmetric(
                                //                       horizontal: 40),
                                //               child: Divider(
                                //                   color: Colors.black38),
                                //             ),
                                //         itemCount:
                                //             state.placeList.length),
                                //   ),
                                // );
                              }

                              if (state
                                  is LocationPredictionOperationFailure) {}

                              return const Center(
                                child: Text("Enter The location"),
                              );
                            }),
                            Positioned(
                                left: 50,
                                right: 50,
                                top: 80,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      child: TextField(
                                        decoration: InputDecoration(
                                            label: Text(currentLocation),
                                            hintText: "PickUp Address",
                                            prefixIcon: const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 10),
                                              child: Icon(
                                                Icons.location_on,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            fillColor: Colors.white,
                                            filled: true,
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none)),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black38,
                                                blurRadius: 4,
                                                spreadRadius: 2,
                                                offset: Offset(0, 4))
                                          ]),
                                      height: 50,
                                      child: TextField(
                                        onChanged: (value) {
                                          findPlace(value);
                                        },
                                        decoration: InputDecoration(
                                            hintText: "DropOff Address",
                                            prefixIcon: const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 10),
                                              child: Icon(Icons.location_on,
                                                  color: Colors.green),
                                            ),
                                            fillColor: Colors.white,
                                            filled: true,
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none)),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        );

                        // SearchScreen(
                        //     args: SearchScreenArgument(
                        //         currentLocation: currentLocation));
                      });

                  // Navigator.pushNamed(context, SearchScreen.routeName,
                  //     arguments: SearchScreenArgument(
                  //         currentLocation: currentLocation));
                },
                child: SizedBox(
                  height: 35,
                  width: 150,
                  child: Text(
                    "Where To?",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictedItem(LocationPrediction prediction, con) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          getPlaceDetail(prediction.placeId);
          settingDropOffDialog(con);
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

  void getPlaceDetail(String placeId) {
    PlaceDetailEvent event = PlaceDetailLoad(placeId: placeId);
    BlocProvider.of<PlaceDetailBloc>(context).add(event);
  }

  void settingDropOffDialog(con) {
    showDialog(
        context: context,
        builder: (BuildContext cont) {
          return BlocBuilder<PlaceDetailBloc, PlaceDetailState>(
              builder: (conext, state) {
            if (state is PlaceDetailLoadSuccess) {
              DirectionEvent event = DirectionLoad(
                  destination:
                      LatLng(state.placeDetail.lat, state.placeDetail.lng));
              BlocProvider.of<DirectionBloc>(context).add(event);

              destinationLtlng =
                  LatLng(state.placeDetail.lat, state.placeDetail.lng);

              Future.delayed(Duration(seconds: 1), () {
                Navigator.pop(context);
                Navigator.pop(con);

                widget.setIsSelected(destinationLtlng);
                widget.callback(widget.service);

                // return Navigator.pushNamed(context, HomeScreen.routeName,
                //     arguments: HomeScreenArgument(
                //         isSelected: true,
                //         destinationlatlang: destinationLtlng));
              });
            }

            if (state is PlaceDetailOperationFailure) {
              // print(state);
              // print("Errorrrrrrrrrrrrrrrrr");
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red.shade900,
                  content: const Text("Unable To set the Dropoff.")));
            }
            return AlertDialog(
              content: Row(
                children: const [
                  CircularProgressIndicator(),
                  Text("Setting up Drop Off. Please wait")
                ],
              ),
            );
          });
        });
  }

  void findPlace(String placeName) {
    if (placeName.isNotEmpty) {
      LocationPredictionEvent event =
          LocationPredictionLoad(placeName: placeName);
      BlocProvider.of<LocationPredictionBloc>(context).add(event);
    }
  }
}
