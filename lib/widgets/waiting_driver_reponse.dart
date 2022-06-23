import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passengerapp/helper/localization.dart';

import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';

class WaitingDriverResponse extends StatefulWidget {
  const WaitingDriverResponse({Key? key}) : super(key: key);

  @override
  State<WaitingDriverResponse> createState() => _WaitingDriverResponseState();
}

class _WaitingDriverResponseState extends State<WaitingDriverResponse> {
  int _start = 90;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    // startTimer();
    super.initState();
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 3,
                      color: Colors.grey,
                      blurStyle: BlurStyle.outer,
                      spreadRadius: 2)
                ],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: Text(
                            getTranslation(
                                context, "looking_for_nearby_providers"),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, CancelReason.routeName,
                                    arguments: CancelReasonArgument(
                                        sendRequest: true));

                                // callback!(CancelTrip(
                                //     callback, WaitingDriverResponse(callback)));
                              },
                              child: Text(
                                getTranslation(context, "cancel"),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge,
                              )),
                        ),
                      )
                    ],
                  ),
                ),
                const LinearProgressIndicator(
                  minHeight: 1.5,
                ),
                Container(
                  height: 90,
                  // padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).backgroundColor.withOpacity(0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // void sendNotification(BuildContext context, String fcm, String id) {
  //   RideRequestEvent event = RideRequestSendNotification(
  //       RideRequest(
  //           driverFcm: fcm,
  //           driverId: id,
  //           passengerName: name,
  //           passengerPhoneNumber: number,
  //           pickUpAddress: pickupAddress,
  //           droppOffAddress: droppOffAddress,
  //           pickupLocation: pickupLatLng,
  //           dropOffLocation: droppOffLatLng),
  //       rideRequestId);

  //   BlocProvider.of<RideRequestBloc>(context).add(event);
  // }
}
