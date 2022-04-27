import 'package:assets_audio_player/assets_audio_player.dart';
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
  final player = AssetsAudioPlayer();

  Future initialize(context, callback, searchNearbyDriver) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print('this is the respomse : ${message.data['response']}');
      player.open(Audio("assets/sounds/announcement-sound.mp3"));
      switch (message.data['response']) {
        case 'Accepted':
          BlocProvider.of<DriverBloc>(context)
              .add(DriverLoad(message.data['myId']));
          callback(DriverOnTheWay(callback));
          break;
        case 'Arrived':
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(" Driver Arrived"),
            backgroundColor: Colors.indigo.shade900,
          ));
          break;
        case 'Cancelled':
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(" Request cancelled"),
            backgroundColor: Colors.indigo.shade900,
          ));
          callback(Service(callback, searchNearbyDriver));
          break;
        case 'Completed':
          Navigator.pushNamed(context, ReviewScreen.routeName);
          break;
        case "TimeOut":
          callback(Service(callback, searchNearbyDriver));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Time out"),
            backgroundColor: Colors.indigo.shade900,
          ));
          break;
        default:
      }
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
