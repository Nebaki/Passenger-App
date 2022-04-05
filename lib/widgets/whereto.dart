import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/bloc/database/location_history_bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';

import '../models/models.dart';

class WhereTo extends StatefulWidget {
  final Function setIsSelected;
  final Function callback;
  final Widget service;
  final Function setPickUpAdress;
  final Function setDroppOffAdress;
  WhereTo(
      {Key? key,
      required this.setPickUpAdress,
      required this.setDroppOffAdress,
      required this.setIsSelected,
      required this.callback,
      required this.service})
      : super(key: key);

  @override
  _WhereToState createState() => _WhereToState();
}

class _WhereToState extends State<WhereTo> {
  late String currentLocation = "Loading current location..";
  late LatLng destinationLtlng;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 3.0,
      left: 2.0,
      right: 2.0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.22,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: Offset(0, -4),
                  color: Colors.grey)
            ],
            color: Color.fromRGBO(240, 241, 241, 1),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
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
                          widget.setPickUpAdress(currentLocation);

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
                        buttomSheet();
                        print("ddffdfffffffffffffffffffffffffff");

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
            const Divider(),
            BlocBuilder<LocationHistoryBloc, LocationHistoryState>(
                builder: (_, state) {
              print("hey i'm trying $state");
              if (state is LocationHistoryLoadSuccess) {
                print("Succccccccccccccccccccccccccccesssssss");
                print(state.locationHistory[0]);
                return SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          getPlaceDetail(state.locationHistory[index].placeId);
                          settingDropOffDialog(null);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 221, 218, 218),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        blurStyle: BlurStyle.outer,
                                        color: Colors.grey,
                                        blurRadius: 3,
                                        spreadRadius: 2)
                                  ]),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.locationHistory[index].mainText,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Text(state
                                      .locationHistory[index].secondaryText)
                                ],
                              )),
                        ),
                      );
                    },
                    itemCount: state.locationHistory.length,
                    separatorBuilder: (context, index) {
                      return VerticalDivider();
                    },
                  ),
                );
              }
              if (state is LocationHistoryLoading) {
                return Column(
                  children: const [
                    Text("Loading recent histories.."),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: LinearProgressIndicator(
                        minHeight: 2,
                      ),
                    ),
                  ],
                );
              }
              return Center(child: Text("No recent history"));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictedItem(LocationPrediction prediction, BuildContext con) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          // Navigator.pop(con);

          getPlaceDetail(prediction.placeId);
          LocationHistoryEvent event = LocationHistoryAdd(location: prediction);
          BlocProvider.of<LocationHistoryBloc>(context).add(event);
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

  void settingDropOffDialog(BuildContext? con) {
    showDialog(
        context: context,
        builder: (BuildContext cont) {
          return BlocBuilder<PlaceDetailBloc, PlaceDetailState>(
              builder: (_, state) {
            if (state is PlaceDetailLoadSuccess) {
              widget.setDroppOffAdress(state.placeDetail.placeName);

              DirectionEvent event = DirectionLoad(
                  destination:
                      LatLng(state.placeDetail.lat, state.placeDetail.lng));
              BlocProvider.of<DirectionBloc>(context).add(event);

              destinationLtlng =
                  LatLng(state.placeDetail.lat, state.placeDetail.lng);
              droppOffLatLng = destinationLtlng;
              print("Hey trying to pop the context around here::");

              Future.delayed(Duration(seconds: 1), () {
                widget.setIsSelected(destinationLtlng);
                widget.callback(widget.service);
                // Navigator.pop(cont);
                Navigator.pop(_);

                if (con != null) {
                  Navigator.pop(con);
                }

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

  void buttomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        enableDrag: true,
        backgroundColor: Colors.white.withOpacity(0),
        builder: (BuildContext context) {
          return Stack(
            children: [
              BlocBuilder<LocationPredictionBloc, LocationPredictionState>(
                  builder: (_, state) {
                if (state is LocationPredictionLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is LocationPredictionLoadSuccess) {
                  return Positioned(
                    top: 180,
                    left: 70,
                    right: 70,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.only(top: 30, bottom: 20),
                        // height: 200,
                        constraints:
                            const BoxConstraints(maxHeight: 400, minHeight: 30),
                        color: Colors.white,
                        width: double.infinity,
                        child: ListView.separated(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (_, index) {
                              return _buildPredictedItem(
                                  state.placeList[index], context);
                            },
                            separatorBuilder: (context, index) => const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Divider(color: Colors.black38),
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

                if (state is LocationPredictionOperationFailure) {}

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
                                padding: EdgeInsets.only(left: 20, right: 10),
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                ),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
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
                                padding: EdgeInsets.only(left: 20, right: 10),
                                child: Icon(Icons.location_on,
                                    color: Colors.green),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
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
  }
}
