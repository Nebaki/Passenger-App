import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class CreateProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: ClipOval(
              child: Material(
                color: Colors.transparent,
                child: Stack(children: [
                  Ink.image(
                    image: const AssetImage("assetName"),
                    child: InkWell(
                      onTap: () {},
                    ),
                  ),
                  ClipOval(
                    child: Container(
                      color: Colors.blue,
                      padding: const EdgeInsets.all(3),
                      child: Positioned(
                        bottom: 0,
                        right: 4,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ]),
              ),
            )),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                    hintText: "Full Name",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black45),
                    // prefixIcon: Icon(
                    //   Icons.vpn_key,
                    //   size: 19,
                    // ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Your Name';
                  }
                  return null;
                },
              ),
            ),
            Expanded(
              child: InternationalPhoneNumberInput(
                hintText: "Phone number",
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
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: const TextStyle(color: Colors.black),
                //initialValue: number,
                //textFieldController: controller,
                formatInput: false,
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputBorder: const OutlineInputBorder(),
              ),
            ),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black45),
                    // prefixIcon: Icon(
                    //   Icons.vpn_key,
                    //   size: 19,
                    // ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Password';
                  }
                  return null;
                },
              ),
            ),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                    hintText: "Emergency Contact Number",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black45),
                    // prefixIcon: Icon(
                    //   Icons.vpn_key,
                    //   size: 19,
                    // ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
              ),
            ),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black45),
                    // prefixIcon: Icon(
                    //   Icons.vpn_key,
                    //   size: 19,
                    // ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
              ),
            ),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                    hintText: "Promo/Referal Code",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black45),
                    // prefixIcon: Icon(
                    //   Icons.vpn_key,
                    //   size: 19,
                    // ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
              ),
            ),
            const Expanded(child: Text.rich(TextSpan(text: ""))),
            Expanded(
                child: TextButton(
                    onPressed: () {}, child: const Text("Register"))),
            const Expanded(
              child: Text.rich(TextSpan(text: "")),
            ),
            Expanded(
                child:
                    TextButton(onPressed: () {}, child: const Text("Register")))
          ],
        ),
      ),
    );
  }
}
