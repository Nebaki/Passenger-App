import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/widgets.dart';

class CreateProfileScreen extends StatelessWidget {
  static const routeName = "/createprofile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomeBackArrow(),
          Padding(
            padding:
                const EdgeInsets.only(top: 80, right: 20, left: 20, bottom: 10),
            child: Form(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Expanded(
                        //     child: ClipOval(
                        //   child: Material(
                        //     //color: Colors.transparent,
                        //     child: Stack(children: [
                        //       // Ink.image(
                        //       //   image: const AssetImage("assetName"),
                        //       //   child: InkWell(
                        //       //     onTap: () {},
                        //       //   ),
                        //       // ),
                        //       ClipOval(
                        //         child: Container(
                        //           color: Colors.blue,
                        //           padding: const EdgeInsets.all(3),
                        //           child: Positioned(
                        //             bottom: 0,
                        //             right: 4,
                        //             child: IconButton(
                        //               onPressed: () {},
                        //               icon: const Icon(Icons.edit),
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     ]),
                        //   ),
                        // )),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Create Profle",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24.0),
                          ),
                        ),

                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Full Name",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.black45),
                            // prefixIcon: Icon(
                            //   Icons.vpn_key,
                            //   size: 19,
                            // ),
                            fillColor: Colors.white,

                            //filled: true,
                            // border:
                            //     OutlineInputBorder(borderSide: BorderSide.none)
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Your Name';
                            }
                            return null;
                          },
                        ),
                        InternationalPhoneNumberInput(
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
                          selectorTextStyle:
                              const TextStyle(color: Colors.black),
                          //initialValue: number,
                          //textFieldController: controller,
                          formatInput: false,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          //inputBorder: const OutlineInputBorder(),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.black45),
                            // prefixIcon: Icon(
                            //   Icons.vpn_key,
                            //   size: 19,
                            // ),
                            fillColor: Colors.white,
                            //filled: true,
                            // border:
                            //     OutlineInputBorder(borderSide: BorderSide.none)
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Password';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Emergency Contact Number",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.black45),
                            // prefixIcon: Icon(
                            //   Icons.vpn_key,
                            //   size: 19,
                            // ),
                            fillColor: Colors.white,
                            //filled: true,
                            // border:
                            //     OutlineInputBorder(borderSide: BorderSide.none)
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.black45),
                            // prefixIcon: Icon(
                            //   Icons.vpn_key,
                            //   size: 19,
                            // ),
                            fillColor: Colors.white,
                            //filled: true,
                            // border:
                            //     OutlineInputBorder(borderSide: BorderSide.none)
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Promo/Referal Code",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.black45),
                            // prefixIcon: Icon(
                            //   Icons.vpn_key,
                            //   size: 19,
                            // ),
                            fillColor: Colors.white,
                            //filled: true,
                            // border:
                            //     OutlineInputBorder(borderSide: BorderSide.none)
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
                        //Text.rich(TextSpan(text: "")),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  onPressed: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text("Thankyou"),
                                            content: const Text.rich(TextSpan(
                                                text:
                                                    "Thank you for registering with SafeWay. Please complete your registration and be activated by visiting our office.",
                                                children: [
                                                  TextSpan(
                                                      text: "+251934540217")
                                                ])),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pushReplacementNamed(
                                                        context,
                                                        HomeScreen.routeName,
                                                        arguments:
                                                            HomeScreenArgument(
                                                                isSelected:
                                                                    false));
                                                  },
                                                  child: const Text("Okay")),
                                            ],
                                          )),
                                  child: const Text("Register",
                                      style: TextStyle(color: Colors.white))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
