import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/widgets.dart';

class PhoneVerification extends StatefulWidget {
  static const routeName = '/phoneverification';
  VerificationArgument args;

  PhoneVerification({Key? key, required this.args}) : super(key: key);

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  final otp1Controller = TextEditingController();

  final otp2Controller = TextEditingController();

  final otp3Controller = TextEditingController();

  final otp4Controller = TextEditingController();

  final otp5Controller = TextEditingController();

  final otp6Controller = TextEditingController();

  late Timer _timer;
  FirebaseAuth _auth = FirebaseAuth.instance;

  final _codeController = TextEditingController();

  int _start = 60;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // void moveToNextScreen(context) {

  @override
  void initState() {
    // TODO: implement initState
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void resendVerificationCode(String phoneNumber, int token) {
    _auth.verifyPhoneNumber(
        phoneNumber: "phoneController",
        verificationCompleted: (phoneAuthCredential) async {
          setState(() {
            //showLoading = false;
          });

          //signInWithPhoneAuthCredential(phoneAuthCredential);
        },
        verificationFailed: (verificationFailed) async {
          setState(() {
            //showLoading = false;
          });
          print(verificationFailed.message);
        },
        codeSent: (verificationId, resendingToken) async {
          setState(() {
            //showLoading = false;
            //currentState = MobileVerficationState.SHOW_OTP_FORM_STATE;
            //this.verificationId = verificationId;
          });
          setState(() {
            //_isLoading = false;
          });
          // Navigator.pushNamed(context, PhoneVerification.routeName,
          //     arguments: VerificationArgument(resendingToken: resendingToken, verificationId: verificationId));
        },
        forceResendingToken: token,
        codeAutoRetrievalTimeout: (verificationId) async {});
    // resending with token got at previous call's `callbacks` method `onCodeSent`
    // [END start_phone_auth]
  }

  final _errorCodeSnackBar = const SnackBar(
    content: Text("Incorrect Code"),
    backgroundColor: Colors.red,
  );

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      body: Stack(
        children: [
          CustomeBackArrow(),
          Container(
            margin: const EdgeInsets.only(left: 25.0, right: 25.0),
            padding: const EdgeInsets.only(top: 100),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verification Code Sent',
                    style: TextStyle(color: Colors.green[900], fontSize: 24.0),
                  ),
                  const Text(
                    'Enter the verification code sent to you',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 50.0,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Must fill all fields";
                              }
                              return null;
                            },
                            controller: otp1Controller,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26.0),
                            onChanged: (value) {
                              if (value.length == 1) node.nextFocus();
                            },
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                counterText: "",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          )),
                      SizedBox(
                          width: 50.0,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Must fill all fields";
                              }
                              return null;
                            },
                            controller: otp2Controller,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26.0),
                            onChanged: (value) {
                              if (value.length == 1) node.nextFocus();
                            },
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                counterText: "",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          )),
                      SizedBox(
                          width: 50.0,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Must fill all fields";
                              }
                              return null;
                            },
                            controller: otp3Controller,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26.0),
                            onChanged: (value) {
                              if (value.length == 1) node.nextFocus();
                            },
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                counterText: "",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          )),
                      SizedBox(
                          width: 50.0,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Must fill all fields";
                              }
                              return null;
                            },
                            controller: otp4Controller,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26.0),
                            onChanged: (value) {
                              if (value.length == 1) node.nextFocus();
                            },
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                counterText: "",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          )),
                      SizedBox(
                          width: 50.0,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Must fill all fields";
                              }
                              return null;
                            },
                            controller: otp5Controller,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26.0),
                            onChanged: (value) {
                              if (value.length == 1) node.nextFocus();
                            },
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                counterText: "",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          )),
                      SizedBox(
                          width: 50.0,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Must fill all fields";
                              }
                              return null;
                            },
                            controller: otp6Controller,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26.0),
                            onChanged: (value) {
                              if (value.length == 1) node.nextFocus();
                            },
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                counterText: "",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 60.0),
                      child: Row(
                        children: [
                          Text(
                            "${_start != 0 ? _start : 'Didn\'t receive the code? '}",
                            style: const TextStyle(fontSize: 17.0),
                          ),
                          TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> state) =>
                                            state.contains(
                                                    MaterialState.disabled)
                                                ? Colors.grey
                                                : null),
                              ),
                              onPressed: _start == 0 ? () {} : null,
                              child: const Text(
                                ' RESEND',
                              )),
                        ],
                      )),
                  Center(
                    child: Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        width: 200.0,
                        height: 40.0,
                        child: ElevatedButton(
                          onPressed: () {
                            final form = _formKey.currentState;
                            if (form!.validate()) {
                              form.save();
                              String code = otp1Controller.text +
                                  otp2Controller.text +
                                  otp3Controller.text +
                                  otp4Controller.text +
                                  otp5Controller.text +
                                  otp6Controller.text;

                              PhoneAuthCredential credential =
                                  PhoneAuthProvider.credential(
                                      verificationId:
                                          this.widget.args.verificationId,
                                      smsCode: code);
                              _auth
                                  .signInWithCredential(credential)
                                  .then((value) {
                                print(value);
                                Navigator.pushNamed(
                                    context, CreateProfileScreen.routeName);
                              });
                            }
                          },
                          child: const Text(
                            'Verify',
                            style:
                                TextStyle(fontSize: 17.0, color: Colors.white),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
