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

class WhereTo extends StatefulWidget {
  const WhereTo({Key? key}) : super(key: key);

  @override
  _WhereToState createState() => _WhereToState();
}

class _WhereToState extends State<WhereTo> {
  late String currentLocation = "Loading current location..";
  late LatLng destinationLtlng;
  final pickupController = TextEditingController();
  FocusNode pickupLocationNode = FocusNode();
  FocusNode droppOffLocationNode = FocusNode();
  @override
  void dispose() {
    pickupLocationNode.dispose();
    droppOffLocationNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.22,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.only(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.blue.shade600,
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
                          buttomSheet();
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
                        whereToClicked = true;
                        BlocProvider.of<LocationBloc>(context)
                            .add(const ReverseLocationLoad());
                      },
                      child: SizedBox(
                        height: 35,
                        width: 150,
                        child: Text(
                          getTranslation(context, "where_to"),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const Divider(),
          BlocBuilder<LocationHistoryBloc, LocationHistoryState>(
              builder: (context, state) {
            if (state is LocationHistoryLoadSuccess) {
              return SizedBox(
                height: 70,
                width: double.infinity,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (selectedCar != SelectedCar.none) {
                          getPlaceDetail(state.locationHistory[index].placeId);
                          settingDropOffDialog(true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(getTranslation(context,
                                  "location_not_determined_error_message"))));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor,
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
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                    state.locationHistory[index].mainText,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
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
                ),
              );
            }
            if (state is LocationHistoryLoading) {
              return Column(
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
              );
            }
            return Center(
                child: Text(getTranslation(
                    context, "recent_history_not_found_message")));
          }),
        ],
      ),
    );
  }

  void _buildReverseLocationLoadingDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return BlocBuilder(builder: ((context, state) {
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
                        strokeWidth: 1,
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
              Flexible(flex: 5, child: Text(location.address)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPredictedItem(LocationPrediction prediction) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
          // Navigator.pop(con);

          // getPlaceDetail(prediction.placeId);
          // LocationHistoryEvent event = LocationHistoryAdd(location: prediction);
          // BlocProvider.of<LocationHistoryBloc>(context).add(event);
          // settingDropOffDialog(con);
        },
        child: Container(
          color: Colors.black.withOpacity(0),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Flexible(
                  flex: 1,
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
                            color: isFav ? Colors.red : null,
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
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                        getTranslation(context, "settingup_dropp_off_message")),
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
              return WillPopScope(
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
                            strokeWidth: 1,
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
            }),
          );
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
                          padding: const EdgeInsets.only(top: 30, bottom: 22),
                          // height: 200,
                          constraints: const BoxConstraints(
                              maxHeight: 400, minHeight: 30),
                          color: Theme.of(context).backgroundColor,
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
                              left: 70,
                              right: 70,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 30, bottom: 22),
                                  // height: 200,
                                  constraints: const BoxConstraints(
                                      maxHeight: 400, minHeight: 30),
                                  color: Theme.of(context).backgroundColor,
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
                    left: 50,
                    right: 50,
                    top: 80,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            onChanged: (value) {
                              findPlace(value);
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
                                hintText: getTranslation(
                                    context, "pickup_address_hint_text"),
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
                          height: 60,
                          child: TextFormField(
                            focusNode: droppOffLocationNode,
                            onChanged: (value) {
                              findPlace(value);
                            },
                            decoration: InputDecoration(
                                hintText: getTranslation(
                                    context, "droppoff_address_hint_text"),
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.only(left: 20, right: 10),
                                  child: Icon(Icons.location_on,
                                      color: Colors.green),
                                ),
                                // fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none)),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          );

          // SearchScreen(
          //     args: SearchScreenArgument(
          //         currentLocation: currentLocation));
        });
  }
}
