import 'package:flutter/material.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/canceltrip.dart';
import 'package:passengerapp/widgets/widgets.dart';

class WaitingDriverResponse extends StatelessWidget {
  Function? callback;
  WaitingDriverResponse(this.callback);
  @override
  Widget build(BuildContext context) {
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
                          child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, CancelReason.routeName,
                                    arguments: CancelReasonArgument(
                                        sendRequest: false));

                                // callback!(CancelTrip(
                                //     callback, WaitingDriverResponse(callback)));
                              },
                              child: Text(
                                "Cancel",
                                style: Theme.of(context).textTheme.titleLarge,
                              )))
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
}
