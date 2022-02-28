import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/drawer/drawer.dart';
import 'package:passengerapp/models/nearby_driver.dart';
import 'package:passengerapp/repository/nearby_driver.dart';
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
  NearbyDriverRepository repo = NearbyDriverRepository();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};
  Map<MarkerId, Marker> driverMarkers = {};
  late List<NearbyDriver> drivers;

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

  @override
  // ignore: must_call_super
  void initState() {
    widget.args.isSelected
        ? _currentWidget = Service(callback, searchNearbyDriver)
        : _currentWidget = const WhereTo();
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
          widget.args.isSelected
              ? BlocBuilder<DirectionBloc, DirectionState>(
                  builder: (context, state) {
                  bool isDialog = true;

                  if (state is DirectionLoadSuccess) {
                    isDialog = false;

                    _getPolyline(state.direction.encodedPoints);
                    _addMarker(
                        widget.args.destinationlatlang!,
                        "destination",
                        BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueGreen));

                    return GoogleMap(
                      mapType: MapType.normal,
                      myLocationButtonEnabled: true,
                      initialCameraPosition: _addissAbaba,
                      myLocationEnabled: true,
                      polylines: Set<Polyline>.of(polylines.values),
                      markers: Set<Marker>.of(markers.values),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);

                        controller.setMapStyle('''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ebe3cd"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#523735"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f1e6"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#c9b2a6"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#dcd2be"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#ae9e90"
      }
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#93817c"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#a5b076"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#447530"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f1e6"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#fdfcf8"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f8c967"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#e9bc62"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e98d58"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#db8555"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#806b63"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8f7d77"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#ebe3cd"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#b9d3c2"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#92998d"
      }
    ]
  },
  {
    "featureType": "poi",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  }
]''');

                        _determinePosition().then((value) {
                          setState(() {
                            _addMarker(
                                LatLng(value.latitude, value.longitude),
                                "pickup",
                                BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueRed));
                          });

                          LatLngBounds latLngBounds;

                          final destinationLatLng =
                              widget.args.destinationlatlang;
                          final pickupLatLng =
                              LatLng(value.latitude, value.longitude);
                          if (pickupLatLng.latitude >
                                  destinationLatLng!.latitude &&
                              pickupLatLng.longitude >
                                  destinationLatLng.longitude) {
                            latLngBounds = LatLngBounds(
                                southwest: destinationLatLng,
                                northeast: pickupLatLng);
                          } else if (pickupLatLng.longitude >
                              destinationLatLng.longitude) {
                            latLngBounds = LatLngBounds(
                                southwest: LatLng(pickupLatLng.latitude,
                                    destinationLatLng.longitude),
                                northeast: LatLng(destinationLatLng.latitude,
                                    pickupLatLng.longitude));
                          } else if (pickupLatLng.latitude >
                              destinationLatLng.latitude) {
                            latLngBounds = LatLngBounds(
                                southwest: LatLng(destinationLatLng.latitude,
                                    pickupLatLng.longitude),
                                northeast: LatLng(pickupLatLng.latitude,
                                    destinationLatLng.longitude));
                          } else {
                            latLngBounds = LatLngBounds(
                                southwest: pickupLatLng,
                                northeast: destinationLatLng);
                          }

                          controller.animateCamera(
                              CameraUpdate.newLatLngBounds(latLngBounds, 70));
                        });
                      },
                    );
                  }
                  if (state is DirectionOperationFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text("Unable to find direction"),
                      backgroundColor: Colors.red.shade900,
                    ));
                    return GoogleMap(
                      mapType: MapType.terrain,
                      buildingsEnabled: false,
                      indoorViewEnabled: true,
                      tiltGesturesEnabled: false,
                      trafficEnabled: false,
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
                  return isDialog
                      ? AlertDialog(
                          content: Row(
                            children: const [
                              CircularProgressIndicator(),
                              Text("finding direction")
                            ],
                          ),
                        )
                      : Container();
                })
              : GoogleMap(
                  mapType: MapType.terrain,
                  buildingsEnabled: false,
                  indoorViewEnabled: true,
                  tiltGesturesEnabled: false,
                  trafficEnabled: false,
                  myLocationButtonEnabled: true,
                  initialCameraPosition: _addissAbaba,
                  markers: Set<Marker>.of(driverMarkers.values),
                  myLocationEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    print(driverMarkers);
                    _controller.complete(controller);

                    _determinePosition().then((value) async {
                      geofireListener(value.latitude, value.longitude);

                      WidgetsBinding.instance!
                          .addPostFrameCallback((timeStamp) {
                        geofireListener(value.latitude, value.longitude);
                      });

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
          Positioned(
              top: 30,
              right: 20,
              child: ElevatedButton(
                  onPressed: () {
                    geofireListener(8.9936827, 38.7663247);
                  },
                  child: const Text("Maintenance"))),
          // Positioned(
          //     top: 60,
          //     child: ElevatedButton(
          //         onPressed: () {
          //           Geofire.setLocation("test", 8.9936827, 38.7863247);
          //           geofireListener(8.9936827, 38.7663247);
          //         },
          //         child: Text("add")))
        ],
      ),
    );
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
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

  void geofireListener(double lat, double lng) async {
    Geofire.initialize('availableDrivers');
    repo.resetList();

    print(lat);
    print(lng);
    print("Mapppppppppppppppppppppppppppppppppppppppppppppppppppppppaaa");

    try {
      //print(await Geofire.queryAtLocation(lat, lng, 1));

      await Geofire.queryAtLocation(lat, lng, 1)!.listen((map) {
        print("Mapppppppppppppppppppppppppppppppppppppppppppppppppppppppsss");

        print(map);
        print("Mappppppppppppppppppppppppppppppppppppppppppppppppppppppp");
        if (map != null) {
          var callBack = map['callBack'];
          switch (callBack) {
            case Geofire.onKeyEntered:
              repo.addDriver(NearbyDriver(
                  id: map['key'],
                  latitude: map['latitude'],
                  longitude: map['longitude']));
              print("addddddddddddddddddddddddddddddddddddddd");
              showDriversOnMap();

              print("aded");

              break;

            case Geofire.onKeyExited:
              repo.removeDriver(map['key']);
              showDriversOnMap();

              print("now");

              break;

            case Geofire.onKeyMoved:
              print("moved");
              repo.updateDriver(NearbyDriver(
                  id: map['key'],
                  latitude: map['latitude'],
                  longitude: map['longitude']));
              showDriversOnMap();
              print("Yeah Moved");
              break;

            case Geofire.onGeoQueryReady:
              showDriversOnMap();
              print(map['result']);

              break;
          }
          if (!mounted) {
            return;
          }
        }

        setState(() {});
      });
    } on PlatformException {
      print("platform exceprionnnnnnnnnnnnnnnnnnnnnnnnnnnnnn");
    } catch (_) {
      print("here");
    }
  }

  void showDriversOnMap() {
    print("Length :: ");
    print(repo.getNearbyDrivers().first.id);
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: Size(1, 2));
    Map<MarkerId, Marker> newMarker = {};
    for (NearbyDriver driver in repo.getNearbyDrivers()) {
      LatLng driverPosition = LatLng(driver.latitude, driver.longitude);
      MarkerId markerId = MarkerId(driver.id);

      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/icons/car.png')
          .then((value) {
        Marker marker =
            Marker(markerId: markerId, position: driverPosition, icon: value);

        newMarker[markerId] = marker;
      });
    }

    setState(() {
      driverMarkers = newMarker;
    });
  }

  void searchNearbyDriver() {
    if (repo.getNearbyDrivers().isEmpty) {
      return;
    }

    var driver = repo.getNearbyDrivers()[0];
    print("Here Is The driver:: ++++++++++++++++++++");

    print(driver.id);
  }
}
