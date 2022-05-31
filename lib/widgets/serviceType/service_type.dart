import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/bloc/notificationrequest/notification_request_bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/repository/nearby_driver.dart';
import 'package:passengerapp/screens/home/assistant/home_screen_assistant.dart';
import 'package:passengerapp/widgets/serviceType/category_list.dart';
import 'package:passengerapp/widgets/widgets.dart';

class Service extends StatefulWidget {
  final bool ignoreLastDrivers;
  final bool fromOrderForOthers;

  Service(this.ignoreLastDrivers, this.fromOrderForOthers, {Key? key})
      : super(key: key);

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  int? initialFare;
  int? costPerKilloMeter;
  int? costPerMinute;
  bool _isLoading = false;
  late LatLng currentLatlng;
  String capacity = 'loading';

  @override
  void initState() {
    GeolocatorPlatform.instance.getCurrentPosition().then((value) {
      currentLatlng = LatLng(value.latitude, value.longitude);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("YAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAYs");

    return BlocConsumer<RideRequestBloc, RideRequestState>(builder: (_, state) {
      return serviceTypeWidget();
    }, listener: (_, state) {
      if (state is RideRequestSuccess) {
        _isLoading = false;
        context
            .read<CurrentWidgetCubit>()
            .changeWidget(WaitingDriverResponse());
        // widget.callback!(WaitingDriverResponse(widget.callback));
        // widget.callback!(DriverOnTheWay(this.widget.callback));
      }
      if (state is NotificationRequestSending) {}
      if (state is RideRequestOperationFailur) {
        _isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Notification Not Sent"),
          backgroundColor: Colors.red.shade900,
        ));
      }
    });
  }

  NearbyDriverRepository repo = NearbyDriverRepository();

  final _greyTextStyle = TextStyle(color: Colors.black26, fontSize: 14);

  final _blackTextStyle = TextStyle(color: Colors.black);
  void orderForOthers(String fcmToken) {
    RideRequestEvent event = RideRequestOrderForOther(RideRequest(
        driverFcm: fcmToken,
        pickUpAddress: pickupAddress,
        droppOffAddress: droppOffAddress,
        pickupLocation: pickupLatLng,
        dropOffLocation: droppOffLatLng,
        passengerPhoneNumber: number));
    BlocProvider.of<RideRequestBloc>(context).add(event);
  }

  void sendNotification(String fcmToken, String id) async {
    print(' driver fcm $fcmToken');
    setState(() {
      _isLoading = true;
    });
    RideRequestEvent riderequestEvent = RideRequestCreate(RideRequest(
        driverFcm: fcmToken,
        driverId: id,
        passengerName: name,
        passengerPhoneNumber: number,
        pickUpAddress: pickupAddress,
        droppOffAddress: droppOffAddress,
        pickupLocation: pickupLatLng,
        dropOffLocation: droppOffLatLng));
    BlocProvider.of<RideRequestBloc>(context).add(riderequestEvent);
  }

  void changeCost(int initial, int perKillometed, int perminute) {
    initialFareAssistant = initial;
    costPerKilloMeterAssistant = perKillometed;
    costPerKilloMeterAssistant = perminute;
    setState(() {
      initialFare = initial;
      costPerKilloMeter = perKillometed;
      costPerMinute = perminute;
    });
  }

  void changeCapacity(String cap) {
    setState(() {
      capacity = cap;
    });
  }

  Widget serviceTypeWidget() {
    // DriverEvent event = DriverLoad(widget.searchNeabyDriver());
    // BlocProvider.of<DriverBloc>(context).add(event);
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<DirectionBloc>(context).add(
            const DirectionChangeToInitialState(
                loadCurrentLocation: false, listenToNearbyDriver: false));
        context.read<CurrentWidgetCubit>().changeWidget(WhereTo());
        return false;
      },
      child: Positioned(
        bottom: 3.0,
        left: 8.0,
        right: 8.0,
        child: Container(
            height: 260,
            padding:
                const EdgeInsets.only(top: 10, left: 10, right: 20, bottom: 0),
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text("Choose a taxi"),
                ),
                CategoryList(
                    changeCost: changeCost,
                    searchNearbyDriver: searchNearbyDriver,
                    changeCapacity: changeCapacity),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                const DirectionDetail(),
                const SizedBox(
                  height: 15,
                ),
                BlocConsumer<DriverBloc, DriverState>(
                    builder: (context, state) => Container(),
                    listener: (context, state) {
                      if (state is DriverLoadSuccess) {
                        // widget.searchNearbyDriversList('lada').take();
                        // nextDrivers.remove(state.driver.id);
                        driverFcm = state.driver.fcmId;
                        if (widget.fromOrderForOthers) {
                          orderForOthers(driverFcm);
                          print("For others");
                        } else {
                          print("For mine");
                          sendNotification(state.driver.fcmId, state.driver.id);
                        }
                      }
                    }),
                // Text("${nextDrivers}"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: BlocBuilder<DriverBloc, DriverState>(
                        builder: (_, state) {
                      if (state is DriverFoundState) {
                        return BlocBuilder<SelectedCategoryBloc,
                                SelectedCategoryState>(
                            builder: (context, categoryState) {
                          if (categoryState is CategoryChanged) {
                            return ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      const Color.fromRGBO(244, 201, 60, 1)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)))),
                              onPressed: () {
                                final l = searchNearbyDriversList(
                                    categoryState.category.name);
                                if (widget.ignoreLastDrivers) {
                                  nextDrivers = nextDrivers!
                                      .toSet()
                                      .difference(l!.toSet())
                                      .toList()
                                      .take(3)
                                      .toList();
                                } else {
                                  if (l!.length > 3) {
                                    nextDrivers = l.take(3).toList();
                                  } else {
                                    nextDrivers = l;
                                  }
                                }
                                print('nexenexe $nextDrivers');

                                if (nextDrivers!.isNotEmpty) {
                                  DriverEvent event =
                                      DriverLoad(nextDrivers!.first);
                                  BlocProvider.of<DriverBloc>(context)
                                      .add(event);
                                } else {
                                  BlocProvider.of<DriverBloc>(context)
                                      .add(DriverSetNotFound());
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Spacer(),
                                  Text(
                                    _isLoading ? "Sending...." : "Send Request",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  const Spacer(),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.black,
                                            ),
                                          )
                                        : Container(),
                                  )
                                ],
                              ),
                            );
                          }
                          return Container();
                        });
                      }
                      // if (state is DriverLoadSuccess) {
                      //   //  FirebaseMessaging.onMessage.listen((event) {

                      //   //   });

                      // }
                      if (state is DriverLoading) {
                        return ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromRGBO(244, 201, 60, 1)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                          onPressed: null,
                          child: const Text(
                            "Finding nearby driver..",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        );
                      }
                      if (state is DriverOperationFailure) {
                        return ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromRGBO(244, 201, 60, 1)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                          onPressed: null,
                          child: const Text(
                            "No driver Found",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        );
                      }
                      if (state is DriverNotFoundState) {
                        return ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromRGBO(244, 201, 60, 1)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                          onPressed: null,
                          child: const Text(
                            "No driver Found",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        );
                      }
                      return ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(244, 201, 60, 1)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        onPressed: null,
                        child: const Text(
                          "Please select car type",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

// Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _isSelected = 1;
//                       });
//                     },
//                     child: Column(
//                       children: [
//                         Container(
//                           decoration: _isSelected == 1
//                               ? BoxDecoration(
//                                   boxShadow: const [
//                                       BoxShadow(
//                                           color:
//                                               Color.fromRGBO(244, 201, 60, 1)),
//                                     ],
//                                   borderRadius: BorderRadius.circular(10),
//                                   border: Border.all(
//                                       width: 0.5, color: Colors.black))
//                               : null,
//                           child: const Image(
//                               height: 50,
//                               image: AssetImage(
//                                   "assets/icons/economyCarIcon.png")),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         const Text("Standart")
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 20,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _isSelected = 2;
//                         priceMultiplier = 2;
//                         durationMultiplier = 2;

//                         DriverEvent event =
//                             DriverLoad(widget.searchNeabyDriver());
//                         BlocProvider.of<DriverBloc>(context).add(event);
//                       });
//                     },
//                     child: Column(
//                       children: [
//                         Container(
//                           decoration: _isSelected == 2
//                               ? BoxDecoration(
//                                   boxShadow: const [
//                                       BoxShadow(
//                                           color:
//                                               Color.fromRGBO(244, 201, 60, 1)),
//                                     ],
//                                   borderRadius: BorderRadius.circular(10),
//                                   border: Border.all(
//                                       width: 0.5, color: Colors.black))
//                               : null,
//                           child: const Image(
//                               height: 50,
//                               image:
//                                   AssetImage("assets/icons/lexuryCarIcon.png")),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         const Text("XL")
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 20,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _isSelected = 3;
//                         priceMultiplier = 2.5;
//                         durationMultiplier = 2.5;
//                         DriverEvent event =
//                             DriverLoad(widget.searchNeabyDriver());
//                         BlocProvider.of<DriverBloc>(context).add(event);
//                       });
//                     },
//                     child: Column(
//                       children: [
//                         Container(
//                           decoration: _isSelected == 3
//                               ? BoxDecoration(
//                                   boxShadow: const [
//                                       BoxShadow(
//                                           color:
//                                               Color.fromRGBO(244, 201, 60, 1)),
//                                     ],
//                                   borderRadius: BorderRadius.circular(10),
//                                   border: Border.all(
//                                       width: 0.5, color: Colors.black))
//                               : null,
//                           child: const Image(
//                               height: 50,
//                               image:
//                                   AssetImage("assets/icons/familyCarIcon.png")),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         const Text("Family")
//                       ],
//                     ),
//                   ),
//                 ],
//               ),



