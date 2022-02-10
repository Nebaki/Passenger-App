import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/main.dart';
import 'package:passengerapp/screens/screens.dart';

class AppRoute {
  static Route generateRoute(RouteSettings settings) {
    if (settings.name == SigninScreen.routeName) {
      return MaterialPageRoute(builder: (context) => SigninScreen());
    }
    if (settings.name == SignupScreen.routeName) {
      return MaterialPageRoute(builder: (context) => SignupScreen());
    }
    if (settings.name == PhoneVerification.routeName) {
      VerificationArgument arguments =
          settings.arguments as VerificationArgument;
      return MaterialPageRoute(
          builder: (context) => PhoneVerification(args: arguments));
    }
    if (settings.name == HomeScreen.routeName) {
      HomeScreenArgument argument = settings.arguments as HomeScreenArgument;
      return MaterialPageRoute(
          builder: (context) => HomeScreen(
                args: argument,
              ));
    }
    if (settings.name == CreateProfileScreen.routeName) {
      return MaterialPageRoute(builder: (context) => CreateProfileScreen());
    }
    if (settings.name == SearchScreen.routeName) {
      SearchScreenArgument argument =
          settings.arguments as SearchScreenArgument;
      return MaterialPageRoute(
          builder: (context) => SearchScreen(
                args: argument,
              ));
    }
    if (settings.name == ProfileDetail.routeName) {
      return MaterialPageRoute(builder: (context) => ProfileDetail());
    }
    if (settings.name == EditProfile.routeName) {
      return MaterialPageRoute(builder: (context) => EditProfile());
    }
    if (settings.name == SavedAddress.routeName) {
      return MaterialPageRoute(builder: (context) => SavedAddress());
    }
    if (settings.name == HistoryPage.routeName) {
      return MaterialPageRoute(builder: (context) => HistoryPage());
    }
    if (settings.name == SettingScreen.routeName) {
      return MaterialPageRoute(builder: (context) => SettingScreen());
    }
    if (settings.name == ResetPassword.routeName) {
      return MaterialPageRoute(builder: (context) => ResetPassword());
    }
    if (settings.name == CancelReason.routeName) {
      return MaterialPageRoute(builder: (context) => CancelReason());
    }
    if (settings.name == SigninScreen.routeName) {
      return MaterialPageRoute(builder: (context) => SigninScreen());
    }
    if (settings.name == MobileVerification.routeName) {
      return MaterialPageRoute(builder: (context) => MobileVerification());
    }
    if (settings.name == ChangePassword.routeName) {
      return MaterialPageRoute(builder: (context) => ChangePassword());
    }
    if (settings.name == DetailHistoryScreen.routeName) {
      return MaterialPageRoute(builder: (context) => DetailHistoryScreen());
    }
    if (settings.name == ContactUsScreen.routeName) {
      return MaterialPageRoute(builder: (context) => ContactUsScreen());
    }
    return MaterialPageRoute(builder: (context) => CustomSplashScreen());
  }
}

class HomeScreenArgument {
  //String widgetName;
  bool isSelected = false;
  LatLng? destinationlatlang;

  HomeScreenArgument({required this.isSelected, this.destinationlatlang});
}

class VerificationArgument {
  String verificationId;
  int? resendingToken;
  VerificationArgument(
      {required this.verificationId, required this.resendingToken});
}

class SearchScreenArgument {
  String currentLocation;

  SearchScreenArgument({required this.currentLocation});
}
