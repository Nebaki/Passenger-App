import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/bloc_observer.dart';
import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/repository/repositories.dart';
import 'package:passengerapp/rout.dart';
import 'package:http/http.dart' as http;

void main() {
  Bloc.observer = SimpleBlocObserver();
  final ReverseLocationRepository reverseLocationRepository =
      ReverseLocationRepository(
          dataProvider: ReverseGocoding(httpClient: http.Client()));
  final LocationPredictionRepository locationPredictionRepository =
      LocationPredictionRepository(
          dataProvider:
              LocationPredictionDataProvider(httpClient: http.Client()));

  final PlaceDetailRepository placeDetailRepository = PlaceDetailRepository(
      dataProvider: PlaceDetailDataProvider(httpClient: http.Client()));

  final DirectionRepository directionRepository = DirectionRepository(
      dataProvider: DirectionDataProvider(httpClient: http.Client()));
  runApp(MyApp(
    reverseLocationRepository: reverseLocationRepository,
    locationPredictionRepository: locationPredictionRepository,
    placeDetailRepository: placeDetailRepository,
    directionRepository: directionRepository,
  ));
}

class MyApp extends StatelessWidget {
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

  final ReverseLocationRepository reverseLocationRepository;
  final LocationPredictionRepository locationPredictionRepository;
  final PlaceDetailRepository placeDetailRepository;
  final DirectionRepository directionRepository;

  const MyApp(
      {Key? key,
      required this.reverseLocationRepository,
      required this.locationPredictionRepository,
      required this.placeDetailRepository,
      required this.directionRepository})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();

    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: reverseLocationRepository),
          RepositoryProvider.value(value: locationPredictionRepository),
          RepositoryProvider.value(value: placeDetailRepository),
          RepositoryProvider.value(value: directionRepository)
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) => LocationBloc(
                      reverseLocationRepository: reverseLocationRepository)
                    ..add(const ReverseLocationLoad())),
              BlocProvider(
                  create: (context) => LocationPredictionBloc(
                      locationPredictionRepository:
                          locationPredictionRepository)),
              BlocProvider(
                  create: (context) => PlaceDetailBloc(
                      placeDetailRepository: placeDetailRepository)),
              BlocProvider(
                  create: (context) =>
                      DirectionBloc(directionRepository: directionRepository)),
            ],
            child: MaterialApp(
              title: 'SafeWay',
              theme: ThemeData(
                  //F48221
                  primaryColor: const Color.fromRGBO(254, 79, 5, 1),
                  textTheme: TextTheme(
                      button: const TextStyle(
                        color: Color.fromRGBO(254, 79, 5, 1),
                      ),
                      subtitle1:
                          const TextStyle(color: Colors.black38, fontSize: 14),
                      headline5: const TextStyle(fontWeight: FontWeight.bold),
                      bodyText2: TextStyle(color: Colors.grey.shade700)),
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  textButtonTheme: TextButtonThemeData(
                      style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(color: Colors.black)),
                  )),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(254, 79, 5, 1)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80),
                        ))),
                  ),
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.orange,
                  ).copyWith(secondary: Colors.grey.shade600)),
              onGenerateRoute: AppRoute.generateRoute,
            )));
  }
}
