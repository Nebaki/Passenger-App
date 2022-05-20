import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/models/user/user.dart';
import 'package:passengerapp/rout.dart';

import '../../widgets/widgets.dart';

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
  bool _isImageLoading = false;
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
                XFile? image = (await ImagePicker.platform.getImage(
                  source: ImageSource.gallery,
                )

                    // .pickImage(
                    //   source:
                    //   maxHeight: 400,
                    //   maxWidth: 400,
                    // )
                    );

                //File f = File(image!.path);

                setState(() {
                  _image = image;
                });
                Navigator.pop(context);

                UserEvent event = UploadProfile(image!);

                BlocProvider.of<UserBloc>(ctx).add(event);
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    String imageurl;
    return Scaffold(
      body: BlocConsumer<UserBloc, UserState>(builder: (context, state) {
        return _buildProfileForm();
      }, listener: (context, state) {
        if (state is ImageUploadSuccess) {
          BlocProvider.of<AuthBloc>(context).add(AuthDataLoad());
          _isImageLoading = false;
        }
        if (state is UserImageLoading) {
          _isImageLoading = true;
        }
        if (state is UsersLoadSuccess) {
          _isLoading = false;
          Future.delayed(const Duration(seconds: 1), () {
            BlocProvider.of<AuthBloc>(context).add(AuthDataLoad());
          });

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
      child: SingleChildScrollView(
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
                    // artist Icon
                    fillColor: Colors.white,

                    //filled: true,
                    // border:
                    //     OutlineInputBorder(borderSide: BorderSide.none)
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field can\'t be empity:    ';
                    }
                    return null;
                  },
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildProfileForm() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            // color: const Color.fromRGBO(240, 241, 241, 1),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.12,
                  right: 10,
                  left: 10,
                  child: Container(
                    height: MediaQuery.of(context).size.height * .88,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Edit Profile",
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                            "you have to have your old password in order to change new password. lorem ipsum text to add the new."),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              _showModalNavigation();
                            },
                            child: CircleAvatar(
                              radius: 60,
                              child: _isImageLoading
                                  ? CircularProgressIndicator()
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: BlocBuilder<AuthBloc, AuthState>(
                                        builder: (_, state) {
                                          if (state is AuthDataLoadSuccess) {
                                            return CachedNetworkImage(
                                              useOldImageOnUrlChange: true,
                                              imageUrl:
                                                  state.auth.profilePicture!,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              // placeholder: (context, url) =>
                                              //     const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            );
                                          }
                                          return const CircleAvatar(
                                            radius: 100,
                                          );
                                        },
                                      )),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 4,
                                spreadRadius: 2,
                                blurStyle: BlurStyle.normal)
                          ]),
                          child: TextFormField(
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
                                    borderSide: BorderSide.none)),
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
                              _user['name'] = value;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 4,
                                spreadRadius: 2,
                                blurStyle: BlurStyle.normal)
                          ]),
                          child: TextFormField(
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
                              _user["phone_number"] = value;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 4,
                                spreadRadius: 2,
                                blurStyle: BlurStyle.normal)
                          ]),
                          child: TextFormField(
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
                                    borderSide: BorderSide.none)),
                            validator: (value) {
                              if (value!.isEmpty) {}
                              return null;
                            },
                            onSaved: (value) {
                              _user["email"] = value;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 4,
                                spreadRadius: 2,
                                blurStyle: BlurStyle.normal)
                          ]),
                          child: TextFormField(
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
                                    borderSide: BorderSide.none)),
                            onSaved: (value) {
                              //print("now");
                              _user["emergency_contact"] = value;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    final form = _formKey.currentState;
                                    if (form!.validate()) {
                                      form.save();

                                      updateProfile();
                                    }
                                  },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(),
                                const Text(
                                  "Save Changes",
                                ),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.black,
                                            strokeWidth: 1,
                                          ),
                                        )
                                      : Container(),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: TextButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  side: MaterialStateProperty.all<BorderSide>(
                                      BorderSide(color: Colors.red.shade900))),
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
                CustomeBackArrow(),
              ],
            ),
          ),
        ));

    Stack(
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
                              child: _isImageLoading
                                  ? CircularProgressIndicator()
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: BlocBuilder<AuthBloc, AuthState>(
                                        builder: (_, state) {
                                          if (state is AuthDataLoadSuccess) {
                                            return CachedNetworkImage(
                                              imageUrl:
                                                  state.auth.profilePicture!,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            );
                                          }
                                          return CircleAvatar(
                                            radius: 100,
                                          );
                                        },
                                      )),

                              // _image == null
                              //     ? Container()
                              //     : ClipRRect(
                              //         borderRadius: BorderRadius.circular(100),
                              //         child: Stack(
                              //           children: [
                              //             Container(
                              //               child: Image.file(
                              //                 File(_image!.path),
                              //                 fit: BoxFit.cover,
                              //               ),
                              //               width: 300,
                              //               height: 300,
                              //             ),
                              //             Positioned(
                              //               bottom: 4.0,
                              //               right: 4.0,
                              //               child: IconButton(
                              //                 icon: const Icon(Icons.edit),
                              //                 onPressed: () {},
                              //               ),
                              //             )
                              //           ],
                              //         ),
                              //       ),
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
                                          form.save();

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
        name: _user['name'],
        phoneNumber: _user['phone_number'],
        gender: "Male",
        id: widget.args.auth.id,
        email: _user['email'],
        emergencyContact: _user['emergency_contact']));

    BlocProvider.of<UserBloc>(context).add(event);
  }
}
