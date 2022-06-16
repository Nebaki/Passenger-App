// import 'package:flutter/material.dart';
// import 'package:passengerapp/rout.dart';
// import 'package:passengerapp/screens/screens.dart';

// class CancelTrip extends StatelessWidget {
//   Function? callback;
//   Widget? lastWidget;
//   CancelTrip(this.callback, this.lastWidget);
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       bottom: 0,
//       child: Container(
//         padding:
//             const EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
//         height: 250,
//         color: Colors.white,
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Text(
//               "Cancel Your Trip?",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
//             ),
//             SizedBox(
//               height: 60,
//               width: MediaQuery.of(context).size.width,
//               child: ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all<Color>(
//                         Colors.redAccent.shade700),
//                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     )),
//                   ),
//                   onPressed: () {
//                     Navigator.pushNamed(context, CancelReason.routeName,
//                         arguments: CancelReasonArgument(sendRequest: true));
//                   },
//                   child: const Text(
//                     "Yes, Cancel",
//                     style: TextStyle(color: Colors.white),
//                   )),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             SizedBox(
//                 height: 60,
//                 width: MediaQuery.of(context).size.width,
//                 child: ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor:
//                           MaterialStateProperty.all<Color>(Colors.green),
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       )),
//                     ),
//                     onPressed: () {
//                       Widget _widget = lastWidget!;
//                       callback!(_widget);
//                     },
//                     child: const Text(
//                       "No",
//                       style: TextStyle(color: Colors.white),
//                     )))
//           ],
//         ),
//       ),
//     );
//   }
// }
