import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:passengerapp/screens/screens.dart';

class CustomSplashScreen extends StatefulWidget {
  static const routeName = "/splashscreen";
  CustomSplashScreen({Key? key}) : super(key: key);

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
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
    // Platform messages may fail, so we use a try/catch PlatformException.
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
    print(_connectionStatus);
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

    Future.delayed(Duration(seconds: 3), () {
      if (_connectionStatus == ConnectivityResult.none) {
        print("false");
        ScaffoldMessenger.of(context).showSnackBar(_snackBar);

        //initConnectivity();
      } else if (_connectionStatus == ConnectivityResult.wifi ||
          _connectionStatus == ConnectivityResult.mobile) {
        Navigator.pushReplacementNamed(context, SigninScreen.routeName);
      }
    });

    return const Scaffold(
      backgroundColor: Colors.red,
      body: Center(
          child:
              Image(height: 150, image: AssetImage("assets/icons/logo.png"))),
    );
  }
}
