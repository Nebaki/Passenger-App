import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../utils/waver.dart';
import '../theme/theme_provider.dart';
enum ResetMobileVerficationState { SHOW_MOBILE_FORM_STATE, SHOW_OTP_FORM_STATE }

class MobileVerification extends StatefulWidget {
  static const routeName = '/resetverification';

  @override
  _MobileVerificationState createState() => _MobileVerificationState();
}

class _MobileVerificationState extends State<MobileVerification> {
  ResetMobileVerficationState currentState =
      ResetMobileVerficationState.SHOW_MOBILE_FORM_STATE;
  late String phoneController;
  bool isCorrect = false;

  FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = "";
  String userInput = "";
  bool showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });
      if (authCredential.user != null) {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
    }
  }
  late ThemeProvider themeProvider;
  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
  }
  void sendVerificationCode() async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneController,
        verificationCompleted: (phoneAuthCredential) async {
          setState(() {
            showLoading = false;
          });

          signInWithPhoneAuthCredential(phoneAuthCredential);
        },
        verificationFailed: (verificationFailed) async {
          setState(() {
            showLoading = false;
          });
        },
        codeSent: (verificationId, resendingToken) async {
          setState(() {
            showLoading = false;
            currentState = ResetMobileVerficationState.SHOW_OTP_FORM_STATE;
            this.verificationId = verificationId;
          });
          Navigator.pushNamed(context, PhoneVerification.routeName,
              arguments: VerificationArgument(
                  phoneNumber: phoneController,
                  resendingToken: resendingToken,
                  verificationId: verificationId, from: 'ForgetPassword'));
        },
        codeAutoRetrievalTimeout: (verificationId) async {});
  }

  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 241, 241, 1),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 180,
                color: themeProvider.getColor,
              ),
            ),
          ),
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 160,
              color: themeProvider.getColor,
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,
                color: themeProvider.getColor,
                child: ClipPath(
                  clipper: WaveClipperBottom(),
                  child: Container(
                    height: 100,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          CustomeBackArrow(),
          Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Enter mobile number",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: InternationalPhoneNumberInput(
                      inputDecoration: const InputDecoration(
                          hintText: "Phone Number",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black45),
                          fillColor: Colors.white,
                          filled: true,
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                      onInputChanged: (PhoneNumber number) {
                        setState(() {
                          phoneController = number.phoneNumber!;
                        });
                      },
                      onInputValidated: (bool value) {},
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      ignoreBlank: false,

                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      initialValue: PhoneNumber(isoCode: "ET"),
                      //textFieldController: phoneController,
                      formatInput: true,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      spaceBetweenSelectorAndTextField: 0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        "By continuing, i confirm that i have read & agree to the Terms & conditions and Privacypolicy",
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: () {
                              final form = _formkey.currentState;
                              if (form!.validate()) {
                                form.save();
                                isPhoneRegistered(phoneController);
                              }
                            },
                            child: const Text(
                              "Continue",
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  void isPhoneRegistered(String phone){
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              title: const Text("Confirm"),
              content: Text.rich(TextSpan(
                  text:
                  "We will send a verification code to ",
                  children: [
                    TextSpan(text: phoneController)
                  ])),
              actions: [
                TextButton(
                    onPressed: () async {
                      sendVerificationCode();
                      // Navigator
                      //     .pushReplacementNamed(
                      //         context,
                      //         PhoneVerification
                      //             .routeName);
                    },
                    child: const Text("Send Code")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(
                          context, "Cancel");
                    },
                    child: const Text("Cancel")),
              ],
            ));
  }
}
