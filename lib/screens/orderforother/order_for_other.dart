import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/repository/nearby_driver.dart';
import 'package:passengerapp/widgets/widgets.dart';
import '../../localization/localization.dart';
import '../../models/models.dart';
import '../../utils/session.dart';
import '../../utils/waver.dart';

class OrderForOtherScreen extends StatefulWidget {
  static const routeName = "/orderforothers";

  const OrderForOtherScreen({Key? key}) : super(key: key);

  @override
  _OrderForOtherScreenState createState() => _OrderForOtherScreenState();
}

class _OrderForOtherScreenState extends State<OrderForOtherScreen> {
  int _currentStep = 0;
  int selected = -1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode pickupLocationNode = FocusNode();
  FocusNode droppOffLocationNode = FocusNode();
  final pickupController = TextEditingController();
  final droppOffController = TextEditingController();
  bool pickupSetted = false;
  bool droppOffSetted = false;

  late LatLng destinationLtlng;
  @override
  void initState() {
    // pickupLatLng = LatLng(userPostion.latitude, userPostion.longitude);
    super.initState();
  }

  @override
  void dispose() {
    pickupLocationNode.dispose();
    droppOffLocationNode.dispose();
    super.dispose();
  }
  final _appBar = GlobalKey<FormState>();

  var textLength = 0;
  var phoneEnabled = true;
  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
          isActive: _currentStep >= 0,
          title: Text(getTranslation(context, "passenger_information")),
          content: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Padding(
                      padding:
                      const EdgeInsets.only(left: 5, right: 3, top: 0,bottom: 15),
                      child: TextFormField(
                        autofocus: true,
                        maxLength: 9,
                        maxLines: 1,
                        cursorColor: Theme.of(context).primaryColor,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        style: const TextStyle(fontSize: 18),
                        enabled: phoneEnabled,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                          counterText: "",/*
                          prefixIconConstraints:
                          const BoxConstraints(minWidth: 0, minHeight: 0),*/
                          alignLabelWithHint: true,
                          //hintText: "Phone number",
                          labelText: Localization.of(context)
                              .getTranslation("phone_number"),/*
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black45),*/
                         /* prefixIcon: Text(
                              "+251",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),*/
                          prefixText: "+251",
                          suffix: Text("$textLength/9"),
                          fillColor: Colors.white,
                          filled: true,
                          isDense: true,
                          contentPadding: const EdgeInsets.fromLTRB(12, 20, 15, 15),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.solid)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Localization.of(context)
                                .getTranslation("passenger_phone_number");
                          } else if (value.length < 9) {
                            return Localization.of(context)
                                .getTranslation("phone_number_short");
                          } else if (value.length > 9) {
                            return Localization.of(context)
                                .getTranslation("phone_number_exceed");
                          } else if (value.length == 9) {
                            return null;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.length >= 9) {}
                          setState(() {
                            textLength = value.length;
                          });
                        },
                        onSaved: (value) {
                          number = "+251$value";
                          Session().logSuccess("for-other", number);
                        },
                      ),
                    ),
              ],
            ),
          )),
      Step(
          isActive: _currentStep >= 1,
          title: Text(getTranslation(context, "location")),
          content: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                style: const TextStyle(fontSize: 18),
                  onChanged: (value) {
                    if(value.length >= 2){
                      findPlace(value);
                    }
                  },
                  focusNode: pickupLocationNode,
                  controller: pickupController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          pickupController.clear();
                          setState((){
                            pickupSetted = false;
                          });
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.black,
                          size: 15,
                        )),
                    labelText:
                        getTranslation(context, "pickup_address_hint_text"),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 20, right: 10),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.blue,
                      ),
                    ),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(style: BorderStyle.solid)),
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                style: const TextStyle(fontSize: 18),
                focusNode: droppOffLocationNode,
                controller: droppOffController,
                onChanged: (value) {
                  if(value.length >= 2){
                    findPlace(value);
                  }
                },
                decoration: InputDecoration(
                  labelText:
                      getTranslation(context, "droppoff_address_hint_text"),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 20, right: 10),
                    child: Icon(Icons.location_on, color: Colors.green),
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        droppOffController.clear();
                        setState((){
                          droppOffSetted = false;
                        });
                      },
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.black,
                        size: 15,
                      )),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.solid)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              BlocBuilder<LocationPredictionBloc, LocationPredictionState>(
                  builder: (context, state) {
                if (state is LocationPredictionLoading) {
                  //return const Center(child: CircularProgressIndicator());
                  return Container();
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
                  child: Text(""),
                );
              }),
            ],
          )),
    ];

    return Scaffold(
      appBar: SafeAppBar(
          key: _appBar, title: getTranslation(context, "order_for_other"),
          appBar: AppBar(), widgets: []),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 0,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Stepper(
                      physics:
                          const ScrollPhysics(parent: ClampingScrollPhysics()),
                      controlsBuilder: ((context, details) {
                        if (_currentStep == 0) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  onPressed: () {
                                    final form = _formKey.currentState;
                                    if (form!.validate()) {
                                      form.save();
                                      details.onStepContinue!();
                                    }
                                  },
                                  child: Text(
                                    getTranslation(context, "next"),
                                    //style: const TextStyle(color: Colors.black),
                                  )),
                            ),
                          );
                          /*return Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: SizedBox(
                                  height: 50,
                                  //width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        final form = _formKey.currentState;
                                        if (form!.validate()) {
                                          form.save();
                                          details.onStepContinue!();
                                        }
                                      },
                                      child: Text(
                                        getTranslation(context, "next"),
                                        //style: const TextStyle(color: Colors.black),
                                      )),
                                ),
                              ),
                              TextButton(
                                  onPressed: details.onStepCancel,
                                  child: Text(getTranslation(context, "back")))

                            ],
                          )*/;
                        } else if (_currentStep == 1) {
                          return Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.5),
                                child: SizedBox(
                                  height:50,
                                  width: MediaQuery.of(context).size.width * 0.38,
                                  child: TextButton(
                                      onPressed: details.onStepCancel,
                                      child: Text(getTranslation(context, "back"))),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.5),
                                child: SizedBox(
                              height:50,
                                  width: MediaQuery.of(context).size.width * 0.39,
                                  child: ElevatedButton(
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
                                              Geofire.stopListener().then((value) {
                                                NearbyDriverRepository()
                                                    .resetList();
                                                Geofire.queryAtLocation(
                                                    pickupLatLng.latitude,
                                                    pickupLatLng.longitude,
                                                    1);
                                              });
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
                                                      const Service(false, true));

                                              Navigator.pop(context);
                                            }
                                          : null,
                                      child: Text(
                                        getTranslation(context, "next"),
                                        //style: const TextStyle(color: Colors.black),
                                      )),
                                ),
                              )
                            ],
                          );
                        } else {
                          return Container();
                        }
                      }),
                      onStepContinue: () {
                        final isLastStep = _currentStep == steps.length - 1;
                        if (isLastStep) {
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictedItem(LocationPrediction prediction) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {
          if (droppOffLocationNode.hasFocus) {
            FocusScope.of(context).requestFocus(pickupLocationNode);

            getPlaceDetail(prediction.placeId);

            //_settingDropOff();
            settingDropOffDialog();
            droppOffController.text = prediction.mainText;
          } else if (pickupLocationNode.hasFocus) {
            FocusScope.of(context).requestFocus(droppOffLocationNode);

            getPlaceDetail(prediction.placeId);
            //_settingPickup();
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
              Flexible(flex: 5, child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(prediction.mainText),
              )),
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

  _settingPickup(){
    BlocBuilder<PlaceDetailBloc, PlaceDetailState>(
        builder: (context, state) {
          if (state is PlaceDetailLoadSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                pickupSetted = true;
              });
            });

            pickupAddress = state.placeDetail.placeName;
            pickupLatLng =
                LatLng(state.placeDetail.lat, state.placeDetail.lng);
          }

          if (state is PlaceDetailOperationFailure) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red.shade900,
                  content: Text(getTranslation(
                      context, "settingup_pickup_failure_message"))));
            });
            _changePlaceDetailBlocToInitialState();
          }
          return Container();
        });
  }
  void settingPickupDialog() {
    showDialog(
        context: context,
        builder: (BuildContext cont) {
          return BlocBuilder<PlaceDetailBloc, PlaceDetailState>(
              builder: (context, state) {
            if (state is PlaceDetailLoadSuccess) {
              // FocusScope.of(context).requestFocus(droppOffLocationNode);
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red.shade900,
                    content: Text(getTranslation(
                        context, "settingup_pickup_failure_message"))));
              });
              _changePlaceDetailBlocToInitialState();
            }
            return AlertDialog(
              content: Row(
                children: [
                  const Flexible(
                    flex: 1,
                    child:  SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  
                  Flexible(flex: 5, child: Text(getTranslation(context, "settingup_pickup_message"),)),
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
  _settingDropOff(){
    BlocBuilder<PlaceDetailBloc, PlaceDetailState>(
        builder: (context, state) {
          if (state is PlaceDetailLoadSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                droppOffSetted = true;
              });
            });

            droppOffLocationNode.nextFocus();
            droppOffAddress = state.placeDetail.placeName;
            destinationLtlng =
                LatLng(state.placeDetail.lat, state.placeDetail.lng);
            droppOffLatLng = destinationLtlng;

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              droppOffLatLng = destinationLtlng;
            });
            _changePlaceDetailBlocToInitialState();
          }

          if (state is PlaceDetailOperationFailure) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red.shade900,
                  content: Text(getTranslation(
                      context, "settingup_dropp_off_failure_message"))));
            });
          }
          return Container();
        });
  }
  void settingDropOffDialog() {
    showDialog(
        context: context,
        builder: (BuildContext cont) {
          return BlocBuilder<PlaceDetailBloc, PlaceDetailState>(
              builder: (context, state) {
            if (state is PlaceDetailLoadSuccess) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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

              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                droppOffLatLng = destinationLtlng;

                Navigator.pop(context);
              });
              _changePlaceDetailBlocToInitialState();
            }

            if (state is PlaceDetailOperationFailure) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red.shade900,
                    content: Text(getTranslation(
                        context, "settingup_dropp_off_failure_message"))));
              });
            }
            return AlertDialog(
              content: Row(
                children: [
                  const Flexible(
                    flex: 1,
                    child:  SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    ),
                  ),
               
                  Flexible(flex: 5, child: Text(getTranslation(context, "settingup_dropp_off_message"))),
                ],
              ),
            );
          });
        });
  }

  void findPlace(String placeName) {
    if (placeName.length>=2) {
      LocationPredictionEvent event =
          LocationPredictionLoad(placeName: placeName);
      BlocProvider.of<LocationPredictionBloc>(context).add(event);
    }
  }
}
