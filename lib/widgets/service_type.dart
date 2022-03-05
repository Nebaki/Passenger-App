import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/bloc/notificationrequest/notification_request_bloc.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/widgets/widgets.dart';

class Service extends StatefulWidget {
  Function? callback;
  Function searchNeabyDriver;
  Service(this.callback, this.searchNeabyDriver);

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  int _isSelected = 0;
  bool _isLoading = false;
  late LatLng currentLatlng;
  @override
  void initState() {
    // TODO: implement initState
    GeolocatorPlatform.instance.getCurrentPosition().then((value) {
      currentLatlng = LatLng(value.latitude, value.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationRequestBloc, NotificationRequestState>(
        builder: (_, state) {
      return serviceTypeWidget();
    }, listener: (_, state) {
      if (state is NotificationRequestSent) {
        _isLoading = false;
        widget.callback!(DriverOnTheWay(this.widget.callback));
      }
      if (state is NotificationRequestSending) {}
      if (state is NotificationRequestSendingFailure) {
        _isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Notification Not Sent"),
          backgroundColor: Colors.red.shade900,
        ));
      }
    });
  }

  final _greyTextStyle = TextStyle(color: Colors.black26, fontSize: 14);

  final _blackTextStyle = TextStyle(color: Colors.black);

  void sendNotification(String fcmToken) async {
    _isLoading = true;
    NotificationRequestEvent event = NotificationRequestSend(
        NotificationRequest(
            pickupAddress: "Meskel Flower",
            dropOffAddress: "Bole",
            passengerName: "miki",
            pickupLocation:
                LatLng(currentLatlng.latitude, currentLatlng.longitude),
            fcmToken: fcmToken));

    BlocProvider.of<NotificationRequestBloc>(context).add(event);
  }

  Widget serviceTypeWidget() {
    return Positioned(
      bottom: 0.0,
      left: 8.0,
      right: 8.0,
      child: Container(
          height: 260,
          padding:
              const EdgeInsets.only(top: 10, left: 10, right: 20, bottom: 0),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(240, 241, 241, 1),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text("Choose a taxi"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSelected = 1;
                        DriverEvent event =
                            DriverLoad(widget.searchNeabyDriver());
                        BlocProvider.of<DriverBloc>(context).add(event);
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: _isSelected == 1
                              ? BoxDecoration(
                                  boxShadow: const [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(244, 201, 60, 1)),
                                    ],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 0.5, color: Colors.black))
                              : null,
                          child: const Image(
                              height: 50,
                              image: AssetImage(
                                  "assets/icons/economyCarIcon.png")),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text("Standart")
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSelected = 2;
                        DriverEvent event =
                            DriverLoad(widget.searchNeabyDriver());
                        BlocProvider.of<DriverBloc>(context).add(event);
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: _isSelected == 2
                              ? BoxDecoration(
                                  boxShadow: const [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(244, 201, 60, 1)),
                                    ],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 0.5, color: Colors.black))
                              : null,
                          child: const Image(
                              height: 50,
                              image:
                                  AssetImage("assets/icons/lexuryCarIcon.png")),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text("XL")
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSelected = 3;
                        DriverEvent event =
                            DriverLoad(widget.searchNeabyDriver());
                        BlocProvider.of<DriverBloc>(context).add(event);
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: _isSelected == 3
                              ? BoxDecoration(
                                  boxShadow: const [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(244, 201, 60, 1)),
                                    ],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 0.5, color: Colors.black))
                              : null,
                          child: const Image(
                              height: 50,
                              image:
                                  AssetImage("assets/icons/familyCarIcon.png")),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text("Family")
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
              SizedBox(
                height: 10,
              ),
              DirectionDetail(),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child:
                      BlocBuilder<DriverBloc, DriverState>(builder: (_, state) {
                    if (state is DriverLoadSuccess) {
                      return ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(244, 201, 60, 1)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        onPressed: () {
                          sendNotification(state.driver.fcmId);

                          // print(widget.searchNeabyDriver());
                          //callback!(NearbyTaxy(callback));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Text(
                              _isLoading ? "Sending...." : "Send Request",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black,
                                      ),
                                    )
                                  : Container(),
                            )
                          ],
                        ),
                      );
                    }
                    if (state is DriverLoading) {
                      return ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(244, 201, 60, 1)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        onPressed: null,
                        child: const Text(
                          "Finding nearby driver..",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      );
                    }
                    if (state is DriverOperationFailure) {
                      return ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(244, 201, 60, 1)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        onPressed: null,
                        child: const Text(
                          "No driver Found",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      );
                    }
                    return ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(244, 201, 60, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                      onPressed: null,
                      child: const Text(
                        "Please select car type",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.normal),
                      ),
                    );
                  }),
                ),
              ),
            ],
          )),
    );
  }
}
