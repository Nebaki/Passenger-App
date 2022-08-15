import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/cubit/theme_mode_cubit/theme_mode_cubit.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/localization.dart';
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
    if (context.read<ThemeModeCubit>().state == ThemeMode.system) {
      var window = WidgetsBinding.instance.window;
      window.onPlatformBrightnessChanged = () {
        if (window.platformBrightness == Brightness.dark) {
          BlocProvider.of<ThemeModeCubit>(context).ActivateDarkTheme();
        } else {
          BlocProvider.of<ThemeModeCubit>(context).ActivateLightTheme();
        }
      };
    }
    super.initState();
    _toggleInternetServiceStatusStream();
  }

  @override
  void dispose() {
    _connectivitySubscription!.cancel();
    super.dispose();
  }

  Future<bool> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // return Future.error('Location permissions are denied');
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  bool showBanner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Stack(
        fit: StackFit.loose,
        children: [
          showBanner
              ? Padding(
                  child: Container(
                      height: 20,
                      color: Colors.black,
                      width: double.infinity,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                                Icons
                                    .signal_wifi_statusbar_connected_no_internet_4_outlined,
                                size: 15,
                                color: Colors.white),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              getTranslation(context, "no_internet_connection"),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      )),
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).viewPadding.top))
              : Container(),
          BlocConsumer<AuthBloc, AuthState>(builder: (_, state) {
            return const Center(
              child: Image(
                height: 150,
                image: AssetImage("assets/icons/logo.png"),
              ),
            );
          }, listener: (_, state) {
            if (state is AuthDataLoadSuccess) {
              _requestLocationPermission().then((value) {
                if (value) {
                  if (state.auth.token != null) {
                    name = state.auth.name!;
                    number = state.auth.phoneNumber!;
                    myId = state.auth.id!;
                    checkInterNetServiceOnInit();
                  } else {
                    Navigator.pushReplacementNamed(
                        context, SigninScreen.routeName);
                  }
                } else {
                  SystemNavigator.pop();
                }
              });
            }
            if (state is AuthOperationFailure) {
              _requestLocationPermission().then((value) {
                if (value) {
                  Navigator.pushReplacementNamed(
                      context, SigninScreen.routeName);
                } else {
                  SystemNavigator.pop();
                }
              });
            }
          }),
          BlocConsumer<SettingsBloc, SettingsState>(
              builder: (context, settingsState) {
            if (settingsState is SettingsLoading) {
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
            if (settingsState is SettingsLoadSuccess) {
              return BlocConsumer<RideRequestBloc, RideRequestState>(
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
                    content: Text(
                      getTranslation(context, "check_internet_connection"),
                      style: const TextStyle(color: Colors.white),
                    ),
                    action: SnackBarAction(
                        textColor: Colors.white,
                        label: getTranslation(context, "try_again"),
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          _checkStartedTrip();
                        }),
                  ));
                }
                if (st is RideRequestTokentExpired) {
                  Navigator.pushReplacementNamed(
                      context, SigninScreen.routeName);
                }
                if (st is RideRequestStartedTripChecked) {
                  print("Yow we are here");
                  if (st.rideRequest.pickUpAddress == null) {
                    Navigator.pushReplacementNamed(
                        context, HomeScreen.routeName,
                        arguments: HomeScreenArgument(
                            settings: settingsState.settings,
                            isFromSplash: true,
                            isSelected: false));
                  } else {
                    selectedCar = SelectedCar.taxi;
                    DriverEvent event = DriverLoad(st.rideRequest.driver!.id);
                    BlocProvider.of<DriverBloc>(context).add(event);
                    price = st.rideRequest.price!;
                    distance = st.rideRequest.distance!;
                    duration = "Uknown";
                    driverModel = st.rideRequest.driver!;
                    driverId = st.rideRequest.driver!.id;
                    rideRequestId = st.rideRequest.id!;
                    pickupAddress = st.rideRequest.pickUpAddress!;
                    droppOffAddress = st.rideRequest.droppOffAddress!;
                    droppOffLatLng = st.rideRequest.dropOffLocation!;
                    pickupLatLng = st.rideRequest.pickupLocation!;
                    Navigator.pushReplacementNamed(
                        context, HomeScreen.routeName,
                        arguments: HomeScreenArgument(
                            settings: settingsState.settings,
                            isFromSplash: false,
                            isSelected: true,
                            status: st.rideRequest.status,
                            encodedPts: st.rideRequest.direction));
                  }
                }
              });
            }

            return Container();
          }, listener: (context, state) {
            if (state is SettingsUnAuthorised) {
              Navigator.pushReplacementNamed(context, SigninScreen.routeName);
            }
            if (state is SettingsOperationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(minutes: 5),
                backgroundColor: Colors.black,
                content: Text(
                  getTranslation(context, "check_internet_connection"),
                  style: const TextStyle(color: Colors.white),
                ),
                action: SnackBarAction(
                    textColor: Colors.white,
                    label: getTranslation(context, "try_again"),
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      _getSettings();
                    }),
              ));
            }
          }),
        ],
      ),
    );
  }

  void _getSettings() {
    print("Tomlalaw w  www w w");
    BlocProvider.of<SettingsBloc>(context).add(SettingsStarted());
  }

  void _checkStartedTrip() {
    BlocProvider.of<RideRequestBloc>(context)
        .add(RideRequestCheckStartedTrip());
  }

  void checkInterNetServiceOnInit() async {
    ConnectivityResult result;
    result = await _connectivity.checkConnectivity();

    if (result == ConnectivityResult.none) {
      isFirstTime = true;
      showBanner = true;
      setState(() {});
      // ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
      //     content: Center(
      //         child: Text(getTranslation(context, "no_internet_connection"))),
      //     actions: [Container()]));
    } else {
      showBanner = false;
      setState(() {});
      // ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

      // _checkStartedTrip();
      _getSettings();
    }
  }

  void _toggleInternetServiceStatusStream() {
    _connectivitySubscription ??=
        _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        showBanner = true;
        setState(() {});
        // ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(

        //     content: Center(
        //         child: Text(getTranslation(context, "no_internet_connection"))),
        //     actions: [Container()]));
      } else if (event == ConnectivityResult.wifi) {
        showBanner = false;
        setState(() {});
        // ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

        if (isFirstTime) {
          _getSettings();
        }
        isFirstTime = false;
      } else if (event == ConnectivityResult.mobile) {
        if (isFirstTime) {
          _getSettings();
        }
        isFirstTime = false;
        showBanner = false;
        setState(() {});
        // ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      }
    });
  }
}
