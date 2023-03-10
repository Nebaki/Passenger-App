import 'dart:async';
import 'package:flutter/material.dart';
import 'package:passengerapp/widgets/widgets.dart';

class StartedTripPannel extends StatelessWidget {
  const StartedTripPannel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Column(
        children: [
          Container(
              height: 300,
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Flexible(
                      flex: 3,
                      child: DriverProfile(
                          assetImage: 'assets/icons/economyCarIcon.png')),

                  Divider(),
                  Flexible(flex: 1, child: Counter()),
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
  Timer? timer;
  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (time) {
      timer = time;
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
    // context.read<DriverBloc>().state != DriverLoadSuccess
    //     ? context.read<DriverBloc>().add(DriverLoad(driverId!))
    //     : null;
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
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
