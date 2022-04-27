import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/bloc/notificationrequest/notification_request_bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/helper_functions.dart';
import 'package:passengerapp/widgets/custome_back_arrow.dart';

import '../../models/models.dart';

class OrderForOtherScreen extends StatefulWidget {
  static const routeName = "/orderforothers";

  @override
  _OrderForOtherScreenState createState() => _OrderForOtherScreenState();
}

class _OrderForOtherScreenState extends State<OrderForOtherScreen> {
  int _isSelected = 0;
  PlaceDetail? _droppOffPlaceDetail;
  PlaceDetail? _pickUpPlaceDetail;
  int _currentStep = 0;
  int selected = -1;
  String? pickupAddress;
  String? droppOffAddress;
  late LatLng pickupLatLng;
  late LatLng dropOffLatLng;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String? name;
  String? number;
  bool _isLoading = false;
  String? driverId;

  @override
  Widget build(BuildContext context) {
    FocusNode dropOffNode = new FocusNode();
    List<Step> steps = [
      Step(
          isActive: _currentStep >= 0,
          title: Text("Passenger Information"),
          content: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  onSaved: (value) {
                    name = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Name Can't be empity";
                    }
                  },
                  decoration:
                      InputDecoration(hintText: "Full Name of the passenger"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: InternationalPhoneNumberInput(
                    onSaved: (value) {
                      number = value.phoneNumber;
                    },
                    inputDecoration: const InputDecoration(
                      hintText: "Phone Number of the passenger",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w300, color: Colors.black45),
                    ),
                    onInputChanged: (PhoneNumber number) {},
                    initialValue: PhoneNumber(isoCode: "ET"),
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    selectorTextStyle: const TextStyle(color: Colors.black),
                    formatInput: true,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    spaceBetweenSelectorAndTextField: 0,
                  ),
                ),
              ],
            ),
          )),
      Step(
          isActive: _currentStep >= 1,
          title: Text("Location"),
          content: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: TextField(
                  onTap: () {
                    setState(() {
                      selected = 0;
                    });
                  },
                  onChanged: (value) {
                    findPlace(value);
                  },
                  // focusNode: FocusNode.a,
                  decoration: InputDecoration(
                      labelText: pickupAddress != null ? pickupAddress! : null,
                      hintText: "PickUp Address",
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 20, right: 10),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.blue,
                        ),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none)),
                ),
              ),
              selected == 0
                  ? BlocBuilder<LocationPredictionBloc,
                      LocationPredictionState>(builder: (context, state) {
                      if (state is LocationPredictionLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is LocationPredictionLoadSuccess) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.only(top: 30, bottom: 20),
                            // height: 200,
                            constraints: const BoxConstraints(
                                maxHeight: 400, minHeight: 30),

                            width: double.infinity,
                            child: ListView.separated(
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (cont, index) {
                                  return _buildPredictedItem(
                                      state.placeList[index], context);
                                },
                                separatorBuilder: (context, index) =>
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Divider(color: Colors.black38),
                                    ),
                                itemCount: state.placeList.length),
                          ),
                        );
                      }

                      if (state is LocationPredictionOperationFailure) {}

                      return const Center(
                        child: Text("Enter The location"),
                      );
                    })
                  : Container(),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black38,
                          blurRadius: 4,
                          spreadRadius: 2,
                          offset: Offset(0, 4))
                    ]),
                height: 50,
                child: TextField(
                  onTap: () {
                    setState(() {
                      selected = 1;
                    });
                  },
                  onChanged: (value) {
                    findPlace(value);
                  },
                  decoration: InputDecoration(
                      labelText:
                          droppOffAddress != null ? droppOffAddress! : null,
                      hintText: "DropOff Address",
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 20, right: 10),
                        child: Icon(Icons.location_on, color: Colors.green),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none)),
                ),
              ),
              selected == 1
                  ? BlocBuilder<LocationPredictionBloc,
                      LocationPredictionState>(builder: (context, state) {
                      if (state is LocationPredictionLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is LocationPredictionLoadSuccess) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.only(top: 30, bottom: 20),
                            // height: 200,
                            constraints: const BoxConstraints(
                                maxHeight: 400, minHeight: 30),

                            width: double.infinity,
                            child: ListView.separated(
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (cont, index) {
                                  return _buildPredictedItem(
                                      state.placeList[index], context);
                                },
                                separatorBuilder: (context, index) =>
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Divider(color: Colors.black38),
                                    ),
                                itemCount: state.placeList.length),
                          ),
                        );
                      }

                      if (state is LocationPredictionOperationFailure) {}

                      return const Center(
                        child: Text("Enter The location"),
                      );
                    })
                  : Container(),
            ],
          )),
      Step(
        isActive: _currentStep >= 2,
        title: Text("Car Type"),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                geofireListener();

                setState(() {
                  _isSelected = 1;
                  // DriverEvent event = DriverLoad(widget.searchNeabyDriver());
                  // BlocProvider.of<DriverBloc>(context).add(event);
                });
              },
              child: Column(
                children: [
                  Container(
                    decoration: _isSelected == 1
                        ? BoxDecoration(
                            boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(244, 201, 60, 1)),
                              ],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 0.5, color: Colors.black))
                        : null,
                    child: const Image(
                        height: 50,
                        image: AssetImage("assets/icons/economyCarIcon.png")),
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
                  // DriverEvent event = DriverLoad(widget.searchNeabyDriver());
                  // BlocProvider.of<DriverBloc>(context).add(event);
                });
              },
              child: Column(
                children: [
                  Container(
                    decoration: _isSelected == 2
                        ? BoxDecoration(
                            boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(244, 201, 60, 1)),
                              ],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 0.5, color: Colors.black))
                        : null,
                    child: const Image(
                        height: 50,
                        image: AssetImage("assets/icons/lexuryCarIcon.png")),
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
                  // DriverEvent event = DriverLoad(widget.searchNeabyDriver());
                  // BlocProvider.of<DriverBloc>(context).add(event);
                });
              },
              child: Column(
                children: [
                  Container(
                    decoration: _isSelected == 3
                        ? BoxDecoration(
                            boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(244, 201, 60, 1)),
                              ],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 0.5, color: Colors.black))
                        : null,
                    child: const Image(
                        height: 50,
                        image: AssetImage("assets/icons/familyCarIcon.png")),
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
      ),
      Step(
          isActive: _currentStep >= 3,
          title: Text("Request"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(),
              BlocConsumer<RideRequestBloc, RideRequestState>(
                  builder: (context, state) => Container(),
                  listener: (context, state) {
                    if (state is RideRequestSuccess) {
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.pop(context);
                    }
                    if (state is RideRequestOperationFailur) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }),
              Text.rich(
                TextSpan(
                    text: "Pickup Address:  ",
                    style: Theme.of(context).textTheme.titleSmall,
                    children: [
                      TextSpan(
                          text: pickupAddress,
                          style: Theme.of(context).textTheme.bodySmall)
                    ]),
              ),
              SizedBox(
                height: 10,
              ),
              Text.rich(
                TextSpan(
                    text: "DropOff Address:  ",
                    style: Theme.of(context).textTheme.titleSmall,
                    children: [
                      TextSpan(
                          text: droppOffAddress,
                          style: Theme.of(context).textTheme.bodySmall)
                    ]),
              ),
            ],
          ))
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Order For Others",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  // 0996635512
                  Stepper(
                      controlsBuilder: ((context, details) {
                        if (_currentStep == 0) {
                          return Row(
                            children: [
                              ElevatedButton(
                                  onPressed: details.onStepContinue,
                                  child: Text(
                                    "Next",
                                    style: TextStyle(color: Colors.black),
                                  )),
                              TextButton(
                                  onPressed: details.onStepCancel,
                                  child: Text("Back"))
                            ],
                          );
                        }
                        if (_currentStep == 2) {
                          return Row(
                            children: [
                              ElevatedButton(
                                  onPressed: driverId != null
                                      ? details.onStepContinue
                                      : null,
                                  child: Text(
                                    "Next",
                                    style: TextStyle(color: Colors.black),
                                  )),
                              TextButton(
                                  onPressed: details.onStepCancel,
                                  child: Text("Back"))
                            ],
                          );
                        } else if (_currentStep == 1) {
                          return Row(
                            children: [
                              ElevatedButton(
                                  onPressed: _droppOffPlaceDetail == null ||
                                          _pickUpPlaceDetail == null
                                      ? null
                                      : () {
                                          BlocProvider.of<DirectionBloc>(
                                                  context)
                                              .add(DirectionLoad(
                                                  destination: droppOffLatLng));
                                          details.onStepContinue!();
                                        },
                                  child: Text(
                                    "Next",
                                    style: TextStyle(color: Colors.black),
                                  )),
                              TextButton(
                                  onPressed: details.onStepCancel,
                                  child: Text("Back"))
                            ],
                          );
                        } else {
                          return BlocBuilder<DriverBloc, DriverState>(
                              builder: (_, state) {
                            print(state);
                            if (state is DriverLoadSuccess) {
                              return Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            RideRequestEvent event =
                                                RideRequestOrderForOther(
                                                    RideRequest(
                                                        driverFcm:
                                                            state.driver.fcmId,
                                                        pickUpAddress:
                                                            pickupAddress!,
                                                        droppOffAddress:
                                                            droppOffAddress!,
                                                        pickupLocation:
                                                            pickupLatLng,
                                                        dropOffLocation:
                                                            dropOffLatLng,
                                                        passengerPhoneNumber:
                                                            number));
                                            BlocProvider.of<RideRequestBloc>(
                                                    context)
                                                .add(event);
                                            // NotificationRequestEvent event =
                                            //     NotificationRequestSend(
                                            //         NotificationRequest(
                                            //             requestId: "d",
                                            //             pickupAddress:
                                            //                 pickupAddress!,
                                            //             dropOffAddress:
                                            //                 droppOffAddress!,
                                            //             passengerName: "name!",
                                            //             pickupLocation:
                                            //                 pickupLatLng,
                                            //             fcmToken:
                                            //                 state.driver.fcmId));
                                            // BlocProvider.of<
                                            //             NotificationRequestBloc>(
                                            //         context)
                                            //     .add(event);
                                            // Navigator.pop(context);
                                            // geofireListener();
                                          },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Confirm",
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: _isLoading
                                              ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              : Container(),
                                        )
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: details.onStepCancel,
                                      child: const Text("Back"))
                                ],
                              );
                            }
                            return Container();
                          });
                        }
                      }),
                      onStepContinue: () {
                        final isLastStep = _currentStep == steps.length - 1;
                        if (isLastStep) {
                          print("Steps Completed");
                        } else {
                          setState(() => _currentStep += 1);
                        }
                      },
                      onStepCancel: _currentStep == 0
                          ? null
                          : () {
                              setState(() => _currentStep -= 1);
                            },
                      currentStep: _currentStep,
                      steps: steps),
                ],
              ),
            ),
            CustomeBackArrow(),
            BlocConsumer<DirectionBloc, DirectionState>(
                builder: (context, state) => Container(),
                listener: (context, state) {
                  if (state is DirectionLoadSuccess) {
                    double timeTraveledFare =
                        (state.direction.durationValue / 60) * 0.20;
                    double distanceTraveldFare =
                        (state.direction.distanceValue / 100) * 0.20;
                    double totalFareAmount =
                        timeTraveledFare + distanceTraveldFare;

                    double localFareAmount = totalFareAmount * 1;
                    price = (localFareAmount * 1).truncate().toString();
                    distance = (state.direction.distanceValue / 1000)
                        .truncate()
                        .toString();
                    duration = ((state.direction.durationValue / 60) * 1)
                        .truncate()
                        .toString();
                  }
                }),
            BlocConsumer<PlaceDetailBloc, PlaceDetailState>(
              listener: (_, state) {
                if (state is PlaceDetailLoadSuccess) {
                  print("Yeah Yeah it's succesfull");

                  if (selected == 0) {
                    print("Pickup Selected");
                    setState(() {
                      pickupAddress = state.placeDetail.placeName;
                      _pickUpPlaceDetail = state.placeDetail;
                      pickupLatLng =
                          LatLng(state.placeDetail.lat, state.placeDetail.lng);
                    });
                  } else if (selected == 1) {
                    print("drop Of Selected");
                    setState(() {
                      droppOffAddress = state.placeDetail.placeName;
                      _droppOffPlaceDetail = state.placeDetail;
                      droppOffLatLng =
                          LatLng(state.placeDetail.lat, state.placeDetail.lng);
                      dropOffLatLng =
                          LatLng(state.placeDetail.lat, state.placeDetail.lng);
                    });
                  }
                }
              },
              builder: (_, state) {
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPredictedItem(LocationPrediction prediction, con) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          getPlaceDetail(prediction.placeId);
          // settingDropOffDialog(con);
          // LocationHistoryEvent event = LocationHistoryAdd(location: prediction);
          // BlocProvider.of<LocationHistoryBloc>(context).add(event);
        },
        child: Container(
          color: Colors.black.withOpacity(0),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 12,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(prediction.mainText),
            ],
          ),
        ),
      ),
    );
  }

  void findPlace(String placeName) {
    if (placeName.isNotEmpty) {
      LocationPredictionEvent event =
          LocationPredictionLoad(placeName: placeName);
      BlocProvider.of<LocationPredictionBloc>(context).add(event);
    }
  }

  void getPlaceDetail(String placeId) {
    PlaceDetailEvent event = PlaceDetailLoad(placeId: placeId);
    BlocProvider.of<PlaceDetailBloc>(context).add(event);
  }

  void geofireListener() async {
    Geofire.stopListener();
    final loc = await Geolocator.getCurrentPosition();
    final data = await Geofire.queryAtLocation(loc.latitude, loc.longitude, 1)!
        .elementAt(0);

    String driver = data['key'];
    nextDrivers = [];

    print("Hey yow ${data}");
    setState(() {
      driverId = driver.split(',')[0];
    });

    DriverEvent event = DriverLoad(driver.split(',')[0]);
    BlocProvider.of<DriverBloc>(context).add(event);
  }
}
