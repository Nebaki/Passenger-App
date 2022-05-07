import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/home/variables.dart';
import 'package:passengerapp/screens/screens.dart';

class CustomSplashScreen extends StatefulWidget {
  static const routeName = "/splashscreen";
  CustomSplashScreen({Key? key}) : super(key: key);

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  ConnectivityResult? _connectionStatus;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isSuccess = false;

  @override
  void initState() {
    super.initState();
    // requestLocationPermission();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  // void requestLocationPermission() async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final _snackBar = SnackBar(
      content: const Text("No Internet Connection"),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: "Try Again",
        onPressed: () {
          initConnectivity();
        },
        textColor: Colors.white,
      ),
    );
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   print(_connectionStatus);
    //   if (_connectionStatus == ConnectivityResult.none) {
    //     print("false");
    //     ScaffoldMessenger.of(context).showSnackBar(_snackBar);

    //     //initConnectivity();
    //   } else if (_connectionStatus == ConnectivityResult.wifi ||
    //       _connectionStatus == ConnectivityResult.mobile) {
    //     Navigator.pushReplacementNamed(context, SigninScreen.routeName);
    //   }
    // });

    // Future.delayed(Duration(seconds: 3), () {
    //   if (_connectionStatus == ConnectivityResult.none) {
    //     print("false");
    //     ScaffoldMessenger.of(context).showSnackBar(_snackBar);

    //     //initConnectivity();
    //   } else if (_connectionStatus == ConnectivityResult.wifi ||
    //       _connectionStatus == ConnectivityResult.mobile) {
    //     Navigator.pushReplacementNamed(context, SigninScreen.routeName);
    //   }
    // });

    return Scaffold(
      backgroundColor: Colors.red,
      body: Stack(
        children: [
          const Align(
            alignment: Alignment.center,
            child: Center(
              child: Image(
                height: 150,
                image: AssetImage("assets/icons/logo.png"),
              ),
            ),
          ),
          _connectionStatus == ConnectivityResult.none
              ? Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.signal_wifi_connected_no_internet_4,
                                size: 13,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "No Internet Connection",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: LinearProgressIndicator(
                            minHeight: 1,
                            color: Colors.black,
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : _connectionStatus == null
                  ? Container()
                  : BlocConsumer<AuthBloc, AuthState>(builder: (_, state) {
                      // if (state is AuthDataLoading) {
                      //   print("Loadloadloadloadloadload");
                      //   return const Align(
                      //     alignment: Alignment.bottomCenter,
                      //     child: LinearProgressIndicator(),
                      //   );
                      // }
                      return const Center(
                        child: Image(
                          height: 150,
                          image: AssetImage("assets/icons/logo.png"),
                        ),
                      );
                    }, listener: (_, state) {
                      if (state is AuthDataLoading) {
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: LinearProgressIndicator(),
                        );
                      }
                      if (state is AuthDataLoadSuccess) {
                        print(state.auth.token);
                        if (state.auth.token != null) {
                          name = state.auth.name!;
                          number = state.auth.phoneNumber;
                          myId = state.auth.id!;
                        }

                        state.auth.token != null
                            ? setState(() {
                                isSuccess = true;
                              })
                            : Navigator.pushReplacementNamed(
                                context, SigninScreen.routeName);

                        //0967543215

                      }
                    }),
          isSuccess
              ? BlocConsumer<RideRequestBloc, RideRequestState>(
                  builder: (context, state) {
                  return Container();
                }, listener: (context, st) {
                  print("Yoyoyoyoyoyoyoyoyoyooyqqq $st");
                  if (st is RideRequestStartedTripChecked) {
                    print(st.rideRequest);
                    print("data is is is is ${st.rideRequest.pickUpAddress}");

                    if (st.rideRequest.pickUpAddress == null) {
                      BlocProvider.of<RideRequestBloc>(context)
                          .add(RideRequestLoad());
                      Navigator.pushReplacementNamed(
                          context, CarTypeSelector.routName);

                      // Navigator.pushReplacementNamed(
                      //     context, HomeScreen.routeName,
                      //     arguments: HomeScreenArgument(isSelected: false));
                    } else {
                      DriverEvent event = DriverLoad(st.rideRequest.driver!.id);
                      BlocProvider.of<DriverBloc>(context).add(event);
                      price = st.rideRequest.price!;
                      distance = st.rideRequest.distance!;
                      driverModel = st.rideRequest.driver!;
                      Navigator.pushReplacementNamed(
                          context, HomeScreen.routeName,
                          arguments: HomeScreenArgument(
                              isSelected: true,
                              encodedPts: st.rideRequest.direction));
                    }
                    // loadRideRequest();
                  }
                })
              : Container()
        ],
      ),
    );
  }

  void loadRideRequest() {
    // RideRequestEvent event = RideRequestLoad();
    BlocProvider.of<RideRequestBloc>(context).add(RideRequestLoad());
  }
}



//  _connectionStatus == ConnectivityResult.none
//             ? const Center(
//                 child: Image(
//                   height: 150,
//                   image: AssetImage("assets/icons/logo.png"),
//                 ),
//               )
//             // ScaffoldMessenger.of(context).showSnackBar(_snackBar);
//             : 