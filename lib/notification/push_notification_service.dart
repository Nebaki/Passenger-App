import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/repository/repositories.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/home/assistant/home_screen_assistant.dart';
import 'package:passengerapp/screens/screens.dart';
import '../helper/constants.dart';
import '../widgets/widgets.dart';

class PushNotificationService {
  NearbyDriverRepository repo = NearbyDriverRepository();
  final player = AssetsAudioPlayer();

  Future initialize(
      context, callback, searchNearbyDriver, nearbyDriversList) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print('this is the respomse : ${message.data['response']}');
      player.open(Audio("assets/sounds/announcement-sound.mp3"));
      switch (message.data['response']) {
        case 'Accepted':
          BlocProvider.of<DriverBloc>(context)
              .add(DriverLoad(message.data['myId']));
          driverId = message.data['myId'];
          callback(DriverOnTheWay(callback));
          requestAccepted();
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
          callback(Service(callback, searchNearbyDriver, nearbyDriversList));
          break;
        case 'Started':
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(" Trip Started"),
            backgroundColor: Colors.indigo.shade900,
          ));
          callback(const StartedTripPannel());
          break;
        case 'Completed':
          Navigator.pushReplacementNamed(context, ReviewScreen.routeName,
              arguments: ReviewScreenArgument(price: message.data['price']));
          break;
        case "TimeOut":
          callback(Service(callback, searchNearbyDriver, nearbyDriversList));
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
    });
  }

  void seubscribeTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic('driver');

    final token = await FirebaseMessaging.instance.getToken();

    print("The token is:: ");
    print(token);
  }
}
