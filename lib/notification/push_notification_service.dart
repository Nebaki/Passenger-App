import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/repository/repositories.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/home/assistant/home_screen_assistant.dart';
import 'package:passengerapp/screens/screens.dart';
import '../helper/constants.dart';
import '../widgets/widgets.dart';

class PushNotificationService {
  NearbyDriverRepository repo = NearbyDriverRepository();
  final player = AssetsAudioPlayer();

  Future initialize(context) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;
      player.open(Audio("assets/sounds/announcement-sound.mp3"));
      switch (message.data['response']) {
        case 'Accepted':
          Geofire.stopListener();
          BlocProvider.of<DriverBloc>(context)
              .add(DriverLoad(message.data['myId']));
          driverId = message.data['myId'];
          BlocProvider.of<CurrentWidgetCubit>(context)
              .changeWidget(const DriverOnTheWay(
            fromBackGround: false,appOpen: false,
          ));
          // context.read<CurrentWidgetCubit>().changeWidget(DriverOnTheWay());

          requestAccepted();
          break;
        case 'Arrived':
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(getTranslation(context, "driver_arrived")),
            // backgroundColor: Colors.indigo.shade900,
          ));
          break;
        case 'Cancelled':
          BlocProvider.of<CurrentWidgetCubit>(context)
              .changeWidget(const WhereTo(
            key: Key("whereto"),
          ));

          BlocProvider.of<DirectionBloc>(context).add(
              const DirectionChangeToInitialState(
                  loadCurrentLocation: false, listenToNearbyDriver: false));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(getTranslation(context, "trip_cancelled")),
            // backgroundColor: Colors.indigo.shade900,
          ));
          // context.read<CurrentWidgetCubit>().changeWidget(Service(true,false));

          break;
        case 'Started':
          BlocProvider.of<CurrentWidgetCubit>(context)
              .changeWidget(const StartedTripPannel());
          // context
          //     .read<CurrentWidgetCubit>()
          //     .changeWidget(const StartedTripPannel());

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(getTranslation(context, "trip_started")),
            // backgroundColor: Colors.indigo.shade900,
          ));
          break;
        case 'Completed':
          BlocProvider.of<DirectionBloc>(context).add(
              const DirectionChangeToInitialState(
                  loadCurrentLocation: true, listenToNearbyDriver: false));
          // resetScreen();
          Navigator.pushNamed(context, ReviewScreen.routeName,
              arguments: ReviewScreenArgument(price: message.data['price']));
          break;
        case "TimeOut":
          BlocProvider.of<CurrentWidgetCubit>(context)
              .changeWidget(const Service(true, false));

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text((getTranslation(context, "request_time_out"))),
            // backgroundColor: Colors.indigo.shade900,
          ));
          break;
        default:
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
    });
  }

  void seubscribeTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic('global');
    await FirebaseMessaging.instance.subscribeToTopic('passenger');

    final token = await FirebaseMessaging.instance.getToken();

    debugPrint("The token is:: ");
    debugPrint(token);
  }
}
