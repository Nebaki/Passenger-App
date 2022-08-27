import 'package:flutter/material.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/widgets.dart';

class DriverOnTheWay extends StatefulWidget {
  final bool fromBackGround;
  final bool appOpen;
  const DriverOnTheWay({Key? key, required this.fromBackGround,required this.appOpen})
      : super(key: key);

  @override
  State<DriverOnTheWay> createState() => _DriverOnTheWayState();
}

class _DriverOnTheWayState extends State<DriverOnTheWay> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          padding:
              const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Expanded(
                  flex: 3,
                  child: DriverProfile(
                      assetImage: 'assets/icons/economyCarIcon.png')),

              //CarDetail()

              const Divider(),

              Expanded(
                  flex: 2,
                  child: DirectionDetail(
                    fromBackGround: widget.appOpen,
                  )),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, CancelReason.routeName,
                                arguments:
                                    CancelReasonArgument(sendRequest: true));
                          },
                          child: Text(getTranslation(context, "cancel")))),
                ),
              ),
            ],
          )),
    );
  }
}
