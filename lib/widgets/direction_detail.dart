import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';

class DirectionDetail extends StatefulWidget {
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
          double timeTraveledFare = (state.direction.durationValue / 60) * 0.20;
          double distanceTraveldFare =
              (state.direction.distanceValue / 100) * 0.20;
          double totalFareAmount = timeTraveledFare + distanceTraveldFare;

          double localFareAmount = totalFareAmount * 1;
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
                        TextSpan(
                            text: "\$ ${localFareAmount.truncate()}",
                            style: _blackTextStyle)
                      ])),
                  SizedBox(
                    height: 5,
                  ),
                  Text.rich(TextSpan(
                      text: "Member: ",
                      style: _greyTextStyle,
                      children: [
                        TextSpan(text: "1-4", style: _blackTextStyle)
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
                        TextSpan(
                            text:
                                "${(state.direction.distanceValue / 1000).truncate()} km",
                            style: _blackTextStyle)
                      ])),
                  SizedBox(
                    height: 5,
                  ),
                  Text.rich(TextSpan(
                      text: "Time:      ",
                      style: _greyTextStyle,
                      children: [
                        TextSpan(
                            text:
                                "${(state.direction.durationValue / 60).truncate()} min",
                            style: _blackTextStyle)
                      ]))
                ],
              )
            ],
          );
        }
        return Container();
      },
    );
  }
}
