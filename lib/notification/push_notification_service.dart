import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class PushNotificationService {
  Future initialize(context, callback, searchNearbyDriver) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      // print("yow yo mikiki ${message.data['response']}");
      if (message.data['response'] == "Accepted") {
        callback(DriverOnTheWay(callback));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("request cancelled"),
          backgroundColor: Colors.red.shade900,
        ));
        callback(Service(callback, searchNearbyDriver));
      }
      message.data['response'] == "Accepted"
          ? callback(DriverOnTheWay(callback))
          : callback(Service(callback, searchNearbyDriver));
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
