import 'dart:io';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/widgets.dart';
// ignore: import_of_legacy_library_into_null_safe

class CreateProfileScreen extends StatefulWidget {
  static const routeName = "/createprofile";
  final CreateProfileScreenArgument args;

  CreateProfileScreen({Key? key, required this.args}) : super(key: key);

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final password = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  XFile? _image;
  final Map<String, dynamic?> _user = {};
  bool _isLoading = false;

  _showModalNavigation() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            child: ListTile(
              leading: Icon(Icons.image),
              title: Text("Gallery"),
              onTap: () async {
                XFile? image = (await ImagePicker.platform.getImage(
                  source: ImageSource.gallery,
                )

                    // .pickImage(
                    //   source:
                    //   maxHeight: 400,
                    //   maxWidth: 400,
                    // )
                    );

                setState(() {
                  _image = image;
                });
                UserEvent event = UploadProfile(image!);

                BlocProvider.of<UserBloc>(ctx).add(event);
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<UserBloc, UserState>(
      listener: (_, state) {
        if (state is UserLoading) {
          _isLoading = true;
        }
        if (state is UsersLoadSuccess) {
          _isLoading = false;
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext con) => WillPopScope(
                    onWillPop: () async => false,
                    child: AlertDialog(
                      title: const Text("Thank you"),
                      content: const Text.rich(TextSpan(
                        text:
                            "Thank you for registering with SafeWay. Please complete your registration and be activated by visiting our office.",
                      )),
                      actions: [
                        TextButton(
                            onPressed: () {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(AuthDataLoad());
                              Navigator.pop(con);
                              Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  HomeScreen.routeName,
                                  ((Route<dynamic> route) => false),
                                  arguments: HomeScreenArgument(
                                      isSelected: false, isFromSplash: false));
                            },
                            child: const Text("Okay")),
                      ],
                    ),
                  ));
        }
        if (state is UserOperationFailure) {
          _isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Failed To Create profile"),
            backgroundColor: Colors.red.shade900,
            action:
                SnackBarAction(label: "Try Again", onPressed: createProfile),
          ));
        }
      },
      builder: (_, state) {
        return Scaffold(
            // backgroundColor: const Color.fromRGBO(240, 241, 241, 1),
            body: _buildProfileForm());
      },
    ));
  }

  void createProfile() {
    setState(() {
      _isLoading = true;
    });
    UserEvent event = UserCreate(User(
        name: _user["name"],
        password: _user["password"],
        phoneNumber: widget.args.phoneNumber,
        gender: "Male",
        email: _user["email"],
        emergencyContact: _user["phone_number"]));

    BlocProvider.of<UserBloc>(context).add(event);
  }

  Widget _buildProfileForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 80, right: 20, left: 20, bottom: 10),
      child: Form(
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Create Profile",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24.0),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Full Name",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          // color: Colors.black45
                        ),
                        prefixIcon: Icon(
                          Icons.contacts_rounded,
                          size: 19,
                        ),
                        // fillColor: Colors.white,
                        // filled: true,
                        // border: OutlineInputBorder(
                        //     borderSide: BorderSide.none)
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
                      onSaved: (value) {
                        //final val = value!.split("")[0];
                        //print();
                        _user['name'] = value;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        controller: password,
                        decoration: const InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            // color: Colors.black45
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            size: 19,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Your Password';
                          } else if (value.length > 25) {
                            return 'Password must not be longer than 25 charachters';
                          } else if (value.length < 4) {
                            return 'Password must not be shorter than 4 charachters';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _user["password"] = value;
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Confirm Password",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          // color: Colors.black45
                        ),
                        prefixIcon: Icon(
                          Icons.confirmation_num,
                          size: 19,
                        ),
                      ),
                      validator: (value) {
                        if (value != password.text) {
                          return 'Password must match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText: "Promo/Referal Code (Optional)",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            // color: Colors.black45
                          ),
                          prefixIcon: Icon(
                            Icons.gif,
                            size: 19,
                          )),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          createProfileArgumentText,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
                                      final form = _formKey.currentState;
                                      if (form!.validate()) {
                                        form.save();
                                        createProfile();
                                      }
                                    },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Spacer(),
                                  const Text(
                                    "Register",
                                  ),
                                  const Spacer(),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1,
                                              color: Colors.black,
                                            ),
                                          )
                                        : Container(),
                                  )
                                ],
                              )),
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
    );
  }
}





// GestureDetector(
//                           onTap: () {},
//                           child: CircleAvatar(
//                             backgroundColor: Colors.grey.shade300,
//                             radius: 40,
//                             child: _image == null
//                                 ? Stack(
//                                     children: [
//                                       const Align(
//                                         alignment: Alignment.center,
//                                         child: Icon(
//                                           Icons.person,
//                                           size: 50,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                       Align(
//                                         alignment: Alignment.bottomRight,
//                                         child: IconButton(
//                                             constraints: BoxConstraints.tight(
//                                                 const Size.fromRadius(20)),
//                                             splashRadius: 3,
//                                             padding: EdgeInsets.zero,
//                                             iconSize: 15,
//                                             onPressed: () {
//                                               _showModalNavigation();
//                                             },
//                                             icon: const Icon(Icons.edit,
//                                                 color: Colors.black)),
//                                       ),
//                                     ],
//                                   )
//                                 : ClipRRect(
//                                     borderRadius: BorderRadius.circular(100),
//                                     child: Stack(
//                                       children: [
//                                         SizedBox(
//                                           child: Image.file(
//                                             File(_image!.path),
//                                             fit: BoxFit.cover,
//                                           ),
//                                           width: 300,
//                                           height: 300,
//                                         ),
//                                         Positioned(
//                                           top: 6.0,
//                                           right: 6.0,
//                                           child: GestureDetector(
//                                             onTap: () {
//                                               setState(() {
//                                                 _image = null;
//                                               });
//                                             },
//                                             child: Container(
//                                               padding: EdgeInsets.zero,
//                                               decoration: BoxDecoration(
//                                                   // color: Colors.white,
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           100)),
//                                               child: const Icon(
//                                                 Icons.close,
//                                                 color: Colors.white,
//                                                 size: 25,
//                                               ),
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                           ),
//                         ),