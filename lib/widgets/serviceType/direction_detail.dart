import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';

class DirectionDetail extends StatefulWidget {
  final int? initialFare;
  final int? costPerKilloMeter;
  final int? costPerMinute;
  final String capacity;

  const DirectionDetail(
      {Key? key,
      required this.initialFare,
      required this.costPerKilloMeter,
      required this.costPerMinute,
      required this.capacity})
      : super(key: key);
  @override
  _DirectionDetailState createState() => _DirectionDetailState();
}

class _DirectionDetailState extends State<DirectionDetail> {
  final _greyTextStyle = TextStyle(color: Colors.black26, fontSize: 14);
  final _blackTextStyle = TextStyle(color: Colors.black);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DirectionBloc, DirectionState>(
      builder: (_, state) {
        if (state is DirectionLoadSuccess) {
          price = widget.initialFare != null
              ? (widget.initialFare! +
                      (widget.costPerKilloMeter! *
                          (state.direction.distanceValue / 1000)) +
                      (widget.costPerMinute! *
                          ((state.direction.durationValue / 60) / 10)))
                  .truncate()
                  .toString()
              : 'Loading ';
          // double timeTraveledFare = (state.direction.durationValue / 60) * 0.20;
          // double distanceTraveldFare =
          //     (state.direction.distanceValue / 1000) * 0.20;
          // double totalFareAmount = timeTraveledFare + distanceTraveldFare;

          // double localFareAmount = totalFareAmount * 48;
          // price =
          //     (localFareAmount * widget.priceMultiplier).truncate().toString();
          distance =
              (state.direction.distanceValue / 1000).truncate().toString();
          duration = (state.direction.durationValue / 60).truncate().toString();
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(
                    text: "Price:      ",
                    style: _greyTextStyle,
                    children: [
                      TextSpan(text: "$price ETB", style: _blackTextStyle)
                    ])),
                SizedBox(
                  height: 5,
                ),
                Text.rich(TextSpan(
                    text: "Member: ",
                    style: _greyTextStyle,
                    children: [
                      TextSpan(text: widget.capacity, style: _blackTextStyle)
                    ]))
              ],
            ),
            SizedBox(height: 35, child: VerticalDivider()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(
                    text: "Distance: ",
                    style: _greyTextStyle,
                    children: [
                      TextSpan(text: "$distance km", style: _blackTextStyle)
                    ])),
                SizedBox(
                  height: 5,
                ),
                Text.rich(TextSpan(
                    text: "Time:      ",
                    style: _greyTextStyle,
                    children: [
                      TextSpan(text: "$duration min", style: _blackTextStyle)
                    ]))
              ],
            )
          ],
        );
      },
      // builder: (_, state) {
      //   print("YAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAYay");

      // },
    );
  }
}
