// import 'package:flutter/material.dart';
// import 'package:passengerapp/widgets/widgets.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// class NearbyTaxy extends StatefulWidget {
//   Function? callback;

//   NearbyTaxy(this.callback);

//   @override
//   _NearbyTaxyState createState() => _NearbyTaxyState();
// }

// class _NearbyTaxyState extends State<NearbyTaxy> {
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       bottom: 3.0,
//       left: 8.0,
//       right: 8.0,
//       child: Column(
//         children: [
//           Container(
//               height: 310,
//               padding: EdgeInsets.only(left: 10, right: 20, bottom: 0),
//               decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.75),
//                   borderRadius: BorderRadius.circular(20)),
//               child: Column(
//                 children: [
//                   CarouselSlider(
//                       items: List.generate(10, (index) => nearbyTaxies()),
//                       options: CarouselOptions(
//                         viewportFraction: 0.6,
//                         aspectRatio: 2.0,
//                         autoPlay: true,
//                         enlargeCenterPage: true,
//                       )),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
//                     child: CarDetail(),
//                   )
//                 ],
//               )),
//           const SizedBox(
//             height: 15,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: SizedBox(
//                 height: 65,
//                 width: MediaQuery.of(context).size.width,
//                 child: ElevatedButton(
//                     style: ButtonStyle(
//                         shape:
//                             MaterialStateProperty.all<RoundedRectangleBorder>(
//                                 RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(20)))),
//                     onPressed: () {
//                       this.widget.callback!(Driver(this.widget.callback));
//                     },
//                     child: const Text("Confirm"))),
//           ),
//           SizedBox(
//             height: 15,
//           )
//         ],
//       ),
//     );
//   }

//   Widget nearbyTaxies() {
//     return Center(
//         child: Container(
//       height: 150,
//       width: 200,
//       color: Colors.orange,
//       child: Center(
//         child: Text(
//           "Car Logo",
//         ),
//       ),
//     ));
//   }
// }


// // SingleChildScrollView(
// //                 scrollDirection: Axis.horizontal,
// //                 child: Container(
// //                   child: Row(
// //                     children: List.generate(20, (index) {
// //                       return nearbyTaxies();
// //                     }),
// //                   ),
// //                 ),
// //               )