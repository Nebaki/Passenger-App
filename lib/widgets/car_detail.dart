import 'package:flutter/material.dart';

class CarDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              const Text(
                "Audi Q7",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16.0),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Audi Seat Availablity",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Distance",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Time",
                style: TextStyle(
                  color: Colors.white54,
                ),
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              const Text(
                "23 \$",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16.0),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "4 Persons",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "6.3 kms",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "25 mins",
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
