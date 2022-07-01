import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
// ignore: import_of_legacy_library_into_null_safe

class CreateProfileScreen extends StatefulWidget {
  static const routeName = "/createprofile";
  final CreateProfileScreenArgument args;

  const CreateProfileScreen({Key? key, required this.args}) : super(key: key);

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _user = {};
  bool _isLoading = false;

  // _showModalNavigation() {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext ctx) {
  //         return ListTile(
  //           leading: const Icon(Icons.image),
  //           title: const Text("Gallery"),
  //           onTap: () async {
  //             XFile? image = (await ImagePicker.platform.getImage(
  //               source: ImageSource.gallery,
  //             )

  //                 // .pickImage(
  //                 //   source:
  //                 //   maxHeight: 400,
  //                 //   maxWidth: 400,
  //                 // )
  //                 );

  //             setState(() {
  //             });
  //             UserEvent event = UploadProfile(image!);

  //             BlocProvider.of<UserBloc>(ctx).add(event);
  //             Navigator.pop(context);
  //           },
  //         );
  //       });
  // }

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
                  child: BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthDataLoadSuccess) {
                        name = state.auth.name!;
                        number = state.auth.phoneNumber!;
                        myId = state.auth.id!;
                        Navigator.pop(con);

                        context.read<SettingsBloc>().add(SettingsStarted());
                      }
                    },
                    child: AlertDialog(
                      title: Text(getTranslation(context,
                          "create_profile_register_successful_dialog_title")),
                      content: Text.rich(TextSpan(
                        text: getTranslation(context,
                            "create_profile_register_successful_dialog_text"),
                      )),
                      actions: [
                        TextButton(
                            onPressed: () {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(AuthDataLoad());
                            },
                            child:
                                Text(getTranslation(context, "okay_action"))),
                      ],
                    ),
                  )));
        }
        if (state is UserOperationFailure) {
          _isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(getTranslation(
                context, "create_profile_register_failure_message")),
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
    return BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoadSuccess) {
            Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName,
                ((Route<dynamic> route) => false),
                arguments: HomeScreenArgument(
                    settings: state.settings,
                    isSelected: false,
                    isFromSplash: true));
          }
          if (state is SettingsOperationFailure) {
            SystemNavigator.pop();
          }
          if (state is SettingsUnAuthorised) {
            SystemNavigator.pop();
          }
          if (state is SettingsLoading) {
            showDialog(
                // barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: const Dialog(
                        elevation: 0,
                        insetPadding: EdgeInsets.all(0),
                        backgroundColor: Colors.transparent,
                        child: Center(
                          child: SizedBox(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(strokeWidth: 1)),
                        )),
                  );
                });
          }
        },
        child: Padding(
          padding:
              const EdgeInsets.only(top: 80, right: 20, left: 20, bottom: 10),
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            getTranslation(context, "create_profile_title"),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24.0),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: getTranslation(
                                context, "name_textfield_hint_text"),
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w300,
                              // color: Colors.black45
                            ),
                            prefixIcon: const Icon(
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
                              return getTranslation(context,
                                  "create_profile_empity_name_validation");
                            } else if (value.length > 25) {
                              return getTranslation(context,
                                  "create_profile_long_name_validation");
                            } else if (value.length < 4) {
                              return getTranslation(context,
                                  "create_profile_short_name_validation");
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
                            decoration: InputDecoration(
                              hintText:
                                  getTranslation(context, "password_hint_text"),
                              hintStyle: const TextStyle(
                                fontWeight: FontWeight.w300,
                                // color: Colors.black45
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                size: 19,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return getTranslation(context,
                                    "create_profile_empity_password_validation");
                              } else if (value.length > 25) {
                                return 'Password must not be longer than 25 charachters';
                              } else if (value.length < 4) {
                                return getTranslation(context,
                                    "create_profile_long_password_validation");
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
                          decoration: InputDecoration(
                            hintText:
                                getTranslation(context, "confirm_password"),
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w300,
                              // color: Colors.black45
                            ),
                            prefixIcon: const Icon(
                              Icons.confirmation_num,
                              size: 19,
                            ),
                          ),
                          validator: (value) {
                            if (value != password.text) {
                              return getTranslation(context,
                                  "create_profile_password_match_validation_error");
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: getTranslation(
                                  context, "create_profile_promo_text"),
                              hintStyle: const TextStyle(
                                fontWeight: FontWeight.w300,
                                // color: Colors.black45
                              ),
                              prefixIcon: const Icon(
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
                                      Text(
                                        getTranslation(
                                            context, "create_profile_button"),
                                      ),
                                      const Spacer(),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: _isLoading
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
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
        ));
  }
}
