import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/repository/repositories.dart';
import 'package:passengerapp/screens/screens.dart';

import '../helper/constants.dart';
import '../models/nearby_driver.dart';
import '../widgets/widgets.dart';

class PushNotificationService {
  NearbyDriverRepository repo = NearbyDriverRepository();

  String? searchNearbyDriver() {
    if (repo.getNearbyDrivers().isEmpty) {
      return null;
    }
    var nearest;
    var nearestDriver;

    for (NearbyDriver driver in repo.getNearbyDrivers()) {
      print("drivers ::");
      print(driver.id);
      double distance = Geolocator.distanceBetween(
          8.9966827, 38.7675547, driver.latitude, driver.longitude);

      nearest ??= distance;

      print(distance);

      if (distance <= nearest) {
        nearest = distance;
        nearestDriver = driver;
      }
    }

    print(nearestDriver.id);

    return nearestDriver.id;
  }

  void sendNotification(String fcmToken, String id) async {
    print(' driver fcm $fcmToken');
    // _isLoading = true;
  }

  Future initialize(context, callback, searchNearbyDriver) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print('this is the respomse : ${message.data['response']}');

      // print("yow yo mikiki ${message.data['response']}");
      if (message.data['response'] == "Accepted") {
        callback(DriverOnTheWay(callback));
      } else if (message.data['response'] == "Arrived") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(" Driver Arrived"),
          backgroundColor: Colors.indigo.shade900,
        ));
      } else if (message.data['response'] == "Cancelled") {
        // repo.removeDriver(searchNearbyDriver());
        // searchNearbyDriver();
        DriverEvent event = DriverLoad(searchNearbyDriver());
        BlocProvider.of<DriverBloc>(context).add(event);

        BlocListener(listener: (_, state) {
          print('so the state is $state');
          if (state is DriverLoadSuccess) {
            RideRequestEvent riderequestEvent = RideRequestCreate(RideRequest(
                driverFcm: state.driver.fcmId,
                driverId: state.driver.id,
                passengerName: name,
                passengerPhoneNumber: number,
                pickUpAddress: pickupAddress,
                droppOffAddress: droppOffAddress,
                pickupLocation: pickupLatLng,
                dropOffLocation: droppOffLatLng));
            BlocProvider.of<RideRequestBloc>(_).add(riderequestEvent);
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(" Request cancelled"),
          backgroundColor: Colors.indigo.shade900,
        ));
        callback(Service(callback, searchNearbyDriver));
      } else if (message.data['response'] == "Completed") {
        print("it's Completedd");
        Navigator.pushNamed(context, ReviewScreen.routeName);
      } else {
        print(message.data['response']);
      }
      // message.data['response'] == "Accepted"
      //     ? callback(DriverOnTheWay(callback))
      //     : callback(Service(callback, searchNearbyDriver));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(
      //   context,
      //   '/message',
      //   arguments: MessageArguments(message, true),
      // );
    });
  }

  void seubscribeTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic('driver');

    final token = await FirebaseMessaging.instance.getToken();

    print("The token is:: ");
    print(token);
  }
}
