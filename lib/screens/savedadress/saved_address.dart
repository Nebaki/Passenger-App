import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/bloc/database/location_history_bloc.dart';
import 'package:passengerapp/cubit/favorite_location.dart';
import 'package:passengerapp/cubit/favorite_location_state.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/widgets.dart';
import 'package:shimmer/shimmer.dart';
import '../home/assistant/home_screen_assistant.dart';

class SavedAddress extends StatelessWidget {
  static const routeName = "/savedadresses";

  const SavedAddress({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: BlocBuilder<FavoriteLocationCubit, FavoriteLocationState>(
                builder: (context, state) {
              if (state is FavoriteLocationLoadSuccess) {
                return state.savedLocation.isEmpty
                    ? Container()
                    : Container(
                        padding: const EdgeInsets.only(top: 80),
                        child: Column(
                          children: [
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                height: MediaQuery.of(context).size.height - 80,
                                child: ListView.builder(
                                    itemCount: state.savedLocation.length,
                                    itemBuilder: (context, index) {
                                      return Dismissible(
                                          direction:
                                              DismissDirection.horizontal,
                                          background: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFE6E6),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Row(
                                              children: const [
                                                Icon(
                                                  Icons.edit,
                                                  color: Colors.redAccent,
                                                ),
                                                Spacer(),
                                                Icon(
                                                  Icons.delete_outlined,
                                                  color: Colors.redAccent,
                                                )
                                              ],
                                            ),
                                          ),
                                          confirmDismiss: (direction) async {
                                            if (direction ==
                                                DismissDirection.startToEnd) {
                                              Navigator.pushNamed(context,
                                                  AddAddressScreen.routeName,
                                                  arguments:
                                                      AddAdressScreenArgument(
                                                          edit: true,
                                                          savedLocation: state
                                                                  .savedLocation[
                                                              index]));
                                              return false;
                                            }
                                            if (direction ==
                                                DismissDirection.endToStart) {
                                              return true;
                                            }
                                            return null;
                                          },
                                          onDismissed: (DismissDirection d) {
                                            if (d ==
                                                DismissDirection.endToStart) {
                                              context
                                                  .read<FavoriteLocationCubit>()
                                                  .deleteFavoriteLocation(state
                                                      .savedLocation[index]!
                                                      .id!);
                                              state.savedLocation
                                                  .removeAt(index);
                                            }
                                          },
                                          key: const Key("item."),
                                          child: _builHistoryCard(context,
                                              state.savedLocation[index]));
                                    }))
                          ],
                        ),
                      );
              }
              if (state is FavoriteLocationOperationFailure) {
                return Container();
              }
              return _buildShimmer(context);
            }),
          ),
          const CustomeBackArrow(),
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AddAddressScreen.routeName,
                      arguments: AddAdressScreenArgument(edit: false));
                },
                icon: const Icon(
                  Icons.add,
                  // color: Colors.black,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  getTranslation(context, "saved_addresses"),
                  style: Theme.of(context).textTheme.titleLarge,
                )),
          )
        ],
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height - 80,
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).backgroundColor,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.white,
                                      child: Container(
                                        width: 50,
                                        height: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.white,
                                      child: Container(
                                          width: 130,
                                          height: 15,
                                          color: Colors.grey),
                                    )
                                  ],
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                      height: 30,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      color:
                                          const Color.fromRGBO(244, 201, 60, 1),
                                      child: const Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 15,
                                      )),
                                ),
                              ],
                            ),
                            const Divider(),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }

  Widget _builHistoryCard(BuildContext context, SavedLocation? location) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          _showModaLButtomSheet(context, location!);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).backgroundColor,
              boxShadow: [
                BoxShadow(
                    blurStyle: BlurStyle.normal,
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    spreadRadius: 2)
              ]),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          location!.name,
                          style: Theme.of(context).textTheme.overline,
                        ),
                        Text(
                          location.address,
                          style: Theme.of(context).textTheme.subtitle1,
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          color: const Color.fromRGBO(244, 201, 60, 1),
                          child: const Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 15,
                          )),
                    ),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _showModaLButtomSheet(BuildContext context, SavedLocation location) {
    showModalBottomSheet(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
            minWidth: MediaQuery.of(context).size.width,
            maxWidth: MediaQuery.of(context).size.width),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(top: 30, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(getTranslation(context, "saved_locations_title"),
                    style: Theme.of(context).textTheme.titleLarge),
                const Divider(),
                SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () {
                          getPlaceDetail(location.placeId, context);
                          settingDropOffDialog(context);

                          LocationHistoryEvent event = LocationHistoryAdd(
                              location: LocationPrediction(
                                  placeId: location.placeId,
                                  mainText: location.name,
                                  secondaryText: location.address));
                          BlocProvider.of<LocationHistoryBloc>(context)
                              .add(event);
                        },
                        child: Row(
                          children: [
                            Text(getTranslation(context,
                                "saved_locations_bottom_rideto_action")),
                          ],
                        ))),
                TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(
                          context, AddAddressScreen.routeName,
                          arguments: AddAdressScreenArgument(
                              edit: true, savedLocation: location));
                    },
                    child: Row(
                      children: [
                        Text(getTranslation(
                            context, "saved_locations_bottom_edit_action")),
                      ],
                    )),
              ],
            ),
          );
        });
  }

  void getPlaceDetail(String placeId, BuildContext context) {
    PlaceDetailEvent event = PlaceDetailLoad(placeId: placeId);
    BlocProvider.of<PlaceDetailBloc>(context).add(event);
  }

  void settingDropOffDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext cont) {
          return WillPopScope(
            onWillPop: () async => false,
            child: BlocBuilder<PlaceDetailBloc, PlaceDetailState>(
                builder: (context, state) {
              if (state is PlaceDetailLoadSuccess) {
                droppOffAddress = state.placeDetail.placeName;
                DirectionEvent event = DirectionLoad(
                    destination:
                        LatLng(state.placeDetail.lat, state.placeDetail.lng));
                BlocProvider.of<DirectionBloc>(context).add(event);

                droppOffLatLng =
                    LatLng(state.placeDetail.lat, state.placeDetail.lng);

                WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                  showCarIcons = false;
                  context
                      .read<CurrentWidgetCubit>()
                      .changeWidget(const Service(false, false));

                  Navigator.pop(cont);
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              }

              if (state is PlaceDetailOperationFailure) {
                Navigator.pop(context);

                WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
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
                      Text(getTranslation(
                          context, "settingup_dropp_off_message")),
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }
}
