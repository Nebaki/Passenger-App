import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:passengerapp/screens/screens.dart';

import '../widgets/widgets.dart';

class PushNotificationService {
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
