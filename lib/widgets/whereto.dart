import 'package:flutter/material.dart';

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
        height: 200,
        padding: EdgeInsets.only(top: 40, left: 50),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text(widget.currentLocation),
            InkWell(
              onTap: () {},
              child: const Text(
                "Where To? Meskel Flower",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
