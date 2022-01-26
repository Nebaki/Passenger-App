import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/widgets.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                      onInputChanged: (PhoneNumber number) {
                        print(number.phoneNumber);
                      },
                      onInputValidated: (bool value) {
                        print(value);
                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      ignoreBlank: false,

                      autoValidateMode: AutovalidateMode.always,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      //initialValue: number,
                      //textFieldController: controller,
                      formatInput: false,
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
                        "By continuing, iconfirm that i have read & agree to the Terms & conditions and Privacypolicy",
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
                            onPressed: () => showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text("Confirm"),
                                      content: const Text.rich(TextSpan(
                                          text:
                                              "We will send a verivication code to ",
                                          children: [
                                            TextSpan(text: "+251934540217")
                                          ])),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pushReplacementNamed(
                                                  context,
                                                  PhoneVerification.routeName);
                                            },
                                            child: const Text("Send Code")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, "Cancel");
                                            },
                                            child: const Text("Cancel")),
                                      ],
                                    )),
                            child: const Text("Continue")),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
