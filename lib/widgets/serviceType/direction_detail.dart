import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';

class DirectionDetail extends StatefulWidget {
  const DirectionDetail({
    Key? key,
  }) : super(key: key);
  @override
  _DirectionDetailState createState() => _DirectionDetailState();
}

class _DirectionDetailState extends State<DirectionDetail> {
  final _greyTextStyle = const TextStyle(color: Colors.black26, fontSize: 14);
  final _blackTextStyle = const TextStyle(color: Colors.black);
  late String capacity;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedCategoryBloc, SelectedCategoryState>(
      builder: (context, categoryState) {
        if (categoryState is CategoryChanged) {
          capacity = categoryState.category.capacity;

          return BlocBuilder<DirectionBloc, DirectionState>(
              builder: (context, directionState) {
            if (directionState is DirectionLoadSuccess) {
              price = (categoryState.category.initialFare +
                      (categoryState.category.perKiloMeterCost *
                          (directionState.direction.distanceValue / 1000)) +
                      (categoryState.category.perMinuteCost *
                          ((directionState.direction.durationValue / 60) / 10)))
                  .truncate()
                  .toString();
              distance = (directionState.direction.distanceValue / 1000)
                  .truncate()
                  .toString();
              duration = (directionState.direction.durationValue / 60)
                  .truncate()
                  .toString();
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(TextSpan(
                        text: "Estimated Fare:   ",
                        style: Theme.of(context).textTheme.subtitle1,
                        children: [
                          TextSpan(
                              text: "$price ETB",
                              style: Theme.of(context).textTheme.labelMedium)
                        ])),
                    const SizedBox(
                      height: 5,
                    ),
                    Text.rich(TextSpan(
                        text: "Estimated Duration:  ",
                        style: Theme.of(context).textTheme.subtitle1,
                        children: [
                          TextSpan(
                              text: "$duration min",
                              style: Theme.of(context).textTheme.labelMedium)
                        ]))
                  ],
                ),
                const SizedBox(height: 35, child: VerticalDivider()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(TextSpan(
                        text: "Distance: ",
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
                        text: "Capacity: ",
                        style: Theme.of(context).textTheme.subtitle1,
                        children: [
                          TextSpan(
                              text: capacity,
                              style: Theme.of(context).textTheme.labelMedium)
                        ])),
                  ],
                )
              ],
            );
          });
        }
        return Container();
      },
    );
  }
}
