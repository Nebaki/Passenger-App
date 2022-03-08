import 'dart:convert';
import 'package:passengerapp/account/trip_manager.dart';
import 'package:passengerapp/models/local_models/location.dart';
import 'package:passengerapp/models/local_models/models.dart';
import 'package:passengerapp/models/local_models/trips.dart';
import 'package:passengerapp/utils/session.dart';

class TripTest {
  var tripMan = TripManager();
  var session = Session();

  void saveTrips() {
    var start = Location("4 killo", 95.000006, 95.000004);
    var end = Location("bole", 95.000006, 95.000004);
    var price = 50.0;
    List<Trip> tripsList = [];
    var trip;
    for (var i = 0; i < 3; i++) {
      trip = Trip();
      tripsList.add(trip);
    }
    String save_location = jsonEncode(tripsList);
    var trips = SecItem("trips", save_location);
    session.logSuccess("save-trip", "trips: " + save_location);
    tripMan
        .saveTrips(trips)
        .then((value) =>
            {session.logSuccess("save-trip", "success"), loadTrips()})
        .onError((error, stackTrace) =>
            {session.logError("save-trip", "failed: " + error.toString())});
  }

  void loadTrips() {
    tripMan
        .loadTrips()
        .then((value) => {
              session.logSuccess(
                  "load-trip",
                  "success: " +
                      value.trips.length.toString() /*jsonEncode(value.trips)*/)
            })
        .onError((error, stackTrace) => {
              session.logError("load-trip", "failed: " + stackTrace.toString())
            });
  }

  void updateTrips() {
    var start = Location("4 killo", 95.000006, 95.000004);
    var end = Location("bole", 95.000006, 95.000004);
    var price = 50.0;
    var trip = Trip();

    List<Trip> updated;
    tripMan
        .loadTrips()
        .then((value) => {
          updated = value.trips,
      session.logSuccess(
          "update-trip",
          "up s: " +
              updated.length.toString() /*jsonEncode(updated)*/),
      storeTrips(updated)})
        .onError((error, stackTrace) =>
            {session.logError("update-trip", "failed: " + error.toString())});
  }

  void storeTrips(List<Trip> updated) {
    tripMan
        .saveTrips(SecItem("trips", jsonEncode(updated)))
        .then((value) => {
              session.logSuccess("update-trip", "success: " + value.message),
              loadTrips()
            })
        .onError((error, stackTrace) =>
            {session.logError("update-trip", "failed: " + error.toString())});
  }
}
