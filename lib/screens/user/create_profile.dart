import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:provider/provider.dart';
import '../../utils/waver.dart';
import '../theme/theme_provider.dart';

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

  late ThemeProvider themeProvider;

  late bool _visiblePassword;
  late IconData icon;
  @override
  void initState() {
    _visiblePassword = true;
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 180,
              color: themeProvider.getColor,
            ),
          ),
        ),
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            height: 160,
            color: themeProvider.getColor,
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              color: themeProvider.getColor,
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
        BlocConsumer<UserBloc, UserState>(
          listener: (_, state) {
            if (state is UserLoading) {
              _isLoading = true;
            }
            if (state is UsersLoadSuccess) {
              _isLoading = false;

              BlocProvider.of<AuthBloc>(context)
                  .add(AuthDataLoad());
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthDataLoadSuccess) {
                    name = state.auth.name!;
                    number = state.auth.phoneNumber!;
                    myId = state.auth.id!;
                    Navigator.of(context).pop();
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
                        child: Text(
                            getTranslation(context, "okay_action"))),
                  ],
                ),
              );
            }
            if (state is UserOperationFailure) {
              _isLoading = false;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(getTranslation(
                    context, "create_profile_register_failure_message")),
                backgroundColor: Colors.red.shade900,
                action: SnackBarAction(
                    label: "Try Again", onPressed: createProfile),
              ));
            }
          },
          builder: (_, state) {
            return _buildProfileForm();
          },
        ),
      ],
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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 150, right: 20, left: 20, bottom: 10),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          getTranslation(context, "create_profile_title"),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          labelText:
                              getTranslation(context, "name_textfield_hint_text"),
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w300,
                            // color: Colors.black45
                          ),
                          prefixIcon: const Icon(
                            Icons.contacts_rounded,
                            size: 19,
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.solid))
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return getTranslation(
                                context, "create_profile_empity_name_validation");
                          } else if (value.length > 25) {
                            return getTranslation(
                                context, "create_profile_long_name_validation");
                          } else if (value.length < 4) {
                            return getTranslation(
                                context, "create_profile_short_name_validation");
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
                          obscureText: _visiblePassword,
                          style: const TextStyle(fontSize: 18),
                          controller: password,
                          decoration: InputDecoration(
                            labelText: getTranslation(context, "password_hint_text"),
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w300,
                              // color: Colors.black45
                            ),

                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _visiblePassword = !_visiblePassword;

                                      icon = _visiblePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off;
                                    });
                                  },
                                  icon: Icon(icon)),
                            prefixIcon: const Icon(
                              Icons.lock,
                              size: 19,
                            ),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(style: BorderStyle.solid))
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return getTranslation(context,
                                  "create_profile_empity_password_validation");
                            } else if (value.length > 25) {
                              return getTranslation(context,
                                  "signin_form_long_password_validation");
                            } else if (value.length < 4) {
                              return getTranslation(context,
                                  "signin_form_short_password_validation");
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
                        obscureText: _visiblePassword,
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          labelText: getTranslation(context, "confirm_password"),
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w300,
                            // color: Colors.black45
                          ),
                          prefixIcon: const Icon(
                            Icons.lock,
                            size: 19,
                          ),

                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _visiblePassword = !_visiblePassword;

                                    icon = _visiblePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off;
                                  });
                                },
                                icon: Icon(icon)),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(style: BorderStyle.solid))
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
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: SizedBox(
                            height: 50,
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
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
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
        ));
  }
}
