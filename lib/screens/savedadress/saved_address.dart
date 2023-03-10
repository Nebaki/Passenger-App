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
import '../../utils/waver.dart';
import '../home/assistant/home_screen_assistant.dart';

class SavedAddress extends StatelessWidget {
  static const routeName = "/savedadresses";
  final _appBar = GlobalKey<FormState>();

  SavedAddress({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SafeAppBar(
          key: _appBar, title: getTranslation(context, "saved_addresses"),
          appBar: AppBar(), widgets: [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AddAddressScreen.routeName,
                  arguments: AddAdressScreenArgument(edit: false));
            },
            icon: const Icon(
              Icons.add,
               color: Colors.white,
            )),
      ]),
      body: Stack(
        children: [
          Center(
            child: BlocBuilder<FavoriteLocationCubit, FavoriteLocationState>(
                builder: (context, state) {
              if (state is FavoriteLocationLoadSuccess) {
                return state.savedLocation.isEmpty
                    ? Container()
                    : Container(
                        padding: const EdgeInsets.only(top: 00),
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
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                    })
                      );
              }
              if (state is FavoriteLocationOperationFailure) {
                return Container();
              }
              return //_buildShimmer(context)
              const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 40),
                  child: CircularProgressIndicator(),
                ),
              );
            }),
          ),
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
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            _showModalBottomSheet(context, location!);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                ),
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
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              location!.name,
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              location.address,
                            ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context, SavedLocation location) {
    showModalBottomSheet(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.15),
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
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
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
                                  "saved_locations_bottom_rideto_action"),
                                style: const TextStyle(fontSize: 16),),
                            ],
                          )),
                      const VerticalDivider(),
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
                                  context, "saved_locations_bottom_edit_action"),
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          )),
                    ],
                  ),
                ),
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

                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
