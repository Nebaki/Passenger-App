import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/bloc/database/location_history_bloc.dart';
import 'package:passengerapp/cubit/favorite_location.dart';
import 'package:passengerapp/cubit/favorite_location_state.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/screens/home/assistant/home_screen_assistant.dart';
import 'package:passengerapp/widgets/serviceType/service_type.dart';
import '../models/models.dart';
import '../screens/locationchanger/predicted_places.dart';

class WhereTo extends StatefulWidget {
  const WhereTo({Key? key}) : super(key: key);

  @override
  _WhereToState createState() => _WhereToState();
}

class _WhereToState extends State<WhereTo> {
  late String currentLocation = "Loading current location..";
  late LatLng destinationLtlng;
  final pickupController = TextEditingController();
  final dropOffController = TextEditingController();
  FocusNode pickupLocationNode = FocusNode();
  FocusNode droppOffLocationNode = FocusNode();

  @override
  void dispose() {
    pickupLocationNode.dispose();
    droppOffLocationNode.dispose();
    super.dispose();
  }

  Padding _whereToUi() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6.0),
          const Text(
            "Hi there,",
            style: TextStyle(fontSize: 12.0),
          ),
          const Text(
            "Where to?",
            style: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),
          ),
          const SizedBox(height: 10.0),
          BlocBuilder<LocationBloc, ReverseLocationState>(
              builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(top: 15),
              child: GestureDetector(
                onTap: () {
                  if (state is ReverseLocationLoadSuccess) {
                    pickupLatLng =
                        LatLng(userPostion.latitude, userPostion.longitude);
                    bottomSheet();
                    pickupAddress = state.location.address1;
                    currentLocation = state.location.address1;
                    pickupController.text = state.location.address1;
                    pickupAddress = currentLocation;
                  }
                  if (state is ReverseLocationLoading) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(getTranslation(
                            context, "determining_current_location"))));
                  }
                  if (state is ReverseLocationOperationFailure) {
                    context
                        .read<LocationBloc>()
                        .add(const ReverseLocationLoad());
                    _buildReverseLocationLoadingDialog();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 6.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.search,
                          color: Colors.blueAccent,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text("Search Drop Off")
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          /*GestureDetector(
            onTap: () async {
              */ /*Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchScreen()));
              */ /*
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 6.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: const [
                    Icon(
                      Icons.search,
                      color: Colors.blueAccent,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text("Search Drop Off")
                  ],
                ),
              ),
            ),
          ),*/
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Padding _whereToNative() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.search,
                size: 35,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            BlocBuilder<LocationBloc, ReverseLocationState>(
                builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(top: 15),
                child: InkWell(
                  onTap: () {
                    if (state is ReverseLocationLoadSuccess) {
                      pickupLatLng =
                          LatLng(userPostion.latitude, userPostion.longitude);
                      bottomSheet();
                      pickupAddress = state.location.address1;
                      currentLocation = state.location.address1;
                      pickupController.text = state.location.address1;
                      pickupAddress = currentLocation;
                    }
                    if (state is ReverseLocationLoading) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(getTranslation(
                              context, "determining_current_location"))));
                    }
                    if (state is ReverseLocationOperationFailure) {
                      context
                          .read<LocationBloc>()
                          .add(const ReverseLocationLoad());
                      _buildReverseLocationLoadingDialog();
                    }
                  },
                  child: SizedBox(
                    height: 35,
                    width: 150,
                    child: Text(getTranslation(context, "where_to"),
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 20)),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [
          BlocConsumer<LocationBloc, ReverseLocationState>(
              builder: (context, state) => Container(),
              listener: (context, state) {
                if (state is ReverseLocationLoadSuccess) {
                  pickupAddress = state.location.address1;
                }
              }),
          //_whereToNative(),
          _whereToUi(),
          const Divider(),
          BlocBuilder<LocationHistoryBloc, LocationHistoryState>(
              builder: (context, state) {
            if (state is LocationHistoryLoadSuccess) {
              return SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: _predictedPlaces(state)
                  //child: _predictedPlace(state)
                  );
            }
            if (state is LocationHistoryLoading) {
              /*return Column(
                children: [
                  Text(getTranslation(
                      context, "location_history_loading_message")),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: LinearProgressIndicator(
                      minHeight: 2,
                    ),
                  ),
                ],
              );*/
              return Container();
            }
            return Center(
                child: Text(getTranslation(
                    context, "recent_history_not_found_message")));
          }),
        ],
      ),
    );
  }

  _predictedPlace(LocationHistoryLoadSuccess state) {
    return ListView.separated(
      padding: const EdgeInsets.all(0.0),
      itemBuilder: (context, index) {
        return PredictionTile(
          //placePredictions: placePredictionList[index],
          locationPrediction: state.locationHistory[index],
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          const DividerWidget(),
      itemCount: state.locationHistory.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
    );
  }

  _predictedPlaces(LocationHistoryLoadSuccess state) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (selectedCar != SelectedCar.none) {
              getPlaceDetail(state.locationHistory[index].placeId);
              settingDropOffDialog(true);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(getTranslation(
                      context, "location_not_determined_error_message"))));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          blurStyle: BlurStyle.outer,
                          color: Colors.grey,
                          blurRadius: 3,
                          spreadRadius: 2)
                    ]),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        state.locationHistory[index].mainText,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    Text(state.locationHistory[index].secondaryText)
                  ],
                )),
          ),
        );
      },
      itemCount: state.locationHistory.length,
      separatorBuilder: (context, index) {
        return const VerticalDivider();
      },
    );
  }

  void _buildReverseLocationLoadingDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return BlocBuilder<LocationBloc, ReverseLocationState>(
              builder: ((context, state) {
            if (state is ReverseLocationLoadSuccess) {
              Navigator.pop(context);
            }
            if (state is ReverseLocationOperationFailure) {
              Navigator.pop(context);
            }
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                content: Row(
                  children: [
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(getTranslation(
                        context, "current_location_loading_message")),
                  ],
                ),
              ),
            );
          }));
        });
  }

  Widget _buildFavoriteLocations(SavedLocation location) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          getPlaceDetail(location.placeId);
          settingDropOffDialog(false);
          LocationHistoryEvent event = LocationHistoryAdd(
              location: LocationPrediction(
                  placeId: location.placeId,
                  mainText: location.name,
                  secondaryText: location.address));
          BlocProvider.of<LocationHistoryBloc>(context).add(event);
        },
        child: Container(
          color: Colors.black.withOpacity(0),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              //favorite item
              Flexible(flex: 5, child: Text(location.address)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPredictedItem(LocationPrediction prediction) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: GestureDetector(
        onTap: () {
          if (droppOffLocationNode.hasFocus) {
            getPlaceDetail(prediction.placeId);
            LocationHistoryEvent event =
                LocationHistoryAdd(location: prediction);
            BlocProvider.of<LocationHistoryBloc>(context).add(event);
            settingDropOffDialog(false);
          } else if (pickupLocationNode.hasFocus) {
            getPlaceDetail(prediction.placeId);
            settingPickupDialog();

            pickupLocationNode.nextFocus();

            pickupController.text = prediction.mainText;

            pickupAddress = prediction.mainText;
          }
        },
        child: Container(
          color: Colors.black.withOpacity(0),
          height: 40,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Flexible(
                  flex: 0,
                  child:
                      BlocBuilder<FavoriteLocationCubit, FavoriteLocationState>(
                    builder: ((context, state) {
                      if (state is FavoriteLocationLoadSuccess) {
                        bool isFav = false;
                        if (state.savedLocation.isNotEmpty) {
                          isFav = state.savedLocation
                              .where((element) =>
                                  element!.placeId == prediction.placeId)
                              .isNotEmpty;
                        }

                        return IconButton(
                          onPressed: () {
                            isFav
                                ? context
                                    .read<FavoriteLocationCubit>()
                                    .deleteFavoriteLocationByPlaceId(
                                        prediction.placeId)
                                : addToSavedLocaitons(prediction);
                          },
                          icon: Icon(
                            isFav
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            size: 20,
                            color: isFav
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                        );
                      }
                      return IconButton(
                        onPressed: () {
                          // addToSavedLocaitons(prediction);
                        },
                        icon: const Icon(
                          Icons.favorite_border_outlined,
                          size: 20,
                        ),
                      );
                    }),
                  )),
              const SizedBox(
                width: 10,
              ),
              //prediction item
              Flexible(flex: 5, child: Text(prediction.mainText)),
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

  void addToSavedLocaitons(LocationPrediction prediction) {
    context.read<FavoriteLocationCubit>().addToFavoriteLocation(SavedLocation(
        name: "Favorite",
        address: prediction.mainText,
        placeId: prediction.placeId));
  }

  void _changePlaceDetailBlocToInitialState() {
    context
        .read<LocationPredictionBloc>()
        .add(LocationPredicationChangeToInitalState());
  }

  void settingPickupDialog() {
    showDialog(
        context: context,
        builder: (BuildContext cont) {
          return WillPopScope(
            onWillPop: () async => false,
            child: BlocBuilder<PlaceDetailBloc, PlaceDetailState>(
                builder: (context, state) {
              if (state is PlaceDetailLoadSuccess) {
                pickupLatLng =
                    LatLng(state.placeDetail.lat, state.placeDetail.lng);
                _changePlaceDetailBlocToInitialState();
                Navigator.pop(context);
              }

              if (state is PlaceDetailOperationFailure) {
                Navigator.pop(context);

                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red.shade900,
                      content: Text(getTranslation(
                          context, "settingup_pickup_failure_message"))));
                });
              }
              return AlertDialog(
                content: Row(
                  children: [
                    const Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Flexible(
                        flex: 5,
                        child: Text(getTranslation(
                            context, "settingup_dropp_off_message"))),
                  ],
                ),
              );
            }),
          );
        });
  }

  void settingDropOffDialog(bool isFromResentHisotry) {
    showDialog(
        context: context,
        builder: (BuildContext cont) {
          return WillPopScope(
            onWillPop: () async => false,
            child: BlocBuilder<PlaceDetailBloc, PlaceDetailState>(
                builder: (context, state) {
              if (state is PlaceDetailLoadSuccess) {
                droppOffAddress = state.placeDetail.placeName;
                if (isFromResentHisotry) {
                  DirectionEvent event = DirectionLoad(
                      destination:
                          LatLng(state.placeDetail.lat, state.placeDetail.lng));
                  BlocProvider.of<DirectionBloc>(context).add(event);
                } else {
                  DirectionEvent event =
                      DirectionLoadFromDiffrentPickupLocation(
                          pickup: pickupLatLng,
                          destination: LatLng(
                              state.placeDetail.lat, state.placeDetail.lng));
                  BlocProvider.of<DirectionBloc>(context).add(event);
                }

                destinationLtlng =
                    LatLng(state.placeDetail.lat, state.placeDetail.lng);
                droppOffLatLng = destinationLtlng;

                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  showCarIcons = false;
                  droppOffLatLng = destinationLtlng;
                  context
                      .read<CurrentWidgetCubit>()
                      .changeWidget(const Service(false, false));

                  Navigator.pop(cont);
                  _changePlaceDetailBlocToInitialState();

                  !isFromResentHisotry ? Navigator.pop(context) : null;
                });
              }

              if (state is PlaceDetailOperationFailure) {
                Navigator.pop(context);

                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red.shade900,
                      content: Text(getTranslation(
                          context, "settingup_dropp_off_failure_message"))));
                });
              }
              /*return WillPopScope(
                onWillPop: () async => false,
                child: AlertDialog(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Flexible(
                        flex: 1,
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        child: Text(getTranslation(
                            context, "settingup_dropp_off_message")),
                      ),
                    ],
                  ),
                ),
              );
              */
              return Container();
            }),
          );
        });
  }

  void findPlace(String placeName) {
    if (placeName.length >= 2) {
      LocationPredictionEvent event =
          LocationPredictionLoad(placeName: placeName);
      BlocProvider.of<LocationPredictionBloc>(context).add(event);
    }
  }

  void bottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        enableDrag: true,
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              _changePlaceDetailBlocToInitialState();
              return true;
            },
            child: Stack(
              children: [
                BlocBuilder<LocationPredictionBloc, LocationPredictionState>(
                    builder: (context, state) {
                  if (state is LocationPredictionLoading) {
                    //return const Center(child: CircularProgressIndicator());
                    return Container();
                  }
                  if (state is LocationPredictionLoadSuccess) {
                    return Positioned(
                      top: 180,
                      left: 1,
                      right: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.only(top: 30, bottom: 22),
                          // height: 200,
                          constraints: const BoxConstraints(
                              maxHeight: 400, minHeight: 30),
                          color: Colors.white,
                          width: double.infinity,
                          child: ListView.separated(
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return _buildPredictedItem(
                                    state.placeList[index]);
                              },
                              separatorBuilder: (context, index) =>
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Divider(color: Colors.black38),
                                  ),
                              itemCount: state.placeList.length),
                        ),
                      ),
                    );
                  }

                  if (state is LocationPredictionOperationFailure) {}

                  return BlocBuilder<FavoriteLocationCubit,
                      FavoriteLocationState>(builder: ((context, state) {
                    if (state is FavoriteLocationLoadSuccess) {
                      return state.savedLocation.isNotEmpty
                          ? Positioned(
                              top: 180,
                              left: 15,
                              right: 15,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 30, bottom: 22),
                                  // height: 200,
                                  constraints: const BoxConstraints(
                                      maxHeight: 400, minHeight: 30),
                                  color: Colors.white,
                                  width: double.infinity,
                                  child: ListView.separated(
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return _buildFavoriteLocations(
                                            state.savedLocation[index]!);
                                      },
                                      separatorBuilder: (context, index) =>
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child:
                                                Divider(color: Colors.black38),
                                          ),
                                      itemCount: state.savedLocation.length),
                                ),
                              ),
                            )
                          : Container();
                    }
                    return Container();
                  }));
                }),
                Positioned(
                    left: 0,
                    right: 0,
                    top: 40,
                    child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(children: _inputChildren()),
                        )
                    )),
              ],
            ),
          );
        });
  }

  _inputChildren() {
    return [
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
              )
            ]),
        height: 60,
        child: Center(
          child: TextFormField(
            onChanged: (value) {
              if (value.length >= 2) {
                findPlace(value);
              }
            },
            style: const TextStyle(fontSize: 18),
            focusNode: pickupLocationNode,
            controller: pickupController,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      pickupController.clear();
                    },
                    icon: const Icon(
                      Icons.clear,
                      size: 15,
                    )),
                labelText: getTranslation(context, "pickup_address_hint_text"),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 20, right: 10),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.blue,
                  ),
                ),
                // fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none)),
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
              )
            ]),
        height: 60,
        child: Center(
          child: TextFormField(
            controller: dropOffController,
            autofocus: true,
            focusNode: droppOffLocationNode,
            onChanged: (value) {
              if (value.length >= 2) {
                findPlace(value);
              }
            },
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      dropOffController.clear();
                    },
                    icon: const Icon(
                      Icons.clear,
                      size: 15,
                    )),
                labelText: getTranslation(context, "droppoff_address_hint_text"),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 20, right: 10),
                  child: Icon(Icons.location_on, color: Colors.green),
                ),
                // fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none)),
          ),
        ),
      ),
    ];
  }

  _inputChildrenX() {
    return [
      const SizedBox(height: 5.0),
      Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back,color: Colors.black,),
          ),
          const Center(
            child: Text(
              "Enter Destination",
              style: TextStyle(fontSize: 18.0, fontFamily: "Brand-Bold"),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16.0),
      Row(
        children: [
          //Image.asset("/assets/images/pickicon.png", height: 16.0, width: 16.0),
          const Icon(Icons.location_on, color: Colors.blue),
          const SizedBox(width: 18.0),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextField(
                  onChanged: (val) {
                    if (val.length >= 2) {
                      findPlace(val);
                    }
                  },
                  focusNode: pickupLocationNode,
                  controller: pickupController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          pickupController.clear();
                        },
                        icon: const Icon(
                          Icons.clear,
                          size: 15,
                        )),
                    hintText:
                        getTranslation(context, "pickup_address_hint_text"),
                    fillColor: Colors.white,
                    filled: true,
                    //focusColor: Colors.grey[400],
                    //focusedBorder: InputBorder.none,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(style: BorderStyle.solid)
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.only(
                        left: 11.0, top: 8.0, bottom: 8.0),

                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10.0),
      Row(
        children: [
          //Image.asset("images/desticon.png", height: 16.0, width: 16.0),
          const Icon(Icons.location_on, color: Colors.green),
          const SizedBox(width: 18.0),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextField(
                  onChanged: (val) {
                    if (val.length >= 2) {
                      findPlace(val);
                    }
                  },
                  focusNode: droppOffLocationNode,
                  decoration: InputDecoration(
                    hintText:
                        getTranslation(context, "where_to") + "?",
                    fillColor: Colors.white,
                    filled: true,
                    border: InputBorder.none,
                    isDense: true,
                    //focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                        left: 11.0, top: 8.0, bottom: 8.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ];
  }
}
