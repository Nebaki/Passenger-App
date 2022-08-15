import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/rout.dart';

class CancelReason extends StatefulWidget {
  static const routeName = "cacelreason";
  final CancelReasonArgument arg;

  const CancelReason({Key? key, required this.arg}) : super(key: key);

  @override
  State<CancelReason> createState() => _CancelReasonState();
}

class _CancelReasonState extends State<CancelReason> {
  final List<String> _reasons = [
    "Driver isn't here",
    "Wrong address shown",
    "Don't charge rider",
    "Don't charge rider",
    "Don't charge rider",
    "Don't charge rider"
  ];
  String? groupValue;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.3,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.clear,
              )),
          title: Text(getTranslation(context, "cancel_trip")),
          centerTitle: true,
        ),
        body: BlocConsumer<RideRequestBloc, RideRequestState>(
            builder: ((context, state) => Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          _builReasonItem(
                              context: context,
                              text: "Driver isn't here",
                              value: _reasons[0]),
                          _builReasonItem(
                              context: context,
                              text: "Wrong address shown",
                              value: _reasons[1]),
                          _builReasonItem(
                              context: context,
                              text: "Don't charge rider",
                              value: _reasons[2]),
                          _builReasonItem(
                              context: context,
                              text: "Don't charge rider",
                              value: _reasons[3]),
                          _builReasonItem(
                              context: context,
                              text: "Don't charge rider",
                              value: _reasons[4]),
                          _builReasonItem(
                              context: context,
                              text: "Don't charge rider",
                              value: _reasons[5]),
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
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                              ),
                              onPressed: groupValue != null
                                  ? isLoading
                                      ? null
                                      : () {
                                          cancellRequest(context);
                                        }
                                  : null,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Spacer(),
                                  Text(getTranslation(context, "confirm"),
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  const Spacer(),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : Container(),
                                  )
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
                )),
            listener: (context, state) {
              if (state is RideRequestCancelled) {
                isLoading = false;
                BlocProvider.of<DirectionBloc>(context).add(
                    const DirectionChangeToInitialState(
                        loadCurrentLocation: false,
                        listenToNearbyDriver: true));
                Navigator.pop(context);
              }
              if (state is RideRequestOperationFailur) {
                isLoading = false;

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(getTranslation(context, "unable_to_cancel")),
                  backgroundColor: Colors.red.shade900,
                ));
              }
            }));
  }

  void cancellRequest(BuildContext context) {
    isLoading = true;
    RideRequestEvent requestEvent = RideRequestCancell(
        rideRequestId, groupValue!, driverFcm, widget.arg.sendRequest);
    BlocProvider.of<RideRequestBloc>(context).add(requestEvent);
  }

  Widget _builReasonItem(
      {required context, required String text, required String value}) {
    return Column(
      children: [
        ListTile(
          leading: Radio(
            value: value,
            groupValue: groupValue,
            onChanged: (value) {
              setState(() {
                groupValue = value.toString();
              });
            },
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
