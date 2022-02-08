import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/drawer/drawer.dart';
import 'package:passengerapp/rout.dart';
import 'dart:async';
// import 'package:location/location.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as La;

import 'package:passengerapp/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  HomeScreenArgument args;

  HomeScreen({Key? key, required this.args}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Location location = new Location();
  late Widget _currentWidget;
  double currentLat = 3;
  late double currentLng = 4;
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _addissAbaba = CameraPosition(
    target: LatLng(8.9806, 38.7578),
    zoom: 14.4746,
  );

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error("NoLocation Enabled");
      }
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: La.LocationAccuracy.high);
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  // ignore: must_call_super
  void initState() {
    widget.args.isSelected
        ? _currentWidget = Service(callback)
        : _currentWidget = WhereTo();
  }

  void callback(Widget nextwidget) {
    setState(() {
      _currentWidget = nextwidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _addissAbaba,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);

              _determinePosition().then((value) {
                controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        zoom: 14.4746,
                        target: LatLng(value.latitude, value.longitude))));
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                color: Colors.blueGrey.shade900.withOpacity(0.7),
                child: IconButton(
                  onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                  icon: const Icon(
                    Icons.format_align_center,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          _currentWidget,
        ],
      ),
    );
  }
}
