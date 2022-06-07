import 'dart:collection';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/bloc/database/location_history_bloc.dart';
import 'package:passengerapp/bloc/driver/driver_bloc.dart';
import 'package:passengerapp/cubit/favorite_location.dart';
import 'package:passengerapp/drawer/drawer.dart';
import 'package:passengerapp/helper/constants.dart';

import 'package:passengerapp/helper/url_launcher.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/models/nearby_driver.dart';
import 'package:passengerapp/notification/push_notification_service.dart';
import 'package:passengerapp/repository/nearby_driver.dart';
import 'package:passengerapp/rout.dart';
import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as La;
import 'package:passengerapp/screens/home/assistant/home_screen_assistant.dart';
import 'package:passengerapp/screens/home/test.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:flutter/services.dart' show rootBundle;

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
  BitmapDescriptor? carMarkerIcon;
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController outerController;
  NearbyDriverRepository repo = NearbyDriverRepository();
  NearbyTrucksRepository truckRepo = NearbyTrucksRepository();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};
  Map<MarkerId, Marker> carMarker = {};
  late LatLng currentLatLng;
  PushNotificationService pushNotificationService = PushNotificationService();
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();
  final ReceivePort _port = ReceivePort();
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('bookedDrivers');
  static const CameraPosition _addissAbaba = CameraPosition(
    target: LatLng(8.9806, 38.7578),
    zoom: 16.4746,
  );
  late String _darkMapStyle;
  late String serviceStatusValue;
  bool? internetServiceStatus;
  late bool isFirstTime;
  late String brightness;
  late Position currentPostion;
  late LatLngBounds latLngBounds;
  late bool _directionLoadSuccess;

  Future _loadMapStyles() async {
    _darkMapStyle =
        await rootBundle.loadString('assets/map_styles/aubergine.json');
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!serviceEnabled) {
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
    _directionLoadSuccess = false;
    _loadMapStyles();
    _checkLocationServiceOnInit();
    _toggleLocationServiceStatusStream();
    _toggleInternetServiceStatusStream();
    _listenBackGroundMessage();
    pushNotificationService.initialize(context);
    pushNotificationService.seubscribeTopic();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        if (widget.args.isSelected) {
          _getPolyline(widget.args.encodedPts!);
          showBookedDriver();
        }
      });
    });
    var window = WidgetsBinding.instance!.window;
    window.onPlatformBrightnessChanged = () {
      if (window.platformBrightness == Brightness.dark) {
        outerController.setMapStyle(_darkMapStyle);
        BlocProvider.of<ThemeModeCubit>(context).ActivateDarkTheme();
      } else {
        outerController.setMapStyle('[]');
        BlocProvider.of<ThemeModeCubit>(context).ActivateLightTheme();
      }
    };
    _currentWidget = widget.args.isSelected
        ? DriverOnTheWay(
            fromBackGround: false,
          )
        : WhereTo();

    super.initState();
  }

  @override
  void dispose() {
    context.read<UserBloc>().add(UserSetAvailability([], false));
    IsolateNameServer.removePortNameMapping(portName);
    _serviceStatusStreamSubscription!.cancel();
    _connectivitySubscription!.cancel();
    Geofire.stopListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    createMarkerIcon();
    requestAccepted = showBookedDriver;
    return Scaffold(
      backgroundColor: backGroundColor,
      key: _scaffoldKey,
      drawer: NavDrawer(),
      body: Stack(
        children: [
          BlocConsumer<ThemeModeCubit, ThemeMode>(
              builder: (context, themeModeState) =>
                  BlocConsumer<DirectionBloc, DirectionState>(
                      builder: (_, state) {
                    return Animarker(
                      mapId: _controller.future.then((value) => value.mapId),
                      curve: Curves.ease,
                      markers: Set<Marker>.of(carMarker.values),
                      shouldAnimateCamera: true,
                      child: GoogleMap(
                        padding: const EdgeInsets.only(
                            top: 100, right: 10, bottom: 250),
                        zoomControlsEnabled: false,
                        mapType: MapType.normal,
                        myLocationButtonEnabled: false,
                        initialCameraPosition: _addissAbaba,
                        myLocationEnabled: true,
                        polylines: Set<Polyline>.of(polylines.values),
                        markers: Set<Marker>.of(markers.values),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          outerController = controller;
                          _determinePosition().then((value) {
                            context.read<UserBloc>().add(UserSetAvailability(
                                [value.longitude, value.latitude], true));
                            currentPostion = value;
                            if (widget.args.isFromSplash) {
                              carTypeSelectorDialog(value);
                            }
                            MediaQuery.of(context).platformBrightness ==
                                    Brightness.dark
                                ? controller.setMapStyle(_darkMapStyle)
                                : null;
                            currentLatLng =
                                LatLng(value.latitude, value.longitude);
                            pickupLatLng = currentLatLng;
                            controller.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    zoom: 16.1746, target: currentLatLng)));
                          });
                        },
                      ),
                    );
                  }, listener: (_, state) {
                    if (state is DirectionInitialState) {
                      Navigator.pop(context);

                      resetScreen(state.loadCurrentLocation,
                          state.listenToNearbyDriver);
                    }
                    if (state is DirectionLoading) {
                      showDialog(
                          // barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return WillPopScope(
                              onWillPop: () async => false,
                              child: const Dialog(
                                  elevation: 0,
                                  insetPadding: EdgeInsets.all(0),
                                  backgroundColor: Colors.transparent,
                                  child: Center(
                                    child: SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 1)),
                                  )),
                            );
                          });
                    }
                    if (state is DirectionLoadSuccess) {
                      direction = state.direction.encodedPoints;
                      //tre

                      markers.clear();
                      setState(() {
                        _getPolyline(state.direction.encodedPoints);
                        _addMarker(
                            droppOffLatLng,
                            "destination",
                            BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueRed),
                            InfoWindow(
                                title: droppOffAddress,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, LocationChanger.routName,
                                      arguments: LocationChangerArgument(
                                        droppOffLocationAddressName:
                                            droppOffAddress,
                                        droppOffLocationLatLng: droppOffLatLng,
                                        pickupLocationAddressName:
                                            pickupAddress,
                                        pickupLocationLatLng: pickupLatLng,
                                        fromWhere: 'DroppOff',
                                      ));
                                }));
                        _addMarker(
                            LatLng(
                                pickupLatLng.latitude, pickupLatLng.longitude),
                            "pickup",
                            BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueGreen),
                            InfoWindow(
                                title: pickupAddress,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, LocationChanger.routName,
                                      arguments: LocationChangerArgument(
                                        droppOffLocationAddressName:
                                            droppOffAddress,
                                        droppOffLocationLatLng: droppOffLatLng,
                                        pickupLocationAddressName:
                                            pickupAddress,
                                        pickupLocationLatLng: pickupLatLng,
                                        fromWhere: 'PickUp',
                                      ));
                                }));
                      });

                      changeCameraView();

                      Navigator.pop(context);
                    }

                    if (state is DirectionOperationFailure) {
                      Navigator.pop(context);
                    }
                  }),
              listener: (context, themeModeState) {
                themeModeState == ThemeMode.dark
                    ? outerController.setMapStyle(_darkMapStyle)
                    : outerController.setMapStyle('[]');
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
          Align(
            alignment: Alignment.centerLeft,
            child: Text(repo.getNearbyDrivers().length.toString()),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                  onPressed: () async {
                    context
                        .read<CurrentWidgetCubit>()
                        .changeWidget(DriverOnTheWay(fromBackGround: false));

                    debugPrint(repo.getNearbyDrivers().length.toString());
                  },
                  child: const Text("Maintenance")),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 45,
                      child: FloatingActionButton(
                          heroTag: 'Mylocation',
                          // backgroundColor: Colors.grey.shade300,
                          onPressed: () {
                            outerController.animateCamera(
                                _directionLoadSuccess &&
                                        _currentWidget.toString() != "WhereTo"
                                    ? CameraUpdate.newLatLngBounds(
                                        latLngBounds, 100)
                                    : CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                            zoom: 16.4746,
                                            target: pickupLatLng)));
                          },
                          child: Icon(Icons.gps_fixed, size: 30)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 45,
                      child: FloatingActionButton(
                        onPressed: () {
                          makePhoneCall('9495');
                        },
                        child: Icon(Icons.call, size: 30),
                      ),
                    ),
                  ),
                  BlocConsumer<EmergencyReportBloc, EmergencyReportState>(
                      builder: (context, state) => Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: 45,
                              child: FloatingActionButton(
                                  heroTag: 'sos',
                                  // backgroundColor: Colors.grey.shade300,
                                  onPressed: () {
                                    EmergencyReportEvent event =
                                        EmergencyReportCreate(EmergencyReport(
                                            location: [
                                          currentLatLng.latitude,
                                          currentLatLng.longitude
                                        ]));

                                    BlocProvider.of<EmergencyReportBloc>(
                                            context)
                                        .add(event);
                                  },
                                  child: Text(
                                    'SOS',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),

                                    // color: Colors.indigo.shade900,
                                    // size: 35,
                                  )),
                            ),
                          ),
                      listener: (context, state) {
                        if (state is EmergencyReportCreating) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Row(
                                    children: const [
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1,
                                          color: Colors.red,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Reporting.."),
                                    ],
                                  ),
                                );
                              });
                        }
                        if (state is EmergencyReportCreated) {
                          Navigator.pop(context);

                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Row(
                                    children: const [
                                      SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Icon(Icons.done,
                                              color: Colors.green)),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Emergency report has been sent"),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Okay'))
                                  ],
                                );
                              });
                        }
                        if (state is EmergencyReportOperationFailur) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text("Reporting Failed."),
                              backgroundColor: Colors.red.shade900));
                        }
                      }),
                ],
              ),
            ),
          ),
          BlocConsumer<CurrentWidgetCubit, Widget>(
              builder: (context, state) => _currentWidget,
              listener: (context, state) {
                _currentWidget = state;
              })
        ],
      ),
    );
  }

  String generateRandomId() {
    var r = Random();
    final list = List.generate(3, (index) => r.nextInt(33) + 89);
    return String.fromCharCodes(list);
  }

  void resetScreen(bool determinePosition, bool listenToNearbyTaxi) {
    if (determinePosition) {
      _directionLoadSuccess = false;
      _determinePosition().then((value) {
        outerController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                zoom: 16.1746,
                target: LatLng(value.latitude, value.longitude))));
        switch (selectedCar) {
          case SelectedCar.taxi:
            listenTaxi(value);
            break;
          case SelectedCar.truck:
            listenTruck(value);
            break;
          case SelectedCar.none:
            break;
        }
      });
    } else if (!determinePosition && !listenToNearbyTaxi) {
      outerController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(zoom: 16.1746, target: currentLatLng)));
    } else if (listenToNearbyTaxi) {
      outerController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(zoom: 16.1746, target: currentLatLng)));
      switch (selectedCar) {
        case SelectedCar.taxi:
          listenTaxi(currentPostion);
          break;
        case SelectedCar.truck:
          listenTruck(currentPostion);
          break;
        case SelectedCar.none:
          break;
      }
    }

    setState(() {
      _currentWidget = WhereTo();
      markers.clear();
      polylines.clear();
      carMarker.clear();
      showCarIcons = true;
    });
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor,
      InfoWindow infoWindow) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
        markerId: markerId,
        icon: descriptor,
        position: position,
        infoWindow: infoWindow);
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
        color: Theme.of(context).canvasColor,
        geodesic: true,
        points: polylineCoordinates);

    polylines[id] = polyline;

    //Future.delayed(Duration(seconds: 1), () {});
  }

  void geofireListener(
      double lat, double lng, String type, double radius) async {
    repo.resetList();

    try {
      switch (type) {
        case 'Taxi':
          Geofire.queryAtLocation(lat, lng, radius)!.listen((data) {
            if (data != null) {
              var callback = data['callBack'];
              switch (callback) {
                case Geofire.onKeyEntered:
                  debugPrint('Added');

                  repo.addDriver(NearbyDriver(
                      id: data['key'],
                      latitude: data['latitude'],
                      longitude: data['longitude']));
                  if (showCarIcons) {
                    showDriversOnMap();
                  }
                  break;
                case Geofire.onKeyExited:
                  debugPrint('Removed');
                  repo.removeDriver(data['key']);
                  setState(() {
                    markers.remove(MarkerId(data['key']));
                  });
                  break;
                case Geofire.onKeyMoved:
                  debugPrint('Moved');
                  repo.updateDriver(NearbyDriver(
                      id: data['key'],
                      latitude: data['latitude'],
                      longitude: data['longitude']));
                  if (showCarIcons) {
                    showDriversOnMap();
                  }
                  break;
                case Geofire.onGeoQueryReady:
                  break;
              }
            }
          });

          break;
        case 'Truck':
          Geofire.queryAtLocation(lat, lng, radius)!.listen((data) {
            if (data != null) {
              var callback = data['callBack'];
              switch (callback) {
                case Geofire.onKeyEntered:
                  debugPrint('Added');
                  truckRepo.addDriver(NearbyDriver(
                      id: data['key'],
                      latitude: data['latitude'],
                      longitude: data['longitude']));
                  if (showCarIcons) {
                    showTrucksOnMap();
                  }
                  break;
                case Geofire.onKeyExited:
                  debugPrint('Removed');
                  truckRepo.removeDriver(data['key']);
                  setState(() {
                    markers.remove(MarkerId(data['key']));
                  });
                  break;
                case Geofire.onKeyMoved:
                  debugPrint('Moved');
                  truckRepo.updateDriver(NearbyDriver(
                      id: data['key'],
                      latitude: data['latitude'],
                      longitude: data['longitude']));
                  if (showCarIcons) {
                    showTrucksOnMap();
                  }
                  break;
                case Geofire.onGeoQueryReady:
                  break;
              }
            }
          });
          break;
      }
    } on PlatformException {
      throw Exception('platform Eceprion');
    } catch (_) {
      throw Exception(_);
    }
  }

  void showDriversOnMap() {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: Size(1, 2));
    Map<MarkerId, Marker> newMarker = {};
    for (NearbyDriver driver in repo.getNearbyDrivers()) {
      LatLng driverPosition = LatLng(driver.latitude, driver.longitude);
      MarkerId markerId = MarkerId(driver.id);

      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/icons/standard.png')
          .then((value) {
        Marker marker =
            Marker(markerId: markerId, position: driverPosition, icon: value);

        newMarker[markerId] = marker;
        setState(() {
          markers[markerId] = marker;
        });
      });
    }

    // setState(() {
    //   markers = newMarker;
    // });
  }

  void showTrucksOnMap() {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: Size(1, 2));
    Map<MarkerId, Marker> newMarker = {};
    for (NearbyDriver driver in repo.getNearbyDrivers()) {
      LatLng driverPosition = LatLng(driver.latitude, driver.longitude);
      MarkerId markerId = MarkerId(driver.id);

      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/icons/truck.png')
          .then((value) {
        Marker marker =
            Marker(markerId: markerId, position: driverPosition, icon: value);

        newMarker[markerId] = marker;
        setState(() {
          markers[markerId] = marker;
        });
      });
    }

    // setState(() {
    //   markers = newMarker;
    // });
  }

  void changeCameraView() {
    final destinationLatLng = droppOffLatLng;
    // final pickupLatLng = pickUp;
    // pickupLatLng = LatLng(currentLatLng.latitude, currentLatLng.longitude);
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
    _directionLoadSuccess = true;

    outerController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
  }

  void _toggleLocationServiceStatusStream() {
    if (_serviceStatusStreamSubscription == null) {
      final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
      _serviceStatusStreamSubscription =
          serviceStatusStream.handleError((error) {
        _serviceStatusStreamSubscription?.cancel();
        _serviceStatusStreamSubscription = null;
      }).listen((serviceStatus) {
        if (serviceStatus == ServiceStatus.enabled) {
          if (serviceStatusValue == "disabled") {
            Navigator.pop(context);
            if (isFirstTime) {
              Geolocator.getCurrentPosition().then((value) {
                carTypeSelectorDialog(value);
                currentLatLng = LatLng(value.latitude, value.longitude);
                // pickupLatLng = currentLatLng;
                outerController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(zoom: 16.1746, target: currentLatLng)));
              });
            }
            isFirstTime = false;
          }
          serviceStatusValue = 'enabled';
        } else {
          debugPrint("Disableddddd");
          locationServiceButtomSheet();

          serviceStatusValue = 'disabled';
        }
      });
    }
  }

  void _toggleInternetServiceStatusStream() {
    if (_connectivitySubscription == null) {
      _connectivitySubscription ==
          _connectivity.onConnectivityChanged.listen((event) {
            if (event == ConnectivityResult.none) {
              internetServiceButtomSheet();
            } else if (event == ConnectivityResult.wifi) {
              if (internetServiceStatus != null) {
                internetServiceStatus! ? Navigator.pop(context) : null;
              }
            } else if (event == ConnectivityResult.mobile) {
              if (internetServiceStatus != null) {
                internetServiceStatus! ? Navigator.pop(context) : null;
              }
            }
          });
    }
  }

  void _listenBackGroundMessage() {
    IsolateNameServer.registerPortWithName(_port.sendPort, portName);
    _port.listen((message) {
      switch (message.data['response']) {
        case "Accepted":
          Geofire.stopListener();
          driverId = message.data['myId'];
          BlocProvider.of<CurrentWidgetCubit>(context)
              .changeWidget(DriverOnTheWay(
            fromBackGround: true,
          ));
          requestAccepted();
          break;
        case "Arrived":
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(" Driver Arrived"),
            backgroundColor: Colors.indigo.shade900,
          ));
          break;
        case "Completed":
          BlocProvider.of<DirectionBloc>(context).add(
              const DirectionChangeToInitialState(
                  loadCurrentLocation: true, listenToNearbyDriver: false));
          Navigator.pushNamed(context, ReviewScreen.routeName,
              arguments: ReviewScreenArgument(price: message.data['price']));
          break;
        case 'Started':
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(" Trip Started"),
            backgroundColor: Colors.indigo.shade900,
          ));
          BlocProvider.of<CurrentWidgetCubit>(context)
              .changeWidget(StartedTripPannel());
          break;
        case "TimeOut":
          BlocProvider.of<CurrentWidgetCubit>(context)
              .changeWidget(Service(true, false));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Time out"),
            backgroundColor: Colors.indigo.shade900,
          ));
          break;
        default:
      }
    });
  }

  void showBookedDriver() {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: Size(0.5, 1));
    MarkerId markerId = MarkerId(generateRandomId());
    databaseReference.onValue.listen((event) {
      debugPrint(event.snapshot.value.toString());
      if (event.snapshot.child('$driverId/lat').value != null) {
        final position = LatLng(
            double.parse(
                event.snapshot.child('$driverId/lat').value.toString()),
            double.parse(
                event.snapshot.child('$driverId/lng').value.toString()));

        Marker marker = Marker(
            markerId: markerId, position: position, icon: carMarkerIcon!);
        setState(() {
          carMarker[markerId] = marker;
        });
      }
    });
  }

  void createMarkerIcon() {
    if (carMarkerIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(1, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/icons/car.png')
          .then((value) {
        carMarkerIcon = value;
      });
    }
  }

  void carTypeSelectorDialog(Position value) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              elevation: 0,
              insetPadding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.3),
              backgroundColor: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilterChip(
                      backgroundColor: Theme.of(context).backgroundColor,
                      label: Text(
                        "Truck",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      onSelected: (selexted) {
                        selectedCar = SelectedCar.truck;
                        listenTruck(value);
                        Navigator.pop(context);
                      }),
                  FilterChip(
                      backgroundColor: Theme.of(context).backgroundColor,
                      label: Text(
                        "Taxi ",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      onSelected: (selexted) {
                        selectedCar = SelectedCar.taxi;
                        listenTaxi(value);
                        Navigator.pop(context);
                      }),
                  // FilterChip(label: Text("Taxi"), onSelected: (selexted) {}),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       selectedCar = SelectedCar.truck;
                  //       listenTruck(value);
                  //       Navigator.pop(context);
                  //     },
                  //     child: const Text('Truck')),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       selectedCar = SelectedCar.taxi;
                  //       listenTaxi(value);
                  //       Navigator.pop(context);
                  //     },
                  //     child: const Text('Taxi')),
                ],
              ),
            ),
          );
        });
  }

  void locationServiceButtomSheet() {
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
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
                    child: Text("Enable Location Services",
                        style: Theme.of(context).textTheme.headline5),
                  ),
                  const Expanded(
                      child: Center(
                    child: Icon(Icons.location_off_outlined,
                        color: buttonColor, size: 60),
                  )),
                  const Expanded(child: SizedBox()),
                  Expanded(
                      child: Text(
                          "We can't get your location because you have disabled location services. Please turn it on for better experience.",
                          style: Theme.of(context).textTheme.bodyText2)),
                  Expanded(
                      child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          await Geolocator.openLocationSettings();
                        },
                        child: const Text("TURN ON LOCATION SERVICES")),
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
                        child: const Text("CANCEL")),
                  ))
                ],
              ),
            ),
          );
        });
  }

  void internetServiceButtomSheet() {
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        context: context,
        builder: (BuildContext context) {
          internetServiceStatus = true;
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
                  const Expanded(
                      child: Center(
                    child: Icon(
                        Icons
                            .signal_wifi_statusbar_connected_no_internet_4_rounded,
                        color: buttonColor,
                        size: 60),
                  )),
                  const Expanded(child: SizedBox()),
                  Expanded(
                      child: Text(
                          "Please enable WIFI or Mobile data to serve the app",
                          style: Theme.of(context).textTheme.bodyText2)),
                  // Expanded(
                  //     child: Text(
                  //         "For better accuracy,please turn on both GPS and WIFI location services",
                  //         style: Theme.of(context).textTheme.bodyText2)),
                  Expanded(
                      child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          AppSettings.openDeviceSettings(asAnotherTask: true);
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
                        child: const Text("Cancel")),
                  ))
                ],
              ),
            ),
          );
        });
  }

  void listenTaxi(Position value) {
    Geofire.initialize('availableDrivers');
    geofireListener(value.latitude, value.longitude, 'Taxi', 1);
    geofireListener(value.latitude, value.longitude, 'Taxi', 1);
  }

  void listenTruck(Position value) {
    Geofire.initialize('availableTrucks');
    geofireListener(value.latitude, value.longitude, 'Truck', 2);
    geofireListener(value.latitude, value.longitude, 'Truck', 2);
  }

  void _checkLocationServiceOnInit() async {
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        isFirstTime = true;

        locationServiceButtomSheet();
        serviceStatusValue = 'disabled';

        return Future.error("NoLocation Enabled");
      }

      return Future.error('Location services are disabled.');
    } else {
      isFirstTime = false;
    }
  }

  void checkInterNetServiceOnInit() async {
    ConnectivityResult result;
    result = await _connectivity.checkConnectivity();

    if (result == ConnectivityResult.none) {
      internetServiceButtomSheet();
    }
  }
}



// onWillPop: () async {
//           switch (_currentWidget.toString()) {
//             case 'WhereTo':
//               return true;
//             case 'Service':
//               setState(() {
//                 polylines.clear();
//                 markers.clear();
//                 showCarIcons = true;
//               });

//               outerController.animateCamera(CameraUpdate.newCameraPosition(
//                   CameraPosition(zoom: 16.4746, target: currentLatLng)));
//               context.read<CurrentWidgetCubit>().changeWidget(WhereTo());
//               return false;
//             case 'WaitingDriverResponse':
//               return false;
//             case 'DriverOnTheWay(callback)':
//               return false;
//             default:
//               return true;
//           }
//         },
