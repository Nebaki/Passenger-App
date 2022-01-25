import 'package:flutter/material.dart';
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
      return MaterialPageRoute(builder: (context) => PhoneVerification());
    }
    if (settings.name == HomeScreen.routeName) {
      return MaterialPageRoute(builder: (context) => HomeScreen());
    }
    if (settings.name == CreateProfileScreen.routeName) {
      return MaterialPageRoute(builder: (context) => CreateProfileScreen());
    }
    if (settings.name == SearchScreen.routeName) {
      return MaterialPageRoute(builder: (context) => SearchScreen());
    }
    return MaterialPageRoute(builder: (context) => const FrontPage());
  }
}
