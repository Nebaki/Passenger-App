import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/widgets.dart';

class SigninScreen extends StatefulWidget {
  static const routeName = '/signin';
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  String number = "+251934540217";
  String password = "1111";
  late String phoneNumber;
  late String pass;

  // late Timer _timer;
  // late Timer _waitingTimer;
  // int _waitingDuration = 60;

  // int _start = 60;
  // int _attemptCounter = 0;

  // void startTimer() {
  //   const oneSec = Duration(seconds: 1);
  //   _timer = Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       if (_start == 0) {
  //         setState(() {
  //           timer.cancel();
  //         });
  //       } else {
  //         setState(() {
  //           _start--;
  //         });
  //       }
  //     },
  //   );
  // }

  // void startWaitingTimer() {
  //   const oneSec = Duration(seconds: 1);
  //   _waitingTimer = Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       if (_waitingDuration == 1) {
  //         setState(() {
  //           timer.cancel();
  //         });
  //       } else {
  //         setState(() {
  //           _waitingDuration--;
  //         });
  //       }
  //     },
  //   );
  // }

  final _formkey = GlobalKey<FormState>();
  final _errorSnackbar = const SnackBar(
    content: Text("Incorrect username or password"),
    backgroundColor: Colors.red,
  );

  // final _attemptSnackbar = const SnackBar(content: Text("Too many Attempts"));

  // @override
  // void dispose() {
  //   _timer.cancel();
  //   _waitingTimer.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        // CustomeBackArrow(),
        Form(
          key: _formkey,
          child: Container(
            height: 600,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: ListView(
                children: [
                  const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 25),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: InternationalPhoneNumberInput(
                      onSaved: (value) {
                        phoneNumber = value.toString();
                      },
                      onInputChanged: (PhoneNumber number) {
                        print(number.phoneNumber);
                      },
                      onInputValidated: (bool value) {
                        print(value);
                      },
                      selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          trailingSpace: false),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      initialValue: PhoneNumber(isoCode: "ET"),
                      formatInput: true,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      spaceBetweenSelectorAndTextField: 0,
                      inputDecoration: const InputDecoration(
                          hintText: "Phone Number",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black45),
                          fillColor: Colors.white,
                          filled: true,
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          hintText: "Password",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black45),
                          prefixIcon: Icon(
                            Icons.vpn_key,
                            size: 19,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Your Password';
                        } else if (value.length < 4) {
                          return 'Password length must not be less than 4';
                        } else if (value.length > 25) {
                          return 'Password length must not be greater than 25';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        pass = value!;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          final form = _formkey.currentState;
                          // print(_attemptCounter);
                          // print(_waitingDuration);
                          if (form!.validate()) {
                            form.save();
                            Navigator.pushNamed(context, HomeScreen.routeName,
                                arguments:
                                    HomeScreenArgument(isSelected: false));
                          }

                          // print("Hereeeeeeeeeeeeeeeeeee");
                          // if (_attemptCounter == 3) {
                          //   startWaitingTimer();
                          // }
                          // if (_attemptCounter < 3 && _waitingDuration == 60) {
                          //   if (form!.validate()) {
                          //     form.save();
                          //     if (phoneNumber != number && pass != password) {
                          //       print("Errorrrrrrrrrrrrrrrrrrrrrr");
                          //       startTimer();

                          //       print(_start);

                          //       // ScaffoldMessenger.of(context)
                          //       //     .showSnackBar(_errorSnackbar);
                          //       if (_start != 0) {
                          //         setState(() {
                          //           _attemptCounter++;
                          //         });
                          //       } else {
                          //         setState(() {
                          //           _attemptCounter = 0;
                          //         });
                          //       }
                          //     } else {
                          //       print("Corecttttttttttttttttttttttttttt");
                          //       setState(() {
                          //         _timer.cancel();
                          //       });
                          //     }
                          //     // print("Starting from herer");
                          //     // print(pass);
                          //     // print(phoneNumber);

                          //   }
                          // } else {
                          //   print(_waitingDuration);
                          //   if (_waitingDuration == 1) {
                          //     setState(() {
                          //       _waitingTimer.cancel();
                          //       _attemptCounter = 0;
                          //       //_waitingDuration = 60;
                          //       _timer.cancel();
                          //       _start = 60;
                          //     });
                          //     print("Yesss");
                          //   }
                          //   print(_attemptCounter);
                          //   print(_waitingDuration);
                          //   print("Too many trieal");
                          //   // ScaffoldMessenger.of(context)
                          //   //     .showSnackBar(_attemptSnackbar);
                          // }
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, MobileVerification.routeName);
                          },
                          child: const Text(
                            "Forgot Password",
                            style: TextStyle(
                                color: Color.fromRGBO(39, 49, 110, 1),
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("don't have an account? ",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54)),
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, SignupScreen.routeName);
                            },
                            child: const Text(
                              "SIGN UP",
                              style: TextStyle(
                                  color: Color.fromRGBO(39, 49, 110, 1),
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
