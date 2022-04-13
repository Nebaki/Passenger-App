import 'package:flutter/material.dart';
import 'package:passengerapp/rout.dart';

class DetailHistoryScreen extends StatelessWidget {
  static const routeName = "/detailhistory";
  final DetailHistoryArgument args;

  DetailHistoryScreen({Key? key, required this.args}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text("Trip Details"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {},
              child: const Text(
                "Help",
                style: TextStyle(color: Colors.orange),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.blue,
                        ),
                        Text(
                          args.request.pickUpAddress!,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            color: Colors.green),
                        Text(args.request.droppOffAddress!)
                      ],
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "154.75",
                          style: TextStyle(color: Colors.green, fontSize: 26),
                        ),
                      ),
                    ),
                    Center(
                      child: Text("Payment made sucessfully by Cash",
                          style: _greyTextStyle),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text("15 min"),
                            Text(
                              "Time",
                              style: _greyTextStyle,
                            )
                          ],
                        ),
                        const VerticalDivider(),
                        Column(
                          children: [
                            const Text("45 mi"),
                            Text("Distance", style: _greyTextStyle)
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Date & Time"),
                        Text('${args.request.date!} at ${args.request.time!}')
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text("Service Type"), Text("Sedan")],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text("Trip Type"), Text("Normal")],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    // Center(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: const [
                    //       Text("You rated: Yonas Kebede"),
                    //       SizedBox(
                    //         width: 10,
                    //       ),
                    //       CircleAvatar(
                    //         radius: 10,
                    //       )
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 0),
              child: Text("RECIEPT"),
            ),
            Card(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildReciept(title: "Trip fares", value: "40.25"),
                    const SizedBox(
                      height: 15,
                    ),
                    _buildReciept(title: "YellowTaxi fee", value: "40.25"),
                    const SizedBox(
                      height: 15,
                    ),
                    _buildReciept(title: "+Tax", value: "40.25"),
                    const SizedBox(
                      height: 15,
                    ),
                    _buildReciept(title: "+Tolls", value: "40.25"),
                    const SizedBox(
                      height: 15,
                    ),
                    _buildReciept(title: "Discount", value: "40.25"),
                    const SizedBox(
                      height: 15,
                    ),
                    _buildReciept(title: "+ Topup Added", value: "40.25"),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Your Payment",
                          style: _greenTextStyle,
                        ),
                        Text("\$460.75", style: _greenTextStyle)
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "This trip was towards your destination you recieved Guaranted fare",
                      style: TextStyle(
                          fontSize: 9,
                          color: Colors.black26,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  final _greenTextStyle = const TextStyle(
    color: Colors.green,
    fontWeight: FontWeight.bold,
  );
  final _greyTextStyle = const TextStyle(
    color: Colors.black38,
  );

  Widget _buildReciept({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: _greyTextStyle,
        ),
        Text("\$$value", style: _greyTextStyle)
      ],
    );
  }
}
