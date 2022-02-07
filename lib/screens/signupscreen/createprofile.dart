import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/widgets.dart';

class CreateProfileScreen extends StatefulWidget {
  static const routeName = "/createprofile";

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final password = TextEditingController();

  XFile? _image;

  _showModalNavigation() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            child: ListTile(
              leading: Icon(Icons.image),
              title: Text("Gallery"),
              onTap: () async {
                print("heyyyyyyyyyyyyyyyyyyyyy");
                XFile? image = (await ImagePicker.platform.getImage(
                  source: ImageSource.gallery,
                )

                    // .pickImage(
                    //   source:
                    //   maxHeight: 400,
                    //   maxWidth: 400,
                    // )
                    );
                print("testtttttttttttttttttttttttttttttttttttttttttttt");

                print(image.toString() +
                    "testtttttttttttttttttttttttttttttttttttttttttttt");
                setState(() {
                  _image = image;
                });
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  File? image;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              key: _formKey,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Create Profle",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24.0),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _showModalNavigation();
                            },
                            child: CircleAvatar(
                              radius: 40,
                              child: _image == null
                                  ? Container()
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Stack(
                                        children: [
                                          Container(
                                            child: Image.file(
                                              File(_image!.path),
                                              fit: BoxFit.cover,
                                            ),
                                            width: 300,
                                            height: 300,
                                          ),
                                          Positioned(
                                            top: 4.0,
                                            right: 4.0,
                                            child: IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {},
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Full Name",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black45),
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Your Name';
                              } else if (value.length > 25) {
                                return 'Full name must not be longer than 25 charachters';
                              } else if (value.length < 4) {
                                return 'Full name must not be shorter than 4 charachters';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: password,
                            decoration: const InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black45),
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Your Name';
                              } else if (value.length > 25) {
                                return 'Full name must not be longer than 25 charachters';
                              } else if (value.length < 4) {
                                return 'Full name must not be shorter than 4 charachters';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Confirm Password",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black45),
                            ),
                            validator: (value) {
                              if (value != password.text) {
                                return 'Password must match';
                              }
                              return null;
                            },
                          ),
                          InternationalPhoneNumberInput(
                            hintText: "Emergency Contact number",
                            onInputChanged: (PhoneNumber number) {
                              print(number.phoneNumber);
                            },
                            validator: (value) {
                              return null;
                            },
                            // onInputValidated: (bool value) {
                            //   print(value);
                            // },
                            selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            ),
                            ignoreBlank: false,
                            autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle:
                                const TextStyle(color: Colors.black),
                            initialValue: PhoneNumber(isoCode: "ET"),
                            formatInput: false,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Email",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black45),
                            ),
                            validator: (value) {},
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Promo/Referal Code",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black45),
                              fillColor: Colors.white,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                    onPressed: () {
                                      final form = _formKey.currentState;
                                      if (form!.validate()) {
                                        form.save();
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: const Text("Thankyou"),
                                                  content: const Text.rich(TextSpan(
                                                      text:
                                                          "Thank you for registering with SafeWay. Please complete your registration and be activated by visiting our office.",
                                                      children: [
                                                        TextSpan(
                                                            text:
                                                                "+251934540217")
                                                      ])),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pushReplacementNamed(
                                                              context,
                                                              HomeScreen
                                                                  .routeName,
                                                              arguments:
                                                                  HomeScreenArgument(
                                                                      isSelected:
                                                                          false));
                                                        },
                                                        child:
                                                            const Text("Okay")),
                                                  ],
                                                ));
                                      }
                                    },
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
          ),
        ],
      ),
    );
  }
}
