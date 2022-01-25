import 'package:flutter/material.dart';

class Service extends StatelessWidget {
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
                      return Cars();
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
                    child: const Text("Send Request"))),
          ),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }

  Widget Cars() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                height: 100,
                width: 90,
                color: Colors.green,
                // child: Image(
                //   //height: 100,
                //   //width: 30,
                //   image: AssetImage("assets/images/safeway.jpg"),
                //   fit: BoxFit.scaleDown,
                // ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Car Type",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
