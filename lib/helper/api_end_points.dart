import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/screens/home/assistant/home_screen_assistant.dart';

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
    return '$baseUrl/categories/get-categories-by-type?type=$type';
  }
}

class AuthEndPoints {
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
