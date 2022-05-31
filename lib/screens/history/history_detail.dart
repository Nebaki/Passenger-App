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
                color: Theme.of(context).backgroundColor,
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
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          '${args.request.price!} ETB',
                          style: const TextStyle(
                              color: Colors.green, fontSize: 26),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                          args.request.status == "Completed"
                              ? 'Payment made sucessfully by Cash'
                              : "Not Paid Yet",
                          style: Theme.of(context).textTheme.overline),
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
                              style: Theme.of(context).textTheme.overline,
                            )
                          ],
                        ),
                        const VerticalDivider(),
                        Column(
                          children: [
                            Text('${args.request.distance} Km'),
                            Text("Distance",
                                style: Theme.of(context).textTheme.overline)
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
                      children: [
                        const Text("Status"),
                        Text('${args.request.status}')
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Distance"),
                        Text('${args.request.distance} Km')
                      ],
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
              child: Text("Driver & Vehicle"),
            ),
            args.request.status != 'Cancelled' &&
                    args.request.status != 'Pending'
                ? Card(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                      color: Theme.of(context).backgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildReciept(
                              title: "Driver ",
                              value: args.request.driver!.firstName),
                          const SizedBox(
                            height: 15,
                          ),
                          _buildReciept(
                              title: "Phone number",
                              value: args.request.driver!.phoneNumber),
                          const SizedBox(
                            height: 15,
                          ),
                          // _buildReciept(
                          //     title: "Vehicle ",
                          //     value: args.request.driver!.vehicle!['model']),
                          // const SizedBox(
                          //   height: 15,
                          // ),
                          // _buildReciept(
                          //     title: "Plate Number",
                          //     value: args
                          //         .request.driver!.vehicle!['plate_number']),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Your Payment",
                                style: _greenTextStyle,
                              ),
                              Text("\$${args.request.price!}",
                                  style: _greenTextStyle)
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // const Text(
                          //   "This trip was towards your destination you recieved Guaranted fare",
                          //   style: TextStyle(
                          //       fontSize: 9,
                          //       color: Colors.black26,
                          //       fontWeight: FontWeight.bold),
                          //   textAlign: TextAlign.start,
                          // )
                        ],
                      ),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                    child: Text('Not Accpeted Yet'),
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
          // style: _greyTextStyle,
        ),
        Text(
          "$value",
        )
      ],
    );
  }
}
