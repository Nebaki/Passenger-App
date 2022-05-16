import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passengerapp/widgets/widgets.dart';

class StartedTripPannel extends StatelessWidget {
  const StartedTripPannel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 3.0,
      left: 8.0,
      right: 8.0,
      child: Column(
        children: [
          Container(
              height: 250,
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 0),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(240, 241, 241, 1),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                      flex: 1,
                      child: DriverProfile(
                          assetImage: 'assets/icons/economyCarIcon.png')),
                  const Divider(),
                  const Flexible(flex: 1, child: Counter()),
                ],
              )),
        ],
      ),
    );
  }
}

class Counter extends StatefulWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int sec = 0;

  int min = 0;

  int hrs = 0;

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (time) {
      if (sec <= 59) {
        setState(() {
          sec++;
        });
      } else {
        setState(() {
          min++;
          sec = 0;
        });
      }
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "$min : $sec",
        style: const TextStyle(
          fontSize: 27,
        ),
      ),
    );
  }
}
