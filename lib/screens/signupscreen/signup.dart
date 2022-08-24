import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:passengerapp/bloc/bloc.dart';

// import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/utils/session.dart';
import 'package:passengerapp/widgets/widgets.dart';

import 'package:provider/provider.dart';
import '../../localization/localization.dart';
import '../../utils/waver.dart';
import '../theme/theme_provider.dart';

enum MobileVerficationState { SHOW_MOBILE_FORM_STATE, SHOW_OTP_FORM_STATE }

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';

  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  MobileVerficationState currentState =
      MobileVerficationState.SHOW_MOBILE_FORM_STATE;
  late String phoneNumber;
  bool isCorrect = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = "";
  String userInput = "";
  bool showLoading = false;
  final Connectivity _connectivity = Connectivity();
  late ConnectivityResult result;

  void sendVerificationCode() async {
    Session().logSession("register", "sending code to: $phoneNumber");
    await _auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 60),
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          // signInWithPhoneAuthCredential(phoneAuthCredential);
          Session().logSession("register", "$phoneNumber Verified");
        },
        verificationFailed: (verificationFailed) async {
          setState(() {
            _isLoading = false;
          });

          Session().logSession("register",
              "Can't verify $phoneNumber \n error: ${verificationFailed.message}");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red.shade900,
              content: Text(verificationFailed.message ??
                  "Error Happened" /*getTranslation(context, "incorrect_verification_code")*/)));
        },
        codeSent: (verificationId, resendingToken) async {
          // setState(() {
          //   showLoading = false;
          currentState = MobileVerficationState.SHOW_OTP_FORM_STATE;
          //   this.verificationId = verificationId;
          // });
          Session().logSession("register", "Code sent to: $phoneNumber");
          setState(() {
            _isLoading = false;
          });
          Navigator.pushNamed(context, PhoneVerification.routeName,
              arguments: VerificationArgument(
                  from: 'SignUp',
                  phoneNumber: phoneNumber,
                  resendingToken: resendingToken,
                  verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (verificationId) async {});
  }

  Future<bool> checkInternet() async {
    result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("No Internet Connection"),
        backgroundColor: Colors.red.shade900,
      ));
      return false;
    } else {
      return true;
    }
  }

  bool _isLoading = false;

  late ThemeProvider themeProvider;
  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
  }
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromRGBO(240, 241, 241, 1),
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
          const CustomeBackArrow(),
          Form(
            key: _formkey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 200),
                    child: Text(
                      getTranslation(context, "signup_action"),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
/*
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: InternationalPhoneNumberInput(
                      inputDecoration: InputDecoration(
                          hintText:
                              getTranslation(context, "phone_number_hint_text"),
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            // color: Colors.black45
                          ),
                          // fillColor: Colors.white,
                          filled: true,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none)),
                      onInputChanged: (PhoneNumber number) {
                        setState(() {
                          phoneNumber = number.phoneNumber!;
                        });
                      },
                      initialValue: PhoneNumber(isoCode: "ET"),

                      onInputValidated: (bool value) {
                        value
                            ? setState(() {
                                isCorrect = true;
                              })
                            : setState(() {
                                isCorrect = false;
                              });
                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      ignoreBlank: false,

                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      // selectorTextStyle: const TextStyle(color: Colors.black),
                      //initialValue: number,
                      //textFieldController: phoneController,
                      formatInput: true,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      spaceBetweenSelectorAndTextField: 0,
                    ),
                  ),
*/
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: TextFormField(
                      autofocus: true,
                      maxLength: 9,
                      maxLines: 1,
                      cursorColor: themeProvider.getColor,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      style: const TextStyle(fontSize: 18),
                      enabled: phoneEnabled,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: themeProvider.getColor),

                        /*enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5.0),
                        ),*/
                        counterText: "",
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 0, minHeight: 0),
                        alignLabelWithHint: true,
                        //hintText: "Phone number",
                        labelText: Localization.of(context)
                            .getTranslation("phone_number"),
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black45),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text(
                            "+251",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.getColor),
                          ),
                        ),
                        suffix: Text("$textLength/9"),
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.solid)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return Localization.of(context)
                              .getTranslation("phone_number_required");
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
                        phoneNumber = "+251$value";
                        if (value.length >= 9) {}
                        setState(() {
                          textLength = value.length;
                        });
                      },
                      onSaved: (value) {
                        //_auth["phoneNumber"] = "+251$value";
                        phoneNumber = "+251$value";
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        getTranslation(context, "registration_agrement_text"),
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            // color: Colors.black54,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    final form = _formkey.currentState;
                                    if (form!.validate()) {
                                      form.save();
                                      _createAccount();
                                    }
                                  },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(),
                                Text(
                                  getTranslation(context, "signup_title"),
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
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            getTranslation(
                                context, "signup_already_have_an_account_text"),
                            style: const TextStyle(
                              fontSize: 16,
                              // color: Colors.black54
                            )),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              //Navigator.pop(context);
                            },
                            child: Text(
                              getTranslation(context, "signup_inkwell_text"),
                              style: Theme.of(context).textTheme.button,
                            ))
                      ],
                    ),
                  ),
                  BlocConsumer<UserBloc, UserState>(
                      builder: (context, state) => Container(),
                      listener: (context, state) {
                        if (state is UserPhoneNumbeChecked) {
                          if (state.phoneNumberExist) {
                            setState(() {
                              _isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(getTranslation(context,
                                  "signup_alredy_registered_user_error")),
                              backgroundColor: Colors.red.shade900,
                            ));
                          } else {
                            //sendVerificationCode();
                            Navigator.pushNamed(
                                context, PhoneVerification.routeName,
                                arguments: VerificationArgument(
                                    from: 'SignUp', phoneNumber: phoneNumber));
                          }
                        }
                        if (state is UserOperationFailure) {
                          setState(() {
                            _isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(getTranslation(
                                context, "signup_check_phone_number_error")),
                            backgroundColor: Colors.red.shade900,
                          ));
                        }
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  _createAccount() {
    checkInternet().then((value) {
      if (value) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: Text(
                  getTranslation(context, "signup_confirmation_dialog_title"),
                  style: TextStyle(color: themeProvider.getColor),
                ),
                content: Text.rich(
                  TextSpan(
                      text: getTranslation(
                          context, "signup_confirmation_dialog_text"),
                      children: [TextSpan(text: phoneNumber)]),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, "Cancel");
                      },
                      child: Text(getTranslation(context,
                          "signup_confirmation_dialog_action_cancelation"))),
                  TextButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        Navigator.pop(context);
                        checkPhoneNumber(phoneNumber);
                      },
                      child: Text(getTranslation(context,
                          "signup_confirmation_dialog_action_approval")))
                ],
              );
            });
      }
    });
  }
  void checkPhoneNumber(String phoneNumber) {
    setState(() {
      _isLoading = true;
    });

    BlocProvider.of<UserBloc>(context).add(UserCheckPhoneNumber(phoneNumber));
  }

  var textLength = 0;
  var phoneEnabled = true;
}
