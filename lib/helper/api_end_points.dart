import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/screens/home/assistant/home_screen_assistant.dart';

import '../utils/session.dart';

class CategoryEndPoints {
  static String getCategoriesEndPoint() {
    String type;
    switch (selectedCar) {
      case SelectedCar.taxi:
        type = "Taxi";
        break;
      case SelectedCar.truck:
        type = "Truck";
        break;
      default:
        type = 'Taxi';
    }
    Session().logSession("selectedType", type);
    return '$baseUrl/categories/get-categories-by-type?type=$type';
  }
}
class SettingsEndPoint {
  static String getSettingsEndPoint(){
    return "$baseUrl/settings/get-setting";
  }
}

class AuthEndPoints {
  static String refreshTokenEndPoint(){
    return '$baseUrl/auth/refresh';
  }
  static String passegerLoginEndPoint() {
    return '$baseUrl/passengers/passenger-login';
  }
}

class DriverEndPoints {
  static String middle = 'drivers';
  static String getDriversEndPoint() {
    return '$baseUrl/$middle/get-driver';
  }
}

class EmergencyReportEndpopint {
  static String creatEmergencyReportEndPoint() {
    return '$baseUrl/emergency-reports/create-emergency-report';
  }
}

class ReviewEndPoint {
  static String middle = 'reviews';
  static String createReviewEndPoint() {
    return '$baseUrl/$middle/create-review';
  }
}

class SavedLocationEndPoints {
  static String middle = 'saved-locations';
  static String createSavedLocationEndPoint() {
    return '$baseUrl/$middle/create-saved-location';
  }

  static String getSavedLocationEndPoint() {
    return '$baseUrl/$middle/get-my-saved-locations';
  }

  static String clearSavedLocationEndPoint() {
    return '$baseUrl/$middle/clear-saved-locations';
  }

  static String deleteSavedLocationEndPoint(String id) {
    return '$baseUrl/$middle/delete-saved-location';
  }

  static String updateSavedLocationEndPoint() {
    return '$baseUrl/$middle/update-saved-location';
  }
}

class UserEndPoints {
  static String middle = 'passengers';
  static String createPassengerEndPoint() {
    return '$baseUrl/$middle/create-passenger';
  }

  static String uploadImageEndPoint() {
    return '$baseUrl/$middle/update-profile-image';
  }

  static String deletePassengerEndPoint() {
    return '$baseUrl/$middle/delete-passenger';
  }

  static String updatePassengerEndPoint() {
    return '$baseUrl/$middle/update-profile';
  }

  static String updatePreferenceEndPoint() {
    return '$baseUrl/$middle/update-profile';
  }

  static String changePassewordEndPoint() {
    return '$baseUrl/$middle/change-password';
  }

  static String checkPhonenumberEndPoint() {
    return '$baseUrl/$middle/check-phone-number';
  }

  static String forgetPasswordEndPoint() {
    return '$baseUrl/$middle/forget-password';
  }

  static String setPassengerAvailablityEndPoint() {
    return '$baseUrl/$middle/set-passenger-availability';
  }
}

class RideRequestEndPoints {
  static String middle = 'ride-requests';

  static String checkStartedTripEndPoint() {
    return '$baseUrl/$middle/check-started-trip';
  }

  static String getRideRequestsEndPoint(int skip, int top) {
    return '$baseUrl/$middle/get-my-ride-requests?includes[0]=driver&skip=$skip&top=$top&orderBy[0][field]=createdAt&orderBy[0][direction]=desc';
  }

  static String createRideRequestEndPoint() {
    return '$baseUrl/$middle/create-ride-request';
  }

  static String orderForOtherEndPoint() {
    return '$baseUrl/$middle/order-for-other';
  }

  static String cancelRideRequestEndPoint() {
    return '$baseUrl/$middle/cancel-ride-request';
  }
}
