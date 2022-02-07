import 'package:flutter/material.dart';
import 'package:passengerapp/main.dart';
import 'package:passengerapp/screens/screens.dart';

import 'account/tester.dart';

class AppRoute {
  static Route generateRoute(RouteSettings settings) {
    var test = Tester();
    if (settings.name == SigninScreen.routeName) {
      return MaterialPageRoute(builder: (context) => SigninScreen());
    }
    if (settings.name == SignupScreen.routeName) {
      return MaterialPageRoute(builder: (context) => SignupScreen());
    }
    if (settings.name == PhoneVerification.routeName) {
      return MaterialPageRoute(builder: (context) => PhoneVerification());
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
      return MaterialPageRoute(builder: (context) => SearchScreen());
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
    return MaterialPageRoute(builder: (context) => const FrontPage());
  }
}

class HomeScreenArgument {
  //String widgetName;
  bool isSelected = false;

  HomeScreenArgument({required this.isSelected});
}
