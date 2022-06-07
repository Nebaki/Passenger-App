import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
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
  bool doesAllTextFilledsFilled = true;
  // late ScaffoldMessengerState _scaffoldMessenger;

  late Timer _timer;
  FirebaseAuth _auth = FirebaseAuth.instance;

  final _codeController = TextEditingController();

  int _start = 60;
  bool _isLoading = false;

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

  late String _verificationId;
  late int _resendToken;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // _scaffoldMessenger = ScaffoldMessenger.of(context);
    _verificationId = widget.args.verificationId;
    _resendToken = widget.args.resendingToken!;
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void resendVerificationCode(String phoneNumber, int token) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: const [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text("Sending."),
              ],
            ),
          );
        });
    _auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 60),
        phoneNumber: widget.args.phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          _getSmsAutomaticallyAndConfirm(
              phoneAuthCredential.smsCode, phoneAuthCredential);
        },
        verificationFailed: (verificationFailed) async {
          ScaffoldMessenger.of(context).showSnackBar(_errorMesseageSnackBar(
              verificationFailed.message ?? "Uknown Error"));
          debugPrint("Verification failed: $verificationFailed");
          Navigator.pop(context);
        },
        codeSent: (verificationId, resendingToken) async {
          _onCodeSent(verificationId, resendingToken!);
        },
        forceResendingToken: token,
        codeAutoRetrievalTimeout: (verificationId) async {});
  }

  SnackBar _errorMesseageSnackBar(String message) {
    return SnackBar(
      content: Text(message),
      backgroundColor: Colors.red.shade900,
    );
  }

  void _onCodeSent(String verificationId, int resendingToken) {
    otp1Controller.clear();
    otp2Controller.clear();
    otp3Controller.clear();
    otp4Controller.clear();
    otp5Controller.clear();
    otp6Controller.clear();
    Navigator.pop(context);
    setState(() {
      _start = 60;
      _verificationId = verificationId;
      _resendToken = resendingToken;
    });
    startTimer();
  }

  void _getSmsAutomaticallyAndConfirm(
      String? smsCode, PhoneAuthCredential credential) async {
    if (smsCode != null) {
      otp1Controller.text = smsCode[0];
      otp2Controller.text = smsCode[1];
      otp3Controller.text = smsCode[2];
      otp4Controller.text = smsCode[3];
      otp5Controller.text = smsCode[4];
      otp6Controller.text = smsCode[5];
      _signInWithPhoneAuthCredential(credential);
    }
  }

  void _signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        _isLoading = false;
      });
      if (authCredential.user != null) {
        if (widget.args.from == 'SignUp') {
          Navigator.pushNamedAndRemoveUntil(context,
              CreateProfileScreen.routeName, ((Route<dynamic> route) => false),
              arguments: CreateProfileScreenArgument(
                  phoneNumber: widget.args.phoneNumber));
        } else if (widget.args.from == 'ForgetPassword') {
          Navigator.pushReplacementNamed(context, ResetPassword.routeName,
              arguments:
                  ResetPasswordArgument(phoneNumber: widget.args.phoneNumber));
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(_errorMesseageSnackBar(e.toString()));
    }
  }

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
              child: _buildForm(node)),
        ],
      ),
    );
  }

  Widget _buildForm(node) {
    return Form(
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
                        setState(() {
                          doesAllTextFilledsFilled = false;
                        });
                        return null;
                      }
                      setState(() {
                        doesAllTextFilledsFilled = false;
                      });
                      return null;
                    },
                    controller: otp1Controller,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26.0),
                    onChanged: (value) {
                      if (value.length == 1) node.nextFocus();
                      if (value.length == 0) node.previousFocus();
                      print("Changedd");
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  )),
              SizedBox(
                  width: 50.0,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          doesAllTextFilledsFilled = false;
                        });
                        return null;
                      }
                      setState(() {
                        doesAllTextFilledsFilled = false;
                      });
                      return null;
                    },
                    controller: otp2Controller,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26.0),
                    onChanged: (value) {
                      if (value.length == 1) node.nextFocus();
                      if (value.length == 0) node.previousFocus();
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  )),
              SizedBox(
                  width: 50.0,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          doesAllTextFilledsFilled = false;
                        });
                        return null;
                      }
                      setState(() {
                        doesAllTextFilledsFilled = true;
                      });
                      return null;
                    },
                    controller: otp3Controller,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26.0),
                    onChanged: (value) {
                      if (value.length == 1) node.nextFocus();
                      if (value.length == 0) node.previousFocus();
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  )),
              SizedBox(
                  width: 50.0,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          doesAllTextFilledsFilled = false;
                        });
                        return null;
                      }
                      setState(() {
                        doesAllTextFilledsFilled = true;
                      });
                      return null;
                    },
                    controller: otp4Controller,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26.0),
                    onChanged: (value) {
                      if (value.length == 1) node.nextFocus();
                      if (value.length == 0) node.previousFocus();
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  )),
              SizedBox(
                  width: 50.0,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          doesAllTextFilledsFilled = false;
                        });
                        return null;
                      }
                      setState(() {
                        doesAllTextFilledsFilled = true;
                      });
                      return null;
                    },
                    controller: otp5Controller,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26.0),
                    onChanged: (value) {
                      if (value.length == 1) node.nextFocus();
                      if (value.length == 0) node.previousFocus();
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  )),
              SizedBox(
                  width: 50.0,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          doesAllTextFilledsFilled = false;
                        });
                        return null;
                      }
                      setState(() {
                        doesAllTextFilledsFilled = true;
                      });
                      return null;
                    },
                    controller: otp6Controller,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26.0),
                    onChanged: (value) {
                      if (value.length == 1) node.nextFocus();
                      if (value.length == 0) node.previousFocus();
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  )),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          doesAllTextFilledsFilled
              ? Container()
              : const Center(
                  child: Text(
                  'Must fill all fields',
                  style: TextStyle(color: Colors.red),
                )),
          const SizedBox(
            height: 30.0,
          ),
          Container(
              margin: const EdgeInsets.only(left: 60.0),
              child: Row(
                children: [
                  Text(
                    _start != 0
                        ? 'Didn\'t receive the code?  $_start'
                        : 'Didn\'t receive the code? ',
                    style: const TextStyle(fontSize: 17.0),
                  ),
                  TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> state) =>
                                    state.contains(MaterialState.disabled)
                                        ? Colors.grey
                                        : null),
                      ),
                      onPressed: _start == 0
                          ? () {
                              resendVerificationCode(
                                  widget.args.phoneNumber, _resendToken);
                            }
                          : null,
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
                  onPressed: _isLoading
                      ? null
                      : () {
                          final form = _formKey.currentState;
                          if (form!.validate()) {
                            form.save();
                            if (doesAllTextFilledsFilled) {
                              String code = otp1Controller.text +
                                  otp2Controller.text +
                                  otp3Controller.text +
                                  otp4Controller.text +
                                  otp5Controller.text +
                                  otp6Controller.text;
                              print(
                                  "Codeeeeeee $code, ${widget.args.verificationId}");

                              PhoneAuthCredential credential =
                                  PhoneAuthProvider.credential(
                                      verificationId: _verificationId,
                                      smsCode: code);
                              _signInWithPhoneAuthCredential(credential);
                            }
                          }
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      const Text(
                        "Verify",
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Container(),
                      )
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
