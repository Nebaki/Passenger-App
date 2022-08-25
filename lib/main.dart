import 'dart:isolate';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
import 'package:wakelock/wakelock.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:provider/provider.dart';
import 'screens/theme/theme_provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
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
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
  // service.startService();
}

void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
  const secureStorage = FlutterSecureStorage();
  String? theme = await secureStorage.read(key: "theme");
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(theme: int.parse(theme ?? "3")),
      child: MyApp(
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
  )));
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
                  create: (context) =>
                  LocationBloc(
                      reverseLocationRepository: reverseLocationRepository)
                    ..add(const ReverseLocationLoad())),
              BlocProvider(
                  create: (context) =>
                      LocationPredictionBloc(
                          locationPredictionRepository:
                          locationPredictionRepository)),
              BlocProvider(
                  create: (context) =>
                      PlaceDetailBloc(
                          placeDetailRepository: placeDetailRepository)),
              BlocProvider(
                  create: (context) =>
                      DirectionBloc(directionRepository: directionRepository)),
              BlocProvider(
                  create: (context) =>
                      UserBloc(userRepository: userRepository)),
              BlocProvider(
                  create: (context) =>
                  AuthBloc(authRepository: authRepository)
                    ..add(AuthDataLoad())),
              BlocProvider(
                  create: (context) =>
                  RideRequestBloc(
                      rideRequestRepository: rideRequestRepository)
                    ..add(RideRequestCheckStartedTrip())),
              BlocProvider(
                  create: (context) =>
                      DriverBloc(driverRepository: driverRepository)),
              BlocProvider(
                  create: (context) =>
                  LocationHistoryBloc(
                      dataBaseHelperRepository: dataBaseHelperRepository)
                    ..add(LocationHistoryLoad())),
              BlocProvider(
                  create: (context) =>
                      ReviewBloc(reviewRepository: reviewRepository)),
              BlocProvider(
                  create: (context) =>
                  SavedLocationBloc(
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
            child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) =>
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
              theme: ThemeData(
                  inputDecorationTheme: InputDecorationTheme(
                      suffixIconColor: themeProvider.getColor,
                      prefixIconColor: themeProvider.getColor,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: themeProvider.getColor, width: 2.0),
                      ),
                      focusColor: themeProvider.getColor),
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                      backgroundColor: Colors.white,
                      sizeConstraints:
                      const BoxConstraints(minWidth: 80, minHeight: 80),
                      extendedPadding: const EdgeInsets.all(50),
                      foregroundColor: themeProvider.getColor,
                      extendedTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w300)),

                  //F48221
                  primaryColor: themeProvider.getColor,
                  textTheme: TextTheme(
                      button: TextStyle(
                        fontFamily: 'Sifonn',
                        color: themeProvider.getColor,
                      ),
                      subtitle1:
                      TextStyle(color: Colors.black38, fontSize: 13),
                      headline5: const TextStyle(
                          fontFamily: 'Sifonn',
                          fontWeight: FontWeight.bold, fontSize: 18),
                      bodyText2: const TextStyle(
                          fontFamily: 'Sifonn',
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.normal)

                  ),
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  textButtonTheme: TextButtonThemeData(
                      style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                                fontFamily: 'Sifonn',color: Colors.black)),
                      )),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                                fontFamily: 'Sifonn',
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 20)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            themeProvider.getColor),
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ))),
                  ),
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.orange,
                  ).copyWith(secondary: Colors.grey.shade600)),
          onGenerateRoute: AppRoute.generateRoute,
        ),
    )),
    )

    );
  }
}
