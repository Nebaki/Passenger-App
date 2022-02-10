import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/reverselocation/location_bloc.dart';
import 'package:passengerapp/bloc/reverselocation/location_state.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';

class WhereTo extends StatefulWidget {
  const WhereTo({Key? key}) : super(key: key);

  @override
  _WhereToState createState() => _WhereToState();
}

class _WhereToState extends State<WhereTo> {
  late String currentLocation;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 3.0,
      left: 2.0,
      right: 2.0,
      child: Container(
        height: 220,
        padding:
            const EdgeInsets.only(top: 40, left: 50, right: 50, bottom: 20),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            Column(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.blue.shade600,
                ),
                const SizedBox(
                  height: 70,
                  child: VerticalDivider(
                    width: 10,
                    color: Colors.white60,
                  ),
                ),
                const Icon(
                  Icons.location_on,
                  color: Colors.green,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "PICK UP",
                    style: TextStyle(color: Colors.white54, fontSize: 16.0),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  //Text(widget.currentLocation),
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: InkWell(
                      onTap: () {},
                      child: BlocBuilder<LocationBloc, ReverseLocationState>(
                          builder: (context, state) {
                        if (state is ReverseLocationLoadSuccess) {
                          List addresses = state.location.address1.split(",");
                          currentLocation = addresses[1];
                          return Text(addresses[0]);
                        }
                        if (state is ReverseLocationOperationFailure) {
                          return const Text(
                              "Unable To get Your current location");
                        }
                        return const Text("Loading");
                      }),
                      // const Text(
                      //   "Meskel Flower,Addis Ababa",
                      //   style: TextStyle(
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 16),
                      // ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                      width: 200,
                      child: Divider(
                        color: Colors.white60,
                      ),
                    ),
                  ),
                  const Text(
                    "DROP OFF",
                    style: TextStyle(color: Colors.white54, fontSize: 16.0),
                  ),
                  const SizedBox(height: 5),
                  //Text(widget.currentLocation),
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, SearchScreen.routeName,
                            arguments: SearchScreenArgument(
                                currentLocation: currentLocation));
                      },
                      child: const SizedBox(
                        height: 35,
                        width: 150,
                        child: Text(
                          "Where To?",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
