import 'dart:isolate';
import 'dart:ui';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/bloc/database/location_history_bloc.dart';
import 'package:passengerapp/bloc_observer.dart';
import 'package:passengerapp/cubit/cubits.dart';
import 'package:passengerapp/cubit/favorite_location.dart';
import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/localization/localization.dart';
import 'package:passengerapp/repository/repositories.dart';
import 'package:passengerapp/rout.dart';
import 'package:http/http.dart' as http;
import 'package:passengerapp/theme_data.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,http
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  // AssetsAudioPlayer().open(Audio("assets/sounds/announcement-sound.mp3"));
  final SendPort? send = IsolateNameServer.lookupPortByName(portName);
  send!.send(message);

  debugPrint('Handling a background message ${message.messageId}');
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
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: false,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: false,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  // service.startService();
}

void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();


  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  // SharedPreferences preferences = await SharedPreferences.getInstance();
  // await preferences.setString("hello", "world");

  // if (service is AndroidServiceInstance) {
  // service.on('setAsForeground').listen((event) {
  //   print("Yow Herererr as forground");
  //   // service.setAsForegroundService();
  // });

  // service.on('setAsBackground').listen((event) {
  //   print("Yow Herererr as background");

  //   // service.setAsBackgroundService();
  // });
  // }

  service.on('stopService').listen((event) {
    print("Hereeeeeeeeee");
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();

  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
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

  final SettingsRepository settingsRepository = SettingsRepository(
      settingsDataProvider: SettingsDataProvider(httpClient: http.Client()));

  runApp(MyApp(
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
    settingsRepository: settingsRepository,
  ));
}

class MyApp extends StatelessWidget {
  final ReverseLocationRepository reverseLocationRepository;
  final LocationPredictionRepository locationPredictionRepository;
  final PlaceDetailRepository placeDetailRepository;
  final DirectionRepository directionRepository;
  final UserRepository userRepository;
  final DriverRepository driverRepository;
  final AuthRepository authRepository;
  final RideRequestRepository rideRequestRepository;
  final DataBaseHelperRepository dataBaseHelperRepository;
  final ReviewRepository reviewRepository;
  final SavedLocationRepository savedLocationRepository;
  final EmergencyReportRepository emergencyReportRepository;
  final CategoryRepository categoryRepository;
  final SettingsRepository settingsRepository;

  const MyApp(
      {Key? key,
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
      required this.settingsRepository})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    Wakelock.enable();

    return MultiRepositoryProvider(
        providers: [
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
          RepositoryProvider.value(value: settingsRepository)
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
                      rideRequestRepository: rideRequestRepository)
                    ..add(RideRequestCheckStartedTrip())),
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
                  create: ((context) => ThemeModeCubit()..getThemeMode())),
              BlocProvider(create: (context) => CurrentWidgetCubit()),
              BlocProvider(
                create: (context) => FavoriteLocationCubit(
                    favoriteLocationRepository: dataBaseHelperRepository)
                  ..getFavoriteLocations(),
              ),
              BlocProvider(create: (context) => LocaleCubit()..getLocal()),
              BlocProvider(
                  create: (context) =>
                      ProfilePictureCubit()..getProfilePictureUrl()),
              BlocProvider(
                create: (context) =>
                    SettingsBloc(settingsRepository: settingsRepository),
              )
            ],
            child: BlocBuilder<ThemeModeCubit, ThemeMode>(
              builder: ((context, themeModeState) =>
                  BlocBuilder<LocaleCubit, Locale>(
                    builder: (context, localeState) => MaterialApp(
                      locale: localeState,
                      localizationsDelegates: const [
                        Localization.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      supportedLocales: const [
                        Locale('en', 'US'),
                        Locale('am', 'ET')
                      ],
                      localeResolutionCallback:
                          (deviceeLocal, supportedLocals) {
                        for (var locale in supportedLocals) {
                          if (locale.languageCode ==
                                  deviceeLocal!.languageCode &&
                              locale.countryCode == deviceeLocal.countryCode) {
                            return deviceeLocal;
                          }
                        }
                        return supportedLocals.first;
                      },
                      title: 'Mobile Transport',
                      themeMode: themeModeState,
                      darkTheme: ThemesData.darkTheme,
                      theme: ThemesData.lightTheme,
                      onGenerateRoute: AppRoute.generateRoute,
                    ),
                  )),
            )));
  }
}
