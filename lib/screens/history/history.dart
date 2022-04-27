import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/widgets.dart';

class HistoryPage extends StatefulWidget {
  static const routeName = "/history";

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _textStyle = TextStyle(fontSize: 20);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BlocListener<RideRequestBloc, RideRequestState>(
      listener: (context, state) {
        print('staaate $state');
      },
    );
    return Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   iconTheme: const IconThemeData(color: Colors.black),
        //   backgroundColor: Colors.grey.shade100,
        //   title: const Text(
        //     "Trips",
        //     style: TextStyle(color: Colors.black),
        //   ),
        //   centerTitle: true,
        // ),
        body: Stack(
      children: [
        BlocBuilder<RideRequestBloc, RideRequestState>(
          buildWhen: (previous, current) {
            bool build = false;
            if (current is RideRequestLoadSuccess) {
              build = true;
            }
            return build;
          },
          builder: (context, state) {
            if (state is RideRequestLoadSuccess) {
              return Padding(
                padding: const EdgeInsets.only(top: 80),
                child: ListView.builder(
                  itemCount: state.rideRequests.length,
                  itemBuilder: (context, index) {
                    return _builHistoryCard(
                        context,
                        state.rideRequests[index].status!,
                        state.rideRequests[index]);
                  },
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                ),
              );
            }
            if (state is RideRequestOperationFailur) {
              print("Yeah Filedddddddd");
            }
            return const SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ));
          },
        ),
        CustomeBackArrow(),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                "History",
                style: Theme.of(context).textTheme.titleLarge,
              )),
        )
      ],
    ));
  }

  Widget _savedItems({
    required BuildContext context,
    required String text,
  }) {
    const color = Colors.grey;
    const hoverColor = Colors.white70;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          trailing: Text(
            "\$40",
            style: _textStyle,
          ),
          //leading: Icon(Icons.history, color: color.shade700),
          title: Text(text, style: _textStyle),
          subtitle: Text(
            "25 Trips",
          ),
          hoverColor: hoverColor,
          onLongPress: () {},
          onTap: () {
            Navigator.pushNamed(context, DetailHistoryScreen.routeName);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Divider(color: Colors.grey.shade400),
        )
      ],
    );
  }

  Widget _builHistoryCard(
      BuildContext context, String status, RideRequest? request) {
    String st = status.substring(0, 1);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, DetailHistoryScreen.routeName,
              arguments: DetailHistoryArgument(request: request!));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    blurStyle: BlurStyle.normal,
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    spreadRadius: 5)
              ]),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        color: status == "Completed"
                            ? Colors.green
                            : status == "Cancelled"
                                ? Colors.red
                                : status == "Accepted"
                                    ? Colors.indigo.shade900
                                    : status == "Searching"
                                        ? Colors.indigo
                                        : Colors.grey,
                        child: Text(st,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        request!.droppOffAddress!,
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        request.pickUpAddress!,
                        style: TextStyle(color: Colors.black38),
                      )
                    ],
                  )
                ],
              ),
              const Divider(),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        request.date!,
                        style: TextStyle(color: Colors.black38),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        request.time!,
                        style: TextStyle(color: Colors.black38),
                      ),
                      Text(status),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  const Text(
                    "\$15",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
