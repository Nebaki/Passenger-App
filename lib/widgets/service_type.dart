import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/widgets/widgets.dart';

class Service extends StatelessWidget {
  Function? callback;
  Service(this.callback);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      left: 8.0,
      right: 8.0,
      child: Container(
          height: 260,
          padding:
              const EdgeInsets.only(top: 10, left: 10, right: 20, bottom: 0),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(240, 241, 241, 1),
              borderRadius: BorderRadius.circular(20)),
          child: BlocBuilder<DirectionBloc, DirectionState>(
            builder: (_, state) {
              if (state is DirectionLoadSuccess) {
                double timeTraveledFare =
                    (state.direction.durationValue / 60) * 0.20;
                double distanceTraveldFare =
                    (state.direction.distanceValue / 100) * 0.20;
                double totalFareAmount = timeTraveledFare + distanceTraveldFare;

                double localFareAmount = totalFareAmount * 1;

                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text("Choose a taxi"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            FilterChip(
                                label: const Icon(Icons.ac_unit),
                                onSelected: (onSelected) {}),
                            const Text("Standart")
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            FilterChip(
                                selected: true,
                                selectedColor: Colors.yellow,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                label: const Icon(Icons.car_rental),
                                onSelected: (onSelected) {}),
                            const Text("XL")
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
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
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      const Color.fromRGBO(244, 201, 60, 1)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)))),
                              onPressed: () {
                                callback!(NearbyTaxy(callback));
                              },
                              child: const Text(
                                "Send Request",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ))),
                    ),
                  ],
                );
              }

              return Container();
            },
          )),
    );
  }

  final _greyTextStyle = TextStyle(color: Colors.black26, fontSize: 14);
  final _blackTextStyle = TextStyle(color: Colors.black);
}
