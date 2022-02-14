import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/models/user/user.dart';
import 'package:passengerapp/rout.dart';

class EditProfile extends StatefulWidget {
  static const routeName = "/editaprofile";

  final EditProfileArgument args;

  EditProfile({Key? key, required this.args}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Map<String, dynamic> _user = {};
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
      body: BlocConsumer<UserBloc, UserState>(builder: (_, state) {
        return _buildProfileForm();
      }, listener: (_, state) {
        if (state is UserLoading) {}
        if (state is UsersLoadSuccess) {
          _isLoading = false;

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Update Successfull"),
            backgroundColor: Colors.green,
          ));
        }
        if (state is UserOperationFailure) {
          _isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Update Failed"),
            backgroundColor: Colors.red.shade900,
          ));
        }
      }),
    );
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

  Widget _buildProfileForm() {
    return Stack(
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
                            initialValue: widget.args.auth.name,
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
                            onSaved: (value) {
                              _user["first_name"] = value!.split(" ")[0];
                              _user["last_name"] = value.split(" ")[1];
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            initialValue: widget.args.auth.phoneNumber,
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
                            onSaved: (value) {
                              _user["phone_number"] = value;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            initialValue: widget.args.auth.email,
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
                            onSaved: (value) {
                              _user["email"] = value;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            initialValue: widget.args.auth.emergencyContact,
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
                            onSaved: (value) {
                              //print("now");
                              _user["emergency_contact"] = value;
                            },
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        final form = _formKey.currentState;
                                        if (form!.validate()) {
                                          print("Yeah");

                                          form.save();

                                          print("YAYA");
                                          updateProfile();
                                        }
                                      },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Spacer(),
                                    const Text("Save Changes",
                                        style: TextStyle(color: Colors.white)),
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
                                ),
                              )),
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
                                            content: const Text.rich(TextSpan(
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
                                    style:
                                        TextStyle(color: Colors.red.shade900))),
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
    );
  }

  void updateProfile() {
    setState(() {
      _isLoading = true;
    });
    UserEvent event = UserUpdate(User(
        firstName: _user['first_name'],
        lastName: _user['last_name'],
        phoneNumber: _user['phone_number'],
        gender: "Male",
        id: widget.args.auth.id,
        email: _user['email'],
        emergencyContact: _user['emergency_contact']));

    BlocProvider.of<UserBloc>(context).add(event);
  }
}
