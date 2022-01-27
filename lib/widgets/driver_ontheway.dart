import 'package:flutter/material.dart';
import 'package:passengerapp/widgets/canceltrip.dart';
import 'package:passengerapp/widgets/widgets.dart';

class DriverOnTheWay extends StatelessWidget {
  Function? callback;
  DriverOnTheWay(this.callback);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 3.0,
      left: 8.0,
      right: 8.0,
      child: Column(
        children: [
          Container(
              height: 250,
              padding: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 0),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Driver On The Way",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Car Logo",
                        style: TextStyle(color: Colors.white),
                      ),
                      DriverProfile(),
                    ],
                  ),
                  //CarDetail()
                ],
              )),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
                height: 65,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                    onPressed: () {
                      callback!(CancelTrip(callback));
                    },
                    child: const Text("Cancel"))),
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}
