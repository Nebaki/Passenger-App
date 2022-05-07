import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/models/models.dart';
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
  final Connectivity _connectivity = Connectivity();
  late ConnectivityResult result;

  final Map<String, dynamic> _auth = {};

  final _formkey = GlobalKey<FormState>();

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(240, 241, 241, 1),
        body: BlocConsumer<AuthBloc, AuthState>(builder: (_, state) {
          return _buildSigninForm();
        }, listener: (_, state) {
          if (state is AuthSigningIn) {
            _isLoading = true;
          }
          if (state is AuthLoginSuccess) {
            Navigator.pushReplacementNamed(context, HomeScreen.routeName,
                arguments: HomeScreenArgument(isSelected: false));
          }
          if (state is AuthOperationFailure) {
            _isLoading = false;

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text("Incorrect Phone Number or Password"),
              backgroundColor: Colors.red.shade900,
            ));
          }
        }));
  }

  void signIn() async {
    result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("No Internet Connection"),
        backgroundColor: Colors.red.shade900,
      ));
      return;
    }
    _isLoading = true;

    AuthEvent event = AuthLogin(
        Auth(phoneNumber: _auth["phoneNumber"], password: _auth["password"]));

    BlocProvider.of<AuthBloc>(context).add(event);
    BlocProvider.of<AuthBloc>(context).add(AuthDataLoad());
  }

  Widget _buildSigninForm() {
    return Stack(children: [
      Form(
        key: _formkey,
        child: Container(
          color: const Color.fromRGBO(240, 241, 241, 1),
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
                        _auth["phoneNumber"] = value.toString();
                      },
                      onInputChanged: (PhoneNumber number) {},
                      onInputValidated: (bool value) {},
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
                    child: Container(
                      decoration: BoxDecoration(
                          // boxShadow: [
                          // BoxShadow(
                          //     color: Colors.grey.shade300,
                          //     blurRadius: 4,
                          //     spreadRadius: 2,
                          //     blurStyle: BlurStyle.normal)
                          // ]
                          ),
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
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
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
                          _auth["password"] = value;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                final form = _formkey.currentState;
                                if (form!.validate()) {
                                  form.save();
                                  signIn();
                                }
                              },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            const Text(
                              "Sign In",
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black,
                                      ),
                                    )
                                  : Container(),
                            )
                          ],
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
              )),
        ),
      )
    ]);
  }
}
