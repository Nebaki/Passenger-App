import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../../localization/localization.dart';
import '../../utils/waver.dart';
import '../theme/theme_provider.dart';

enum ResetMobileVerificationState { SHOW_MOBILE_FORM_STATE, SHOW_OTP_FORM_STATE }

class ForgetPassword extends StatefulWidget {
  static const routeName = '/forget_password';

  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  ResetMobileVerificationState currentState =
      ResetMobileVerificationState.SHOW_MOBILE_FORM_STATE;
  late String phoneNumber;
  bool isCorrect = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = "";
  String userInput = "";
  bool showLoading = false;

  final Connectivity _connectivity = Connectivity();
  late ConnectivityResult result;
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
    } on FirebaseAuthException catch (_) {
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

  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    padding: const EdgeInsets.only(left: 20.0,top: 200),
                    child: Text(
                      getTranslation(context, "signup_action"),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        // color: Colors.black
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
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
                        counterText: "",
                        prefixIconConstraints:
                        const BoxConstraints(minWidth: 0, minHeight: 0),
                        alignLabelWithHint: true,
                        //hintText: "Phone number",
                        labelText:  Localization.of(context)
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
                          return  Localization.of(context)
                              .getTranslation("phone_number_required");
                        } else if (value.length < 9) {
                          return  Localization.of(context)
                              .getTranslation("phone_number_short");
                        } else if (value.length > 9) {
                          return  Localization.of(context)
                              .getTranslation("phone_number_exceed");
                        } else if(value.length == 9){
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
                  
                  const SizedBox(height: 20),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: showLoading
                                ? null
                                : () {
                                    final form = _formkey.currentState;
                                    if (form!.validate()) {
                                      form.save();
                                      _showDialog();
                                    }
                                  },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(),
                                Text(
                                  getTranslation(context, "continue"),
                                ),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: showLoading
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
                  BlocConsumer<UserBloc, UserState>(
                      builder: (context, state) => Container(),
                      listener: (context, state) {
                        if (state is UserPhoneNumbeChecked) {
                          if (state.phoneNumberExist) {
                            //sendVerificationCode();
                            Navigator.pushNamed(context, PhoneVerification.routeName,
                                arguments: VerificationArgument(
                                    from: 'ForgetPassword',
                                    phoneNumber: phoneNumber));
                          } else {
                            setState(() {
                              showLoading = false;
                            });
                            ShowSnack(context: context,
                                message: getTranslation(context, "no_user_registered_message"),
                            textColor: Colors.white,backgroundColor: Colors.red).show();
                            //showPhoneNumberDoesnotExistDialog();
                          }
                        }
                        if (state is UserOperationFailure) {
                          setState(() {
                            showLoading = false;
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

  _showDialog(){
    checkInternet().then((value) {
      if (value) {
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                AlertDialog(
                  title: Text(getTranslation(
                      context,
                      "signup_confirmation_dialog_title"),style: TextStyle(color: themeProvider.getColor)),
                  content: Text.rich(TextSpan(
                      text: getTranslation(
                          context,
                          "signup_confirmation_dialog_text"),
                      children: [
                        TextSpan(
                            text: phoneNumber)
                      ]),style: const TextStyle(fontWeight: FontWeight.bold)),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(
                              context, "Cancel");
                        },
                        child: Text(getTranslation(
                            context,
                            "signup_confirmation_dialog_action_cancelation"))),
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          checkPhoneNumber(
                              phoneNumber);
                          // Navigator
                          //     .pushReplacementNamed(
                          //         context,
                          //         PhoneVerification
                          //             .routeName);
                        },
                        child: Text(getTranslation(
                            context,
                            "signup_confirmation_dialog_action_approval"))),
                  ],
                ));
      }});
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

  void checkPhoneNumber(String phoneNumber) {
    setState(() {
      showLoading = true;
    });

    BlocProvider.of<UserBloc>(context).add(UserCheckPhoneNumber(phoneNumber));
  }
  var textLength = 0;
  var phoneEnabled = true;
}
