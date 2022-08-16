import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/repository/nearby_driver.dart';
import 'package:passengerapp/screens/home/assistant/home_screen_assistant.dart';
import 'package:passengerapp/widgets/serviceType/category_list.dart';
import 'package:passengerapp/widgets/widgets.dart';

class Service extends StatefulWidget {
  final bool ignoreLastDrivers;
  final bool fromOrderForOthers;

  const Service(this.ignoreLastDrivers, this.fromOrderForOthers, {Key? key})
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
    return BlocConsumer<RideRequestBloc, RideRequestState>(builder: (_, state) {
      return serviceTypeWidget();
    }, listener: (_, state) {
      if (state is RideRequestSuccess) {
        _isLoading = false;
        context
            .read<CurrentWidgetCubit>()
            .changeWidget(const WaitingDriverResponse());
        // widget.callback!(WaitingDriverResponse(widget.callback));
        // widget.callback!(DriverOnTheWay(this.widget.callback));
      }
      if (state is RideRequestOperationFailur) {
        _isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              getTranslation(context, "create_ride_request_failure_message")),
          backgroundColor: Colors.red.shade900,
        ));
      }
    });
  }

  NearbyDriverRepository repo = NearbyDriverRepository();

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
            DirectionChangeToInitialState(
                loadCurrentLocation: false,
                listenToNearbyDriver:
                    widget.fromOrderForOthers ? true : false));
        context.read<CurrentWidgetCubit>().changeWidget(const WhereTo(
              key: Key("whereto"),
            ));
        return false;
      },
      child: Container(
              height: MediaQuery.of(context).size.height*0.37,
          padding:
              const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20))),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(getTranslation(context, "choose_taxi")),
                ),
              ),
              Expanded(
                flex: 2,
                child: CategoryList(
                    changeCost: changeCost,
                    searchNearbyDriver: searchNearbyDriver,
                    changeCapacity: changeCapacity),
              ),
              const Divider(),
           
              const Expanded(flex: 2, child:  DirectionDetail(fromBackGround: false,)),
              
              BlocConsumer<DriverBloc, DriverState>(
                  builder: (context, state) => Container(),
                  listener: (context, state) {
                    if (state is DriverLoadSuccess) {
                      // widget.searchNearbyDriversList('lada').take();
                      // nextDrivers.remove(state.driver.id);
                      driverFcm = state.driver.fcmId;
                      if (widget.fromOrderForOthers) {
                        orderForOthers(driverFcm);
                      } else {
                        sendNotification(state.driver.fcmId, state.driver.id);
                      }
                    }
                  }),
              // Text("${nextDrivers}"),
            
              Expanded(
                flex: 1,
                child: Padding(
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
                            return SizedBox(
                              height: 50,
                              child: ElevatedButton(
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
                                      _isLoading
                                          ? getTranslation(context, "sending")
                                          : getTranslation(
                                              context, "send_request"),
                                      style: const TextStyle(
                                          color: Colors.white,
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
                                                color: Colors.white,
                                              ),
                                            )
                                          : Container(),
                                    )
                                  ],
                                ),
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
                          onPressed: null,
                          child: Text(
                            getTranslation(context, "finding_nearby_driver"),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                        );
                      }
                      if (state is DriverOperationFailure) {
                        return ElevatedButton(
                          onPressed: null,
                          child: Text(
                            getTranslation(context, "no_driver_found"),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                        );
                      }
                      if (state is DriverNotFoundState) {
                        return ElevatedButton(
                          onPressed: null,
                          child: Text(
                            getTranslation(context, "no_driver_found"),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                        );
                      }
                      return
                          // Container();
                          ElevatedButton(
                        onPressed: null,
                        child: Text(
                          getTranslation(context, "please_select_car_type"),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          )),
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
