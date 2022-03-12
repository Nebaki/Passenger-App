import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/main.dart';
import 'package:passengerapp/screens/faker/faker.dart';
import 'package:passengerapp/screens/screens.dart';

import 'models/models.dart';
import 'screens/settings/pages/feedbacks.dart';
import 'screens/settings/pages/privacy.dart';
import 'screens/settings/pages/terms.dart';

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
      CreateProfileScreenArgument argument =
          settings.arguments as CreateProfileScreenArgument;
      return MaterialPageRoute(
          builder: (context) => CreateProfileScreen(
                args: argument,
              ));
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
    if (settings.name == Faker.routeName) {
      return MaterialPageRoute(builder: (context) => Faker());
    }

    if (settings.name == FeedbackScreen.routeName) {
      return MaterialPageRoute(builder: (context) => FeedbackScreen());
    }
    if (settings.name == PrivacyScreen.routeName) {
      return MaterialPageRoute(builder: (context) => PrivacyScreen());
    }
    if (settings.name == TermsAndConditionScreen.routeName) {
      return MaterialPageRoute(builder: (context) => TermsAndConditionScreen());
    }

    if (settings.name == EditProfile.routeName) {
      EditProfileArgument argumnet = settings.arguments as EditProfileArgument;
      return MaterialPageRoute(
          builder: (context) => EditProfile(
                args: argumnet,
              ));
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
    if (settings.name == PreferenceScreen.routeNAme) {
      PreferenceArgument argument = settings.arguments as PreferenceArgument;
      return MaterialPageRoute(
          builder: (context) => PreferenceScreen(
                args: argument,
              ));
    }
    if (settings.name == OrderForOtherScreen.routeName) {
      return MaterialPageRoute(builder: (context) => OrderForOtherScreen());
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
  String phoneNumber;
  VerificationArgument(
      {required this.verificationId,
      required this.resendingToken,
      required this.phoneNumber});
}

class SearchScreenArgument {
  String currentLocation;

  SearchScreenArgument({required this.currentLocation});
}

class CreateProfileScreenArgument {
  String phoneNumber;
  CreateProfileScreenArgument({required this.phoneNumber});
}

class EditProfileArgument {
  Auth auth;
  EditProfileArgument({required this.auth});
}

class PreferenceArgument {
  String gender;
  double min_rate;
  String carType;

  PreferenceArgument(
      {required this.gender, required this.min_rate, required this.carType});
}
