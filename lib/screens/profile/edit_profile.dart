import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/cubit/cubits.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/models/user/user.dart';
import 'package:passengerapp/rout.dart';
import '../../localization/localization.dart';
import '../../utils/waver.dart';
import '../../widgets/widgets.dart';

class EditProfile extends StatefulWidget {
  static const routeName = "/editaprofile";

  final EditProfileArgument args;

  const EditProfile({Key? key, required this.args}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isImageLoading = false;
  final Map<String, dynamic> _user = {};

  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var emergencyController = TextEditingController();
  late String name;
  bool nameUpdate = false;
  late String phone;
  bool phoneUpdate = false;
  late String? email;
  bool emailUpdate = false;
  late String emergency;
  bool emergencyUpdate = false;

  @override
  void initState() {
    name = widget.args.auth.name ?? "Loading";
    nameController.text = name;
    phone = widget.args.auth.phoneNumber ?? "+251";
    phoneController.text = phone;
    email = widget.args.auth.email;
    emailController.text = email ?? "";
    emergency = widget.args.auth.emergencyContact ?? "+251";
    emergencyController.text = emergency;
    textLength = phoneController.text.length;
    eTextLength = emergencyController.text.length;
    super.initState();
  }

  _showModalNavigation() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return ListTile(
            leading: const Icon(Icons.image),
            title: const Text("Gallery"),
            onTap: () async {
              XFile? image = (await ImagePicker.platform.getImage(
                source: ImageSource.gallery,
              ));

              UserEvent event = UploadProfile(image!);

              BlocProvider.of<UserBloc>(ctx).add(event);
              Navigator.pop(context);
            },
          );
        });
  }

  final _appBar = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SafeAppBar(
          key: _appBar,
          title: getTranslation(context, "edit_profile"),
          appBar: AppBar(),
          widgets: []),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 180,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 160,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,
                color: Theme.of(context).primaryColor,
                child: ClipPath(
                  clipper: WaveClipperBottom(),
                  child: Container(
                    height: 100,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          BlocConsumer<UserBloc, UserState>(builder: (context, state) {
            return _buildProfileForm();
          }, listener: (context, state) {
            if (state is ImageUploadSuccess) {
              context.read<ProfilePictureCubit>().getProfilePictureUrl();

              _isImageLoading = false;
            }
            if (state is UserImageLoading) {
              _isImageLoading = true;
            }
            if (state is UsersLoadSuccess) {
              _isLoading = false;
              Future.delayed(const Duration(seconds: 1), () {
                BlocProvider.of<AuthBloc>(context).add(AuthDataLoad());
                //Navigator.pop(context);
              });

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(getTranslation(context, "update_successfull")),
                backgroundColor: Colors.green,
              ));
            }
            if (state is UserOperationFailure) {
              _isLoading = false;
              _isImageLoading = false;

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text("Update Failed"),
                backgroundColor: Colors.red.shade900,
              ));
            }
          }),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10, top: 40, bottom: 3),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _showModalNavigation();
                        },
                        child: CircleAvatar(
                          radius: 50,
                          child: _isImageLoading
                              ? const CircularProgressIndicator()
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: BlocBuilder<ProfilePictureCubit, String>(
                                    builder: (_, state) {
                                      return CachedNetworkImage(
                                        useOldImageOnUrlChange: true,
                                        imageUrl: state,
                                        imageBuilder: (context, imageProvider) =>
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
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.person, size: 60),
                                      );
                                    },
                                  )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          isCollapsed: false,
                          isDense: true,
                          hintText:
                              getTranslation(context, "name_textfield_hint_text"),
                          focusColor: Colors.blue,
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 0.6, color: Colors.orange)),
                          prefixIcon: const Icon(
                            Icons.contact_mail,
                            size: 19,
                          ),
                          // fillColor: Colors.white,
                          filled: true,
                          border: const OutlineInputBorder(
                              //borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field can\'t be empity';
                        } else if (value.length < 2) {
                          return getTranslation(
                              context, "create_profile_short_name_validation");
                        } else if (value.length > 25) {
                          return getTranslation(
                              context, "create_profile_long_name_validation");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _user['name'] = value;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          isCollapsed: false,
                          isDense: true,
                          hintText:
                              getTranslation(context, "phone_number_hint_text"),
                          focusColor: Colors.blue,
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 0.6, color: Colors.orange)),
                          prefixIcon: const Icon(
                            Icons.phone_callback_outlined,
                            size: 19,
                          ),
                          // fillColor: Colors.white,
                          suffix: Text("$textLength/13"),
                          filled: true,
                          enabled: phoneEnabled,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return getTranslation(context, "phone_number_required");
                        } else if (value.length < 13) {
                          return getTranslation(context, "phone_number_short");
                        } else if (value.length > 13) {
                          return getTranslation(context, "phone_number_exceed");
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.length >= 9) {
                          //phoneEnabled = false;
                        }
                        setState(() {
                          textLength = value.length;
                        });
                      },
                      onSaved: (value) {
                        _user["phone_number"] = value;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          isCollapsed: false,
                          isDense: true,
                          hintText: getTranslation(
                              context, "email_textfield_hint_text"),
                          focusColor: Colors.blue,
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 0.6, color: Colors.orange)),
                          prefixIcon: const Icon(
                            Icons.mail_outline,
                            size: 19,
                          ),
                          // fillColor: Colors.white,
                          filled: true,
                          border: const OutlineInputBorder(
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
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: emergencyController,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          isCollapsed: false,
                          isDense: true,
                          enabled: ePhoneEnabled,
                          hintText: getTranslation(
                              context, "emergency_contact_number_hint_text"),
                          focusColor: Colors.blue,
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 0.6, color: Colors.orange)),
                          prefixIcon: const Icon(
                            Icons.contact_phone_outlined,
                            size: 19,
                          ),
                          suffix: Text("$eTextLength/13"),
                          filled: true,
                          border: const OutlineInputBorder(
                              //borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none)),
                      onSaved: (value) {
                        //print("now");
                        _user["emergency_contact"] = emergencyController.text;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return null;
                        } else if (value.length < 13) {
                          return getTranslation(context, "phone_number_short");
                        } else if (value.length > 13) {
                          return getTranslation(context, "phone_number_exceed");
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.length >= 9) {
                          //ePhoneEnabled = false;
                        }
                        setState(() {
                          eTextLength = value.length;
                        });
                      },
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
                                  if (_isDataUpdated()) {
                                    updateProfile();
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                        "Nothing to update",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      backgroundColor: Colors.white,
                                    ));
                                  }
                                }
                              },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Text(
                              getTranslation(context, "save_changes"),
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 1,
                                      ),
                                    )
                                  : Container(),
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
        ));
  }

  bool _isDataUpdated() {
    if (name != nameController.text) {
      nameUpdate = true;
    }
    if (phone != phoneController.text) {
      phoneUpdate = true;
    }
    if (email != emailController.text) {
      emailUpdate = true;
    }
    if (emergency != emergencyController.text) {
      emergencyUpdate = true;
    }
    return nameUpdate || phoneUpdate || emailUpdate || emergencyUpdate;
  }

  var textLength = 0;
  var eTextLength = 0;
  var phoneEnabled = true;
  var ePhoneEnabled = true;

  void updateProfile() {
    setState(() {
      _isLoading = true;
    });
    UserEvent event = UserUpdate(User(
        name: nameController.text,
        phoneNumber: phoneController.text,
        id: widget.args.auth.id,
        email: emailController.text,
        emergencyContact: emergencyController.text));

    BlocProvider.of<UserBloc>(context).add(event);
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
  File? imageFile;
  /// Get from Camera
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
  _buildBottomSheet(){
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        builder: (BuildContext ctx) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              padding: const EdgeInsets.fromLTRB(30, 30, 20, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        _getFromCamera();
                      },
                      child: Text("Open Camera")),
                  ElevatedButton(
                      onPressed: () {
                        _getFromGallery();
                      },
                      child: Text("From Gallery")),
                ],
              ),
            ),
          );
        });
  }
}
