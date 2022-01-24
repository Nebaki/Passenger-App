import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:passengerapp/screens/screens.dart';

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
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
          child: Column(
            children: [
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  print(number.phoneNumber);
                },
                onInputValidated: (bool value) {
                  print(value);
                },
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.DROPDOWN,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.always,
                selectorTextStyle: const TextStyle(color: Colors.black),
                //initialValue: number,
                //textFieldController: controller,
                formatInput: false,
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputBorder: const OutlineInputBorder(),
                spaceBetweenSelectorAndTextField: 4,
              ),
              const Text("Terms of privacy"),
              TextButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text("Confirm"),
                            content: const Text.rich(TextSpan(
                                text: "We will send a verivication",
                                children: [TextSpan(text: "+251934540217")])),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, PhoneVerification.routeName);
                                  },
                                  child: const Text("Send Code")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, "Cancel");
                                  },
                                  child: const Text("Cancel")),
                            ],
                          )),
                  child: const Text("Continue"))
            ],
          ),
        ),
      ),
    );
  }
}
