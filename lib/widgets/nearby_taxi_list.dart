import 'package:flutter/material.dart';
import 'package:passengerapp/widgets/widgets.dart';

class NearbyTaxy extends StatefulWidget {
  @override
  _NearbyTaxyState createState() => _NearbyTaxyState();
}

class _NearbyTaxyState extends State<NearbyTaxy> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 3.0,
      left: 8.0,
      right: 8.0,
      child: Column(
        children: [
          Container(
              height: 200,
              padding: EdgeInsets.only(top: 40, left: 10, right: 20, bottom: 0),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(20)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  child: Row(
                    children: List.generate(20, (index) {
                      return nearbyTaxies();
                    }),
                  ),
                ),
              )),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
                height: 65,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                    onPressed: () {},
                    child: const Text("Confirm"))),
          ),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }

  Widget nearbyTaxies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Text("Car Logo"), CarDetail()],
    );
  }
}
