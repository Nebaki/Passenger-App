import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/canceltrip.dart';
import 'package:passengerapp/widgets/widgets.dart';

class WaitingDriverResponse extends StatefulWidget {
  Function? callback;

  WaitingDriverResponse(this.callback);

  @override
  State<WaitingDriverResponse> createState() => _WaitingDriverResponseState();
}

class _WaitingDriverResponseState extends State<WaitingDriverResponse> {
  late Timer _timer;
  int _start = 90;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
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
    // TODO: implement initState
    // startTimer();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setWillScreenPop();
    });
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3,
                      color: Colors.grey,
                      blurStyle: BlurStyle.outer,
                      spreadRadius: 2)
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      const Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "Looking for nearby providers...",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
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
                                  "Cancel",
                                  style: Theme.of(context).textTheme.titleLarge,
                                )),
                          ))
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
                  color: Colors.black26.withOpacity(0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendNotification(BuildContext context, String fcm, String id) {
    RideRequestEvent event = RideRequestSendNotification(
        RideRequest(
            driverFcm: fcm,
            driverId: id,
            passengerName: name,
            passengerPhoneNumber: number,
            pickUpAddress: pickupAddress,
            droppOffAddress: droppOffAddress,
            pickupLocation: pickupLatLng,
            dropOffLocation: droppOffLatLng),
        rideRequestId);

    BlocProvider.of<RideRequestBloc>(context).add(event);
  }
}
