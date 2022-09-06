import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/screens/screens.dart';
import 'models/models.dart';
import 'screens/award/lottery.dart';
import 'screens/settings/pages/feedbacks.dart';
import 'screens/settings/pages/privacy.dart';
import 'screens/settings/pages/terms.dart';

class AppRoute {
  static Route generateRoute(RouteSettings settings) {
    if (settings.name == SigninScreen.routeName) {
      return MaterialPageRoute(builder: (context) => const SigninScreen());
    }
    if (settings.name == SignupScreen.routeName) {
      return MaterialPageRoute(builder: (context) => const SignupScreen());
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
    if (settings.name == EditProfile.routeName) {
      EditProfileArgument argumnet = settings.arguments as EditProfileArgument;
      return MaterialPageRoute(
          builder: (context) => EditProfile(
                args: argumnet,
              ));
    }
    if (settings.name == SavedAddress.routeName) {
      return MaterialPageRoute(builder: (context) =>  SavedAddress());
    }
    if (settings.name == HistoryPage.routeName) {
      return MaterialPageRoute(builder: (context) => const HistoryPage());
    }
    if (settings.name == SettingScreen.routeName) {
      return MaterialPageRoute(builder: (context) => const SettingScreen());
    }
    if (settings.name == ResetPassword.routeName) {
      ResetPasswordArgument argument =
          settings.arguments as ResetPasswordArgument;
      return MaterialPageRoute(
          builder: (context) => ResetPassword(
                arg: argument,
              ));
    }
    if (settings.name == CancelReason.routeName) {
      CancelReasonArgument argument =
          settings.arguments as CancelReasonArgument;
      return MaterialPageRoute(
          builder: (context) => CancelReason(
                arg: argument,
              ));
    }
    if (settings.name == SigninScreen.routeName) {
      return MaterialPageRoute(builder: (context) => const SigninScreen());
    }
    if (settings.name == ForgetPassword.routeName) {
      return MaterialPageRoute(
          builder: (context) => const ForgetPassword());
    }
    if (settings.name == ChangePassword.routeName) {
      return MaterialPageRoute(builder: (context) => ChangePassword());
    }
    if (settings.name == LotteryScreen.routeName) {
      return MaterialPageRoute(builder: (context) => LotteryScreen());
    }
    if (settings.name == DetailHistoryScreen.routeName) {
      DetailHistoryArgument argument =
      settings.arguments as DetailHistoryArgument;
      return MaterialPageRoute(
          builder: (context) => DetailHistoryScreen(
            args: argument,
          ));
    }
    if (settings.name == TripDetail.routeName) {
      DetailHistoryArgument argument =
      settings.arguments as DetailHistoryArgument;
      return MaterialPageRoute(
          builder: (context) => TripDetail(
            args: argument,
          ));
    }


    if (settings.name == PreferenceScreen.routeNAme) {
      PreferenceArgument argument = settings.arguments as PreferenceArgument;
      return MaterialPageRoute(
          builder: (context) => PreferenceScreen(
                args: argument,
              ));
    }
    if (settings.name == OrderForOtherScreen.routeName) {
      return MaterialPageRoute(
          builder: (context) => const OrderForOtherScreen());
    }
    if (settings.name == FeedbackScreen.routeName) {
      return MaterialPageRoute(
          builder: (context) => const FeedbackScreen());
    }
    if (settings.name == PrivacyScreen.routeName) {
      return MaterialPageRoute(
          builder: (context) => const PrivacyScreen());
    }
    if (settings.name == TermsAndConditionScreen.routeName) {
      return MaterialPageRoute(
          builder: (context) => const TermsAndConditionScreen());
    }

    if (settings.name == ReviewScreen.routeName) {
      ReviewScreenArgument argument =
          settings.arguments as ReviewScreenArgument;
      return MaterialPageRoute(
          builder: (context) => ReviewScreen(
                arg: argument,
              ));
    }

    if (settings.name == AddAddressScreen.routeName) {
      AddAdressScreenArgument argument =
          settings.arguments as AddAdressScreenArgument;
      return MaterialPageRoute(
          builder: (context) => AddAddressScreen(
                args: argument,
              ));
    }

    if (settings.name == LocationChanger.routName) {
      LocationChangerArgument argument =
          settings.arguments as LocationChangerArgument;
      return MaterialPageRoute(
          builder: (context) => LocationChanger(
                args: argument,
              ));
    }
    if (settings.name == Language.routName) {
      LanguageArgument argument = settings.arguments as LanguageArgument;
      return MaterialPageRoute(
          builder: (context) => Language(
                args: argument,
              ));
    }
    return MaterialPageRoute(builder: (context) => const CustomSplashScreen());
  }
}

class HomeScreenArgument {
  final bool isFromSplash;
  bool isSelected = false;
  LatLng? destinationlatlang;
  String? encodedPts;
  final Settings settings;
  final String? status;

  HomeScreenArgument(
      {required this.isSelected,
      required this.settings,
      this.destinationlatlang,
      this.encodedPts,
      this.status,
      required this.isFromSplash});
}

class VerificationArgument {
  String? verificationId;
  int? resendingToken;
  String phoneNumber;
  String from;
  VerificationArgument(
      {this.verificationId,
      this.resendingToken,
      required this.phoneNumber,
      required this.from});
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
  double minRate;
  String carType;

  PreferenceArgument(
      {required this.gender, required this.minRate, required this.carType});
}

class AddAdressScreenArgument {
  final bool edit;
  final SavedLocation? savedLocation;

  AddAdressScreenArgument({required this.edit, this.savedLocation});
}

class CancelReasonArgument {
  final bool sendRequest;
  CancelReasonArgument({required this.sendRequest});
}

class DetailHistoryArgument {
  final RideRequest request;
  DetailHistoryArgument({required this.request});
}

class ResetPasswordArgument {
  final String phoneNumber;
  ResetPasswordArgument({required this.phoneNumber});
}

class ReviewScreenArgument {
  final String price;
  ReviewScreenArgument({required this.price});
}

class LocationChangerArgument {
  final String droppOffLocationAddressName;
  final String pickupLocationAddressName;
  final LatLng pickupLocationLatLng;
  final LatLng droppOffLocationLatLng;
  final String fromWhere;

  LocationChangerArgument({
    required this.droppOffLocationAddressName,
    required this.droppOffLocationLatLng,
    required this.pickupLocationAddressName,
    required this.pickupLocationLatLng,
    required this.fromWhere,
  });
}

class LanguageArgument {
  final int index;
  LanguageArgument({required this.index});
}
