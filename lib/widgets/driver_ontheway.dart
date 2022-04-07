import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/url_launcher.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/canceltrip.dart';
import 'package:passengerapp/widgets/widgets.dart';

class DriverOnTheWay extends StatefulWidget {
  Function? callback;
  DriverOnTheWay(this.callback);

  @override
  State<DriverOnTheWay> createState() => _DriverOnTheWayState();
}

class _DriverOnTheWayState extends State<DriverOnTheWay> {
  final _greyTextStyle = TextStyle(color: Colors.black26, fontSize: 14);

  final _blackTextStyle = TextStyle(color: Colors.black);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 3.0,
      left: 8.0,
      right: 8.0,
      child: Column(
        children: [
          Container(
              height: 280,
              padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 0),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(240, 241, 241, 1),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DriverProfile(assetImage: 'assets/icons/economyCarIcon.png'),

                  //CarDetail()
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),

                  DirectionDetail(priceMultiplier: 1, durationMultiplier: 1),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text.rich(TextSpan(
                  //             text: "Price:      ",
                  //             style: _greyTextStyle,
                  //             children: [
                  //               TextSpan(
                  //                   text: "\$ ${40}", style: _blackTextStyle)
                  //             ])),
                  //         SizedBox(
                  //           height: 5,
                  //         ),
                  //         Text.rich(TextSpan(
                  //             text: "Member: ",
                  //             style: _greyTextStyle,
                  //             children: [
                  //               TextSpan(text: "1-4", style: _blackTextStyle)
                  //             ]))
                  //       ],
                  //     ),
                  //     SizedBox(height: 35, child: VerticalDivider()),
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text.rich(TextSpan(
                  //             text: "Distance: ",
                  //             style: _greyTextStyle,
                  //             children: [
                  //               TextSpan(text: "5 km", style: _blackTextStyle)
                  //             ])),
                  //         SizedBox(
                  //           height: 5,
                  //         ),
                  //         Text.rich(TextSpan(
                  //             text: "Time:      ",
                  //             style: _greyTextStyle,
                  //             children: [
                  //               TextSpan(text: "10 min", style: _blackTextStyle)
                  //             ]))
                  //       ],
                  //     )
                  //   ],
                  // ),

                  SizedBox(
                    height: 30,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, CancelReason.routeName,
                                  arguments:
                                      CancelReasonArgument(sendRequest: true));
                              // widget.callback!(CancelTrip(widget.callback,
                              //     DriverOnTheWay(widget.callback)));
                            },
                            child: const Text("Cancel"))),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
