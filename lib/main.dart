import 'dart:isolate';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/bloc/category/category.dart';
import 'package:passengerapp/bloc/currentwidget/current_widget_bloc.dart';
import 'package:passengerapp/bloc/database/location_history_bloc.dart';
import 'package:passengerapp/bloc/notificationrequest/notification_request_bloc.dart';
import 'package:passengerapp/bloc/savedlocation/saved_location_bloc.dart';
import 'package:passengerapp/bloc/thememode/theme_mode_bloc.dart';
import 'package:passengerapp/bloc_observer.dart';
import 'package:passengerapp/cubit/favorite_location.dart';
import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/repository/repositories.dart';
import 'package:passengerapp/rout.dart';
import 'package:http/http.dart' as http;
import 'package:passengerapp/theme_data.dart';
import 'package:wakelock/wakelock.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,http
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  AssetsAudioPlayer().open(Audio("assets/sounds/announcement-sound.mp3"));
  final SendPort? send = IsolateNameServer.lookupPortByName(portName);
  send!.send(message);

  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Bloc.observer = SimpleBlocObserver();
  final ReverseLocationRepository reverseLocationRepository =
      ReverseLocationRepository(
          dataProvider: ReverseGocoding(httpClient: http.Client()));
  final RideRequestRepository rideRequestRepository = RideRequestRepository(
      dataProvider: RideRequestDataProvider(httpClient: http.Client()));
  final LocationPredictionRepository locationPredictionRepository =
      LocationPredictionRepository(
          dataProvider:
              LocationPredictionDataProvider(httpClient: http.Client()));

  final PlaceDetailRepository placeDetailRepository = PlaceDetailRepository(
      dataProvider: PlaceDetailDataProvider(httpClient: http.Client()));

  final DirectionRepository directionRepository = DirectionRepository(
      dataProvider: DirectionDataProvider(httpClient: http.Client()));

  final UserRepository userRepository =
      UserRepository(dataProvider: UserDataProvider(httpClient: http.Client()));

  final AuthRepository authRepository =
      AuthRepository(dataProvider: AuthDataProvider(httpClient: http.Client()));
  final NotificationRequestRepository notificationRequestRepository =
      NotificationRequestRepository(
          dataProvider:
              NotificationRequestDataProvider(httpClient: http.Client()));

  final DataBaseHelperRepository dataBaseHelperRepository =
      DataBaseHelperRepository(dataProvider: DatabaseHelper());

  final DriverRepository driverRepository = DriverRepository(
      dataProvider: DriverDataProvider(httpClient: http.Client()));
  final ReviewRepository reviewRepository = ReviewRepository(
      dataProvider: ReviewDataProvider(httpClient: http.Client()));

  final SavedLocationRepository savedLocationRepository =
      SavedLocationRepository(
          savedLocationDataProvider:
              SavedLocationDataProvider(httpClient: http.Client()));
  final EmergencyReportRepository emergencyReportRepository =
      EmergencyReportRepository(
          dataProvider: EmergencyReportDataProvider(httpClient: http.Client()));

  final CategoryRepository categoryRepository = CategoryRepository(
      categoryDataProvider: CategoryDataProvider(httpClient: http.Client()));

  runApp(MyApp(
    notificationRequestRepository: notificationRequestRepository,
    rideRequestRepository: rideRequestRepository,
    authRepository: authRepository,
    userRepository: userRepository,
    driverRepository: driverRepository,
    reverseLocationRepository: reverseLocationRepository,
    locationPredictionRepository: locationPredictionRepository,
    placeDetailRepository: placeDetailRepository,
    directionRepository: directionRepository,
    dataBaseHelperRepository: dataBaseHelperRepository,
    reviewRepository: reviewRepository,
    savedLocationRepository: savedLocationRepository,
    emergencyReportRepository: emergencyReportRepository,
    categoryRepository: categoryRepository,
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
  final UserRepository userRepository;
  final DriverRepository driverRepository;
  final AuthRepository authRepository;
  final RideRequestRepository rideRequestRepository;
  final NotificationRequestRepository notificationRequestRepository;
  final DataBaseHelperRepository dataBaseHelperRepository;
  final ReviewRepository reviewRepository;
  final SavedLocationRepository savedLocationRepository;
  final EmergencyReportRepository emergencyReportRepository;
  final CategoryRepository categoryRepository;

  const MyApp({
    Key? key,
    required this.notificationRequestRepository,
    required this.rideRequestRepository,
    required this.userRepository,
    required this.driverRepository,
    required this.authRepository,
    required this.reverseLocationRepository,
    required this.locationPredictionRepository,
    required this.placeDetailRepository,
    required this.directionRepository,
    required this.dataBaseHelperRepository,
    required this.reviewRepository,
    required this.savedLocationRepository,
    required this.emergencyReportRepository,
    required this.categoryRepository,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    Wakelock.enable();

    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: notificationRequestRepository),
          RepositoryProvider.value(value: rideRequestRepository),
          RepositoryProvider.value(value: reverseLocationRepository),
          RepositoryProvider.value(value: locationPredictionRepository),
          RepositoryProvider.value(value: placeDetailRepository),
          RepositoryProvider.value(value: directionRepository),
          RepositoryProvider.value(value: userRepository),
          RepositoryProvider.value(value: driverRepository),
          RepositoryProvider.value(value: authRepository),
          RepositoryProvider.value(value: dataBaseHelperRepository),
          RepositoryProvider.value(value: reviewRepository),
          RepositoryProvider.value(value: savedLocationRepository),
          RepositoryProvider.value(value: emergencyReportRepository),
          RepositoryProvider.value(value: categoryRepository),
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
              BlocProvider(
                  create: (context) =>
                      UserBloc(userRepository: userRepository)),
              BlocProvider(
                  create: (context) => AuthBloc(authRepository: authRepository)
                    ..add(AuthDataLoad())),
              BlocProvider(
                  create: (context) => RideRequestBloc(
                      rideRequestRepository: rideRequestRepository)),
              BlocProvider(
                  create: (context) => NotificationRequestBloc(
                      notificationRequestRepository:
                          notificationRequestRepository)),
              BlocProvider(
                  create: (context) =>
                      DriverBloc(driverRepository: driverRepository)),
              BlocProvider(
                  create: (context) => LocationHistoryBloc(
                      dataBaseHelperRepository: dataBaseHelperRepository)
                    ..add(LocationHistoryLoad())),
              BlocProvider(
                  create: (context) =>
                      ReviewBloc(reviewRepository: reviewRepository)),
              BlocProvider(
                  create: (context) => SavedLocationBloc(
                      savedLocationRepository: savedLocationRepository)
                    ..add(SavedLocationsLoad())),
              BlocProvider(
                  create: (context) => EmergencyReportBloc(
                      emergencyReportRepository: emergencyReportRepository)),
              BlocProvider(
                  create: ((context) =>
                      CategoryBloc(categoryRepository: categoryRepository)
                        ..add(CategoryLoad()))),
              BlocProvider(
                  create: ((context) => TripHistoryBloc(
                      rideRequestRepository: rideRequestRepository))),
              BlocProvider(
                  create: ((context) =>
                      SelectedCategoryBloc(SelectedCategoryLoading()))),
              BlocProvider(
                  create: ((context) => ThemeModeCubit(ThemeMode.system))),
              BlocProvider(create: (context) => CurrentWidgetCubit()),
              BlocProvider(
                create: (context) => FavoriteLocationCubit(
                    favoriteLocationRepository: dataBaseHelperRepository)
                  ..getFavoriteLocations(),
              )
            ],
            child: BlocBuilder<ThemeModeCubit, ThemeMode>(
              builder: (context, state) => MaterialApp(
                title: 'SafeWay',
                themeMode: state,
                darkTheme: ThemesData.darkTheme,
                theme: ThemesData.lightTheme,
                onGenerateRoute: AppRoute.generateRoute,
              ),
            )));
  }
}
