import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passengerapp/widgets/widgets.dart';

class EditProfile extends StatefulWidget {
  static const routeName = "/editaprofile";

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _textStyle =
      const TextStyle(color: Colors.black12, fontWeight: FontWeight.bold);

  XFile? _image;
  _showModalNavigation() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            child: ListTile(
              leading: const Icon(Icons.image),
              title: const Text("Gallery"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text("Edit Profile"),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        backgroundColor: Colors.red,
        body: Stack(
          children: [
            // CustomeBackArrow(),
            Form(
              key: _formKey,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Edit Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 32,
                              color: Colors.white)),
                      const SizedBox(height: 40),
                      Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              // const CircleAvatar(
                              //   radius: 60,
                              //   backgroundColor: Colors.black54,
                              //   //backgroundImage: AssetImage("assetName"),
                              // ),
                              const SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showModalNavigation();
                                },
                                child: CircleAvatar(
                                  radius: 60,
                                  child: _image == null
                                      ? Container()
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
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
                                                bottom: 4.0,
                                                right: 4.0,
                                                child: IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () {},
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    alignLabelWithHint: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    isCollapsed: false,
                                    isDense: true,
                                    hintText: "Full Name",
                                    focusColor: Colors.blue,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0.6, color: Colors.orange)),
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45),
                                    prefixIcon: Icon(
                                      Icons.contact_mail,
                                      size: 19,
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                        //borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.4))),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field can\'t be empity';
                                  } else if (value.length < 4) {
                                    return 'Name length must not be less than 4';
                                  } else if (value.length > 25) {
                                    return 'Nameength must not be Longer than 25';
                                  }
                                  return null;
                                },
                                onSaved: (value) {},
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    alignLabelWithHint: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    isCollapsed: false,
                                    isDense: true,
                                    hintText: "Phone Number",
                                    focusColor: Colors.blue,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0.6, color: Colors.orange)),
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45),
                                    prefixIcon: Icon(
                                      Icons.phone_callback_outlined,
                                      size: 19,
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                        //borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.4))),
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
                                onSaved: (value) {},
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    alignLabelWithHint: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    isCollapsed: false,
                                    isDense: true,
                                    hintText: "Email",
                                    focusColor: Colors.blue,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0.6, color: Colors.orange)),
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45),
                                    prefixIcon: Icon(
                                      Icons.mail_outline,
                                      size: 19,
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                        //borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.4))),
                                validator: (value) {
                                  if (value!.isEmpty) {}
                                  return null;
                                },
                                onSaved: (value) {},
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    alignLabelWithHint: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    isCollapsed: false,
                                    isDense: true,
                                    hintText: "Password",
                                    focusColor: Colors.blue,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0.6, color: Colors.orange)),
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45),
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      size: 19,
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                        //borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.4))),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Password can\'t be empity';
                                  } else if (value.length < 4) {
                                    return 'Password length must not be less than 4';
                                  } else if (value.length > 25) {
                                    return 'Password length must not be greater than 25';
                                  }
                                  return null;
                                },
                                onSaved: (value) {},
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    alignLabelWithHint: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    isCollapsed: false,
                                    isDense: true,
                                    hintText: "Emergency Contact Number",
                                    focusColor: Colors.blue,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0.6, color: Colors.orange)),
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45),
                                    prefixIcon: Icon(
                                      Icons.contact_phone_outlined,
                                      size: 19,
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                        //borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.4))),
                                onSaved: (value) {},
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              SizedBox(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        final form = _formKey.currentState;
                                        if (form!.validate()) {
                                          form.save();
                                        }
                                      },
                                      child: const Text("Save Changes",
                                          style:
                                              TextStyle(color: Colors.white)))),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: TextButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30))),
                                        side: MaterialStateProperty.all<BorderSide>(
                                            BorderSide(
                                                color: Colors.red.shade900))),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: const Text("Confirm"),
                                                content:
                                                    const Text.rich(TextSpan(
                                                  text:
                                                      "Are you sure you want to delete your accout? ",
                                                )),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {},
                                                      child: const Text("Yes")),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text("No")),
                                                ],
                                              ));
                                    },
                                    child: Text("Delete Account",
                                        style: TextStyle(
                                            color: Colors.red.shade900))),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildProfileItems(
      {required BuildContext context,
      required String text,
      required String textfieldtext}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: _textStyle,
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: "Full Name",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.black45),
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
                    return 'This field can\'t be empity';
                  }
                  return null;
                },
              ))
        ],
      ),
    );
  }
}

// Stack(
//         children: [
//           SingleChildScrollView(
//             child: Container(
//               child: Form(
//                   child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const CircleAvatar(
//                     radius: 40,
//                     backgroundImage: AssetImage("assetName"),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         children: [
//                           Text(
//                             "Name",
//                             style: _textStyle,
//                           ),
//                           Text("Location", style: _textStyle),
//                           Text("E-mail", style: _textStyle),
//                           Text("Phone", style: _textStyle),
//                           Text("Password", style: _textStyle),
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           TextFormField(),
//                           TextFormField(),
//                           TextFormField(),
//                           TextFormField(),
//                           TextFormField(),
//                         ],
//                       )
//                     ],
//                   ),
//                   ElevatedButton(
//                       onPressed: () {}, child: const Text("Save Changes")),
//                   TextButton(
//                       style: ButtonStyle(
//                           side: MaterialStateProperty.all<BorderSide>(
//                               BorderSide(color: Colors.red.shade900))),
//                       onPressed: () {},
//                       child: Text("Delete Account",
//                           style: TextStyle(color: Colors.red.shade900)))
//                 ],
//               )),
//             ),
//           ),
//           CustomeBackArrow()
//         ],
//       ),