import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:shimmer/shimmer.dart';

class DirectionDetail extends StatefulWidget {
  final bool fromBackGround;
  const DirectionDetail({
    required this.fromBackGround,
    Key? key,
  }) : super(key: key);
  @override
  _DirectionDetailState createState() => _DirectionDetailState();
}

class _DirectionDetailState extends State<DirectionDetail> {
  String capacity = "Uknown";
  @override
  Widget build(BuildContext context) {
    print("From where ${widget.fromBackGround}");
    return widget.fromBackGround
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(TextSpan(
                        text: "${getTranslation(context, "estimated_fare")}:  ",
                        style: Theme.of(context).textTheme.subtitle1,
                        children: [
                          TextSpan(
                              text: "$price ${getTranslation(context, "etb")}",
                              style: Theme.of(context).textTheme.labelMedium)
                        ])),
                    const SizedBox(
                      height: 5,
                    ),
                    Text.rich(TextSpan(
                        text:
                            "${getTranslation(context, "estimated_duration")}: ",
                        style: Theme.of(context).textTheme.subtitle1,
                        children: [
                          TextSpan(
                              text: "$duration min",
                              style: Theme.of(context).textTheme.labelMedium)
                        ]))
                  ],
                ),
              ),
              //  const Flexible(flex:1 ,child: VerticalDivider()),
              Flexible(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(TextSpan(
                        text: getTranslation(context, "distance"),
                        style: Theme.of(context).textTheme.subtitle1,
                        children: [
                          TextSpan(
                              text: "$distance km",
                              style: Theme.of(context).textTheme.labelMedium)
                        ])),
                    const SizedBox(
                      height: 5,
                    ),
                    Text.rich(TextSpan(
                        text: "${getTranslation(context, "capacity")}: ",
                        style: Theme.of(context).textTheme.subtitle1,
                        children: [
                          TextSpan(
                              text: capacity,
                              style: Theme.of(context).textTheme.labelMedium)
                        ])),
                  ],
                ),
              )

            ],
          )
        : BlocBuilder<SelectedCategoryBloc, SelectedCategoryState>(
            builder: (context, categoryState) {
              if (categoryState is CategoryChanged) {
                capacity = categoryState.category.capacity;

                return BlocBuilder<DirectionBloc, DirectionState>(
                    builder: (context, directionState) {
                  if (directionState is DirectionLoadSuccess) {
                    price = (categoryState.category.initialFare +
                            (categoryState.category.perKiloMeterCost *
                                (directionState.direction.distanceValue /
                                    1000)) +
                            (categoryState.category.perMinuteCost *
                                ((directionState.direction.durationValue / 60) /
                                    10)))
                        .truncate()
                        .toString();
                    distance = (directionState.direction.distanceValue / 1000)
                        .truncate()
                        .toString();
                    duration = (directionState.direction.durationValue / 60)
                        .truncate()
                        .toString();
                  }
                  if (directionState is DirectionLoading) {
                    return _buildShimmer();
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(TextSpan(
                                text:
                                    "${getTranslation(context, "estimated_fare")}:  ",
                                style: Theme.of(context).textTheme.subtitle1,
                                children: [
                                  TextSpan(
                                      text:
                                          "$price ${getTranslation(context, "etb")}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium)
                                ])),
                            const SizedBox(
                              height: 5,
                            ),
                            Text.rich(TextSpan(
                                text:
                                    "${getTranslation(context, "estimated_duration")}: ",
                                style: Theme.of(context).textTheme.subtitle1,
                                children: [
                                  TextSpan(
                                      text: "$duration min",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium)
                                ]))
                          ],
                        ),
                      ),
                      //  const Flexible(flex:1 ,child: VerticalDivider()),
                      Flexible(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(TextSpan(
                                text: getTranslation(context, "distance"),
                                style: Theme.of(context).textTheme.subtitle1,
                                children: [
                                  TextSpan(
                                      text: "$distance km",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium)
                                ])),
                            const SizedBox(
                              height: 5,
                            ),
                            Text.rich(TextSpan(
                                text:
                                    "${getTranslation(context, "capacity")}: ",
                                style: Theme.of(context).textTheme.subtitle1,
                                children: [
                                  TextSpan(
                                      text: capacity,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium)
                                ])),
                          ],
                        ),
                      )
                    ],
                  );
                });
              }

              return _buildShimmer();
            },
          );
  }

  Widget _buildShimmer() {
    return Shimmer(
      gradient: shimmerGradient,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 10,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16))),
              const SizedBox(
                height: 5,
              ),
              Container(
                  height: 10,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16))),
            ],
          ),
          const SizedBox(height: 35, child: VerticalDivider()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 10,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16))),
              const SizedBox(
                height: 5,
              ),
              Container(
                  height: 10,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16))),
            ],
          )
        ],
      ),
    );
  }
}
