import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/drawer/drawer.dart';
import 'package:passengerapp/rout.dart';
import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

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

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  static const CameraPosition _addissAbaba = CameraPosition(
    target: LatLng(8.9806, 38.7578),
    zoom: 14.4746,
  );

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error("NoLocation Enabled");
      }

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: La.LocationAccuracy.high);
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  // ignore: must_call_super
  void initState() {
    widget.args.isSelected
        ? _currentWidget = Service(callback)
        : _currentWidget = const WhereTo();
  }

  void callback(Widget nextwidget) {
    setState(() {
      _currentWidget = nextwidget;
    });
  }

  String y = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(),
      body: Stack(
        children: [
          widget.args.isSelected
              ? BlocBuilder<DirectionBloc, DirectionState>(
                  builder: (context, state) {
                  print("succcesssss");

                  if (state is DirectionLoadSuccess) {
                    _getPolyline(state.direction.encodedPoints);
                    return GoogleMap(
                      mapType: MapType.normal,
                      myLocationButtonEnabled: true,
                      initialCameraPosition: _addissAbaba,
                      myLocationEnabled: true,
                      polylines: Set<Polyline>.of(polylines.values),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);

                        _determinePosition().then((value) {
                          // final pickupLatLng =
                          //     LatLng(value.latitude, value.longitude);
                          // LatLng destinationLatLng;

                          // BlocListener<PlaceDetailBloc, PlaceDetailState>(
                          //     listener: (context, state) {
                          //   if (state is PlaceDetailLoadSuccess) {
                          //     destinationLatLng = LatLng(
                          //         state.placeDetail.lat, state.placeDetail.lng);
                          //     LatLngBounds latLngBounds;
                          //     if (pickupLatLng.latitude >
                          //             destinationLatLng.latitude &&
                          //         pickupLatLng.longitude >
                          //             destinationLatLng.longitude) {
                          //       latLngBounds = LatLngBounds(
                          //           southwest: destinationLatLng,
                          //           northeast: pickupLatLng);
                          //     } else if (pickupLatLng.longitude >
                          //         destinationLatLng.longitude) {
                          //       latLngBounds = LatLngBounds(
                          //           southwest: LatLng(pickupLatLng.latitude,
                          //               destinationLatLng.longitude),
                          //           northeast: LatLng(
                          //               destinationLatLng.latitude,
                          //               pickupLatLng.longitude));
                          //     } else if (pickupLatLng.latitude >
                          //         destinationLatLng.latitude) {
                          //       latLngBounds = LatLngBounds(
                          //           southwest: LatLng(
                          //               destinationLatLng.latitude,
                          //               pickupLatLng.longitude),
                          //           northeast: LatLng(pickupLatLng.latitude,
                          //               destinationLatLng.longitude));
                          //     } else {
                          //       latLngBounds = LatLngBounds(
                          //           southwest: pickupLatLng,
                          //           northeast: destinationLatLng);
                          //     }

                          //     controller.animateCamera(
                          //         CameraUpdate.newLatLngBounds(
                          //             latLngBounds, 70));
                          //   }
                          // });

                          //final destinationLatlng =
                          //if()
                          controller.animateCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  zoom: 14.4746,
                                  target: LatLng(
                                      value.latitude, value.longitude))));
                        });
                      },
                    );
                    //_getPolyline(state.direction.encodedPoints);
                  }
                  if (state is DirectionOperationFailure) {
                    print("Failurrrrrrrrrrrrrrrrrrrr");

                    return GoogleMap(
                      mapType: MapType.normal,
                      myLocationButtonEnabled: true,
                      initialCameraPosition: _addissAbaba,
                      myLocationEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);

                        _determinePosition().then((value) {
                          controller.animateCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  zoom: 14.4746,
                                  target: LatLng(
                                      value.latitude, value.longitude))));
                        });
                      },
                    );
                  }
                  return Text("Loading");

                  //  AlertDialog(
                  //   content: Row(
                  //     children: const [
                  //       CircularProgressIndicator(),
                  //       Text("finding direction")
                  //     ],
                  //   ),
                  // );
                })
              : GoogleMap(
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
                              target:
                                  LatLng(value.latitude, value.longitude))));
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

  _getPolyline(String encodedString) {
    polylineCoordinates.clear();
    List<PointLatLng> result = polylinePoints.decodePolyline(encodedString);

    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  _addPolyLine() {
    polylines.clear();
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        width: 2,
        polylineId: id,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        color: Colors.indigo,
        geodesic: true,
        points: polylineCoordinates);

    polylines[id] = polyline;

    //Future.delayed(Duration(seconds: 1), () {});
  }
}
