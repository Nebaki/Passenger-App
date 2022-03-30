import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/riderequest/bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';

class CancelReason extends StatefulWidget {
  static const routeName = "cacelreason";
  final CancelReasonArgument arg;

  CancelReason({Key? key, required this.arg}) : super(key: key);
  @override
  State<CancelReason> createState() => _CancelReasonState();
}

class _CancelReasonState extends State<CancelReason> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.3,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.clear,
                color: Colors.black,
              )),
          title: const Text("Cancel Trip"),
          centerTitle: true,
        ),
        body: BlocConsumer<RideRequestBloc, RideRequestState>(
          builder: (context, state) => _buildScreen(),
          listener: (context, state) {
            if (state is RideRequestStatusChangedSuccess) {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName,
                  arguments: HomeScreenArgument(isSelected: false));
            }
          },
        ));
  }

  void cancelTrip() {
    RideRequestEvent event =
        RideRequestChangeStatus(rideRequestId, widget.arg.sendRequest);
    BlocProvider.of<RideRequestBloc>(context).add(event);
  }

  Widget _buildScreen() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              _builReasonItem(context: context, text: "Rider isn't here"),
              _builReasonItem(context: context, text: "Wrong address shown"),
              _builReasonItem(context: context, text: "Don't charge rider"),
              _builReasonItem(context: context, text: "Don't charge rider"),
              _builReasonItem(context: context, text: "Don't charge rider"),
              _builReasonItem(context: context, text: "Don't charge rider"),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                    ),
                    onPressed: () {
                      cancelTrip();
                      Navigator.pushReplacementNamed(
                          context, HomeScreen.routeName,
                          arguments: HomeScreenArgument(isSelected: false));
                    },
                    child: const Text(
                      "Confirm",
                      style: TextStyle(color: Colors.white),
                    ))),
          )
        ],
      ),
    );
  }

  Widget _builReasonItem({required context, required String text}) {
    return Column(
      children: [
        ListTile(
          leading: Radio(
            value: "value",
            groupValue: "groupValue",
            onChanged: (value) {},
          ),
          title: Text(text),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 65, right: 20),
          child: Divider(color: Colors.grey.shade200),
        ),
      ],
    );
  }
}
