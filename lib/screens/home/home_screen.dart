import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/bloc/driver/driver_bloc.dart';
import 'package:passengerapp/drawer/drawer.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/url_launcher.dart';
import 'package:passengerapp/models/nearby_driver.dart';
import 'package:passengerapp/notification/push_notification_service.dart';
import 'package:passengerapp/repository/nearby_driver.dart';
import 'package:passengerapp/rout.dart';
import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:passengerapp/helper/helper_functions.dart';

import 'package:passengerapp/helper/constants.dart';

// import 'package:location/location.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as La;
import 'package:passengerapp/screens/home/test.dart';
import 'package:passengerapp/screens/screens.dart';

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
  late GoogleMapController outerController;
  NearbyDriverRepository repo = NearbyDriverRepository();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};
  Map<MarkerId, Marker> driverMarkers = {};
  late List<NearbyDriver> drivers;
  LatLng currentLatLng = _addissAbaba.target;
  bool isSelectedd = false;
  late LatLng dtn;
  PushNotificationService pushNotificationService = PushNotificationService();

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  ConnectivityResult _connectionStatus = ConnectivityResult.bluetooth;
  final Connectivity _connectivity = Connectivity();

  bool? isLocationOn;
  bool isModal = false;
  bool isConModal = false;

  static const CameraPosition _addissAbaba = CameraPosition(
    target: LatLng(8.9806, 38.7578),
    zoom: 16.4746,
  );

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        setState(() {
          isLocationOn = false;
        });
        return Future.error("NoLocation Enabled");
      }

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        SystemNavigator.pop();
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
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _toggleServiceStatusStream();
    pushNotificationService.initialize(context, callback, searchNearbyDriver);
    pushNotificationService.seubscribeTopic();
    widget.args.isSelected
        ? _currentWidget = DriverOnTheWay(callback)
        : _currentWidget = WhereTo(
            setPickUpAdress: setPickUpAddress,
            setDroppOffAdress: setDroppOffAddress,
            setIsSelected: setIsSelected,
            callback: callback,
            service: Service(callback, searchNearbyDriver));

    widget.args.isSelected ? _getPolyline(widget.args.encodedPts!) : null;

    _determinePosition().then((value) {
      geofireListener(value.latitude, value.longitude);
      Geofire.stopListener();
      geofireListener(value.latitude, value.longitude);
    });
  }

  @override
  void dispose() {
    _serviceStatusStreamSubscription!.cancel();
    _connectivitySubscription.cancel();
    Geofire.stopListener();

    super.dispose();
  }

  void setIsSelected(LatLng destination) {
    setState(() {
      dtn = destination;
    });
  }

  void setPickUpAddress(String address) {
    pickupAddress = address;
  }

  void setDroppOffAddress(String address) {
    droppOffAddress = address;
  }

  void callback(Widget nextwidget) {
    setState(() {
      _currentWidget = nextwidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLocationOn != null) {
      if (isLocationOn! && isModal) {
        setState(() {
          isModal = false;
        });

        Navigator.pop(context);
      }
    }
    if (isLocationOn != null) {
      if (isLocationOn == false && isModal == false) {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          setState(() {
            isModal = true;
          });
          showModalBottomSheet(
              enableDrag: false,
              isDismissible: false,
              context: context,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              builder: (BuildContext ctx) {
                return WillPopScope(
                  onWillPop: () async => false,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    padding: const EdgeInsets.fromLTRB(30, 30, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text("Location Services are off",
                              style: Theme.of(context).textTheme.headline5),
                        ),
                        Expanded(
                            child: Text(
                                "Please enable Location Service to allow us finding your location.",
                                style: Theme.of(context).textTheme.bodyText2)),
                        Expanded(
                            child: Text(
                                "For better accuracy,please turn on both GPS and WIFI location services",
                                style: Theme.of(context).textTheme.bodyText2)),
                        Expanded(
                            child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                await Geolocator.openLocationSettings();
                              },
                              child: Text("Go to Location Services")),
                        )),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                            child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                SystemNavigator.pop();
                              },
                              child: Text("Close App")),
                        ))
                      ],
                    ),
                  ),
                );
              });
        });
      }
    }

    if (_connectionStatus == ConnectivityResult.wifi && isConModal == true ||
        _connectionStatus == ConnectivityResult.mobile && isConModal == true) {
      // setState(() {
      isConModal = false;
      // });
      Navigator.pop(context);
    }

    if (_connectionStatus == ConnectivityResult.none && isConModal == false) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        // setState(() {
        isConModal = true;
        // });
        showModalBottomSheet(
            enableDrag: false,
            isDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () async => false,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  padding: const EdgeInsets.fromLTRB(30, 30, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text("No Internet Connection",
                            style: Theme.of(context).textTheme.headline5),
                      ),
                      Expanded(
                          child: Text(
                              "Please enable WIFI or Mobile Data to allow us finding your location.",
                              style: Theme.of(context).textTheme.bodyText2)),
                      Expanded(
                          child: Text(
                              "For better accuracy,please turn on both GPS and WIFI location services",
                              style: Theme.of(context).textTheme.bodyText2)),
                      Expanded(
                          child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              AppSettings.openDeviceSettings(
                                  asAnotherTask: true);
                            },
                            child: const Text("Go to Settings")),
                      )),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              SystemNavigator.pop();
                            },
                            child: const Text("Close App")),
                      ))
                    ],
                  ),
                ),
              );
            });
      });
    }

    setWillScreenPop = () {
      setState(() {
        willScreenPop = false;
      });
    };

    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(),
      body: WillPopScope(
        onWillPop: () async => willScreenPop,
        child: Stack(
          children: [
            BlocConsumer<DirectionBloc, DirectionState>(builder: (_, state) {
              return Animarker(
                mapId: _controller.future.then((value) => value.mapId),
                curve: Curves.ease,
                // markers: Set<Marker>.of(markers.values),
                shouldAnimateCamera: true,
                child: GoogleMap(
                  // scrollGesturesEnabled: false,
                  // zoomGesturesEnabled: false,
                  // rotateGesturesEnabled: false,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: _addissAbaba,
                  myLocationEnabled: true,
                  polylines: Set<Polyline>.of(polylines.values),
                  markers: Set<Marker>.of(markers.values),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    outerController = controller;
                    // controller.setMapStyle(mapStyle);
                    _determinePosition().then((value) {
                      pickupLatLng = LatLng(value.latitude, value.longitude);

                      currentLatLng = LatLng(value.latitude, value.longitude);

                      controller.animateCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(
                              zoom: 16.1746,
                              target: LatLng(currentLatLng.latitude,
                                  currentLatLng.longitude))));
                    });
                  },
                ),
              );
            }, listener: (_, state) {
              print("Yow we are around here");

              if (state is DirectionLoadSuccess) {
                direction = state.direction.encodedPoints;

                markers.clear();
                setState(() {
                  _getPolyline(state.direction.encodedPoints);
                  _addMarker(
                      dtn,
                      "destination",
                      BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen));
                  _addMarker(
                      LatLng(currentLatLng.latitude, currentLatLng.longitude),
                      "pickup",
                      BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed));
                });

                changeCameraView();
              }
            }),
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  color: Colors.black,
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
            Align(
              alignment: Alignment.centerRight,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    topLeft: Radius.circular(30)),
                child: Container(
                  color: Colors.grey.shade300,
                  child: IconButton(
                      onPressed: () {
                        makePhoneCall('9495');
                      },
                      icon: Icon(
                        Icons.call,
                        color: Colors.indigo.shade900,
                        size: 30,
                      )),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(repo.getNearbyDrivers().length.toString()),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                    onPressed: () async {
                      removeQueryListener();
                      removeQueryListener();
                      removeQueryListener();
                      removeQueryListener();

                      // final g = Geofire();
                      // final res = await Geofire.stopListener();
                      // if (res == true) {

                      //   print("Yow yow yow");
                      //   final res = await Geofire.initialize('availableTrucks');
                      //   if (res == true) {
                      //     await Geofire.queryAtLocation(8.9936827, 38.7695649, 1)!
                      //         .listen((event) {
                      //       print("Yowwwwwwwwwwwwwwwwwwwwww $event");
                      //     });
                      //   }
                      // }
                    },
                    child: Text("Maintenance")),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                    onPressed: () async {
                      // removeQueryListener();
                      // await Geofire.initialize('availableTrucks')
                      //     .whenComplete(() {
                      //   print('completed');
                      //   geofireListener(8.9936827, 38.7695649);
                      // });

                      // if (res == true) {
                      //   print("Yeah initialised");
                      // }

                      // final g = Geofire();
                      // final res = await Geofire.stopListener();
                      // if (res == true) {

                      //   print("Yow yow yow");
                      //   final res = await Geofire.initialize('availableTrucks');
                      //   if (res == true) {
                      //     await Geofire.queryAtLocation(8.9936827, 38.7695649, 1)!
                      //         .listen((event) {
                      //       print("Yowwwwwwwwwwwwwwwwwwwwww $event");
                      //     });
                      //   }
                      // }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TestScreen()));
                    },
                    child: Text("Maintenance")),
              ),
            ),
          ],
        ),
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
        width: 4,
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
    print("Mapppppppppppppppppppppppppppppppppppppppppppppppppppppppaaa");

    try {
      //print(await Geofire.queryAtLocation(lat, lng, 1));

      await Geofire.queryAtLocation(lat, lng, 1)?.listen((map) {
        print("Mapppppppppppppppppppppppppppppppppppppppppppppppppppppppsss");
        print("adeddd ${repo.getIdList()}");

        print('herer is your length ${repo.getNearbyDrivers().length}');

        print(map);
        print("Mappppppppppppppppppppppppppppppppppppppppppppppppppppppp");
        if (map != null) {
          var callBack = map['callBack'];
          print('callBack = $callBack');
          switch (callBack) {
            case Geofire.onKeyEntered:
              repo.addDriver(NearbyDriver(
                  id: map['key'],
                  latitude: map['latitude'],
                  longitude: map['longitude']));
              showDriversOnMap();

              print("adeddd ${repo.getIdList()}");

              break;

            case Geofire.onKeyExited:
              repo.removeDriver(map['key']);
              showDriversOnMap();

              print("now");

              break;

            case Geofire.onKeyMoved:
              print("moved");
              print(map['key']);
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
      });
    } on PlatformException {
      print("platform exceprionnnnnnnnnnnnnnnnnnnnnnnnnnnnnn");
    } catch (_) {
      print("here");
    }
  }

  void showDriversOnMap() {
    print("Length :: ");
    print(repo.getNearbyDrivers().length);
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
      markers = newMarker;
      //   // driverMarkers.
    });
  }

  String? searchNearbyDriver() {
    if (repo.getNearbyDrivers().isEmpty) {
      return null;
    }
    var nearest;
    var nearestDriver;

    for (NearbyDriver driver in repo.getNearbyDrivers()) {
      print("drivers ::");
      print(driver.id);
      double distance = Geolocator.distanceBetween(
          8.9966827, 38.7675547, driver.latitude, driver.longitude);

      nearest ??= distance;

      print(distance);

      if (distance <= nearest) {
        nearest = distance;
        nearestDriver = driver;
      }
    }

    print(nearestDriver.id);

    return nearestDriver.id;
  }

  void changeCameraView() {
    LatLngBounds latLngBounds;

    final destinationLatLng = dtn;
    final pickupLatLng =
        LatLng(currentLatLng.latitude, currentLatLng.longitude);
    if (pickupLatLng.latitude > destinationLatLng.latitude &&
        pickupLatLng.longitude > destinationLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickupLatLng);
    } else if (pickupLatLng.longitude > destinationLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
          northeast:
              LatLng(destinationLatLng.latitude, pickupLatLng.longitude));
    } else if (pickupLatLng.latitude > destinationLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
          northeast:
              LatLng(pickupLatLng.latitude, destinationLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickupLatLng, northeast: destinationLatLng);
    }

    outerController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
  }

  void _toggleServiceStatusStream() {
    if (_serviceStatusStreamSubscription == null) {
      print("yeah it's enabled");

      final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
      _serviceStatusStreamSubscription =
          serviceStatusStream.handleError((error) {
        print("yeah it's the error bruhh $error");

        _serviceStatusStreamSubscription?.cancel();
        _serviceStatusStreamSubscription = null;
      }).listen((serviceStatus) {
        String serviceStatusValue;
        if (serviceStatus == ServiceStatus.enabled) {
          print("yeah it's enabled");
          setState(() {
            isLocationOn = true;
          });
          _determinePosition().then((value) {
            pickupLatLng = LatLng(value.latitude, value.longitude);

            currentLatLng = LatLng(value.latitude, value.longitude);

            outerController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    zoom: 16.1746,
                    target: LatLng(
                        currentLatLng.latitude, currentLatLng.longitude))));
          });
          // if (positionStreamStarted) {
          //   _toggleListening();
          // }
          serviceStatusValue = 'enabled';
        } else {
          setState(() {
            isLocationOn = false;
          });

          print("nope ist's disabled");

          serviceStatusValue = 'disabled';
        }
      });
    }
  }

  void removeQueryListener() async {
    bool? response = await Geofire.stopListener();

    repo.resetList();
    setState(() {});

    print(response);
  }
}



//for maintenance


//           isSelectedd
//               ? BlocBuilder<DirectionBloc, DirectionState>(
//                   builder: (context, state) {
//                   bool isDialog = true;

//                   if (state is DirectionLoadSuccess) {
//                     isDialog = false;

//                     print("Welcome");

//                     _getPolyline(state.direction.encodedPoints);
//                     _addMarker(
//                         dtn,
//                         "destination",
//                         BitmapDescriptor.defaultMarkerWithHue(
//                             BitmapDescriptor.hueGreen));

//                     return GoogleMap(
//                       mapType: MapType.normal,
//                       myLocationButtonEnabled: true,
//                       initialCameraPosition: _addissAbaba,
//                       myLocationEnabled: true,
//                       polylines: Set<Polyline>.of(polylines.values),
//                       markers: Set<Marker>.of(markers.values),
//                       onMapCreated: (GoogleMapController controller) {
//                         // _controller.complete(controller);


//                         _determinePosition().then((value) {
//                           currentLatLng =
//                               LatLng(value.latitude, value.longitude);
//                           setState(() {
//                             _addMarker(
//                                 LatLng(value.latitude, value.longitude),
//                                 "pickup",
//                                 BitmapDescriptor.defaultMarkerWithHue(
//                                     BitmapDescriptor.hueRed));
//                           });

//                           LatLngBounds latLngBounds;

//                           final destinationLatLng = dtn;
//                           final pickupLatLng =
//                               LatLng(value.latitude, value.longitude);
//                           if (pickupLatLng.latitude >
//                                   destinationLatLng.latitude &&
//                               pickupLatLng.longitude >
//                                   destinationLatLng.longitude) {
//                             latLngBounds = LatLngBounds(
//                                 southwest: destinationLatLng,
//                                 northeast: pickupLatLng);
//                           } else if (pickupLatLng.longitude >
//                               destinationLatLng.longitude) {
//                             latLngBounds = LatLngBounds(
//                                 southwest: LatLng(pickupLatLng.latitude,
//                                     destinationLatLng.longitude),
//                                 northeast: LatLng(destinationLatLng.latitude,
//                                     pickupLatLng.longitude));
//                           } else if (pickupLatLng.latitude >
//                               destinationLatLng.latitude) {
//                             latLngBounds = LatLngBounds(
//                                 southwest: LatLng(destinationLatLng.latitude,
//                                     pickupLatLng.longitude),
//                                 northeast: LatLng(pickupLatLng.latitude,
//                                     destinationLatLng.longitude));
//                           } else {
//                             latLngBounds = LatLngBounds(
//                                 southwest: pickupLatLng,
//                                 northeast: destinationLatLng);
//                           }

//                           controller.animateCamera(
//                               CameraUpdate.newLatLngBounds(latLngBounds, 70));
//                         });
//                       },
//                     );
//                   }
//                   if (state is DirectionOperationFailure) {
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       content: const Text("Unable to find direction"),
//                       backgroundColor: Colors.red.shade900,
//                     ));
//                     return GoogleMap(
//                       mapType: MapType.terrain,
//                       buildingsEnabled: false,
//                       indoorViewEnabled: true,
//                       tiltGesturesEnabled: false,
//                       trafficEnabled: false,
//                       myLocationButtonEnabled: true,
//                       initialCameraPosition: _addissAbaba,
//                       myLocationEnabled: true,
//                       onMapCreated: (GoogleMapController controller) {
//                         _controller.complete(controller);

//                         _determinePosition().then((value) {
//                           currentLatLng =
//                               LatLng(value.latitude, value.longitude);
//                           controller.animateCamera(
//                               CameraUpdate.newCameraPosition(CameraPosition(
//                                   zoom: 14.4746,
//                                   target: LatLng(
//                                       value.latitude, value.longitude))));
//                         });
//                       },
//                     );
//                   }
//                   return isDialog
//                       ? AlertDialog(
//                           content: Row(
//                             children: const [
//                               CircularProgressIndicator(),
//                               Text("finding direction")
//                             ],
//                           ),
//                         )
//                       : Container();
//                 })
//               : GoogleMap(
//                   mapType: MapType.terrain,
//                   buildingsEnabled: false,
//                   indoorViewEnabled: true,
//                   tiltGesturesEnabled: false,
//                   trafficEnabled: false,
//                   myLocationButtonEnabled: true,
//                   initialCameraPosition: _addissAbaba,
//                   markers: Set<Marker>.of(driverMarkers.values),
//                   myLocationEnabled: true,
//                   onMapCreated: (GoogleMapController controller) {
//                     print(driverMarkers);
//                     _controller.complete(controller);

//                     _determinePosition().then((value) async {
//                       currentLatLng = LatLng(value.latitude, value.longitude);
//                       geofireListener(value.latitude, value.longitude);

//                       WidgetsBinding.instance!
//                           .addPostFrameCallback((timeStamp) {
//                         geofireListener(value.latitude, value.longitude);
//                       });

//                       controller.animateCamera(CameraUpdate.newCameraPosition(
//                           CameraPosition(
//                               zoom: 14.4746,
//                               target:
//                                   LatLng(value.latitude, value.longitude))));
//                     });
//                   },
//                 ),