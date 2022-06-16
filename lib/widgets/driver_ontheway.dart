import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/widgets.dart';

class DriverOnTheWay extends StatefulWidget {
  final bool fromBackGround;
  const DriverOnTheWay({Key? key, required this.fromBackGround})
      : super(key: key);

  @override
  State<DriverOnTheWay> createState() => _DriverOnTheWayState();
}

class _DriverOnTheWayState extends State<DriverOnTheWay> {
  @override
  void initState() {
    widget.fromBackGround
        ? BlocProvider.of<DriverBloc>(context).add(DriverLoad(driverId!))
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Positioned(
        bottom: 3.0,
        left: 8.0,
        right: 8.0,
        child: Container(
            height: MediaQuery.of(context).size.height *0.4,
            padding: const EdgeInsets.only(
                top: 10, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
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
        
                const Expanded(flex: 2, child: DirectionDetail()),
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
                //                   text: "$ ", style: _blackTextStyle)
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
        
                
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, CancelReason.routeName,
                                  arguments: CancelReasonArgument(
                                      sendRequest: true));
                              // widget.callback!(CancelTrip(widget.callback,
                              //     DriverOnTheWay(widget.callback)));
                            },
                            child:  Text(getTranslation(context, "cancel")))),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
