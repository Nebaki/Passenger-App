import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/cubit/cubits.dart';
import 'package:passengerapp/drawer/drawer.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/helper/url_launcher.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/models/nearby_driver.dart';
import 'package:passengerapp/notification/push_notification_service.dart';
import 'package:passengerapp/repository/nearby_driver.dart';
import 'package:passengerapp/rout.dart';
import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:passengerapp/screens/home/assistant/home_screen_assistant.dart';
import 'package:passengerapp/screens/screens.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:passengerapp/widgets/widgets.dart';

import '../../utils/waver.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  final HomeScreenArgument args;

  const HomeScreen({Key? key, required this.args}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  late String _nightMapStyle;
  late String serviceStatusValue;
  bool? internetServiceStatus;
  late bool isFirstTime;
  late String brightness;
  late Position currentPostion;
  late LatLngBounds latLngBounds;

  Future _loadMapStyles() async {
    _nightMapStyle =
        await rootBundle.loadString("assets/map_styles/night.json");
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
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void initState() {
    _loadMapStyles();
    _checkLocationServiceOnInit();
    _toggleLocationServiceStatusStream();
    _toggleInternetServiceStatusStream();
    _listenBackGroundMessage();
    pushNotificationService.initialize(context);
    pushNotificationService.subscribeTopic();
    loadStartedTrip();

    if (context.read<ThemeModeCubit>().state == ThemeMode.system) {
      var window = WidgetsBinding.instance.window;
      window.onPlatformBrightnessChanged = () {
        if (window.platformBrightness == Brightness.dark) {
          _controller.future.whenComplete(() {
            outerController.setMapStyle(_nightMapStyle);
          });
        }
      };
    } else if (context.read<ThemeModeCubit>().state == ThemeMode.dark) {
      _controller.future.whenComplete(() {
        outerController.setMapStyle(_nightMapStyle);
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping(portName);
    _serviceStatusStreamSubscription!.cancel();
    _connectivitySubscription!.cancel();
    Geofire.stopListener();
    super.dispose();
  }

  Padding _drawerAction(){
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: SizedBox(
        height: 45,
        child: FloatingActionButton(
          elevation: 5,
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
          child: Icon(
            Icons.format_align_center,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
  Align _currentLocation(){
    return Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          height: 45,
          child: FloatingActionButton(
              heroTag: 'Mylocation',
              // backgroundColor: Colors.grey.shade300,
              onPressed: () {
                outerController.animateCamera(context
                    .read<CurrentWidgetCubit>()
                    .state
                    .key !=
                    const Key("whereto")
                    ? CameraUpdate.newLatLngBounds(
                    latLngBounds, 100)
                    : CameraUpdate.newCameraPosition(
                    CameraPosition(
                        zoom: 16.4746,
                        target: LatLng(
                            currentPostion.latitude,
                            currentPostion
                                .longitude))));
              },
              child: const Icon(Icons.gps_fixed, size: 20)),
        ),
      );
  }
  Align _callCenter(){
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        height: 45,
        child: FloatingActionButton(
          onPressed: () async {
            makePhoneCall('9495');
          },
          child: const Icon(Icons.call, size: 20),
        ),
      ),
    );
  }
  Padding _selectCar(){
    return Padding(
      padding: const EdgeInsets.only(top: 150.0),
      child: SizedBox(
          height: 45,
          child: FloatingActionButton(
            onPressed: () async {
              Geolocator.getCurrentPosition().then((value) {
                carTypeSelectorDialog(value);
                currentPostion = value;
                userPostion = currentPostion;
                currentLatLng = LatLng(value.latitude, value.longitude);
                // pickupLatLng = currentLatLng;
                outerController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(zoom: 14.1746, target: currentLatLng)));
              });
            },
            child: const Icon(Icons.car_rental, size: 20),
          ),
        ),
    );
  }

  BlocConsumer<EmergencyReportBloc, EmergencyReportState> _emergencyReport(){
    return BlocConsumer<EmergencyReportBloc,
        EmergencyReportState>(
        builder: (context, state) => Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            height: 45,
            child: FloatingActionButton(
                heroTag: 'sos',
                // backgroundColor: Colors.grey.shade300,
                onPressed: () {
                  EmergencyReportEvent event =
                  EmergencyReportCreate(
                      EmergencyReport(location: [
                        currentLatLng.latitude,
                        currentLatLng.longitude
                      ]));

                  BlocProvider.of<
                      EmergencyReportBloc>(
                      context)
                      .add(event);
                  /*_determinePosition().then((value) {
                    currentPostion = value;
                    userPostion = currentPostion;
                    context.read<UserBloc>().add(UserSetAvailability(
                        [value.longitude, value.latitude], true));
                    currentPostion = value;
                    if (widget.args.isFromSplash) {
                      carTypeSelectorDialog(value);
                    }
                  });*/
                },
                child: const Text(
                  'SOS',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                )),
          ),
        ),
        listener: (context, state) {
          if (state is EmergencyReportCreating) {
            ShowSnack(context: context,
                message: getTranslation(context,
                    "emergency_reporting_message"),
                duration: 20,
                textColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor).show();
          }
          if (state is EmergencyReportCreated) {

            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ShowSnack(
                context: context,
                message: "Emergency report has been sent.",
                backgroundColor: Colors.green).show();
          }
          if (state is EmergencyReportOperationFailur) {
            ShowSnack(context: context,message: "Reporting Failed, Try Again",
                backgroundColor: Colors.red).show();
          }
        });
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
                            currentPostion = value;
                            userPostion = currentPostion;
                            context.read<UserBloc>().add(UserSetAvailability(
                                [value.longitude, value.latitude], true));
                            currentPostion = value;
                            if (widget.args.isFromSplash) {
                              carTypeSelectorDialog(value);
                            }
                            currentLatLng =
                                LatLng(value.latitude, value.longitude);
                            pickupLatLng = currentLatLng;
                            controller.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    zoom: 14.1746, target: currentLatLng)));
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
                                        child: CircularProgressIndicator()),
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
                    ? outerController.setMapStyle(_nightMapStyle)
                    : outerController.setMapStyle('[]');
              }),
          _drawerAction(),
          _selectCar(),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(repo.getNearbyDrivers().length.toString()),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 38),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _currentLocation(),
                          _callCenter(),
                          _emergencyReport(),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: BlocBuilder<CurrentWidgetCubit, Widget>(
                    builder: (context, state) {
                      return state;
                    },
                  ),
                ),
              ],
            ),
          ),
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
      _determinePosition().then((value) {
        currentPostion = value;
        userPostion = currentPostion;
        outerController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                zoom: 14.1746,
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
          CameraPosition(zoom: 14.1746, target: currentLatLng)));
    } else if (listenToNearbyTaxi) {
      outerController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(zoom: 14.1746, target: currentLatLng)));
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
    context.read<CurrentWidgetCubit>().changeWidget(const WhereTo(
          key: Key("whereto"),
        ));

    setState(() {
      // _currentWidget = WhereTo();
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
      for (var point in result) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    _addPolyLine();
  }

  _addPolyLine() {
    polylines.clear();
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        width: 4,
        polylineId: id,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        color: Theme.of(context).primaryColor,
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
        createLocalImageConfiguration(context, size: const Size(0.5, 1));
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
        createLocalImageConfiguration(context, size: const Size(0.5, 1));
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
  }

  void changeCameraView() {
    final destinationLatLng = droppOffLatLng;
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
                currentPostion = value;
                userPostion = currentPostion;
                currentLatLng = LatLng(value.latitude, value.longitude);
                // pickupLatLng = currentLatLng;
                outerController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(zoom: 14.1746, target: currentLatLng)));
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
              debugPrint("yow none");

              internetServiceButtomSheet();
              internetServiceStatus = true;
            } else if (event == ConnectivityResult.wifi) {
              debugPrint("yow wifi");

              if (internetServiceStatus != null) {
                internetServiceStatus! ? Navigator.pop(context) : null;
              }
            } else if (event == ConnectivityResult.mobile) {
              debugPrint("yow mobile");

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
      print(
          "Dataaaaaaaaaaaaaa Has Arrivedd Bruhhhhhhhh ${message.data['response']}");
      switch (message.data['response']) {
        case "Accepted":
          Geofire.stopListener();
          driverId = message.data['myId'];
          BlocProvider.of<CurrentWidgetCubit>(context)
              .changeWidget(const DriverOnTheWay(
            fromBackGround: true,
            appOpen: false,
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
              .changeWidget(const StartedTripPannel());
          break;
        case "TimeOut":
          BlocProvider.of<CurrentWidgetCubit>(context)
              .changeWidget(const Service(true, false));
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
          createLocalImageConfiguration(context, size: const Size(0.5, 1));
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
              alignment: Alignment.center,
              elevation: 0,/*
              insetPadding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.3),*/
              backgroundColor: Colors.transparent,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                        )
                      ]),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(13.0),
                              child: Text(
                                "What are You Looking for?",
                                style: TextStyle(fontSize: 14,color: Theme.of(context).primaryColor
                                ),
                              ),
                            ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                selectedCar = SelectedCar.truck;
                                listenTruck(value);
                                Navigator.pop(context);
                              },
                              child: Text("Truck")),
                          ElevatedButton(
                              onPressed: () {
                                selectedCar = SelectedCar.taxi;
                                listenTaxi(value);
                                Navigator.pop(context);
                              },
                              child: Text("Taxi")),
                        ],
                      ),
                    ],
                  ),
                ),
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
                    flex: 2,
                    child: Text(
                        getTranslation(
                            context, "location_service_off_buttom_sheet_title"),
                        style: Theme.of(context).textTheme.headline5),
                  ),
                  const Expanded(
                      flex: 2,
                      child: Center(
                        child: Icon(Icons.location_off_outlined,
                            color: buttonColor, size: 60),
                      )),
                  // const Expanded(child: SizedBox()),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      flex: 3,
                      child: Text(
                          getTranslation(context,
                              "location_service_off_buttom_sheet_text"),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2)),
                  Expanded(
                      flex: 2,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              AppSettings.openLocationSettings(
                                  asAnotherTask: true);
                              // await Geolocator.openLocationSettings();
                            },
                            child: Text(
                              getTranslation(context,
                                  "location_service_off_buttom_sheet_acction_button_top"),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            )),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      flex: 2,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              SystemNavigator.pop();
                            },
                            child: Text(getTranslation(context, "cancel"))),
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
          return WillPopScope(
            onWillPop: () async => false,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              padding: const EdgeInsets.fromLTRB(30, 30, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                        getTranslation(
                            context, "internet_service_off_buttom_sheet_title"),
                        style: Theme.of(context).textTheme.headline5),
                  ),
                  const Expanded(
                      flex: 2,
                      child: Center(
                        child: Icon(
                            Icons
                                .signal_wifi_statusbar_connected_no_internet_4_rounded,
                            color: buttonColor,
                            size: 60),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      flex: 3,
                      child: Text(
                          getTranslation(context,
                              "internet_service_off_buttom_sheet_text"),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2)),
                  Expanded(
                      flex: 2,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              AppSettings.openDeviceSettings(
                                  asAnotherTask: true);
                            },
                            child: Text(getTranslation(context,
                                "internet_service_off_buttom_sheet_acction_button_top"))),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      flex: 2,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              SystemNavigator.pop();
                            },
                            child: Text(getTranslation(context, "cancel"))),
                      ))
                ],
              ),
            ),
          );
        });
  }

  void listenTaxi(Position value) {
    Geofire.initialize('availableDrivers');
    geofireListener(value.latitude, value.longitude, 'Taxi',
        widget.args.settings.radius.taxiRadius);
    geofireListener(value.latitude, value.longitude, 'Taxi',
        widget.args.settings.radius.taxiRadius);
  }

  void listenTruck(Position value) {
    Geofire.initialize('availableTrucks');
    geofireListener(value.latitude, value.longitude, 'Truck',
        widget.args.settings.radius.truckRadius);
    geofireListener(value.latitude, value.longitude, 'Truck',
        widget.args.settings.radius.truckRadius);
  }

  void _checkLocationServiceOnInit() async {
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!serviceEnabled) {
        isFirstTime = true;

        locationServiceButtomSheet();
        serviceStatusValue = 'disabled';

        return Future.error("No Location Enabled");
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

  void loadStartedTrip() {
    if (widget.args.isSelected) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        switch (widget.args.status) {
          case "Accepted":
            context
                .read<CurrentWidgetCubit>()
                .changeWidget(const DriverOnTheWay(
                  fromBackGround: false,
                  appOpen: true,
                ));
            break;
          case "Arrived":
            context
                .read<CurrentWidgetCubit>()
                .changeWidget(const DriverOnTheWay(
                  fromBackGround: false,
                  appOpen: true,
                ));
            break;
          case "Started":
            context
                .read<CurrentWidgetCubit>()
                .changeWidget(const StartedTripPannel());
            break;
          default:
            const WhereTo(
              key: Key("whereto"),
            );
        }

        _getPolyline(widget.args.encodedPts!);
        _addMarker(
            pickupLatLng,
            "pickup",
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            InfoWindow(title: pickupAddress));
        _addMarker(
            droppOffLatLng,
            "droppoff",
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            InfoWindow(title: droppOffAddress));
        _controller.future.whenComplete(() => changeCameraView());

        showBookedDriver();
        setState(() {});
      });
    }
  }

  bool onIosBackground(ServiceInstance service) {
    WidgetsFlutterBinding.ensureInitialized();
    print('FLUTTER BACKGROUND FETCH');

    return true;
  }

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,

        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,

        onForeground: onStart,

        onBackground: onIosBackground,
      ),
    );
  }

  void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    service.on('method').listen((event) {});

    service.on('stopService').listen((event) {
      print("Hereeeeeeeeeexx");
      service.stopSelf();
    });

    // bring to foreground
    // Timer.periodic(const Duration(seconds: 1), (timer) async {
    //   final hello = preferences.getString("hello");
    //   print(hello);

    //   if (service is AndroidServiceInstance) {
    //     service.setForegroundNotificationInfo(
    //       title: "My App Service",
    //       content: "Updated at ${DateTime.now()}",
    //     );
    //   }

    //   /// you can see this log in logcat
    //   print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    //   // test using external plugin
    //   final deviceInfo = DeviceInfoPlugin();
    //   String? device;
    //   if (Platform.isAndroid) {
    //     final androidInfo = await deviceInfo.androidInfo;
    //     device = androidInfo.model;
    //   }

    //   if (Platform.isIOS) {
    //     final iosInfo = await deviceInfo.iosInfo;
    //     device = iosInfo.model;
    //   }

    //   service.invoke(
    //     'update',
    //     {
    //       "current_date": DateTime.now().toIso8601String(),
    //       "device": device,
    //     },
    //   );
    // });
  }
}
