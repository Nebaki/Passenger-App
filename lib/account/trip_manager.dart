import 'dart:convert';

import 'package:passengerapp/models/local_models/models.dart';
import 'package:passengerapp/models/local_models/trips.dart';
import 'package:passengerapp/utils/session.dart';
import 'package:passengerapp/utils/storage.dart';

class TripManager{
  var session = Session();
  var store = DataStorage();
  var sample = SecItem("phone", "0922877115");

  Future<Result> saveTrips(SecItem item) async {
    Result result = Result(false, "init");
    await store.performAction(ItemActions.edit, item)
        .then((value) => {
      result = Result(false, "trip created")
    }).onError((error, stackTrace) => {
      result = Result(false, "Failed to add" +item.key)
    });
    return result;
  }
  Future<TripStore> loadTrips() async {
    List<dynamic> result = [];
    await store.loadItem(SecItem("trips", ""))
        .then((value) => {
      result = jsonDecode(value)
    }).onError((error, stackTrace) => {
      result = []
    });
    return TripStore.fromJson(result);
  }
  Future<Result> deleteTrips() async {
    Result result = Result(false, "init");
    await store.performAction(ItemActions.delete, sample)
        .then((value) => {
      result = Result(false, "trip deleted")
    }).onError((error, stackTrace) => {
      result = Result(false, "Failed to delete" +sample.key)
    });
    return result;
  }
}