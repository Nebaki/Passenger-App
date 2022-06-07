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
import 'package:passengerapp/screens/home/assistant/home_screen_assistant.dart';
import 'package:passengerapp/widgets/custome_back_arrow.dart';
import 'package:passengerapp/widgets/widgets.dart';

import '../../models/models.dart';

class OrderForOtherScreen extends StatefulWidget {
  static const routeName = "/orderforothers";

  @override
  _OrderForOtherScreenState createState() => _OrderForOtherScreenState();
}

class _OrderForOtherScreenState extends State<OrderForOtherScreen> {
  int _currentStep = 0;
  int selected = -1;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  FocusNode pickupLocationNode = FocusNode();
  FocusNode droppOffLocationNode = FocusNode();
  final pickupController = TextEditingController();
  final droppOffController = TextEditingController();
  bool pickupSetted = false;
  bool droppOffSetted = false;

  late LatLng destinationLtlng;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pickupLocationNode.dispose();
    droppOffLocationNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
          isActive: _currentStep >= 0,
          title: const Text("Passenger Information"),
          content: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: InternationalPhoneNumberInput(
                    onSaved: (value) {
                      number = value.phoneNumber!;
                    },
                    inputDecoration: const InputDecoration(
                      hintText: "Phone Number of the passenger",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w300, color: Colors.black45),
                    ),
                    onInputChanged: (PhoneNumber phoneNum) {},
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
              SizedBox(
                height: 60,
                child: TextFormField(
                  onChanged: (value) {
                    findPlace(value);
                  },
                  focusNode: pickupLocationNode,
                  controller: pickupController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          pickupController.clear();
                          debugPrint("TATAT");
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.black,
                          size: 15,
                        )),
                    hintText: "PickUp Address",
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 20, right: 10),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                focusNode: droppOffLocationNode,
                controller: droppOffController,
                onChanged: (value) {
                  findPlace(value);
                },
                decoration: const InputDecoration(
                  hintText: "DropOff Address",
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 20, right: 10),
                    child: Icon(Icons.location_on, color: Colors.green),
                  ),
                ),
              ),
              BlocBuilder<LocationPredictionBloc, LocationPredictionState>(
                  builder: (context, state) {
                if (state is LocationPredictionLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is LocationPredictionLoadSuccess) {
                  return Container(
                    padding: const EdgeInsets.only(top: 30, bottom: 22),
                    // height: 200,
                    constraints:
                        const BoxConstraints(maxHeight: 400, minHeight: 30),
                    width: double.infinity,
                    child: ListView.separated(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return _buildPredictedItem(state.placeList[index]);
                        },
                        separatorBuilder: (context, index) => const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Divider(color: Colors.black38),
                            ),
                        itemCount: state.placeList.length),
                  );
                }

                if (state is LocationPredictionOperationFailure) {}

                return const Center(
                  child: Text("Enter The location"),
                );
              }),
            ],
          )),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 100,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
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
                      physics: ScrollPhysics(parent: ClampingScrollPhysics()),
                      controlsBuilder: ((context, details) {
                        if (_currentStep == 0) {
                          return Row(
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    final form = _formKey.currentState;
                                    if (form!.validate()) {
                                      form.save();
                                      details.onStepContinue!();
                                    }
                                  },
                                  child: const Text(
                                    "Next",
                                    style: TextStyle(color: Colors.black),
                                  )),
                              TextButton(
                                  onPressed: details.onStepCancel,
                                  child: const Text("Back"))
                            ],
                          );
                        } else if (_currentStep == 1) {
                          return Row(
                            children: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        // MaterialStateProperty.all<Color>(
                                        //     Colors.black),
                                        MaterialStateProperty.resolveWith<
                                                Color?>(
                                            (Set<MaterialState> state) =>
                                                state.contains(
                                                        MaterialState.disabled)
                                                    ? Colors.grey
                                                    : null),
                                  ),
                                  onPressed: pickupSetted && droppOffSetted
                                      ? () {
                                          DirectionEvent event =
                                              DirectionLoadFromDiffrentPickupLocation(
                                                  pickup: pickupLatLng,
                                                  destination:
                                                      destinationLtlng);
                                          BlocProvider.of<DirectionBloc>(
                                                  context)
                                              .add(event);

                                          context
                                              .read<CurrentWidgetCubit>()
                                              .changeWidget(
                                                  Service(false, true));

                                          Navigator.pop(context);
                                        }
                                      : null,
                                  child: const Text(
                                    "Next",
                                    style: TextStyle(color: Colors.black),
                                  )),
                              TextButton(
                                  onPressed: details.onStepCancel,
                                  child: Text("Back"))
                            ],
                          );
                        } else {
                          return Container();
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
          ],
        ),
      ),
    );
  }

  Widget _buildPredictedItem(LocationPrediction prediction) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          if (droppOffLocationNode.hasFocus) {
            FocusScope.of(context).requestFocus(pickupLocationNode);

            getPlaceDetail(prediction.placeId);

            settingDropOffDialog();
            droppOffController.text = prediction.mainText;
          } else if (pickupLocationNode.hasFocus) {
            FocusScope.of(context).requestFocus(droppOffLocationNode);

            getPlaceDetail(prediction.placeId);
            settingPickupDialog();

            pickupController.text = prediction.mainText;

            pickupAddress = prediction.mainText;
          }
        },
        child: Container(
          color: Colors.black.withOpacity(0),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              const Flexible(
                flex: 1,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 12,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(flex: 5, child: Text(prediction.mainText)),
            ],
          ),
        ),
      ),
    );
  }

  void getPlaceDetail(String placeId) {
    PlaceDetailEvent event = PlaceDetailLoad(placeId: placeId);
    BlocProvider.of<PlaceDetailBloc>(context).add(event);
  }

  void settingPickupDialog() {
    showDialog(
        context: context,
        builder: (BuildContext cont) {
          return BlocBuilder<PlaceDetailBloc, PlaceDetailState>(
              builder: (context, state) {
            if (state is PlaceDetailLoadSuccess) {
              // FocusScope.of(context).requestFocus(droppOffLocationNode);
              WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                setState(() {
                  pickupSetted = true;
                });
              });

              pickupAddress = state.placeDetail.placeName;
              pickupLatLng =
                  LatLng(state.placeDetail.lat, state.placeDetail.lng);
              Navigator.pop(context);
            }

            if (state is PlaceDetailOperationFailure) {
              WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red.shade900,
                    content: const Text("Unable To set the Pickup.")));
              });
              _changePlaceDetailBlocToInitialState();
            }
            return AlertDialog(
              content: Row(
                children: const [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Setting up Pickup. Please wait.."),
                ],
              ),
            );
          });
        });
  }

  void _changePlaceDetailBlocToInitialState() {
    context
        .read<LocationPredictionBloc>()
        .add(LocationPredicationChangeToInitalState());
  }

  void settingDropOffDialog() {
    showDialog(
        context: context,
        builder: (BuildContext cont) {
          return BlocBuilder<PlaceDetailBloc, PlaceDetailState>(
              builder: (context, state) {
            if (state is PlaceDetailLoadSuccess) {
              WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                setState(() {
                  droppOffSetted = true;
                });
              });

              droppOffLocationNode.nextFocus();

              droppOffAddress = state.placeDetail.placeName;
              // widget.setDroppOffAdress(state.placeDetail.placeName);

              destinationLtlng =
                  LatLng(state.placeDetail.lat, state.placeDetail.lng);
              droppOffLatLng = destinationLtlng;

              WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                droppOffLatLng = destinationLtlng;

                Navigator.pop(context);
              });
              _changePlaceDetailBlocToInitialState();
            }

            if (state is PlaceDetailOperationFailure) {
              WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red.shade900,
                    content: const Text("Unable To set the Dropoff.")));
              });
            }
            return AlertDialog(
              content: Row(
                children: const [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Setting up Drop Off. Please wait.."),
                ],
              ),
            );
          });
        });
  }

  void findPlace(String placeName) {
    if (placeName.isNotEmpty) {
      LocationPredictionEvent event =
          LocationPredictionLoad(placeName: placeName);
      BlocProvider.of<LocationPredictionBloc>(context).add(event);
    }
  }
}
