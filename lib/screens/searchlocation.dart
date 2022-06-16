// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:passengerapp/bloc/bloc.dart';
// import 'package:passengerapp/models/models.dart';
// import 'package:passengerapp/rout.dart';
// import 'package:passengerapp/screens/screens.dart';

// class SearchScreen extends StatefulWidget {
//   static const routeName = "/searchlocation";

//   final SearchScreenArgument args;

//   SearchScreen({Key? key, required this.args}) : super(key: key);
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final _whereToController = TextEditingController();
//   final _pickupLocationController = TextEditingController();
//   late LatLng destinationLtlng;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height,
//           child: Column(
//             children: [
//               Card(
//                 margin: const EdgeInsets.fromLTRB(10, 40, 10, 20),
//                 color: Colors.white,
//                 child: Form(
//                   child: Container(
//                     height: 200,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 15),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Search Location",
//                           style: TextStyle(
//                               fontSize: 25,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.red.shade900),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         TextFormField(
//                           initialValue: widget.args.currentLocation,
//                           decoration: const InputDecoration(
//                               alignLabelWithHint: true,
//                               floatingLabelBehavior:
//                                   FloatingLabelBehavior.always,
//                               isCollapsed: false,
//                               isDense: true,
//                               hintText: "Pickup Location",
//                               focusColor: Colors.blue,
//                               focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       width: 0.6, color: Colors.orange)),
//                               hintStyle: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black45),
//                               prefixIcon: Icon(
//                                 Icons.location_on_outlined,
//                                 color: Colors.blue,
//                                 size: 25,
//                               ),
//                               fillColor: Colors.white,
//                               filled: true,
//                               border: OutlineInputBorder(
//                                   //borderRadius: BorderRadius.all(Radius.circular(10)),
//                                   borderSide: BorderSide(
//                                       color: Colors.grey, width: 0.4))),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         TextFormField(
//                           controller: _whereToController,
//                           decoration: const InputDecoration(
//                               alignLabelWithHint: true,
//                               floatingLabelBehavior:
//                                   FloatingLabelBehavior.always,
//                               isCollapsed: false,
//                               isDense: true,
//                               hintText: "Where To?",
//                               focusColor: Colors.blue,
//                               focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       width: 0.6, color: Colors.orange)),
//                               hintStyle: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black45),
//                               prefixIcon: Icon(
//                                 Icons.location_on_outlined,
//                                 color: Colors.green,
//                                 size: 25,
//                               ),
//                               fillColor: Colors.white,
//                               filled: true,
//                               border: OutlineInputBorder(
//                                   //borderRadius: BorderRadius.all(Radius.circular(10)),
//                                   borderSide: BorderSide(
//                                       color: Colors.grey, width: 0.4))),
//                           onChanged: (value) {
//                             findPlace(value);
//                           },
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               BlocBuilder<LocationPredictionBloc, LocationPredictionState>(
//                   builder: (context, state) {
//                 if (state is LocationPredictionLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (state is LocationPredictionLoadSuccess) {
//                   return SizedBox(
//                     height: MediaQuery.of(context).size.height - 260,
//                     child: Container(
//                       color: Colors.white,
//                       child: ListView.separated(
//                           physics: const ClampingScrollPhysics(),
//                           shrinkWrap: true,
//                           itemBuilder: (context, index) {
//                             return _buildPredictedItem(state.placeList[index]);
//                           },
//                           separatorBuilder: (context, index) => const Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 40),
//                                 child: Divider(color: Colors.black38),
//                               ),
//                           itemCount: state.placeList.length),
//                     ),
//                   );
//                 }

//                 if (state is LocationPredictionOperationFailure) {}

//                 return const Center(
//                   child: Text("Enter The location"),
//                 );
//               })
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPredictedItem(LocationPrediction prediction) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: ListTile(
//         horizontalTitleGap: 0,
//         onTap: () {
//           getPlaceDetail(prediction.placeId);
//           settingDropOffDialog();
//         },
//         title: Text(prediction.mainText),
//         subtitle: Text(prediction.secondaryText),
//         leading: const Icon(
//           Icons.location_on_outlined,
//           color: Colors.red,
//         ),
//       ),
//     );
//   }

//   void findPlace(String placeName) {
//     if (placeName.isNotEmpty) {
//       LocationPredictionEvent event =
//           LocationPredictionLoad(placeName: placeName);
//       BlocProvider.of<LocationPredictionBloc>(context).add(event);
//     }
//   }

//   void getPlaceDetail(String placeId) {
//     PlaceDetailEvent event = PlaceDetailLoad(placeId: placeId);
//     BlocProvider.of<PlaceDetailBloc>(context).add(event);
//   }

//   void settingDropOffDialog() {
//     showDialog(
//         context: context,
//         builder: (BuildContext cont) {
//           return BlocBuilder<PlaceDetailBloc, PlaceDetailState>(
//               builder: (conext, state) {
//             if (state is PlaceDetailLoadSuccess) {
//               DirectionEvent event = DirectionLoad(
//                   destination:
//                       LatLng(state.placeDetail.lat, state.placeDetail.lng));
//               BlocProvider.of<DirectionBloc>(context).add(event);

//               destinationLtlng =
//                   LatLng(state.placeDetail.lat, state.placeDetail.lng);

//               Future.delayed(Duration(seconds: 1), () {
//                 Navigator.pop(context);

//                 return Navigator.pushNamed(context, HomeScreen.routeName,
//                     arguments: HomeScreenArgument(
//                         isFromSplash: false,
//                         isSelected: true,
//                         destinationlatlang: destinationLtlng));
//               });
//             }

//             if (state is PlaceDetailOperationFailure) {
//               // print(state);
//               // print("Errorrrrrrrrrrrrrrrrr");
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   backgroundColor: Colors.red.shade900,
//                   content: const Text("Unable To set the Dropoff.")));
//             }
//             return AlertDialog(
//               content: Row(
//                 children: const [
//                   CircularProgressIndicator(),
//                   Text("Setting up Drop Off. Please wait")
//                 ],
//               ),
//             );
//           });
//         });
//   }
// }
