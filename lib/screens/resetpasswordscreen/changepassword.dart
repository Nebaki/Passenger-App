import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:passengerapp/widgets/widgets.dart';

class ChangePassword extends StatelessWidget {
  static const routeName = '/changepassword';
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formkey,
          child: Container(
            color: const Color.fromRGBO(240, 241, 241, 1),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.12,
                  right: 10,
                  left: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Change Password",
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                            "you have to have your old password in order to change new password. lorem ipsum text to add the new."),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 4,
                                spreadRadius: 2,
                                blurStyle: BlurStyle.normal)
                          ]),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                hintText: "Old Password",
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  size: 19,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter The Old password';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 4,
                                spreadRadius: 2,
                                blurStyle: BlurStyle.normal)
                          ]),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                hintText: "New Password",
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  size: 19,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter The New Password';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 4,
                                spreadRadius: 2,
                                blurStyle: BlurStyle.normal)
                          ]),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45),
                                prefixIcon: Icon(
                                  Icons.vpn_key,
                                  size: 19,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please confirm the password';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {},
                              child: const Text("Change Password")),
                        )
                      ],
                    ),
                  ),
                ),
                CustomeBackArrow(),
              ],
            ),
          )),
    );
  }
}

// Card(
//           margin: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
//           child: Center(
//             child: Column(
//               children: [
//                 TextFormField(
//                   decoration: const InputDecoration(
//                       hintText: "Old Password",
//                       hintStyle: TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.black45),
//                       prefixIcon: Icon(
//                         Icons.phone,
//                         size: 19,
//                       ),
//                       fillColor: Colors.white,
//                       filled: true,
//                       border: OutlineInputBorder(borderSide: BorderSide.none)),
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please enter The Old password';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   decoration: const InputDecoration(
//                       hintText: "New Password",
//                       hintStyle: TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.black45),
//                       prefixIcon: Icon(
//                         Icons.phone,
//                         size: 19,
//                       ),
//                       fillColor: Colors.white,
//                       filled: true,
//                       border: OutlineInputBorder(borderSide: BorderSide.none)),
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please enter The New Password';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   decoration: const InputDecoration(
//                       hintText: "Confirm Password",
//                       hintStyle: TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.black45),
//                       prefixIcon: Icon(
//                         Icons.vpn_key,
//                         size: 19,
//                       ),
//                       fillColor: Colors.white,
//                       filled: true,
//                       border: OutlineInputBorder(borderSide: BorderSide.none)),
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please confirm the password';
//                     }
//                     return null;
//                   },
//                 ),
//                 ElevatedButton(
//                     onPressed: () {},
//                     child: const Text(
//                       "Change Password",
//                       style: TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.normal),
//                     ))
//               ],
//             ),
//           ),
//         ),
