import 'package:flutter/material.dart';
import 'package:passengerapp/screens/screens.dart';

class WhereTo extends StatefulWidget {
  final String currentLocation;
  const WhereTo({Key? key, required this.currentLocation}) : super(key: key);

  @override
  _WhereToState createState() => _WhereToState();
}

class _WhereToState extends State<WhereTo> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 3.0,
      left: 2.0,
      right: 2.0,
      child: Container(
        height: 220,
        padding: EdgeInsets.only(top: 40, left: 50, right: 50, bottom: 20),
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
                SizedBox(
                  height: 70,
                  child: VerticalDivider(
                    width: 10,
                    color: Colors.white60,
                  ),
                ),
                Icon(
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
                  SizedBox(
                    height: 5,
                  ),
                  //Text(widget.currentLocation),
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: InkWell(
                      onTap: () {},
                      child: const Text(
                        "Meskel Flower,Addis Ababa",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                      width: 220,
                      child: const Divider(
                        color: Colors.white60,
                      ),
                    ),
                  ),
                  const Text(
                    "DROP OFF",
                    style: TextStyle(color: Colors.white54, fontSize: 16.0),
                  ),
                  SizedBox(height: 5),
                  //Text(widget.currentLocation),
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, SearchScreen.routeName);
                      },
                      child: const Text(
                        "Where To?",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
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
