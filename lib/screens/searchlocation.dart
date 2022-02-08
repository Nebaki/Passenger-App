import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/prediction/bloc.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/searchlocation";
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _whereToController = TextEditingController();
  final _pickupLocationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Card(
                color: Colors.white,
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            isCollapsed: false,
                            isDense: true,
                            hintText: "Pickup Location",
                            focusColor: Colors.blue,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 0.6, color: Colors.orange)),
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                            prefixIcon: Icon(
                              Icons.location_on_outlined,
                              color: Colors.blue,
                              size: 19,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                //borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: Colors.grey, width: 0.4))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field can\'t be empity';
                          } else if (value.length < 4) {
                            return 'Name length must not be less than 4';
                          } else if (value.length > 25) {
                            return 'Nameength must not be Longer than 25';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _whereToController,
                        decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            isCollapsed: false,
                            isDense: true,
                            hintText: "Where To?",
                            focusColor: Colors.blue,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 0.6, color: Colors.orange)),
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                            prefixIcon: Icon(
                              Icons.location_on_outlined,
                              color: Colors.blue,
                              size: 19,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                //borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: Colors.grey, width: 0.4))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field can\'t be empity';
                          } else if (value.length < 4) {
                            return 'Name length must not be less than 4';
                          } else if (value.length > 25) {
                            return 'Nameength must not be Longer than 25';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                        onChanged: (value) {
                          findPlace(value);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, HomeScreen.routeName,
                                arguments:
                                    HomeScreenArgument(isSelected: true));
                          },
                          child: const Text("Continue"))
                    ],
                  ),
                ),
              ),
              BlocBuilder<LocationPredictionBloc, LocationPredictionState>(
                  builder: (context, state) {
                if (state is LocationPredictionLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is LocationPredictionLoadSuccess) {
                  print("Successssssssssssssssssssssssss");
                  print(state.placeList);
                  return SizedBox(
                    height: 400,
                    child: ListView.separated(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return _buildPredictedItem(state.placeList[index]);
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: state.placeList.length),
                  );
                }

                if (state is LocationPredictionOperationFailure) {}
                return Container();
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPredictedItem(LocationPrediction prediction) {
    return ListTile(
      title: Text(prediction.mainText),
      subtitle: Text(prediction.secondaryText),
      leading: const Icon(Icons.location_off_outlined),
    );
  }

  void findPlace(String placeName) {
    if (placeName.isNotEmpty) {
      print("YAYAYAY");
      LocationPredictionEvent event =
          LocationPredictionLoad(placeName: placeName);
      BlocProvider.of<LocationPredictionBloc>(context).add(event);
    }
  }
}


 // BlocBuilder<LocationPredictionBloc, LocationPredictionState>(
              //     builder: (context, state) {
              //   if (state is LocationPredictionLoading) {
              //     return const Center(
              //       child: CircularProgressIndicator(),
              //     );
              //   }
              //   if (state is LocationPredictionLoadSuccess) {
              //     SizedBox(
              //       height: 400,
              //       child: ListView.separated(
              //           physics: const ClampingScrollPhysics(),
              //           shrinkWrap: true,
              //           itemBuilder: (context, index) {
              //             return _buildPredictedItem(state.placeList[index]);
              //           },
              //           separatorBuilder: (context, index) => const Divider(),
              //           itemCount: state.placeList.length),
              //     );
              //   }

              //   if (state is LocationPredictionOperationFailure) {}
              //   return Container();
              // })