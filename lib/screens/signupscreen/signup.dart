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
import 'package:passengerapp/widgets/widgets.dart';

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
  late String phoneController;
  bool isCorrect = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = "";
  String userInput = "";
  bool showLoading = false;
  final Connectivity _connectivity = Connectivity();
  late ConnectivityResult result;

  void sendVerificationCode() async {
    await _auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 60),
        phoneNumber: phoneController,
        verificationCompleted: (phoneAuthCredential) async {
          // signInWithPhoneAuthCredential(phoneAuthCredential);
        },
        verificationFailed: (verificationFailed) async {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red.shade900,
              content: Text(getTranslation(context, "incorrect_verification_code"))));
        },
        codeSent: (verificationId, resendingToken) async {
          // setState(() {
          //   showLoading = false;
          currentState = MobileVerficationState.SHOW_OTP_FORM_STATE;
          //   this.verificationId = verificationId;
          // });
          setState(() {
            _isLoading = false;
          });
          Navigator.pushNamed(context, PhoneVerification.routeName,
              arguments: VerificationArgument(
                  from: 'SignUp',
                  phoneNumber: phoneController,
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

  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromRGBO(240, 241, 241, 1),
      body: Stack(
        children: [
          const CustomeBackArrow(),
          Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      getTranslation(context, "signup_action"),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
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
                          phoneController = number.phoneNumber!;
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    final form = _formkey.currentState;
                                    if (form!.validate()) {
                                      checkInternet().then((value) {
                                        if (value) {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(getTranslation(
                                                      context,
                                                      "signup_confirmation_dialog_title")),
                                                  content: Text.rich(TextSpan(
                                                      text: getTranslation(
                                                          context,
                                                          "signup_confirmation_dialog_text"),
                                                      children: [
                                                        TextSpan(
                                                            text:
                                                                phoneController)
                                                      ])),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () async {
                                                          setState(() {
                                                            _isLoading = true;
                                                          });

                                                          Navigator.pop(
                                                              context);

                                                          checkPhoneNumber(
                                                              phoneController);
                                                        },
                                                        child: Text(getTranslation(
                                                            context,
                                                            "signup_confirmation_dialog_action_approval"))),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context,
                                                              "Cancel");
                                                        },
                                                        child: Text(getTranslation(
                                                            context,
                                                            "signup_confirmation_dialog_action_cancelation"))),
                                                  ],
                                                );
                                              });
                                        }
                                      });
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
                            sendVerificationCode();
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

  void checkPhoneNumber(String phoneNumber) {
    setState(() {
      _isLoading = true;
    });

    BlocProvider.of<UserBloc>(context).add(UserCheckPhoneNumber(phoneNumber));
  }
}
