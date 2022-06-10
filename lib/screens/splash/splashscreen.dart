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
import 'package:passengerapp/screens/home/assistant/home_screen_assistant.dart';
import 'package:passengerapp/screens/home/variables.dart';
import 'package:passengerapp/screens/screens.dart';

class CustomSplashScreen extends StatefulWidget {
  static const routeName = "/splashscreen";
  const CustomSplashScreen({Key? key}) : super(key: key);

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool isFirstTime = false;

  @override
  void initState() {
    super.initState();
    _toggleInternetServiceStatusStream();
  }

  @override
  void dispose() {
    _connectivitySubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Stack(
        children: [
          BlocConsumer<AuthBloc, AuthState>(builder: (_, state) {
            return const Center(
              child: Image(
                height: 150,
                image: AssetImage("assets/icons/logo.png"),
              ),
            );
          }, listener: (_, state) {
            if (state is AuthDataLoadSuccess) {
              if (state.auth.token != null) {
                name = state.auth.name!;
                number = state.auth.phoneNumber!;
                myId = state.auth.id!;
                checkInterNetServiceOnInit();
              } else {
                Navigator.pushReplacementNamed(context, SigninScreen.routeName);
              }
            }
            if (state is AuthOperationFailure) {
              Navigator.pushReplacementNamed(context, SigninScreen.routeName);
            }
          }),
          BlocConsumer<RideRequestBloc, RideRequestState>(
              builder: (context, state) {
            if (state is RideRequestLoading) {
              return const Align(
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
              );
            }

            return Container();
          }, listener: (context, st) {
            if (st is RideRequestOperationFailur) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(minutes: 5),
                backgroundColor: Colors.black,
                content: const Text(
                  "Check your internet connection",
                  style: TextStyle(color: Colors.white),
                ),
                action: SnackBarAction(
                    textColor: Colors.white,
                    label: "Try Again",
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      _checkStartedTrip();
                    }),
              ));
            }
            if (st is RideRequestTokentExpired) {
              Navigator.pushReplacementNamed(context, SigninScreen.routeName);
            }
            if (st is RideRequestStartedTripChecked) {
              if (st.rideRequest.pickUpAddress == null) {
                Navigator.pushReplacementNamed(context, HomeScreen.routeName,
                    arguments: HomeScreenArgument(
                        isFromSplash: true, isSelected: false));
              } else {
                selectedCar = SelectedCar.taxi;
                DriverEvent event = DriverLoad(st.rideRequest.driver!.id);
                BlocProvider.of<DriverBloc>(context).add(event);
                price = st.rideRequest.price!;
                distance = st.rideRequest.distance!;
                driverModel = st.rideRequest.driver!;
                driverId = st.rideRequest.driver!.id;
                rideRequestId = st.rideRequest.id!;
                Navigator.pushReplacementNamed(context, HomeScreen.routeName,
                    arguments: HomeScreenArgument(
                        isFromSplash: false,
                        isSelected: true,
                        encodedPts: st.rideRequest.direction));
              }
            }
          })
        ],
      ),
    );
  }

  void _checkStartedTrip() {
    BlocProvider.of<RideRequestBloc>(context)
        .add(RideRequestCheckStartedTrip());
  }

  void checkInterNetServiceOnInit() async {
    ConnectivityResult result;
    result = await _connectivity.checkConnectivity();

    if (result == ConnectivityResult.none) {
      print("Showing the banner from here");
      isFirstTime = true;

      ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
          content: const Text(Strings.noIntertConnection),
          actions: [TextButton(onPressed: () {}, child: Text("Try Again"))]));
    } else {
      print("We are all around here");
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

      _checkStartedTrip();
    }
  }

  void _toggleInternetServiceStatusStream() {
    _connectivitySubscription ??=
        _connectivity.onConnectivityChanged.listen((event) {
      print("event:  $event");
      if (event == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
            content: const Text(Strings.noIntertConnection),
            actions: [
              TextButton(onPressed: () {}, child: const Text("Try again"))
            ]));
      } else if (event == ConnectivityResult.wifi) {
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

        if (isFirstTime) {
          _checkStartedTrip();
        }
        isFirstTime = false;
      } else if (event == ConnectivityResult.mobile) {
        if (isFirstTime) {
          _checkStartedTrip();
        }
        isFirstTime = false;
        print("Noohhhh");
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      }
    });
  }
}
