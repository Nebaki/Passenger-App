import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/cubit/locale_cubit/locale_cubit.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/localization/localization.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';

import '../../utils/waver.dart';
import '../theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatefulWidget {
  static const routeName = '/signin';

  const SigninScreen({Key? key}) : super(key: key);

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  late String phoneNumber;
  late String pass;
  final Connectivity _connectivity = Connectivity();
  late ConnectivityResult result;

  final Map<String, dynamic> _auth = {};

  final _formkey = GlobalKey<FormState>();
  late ThemeProvider themeProvider;

  late bool _visiblePassword;
  late IconData icon;
  @override
  void initState() {
    _visiblePassword = true;
    icon = Icons.visibility;
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
  }

  bool _isLoading = false;

  void _getSettings() {
    context.read<SettingsBloc>().add(SettingsStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: const Color.fromRGBO(240, 241, 241, 1),
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
        BlocConsumer<AuthBloc, AuthState>(builder: (_, state) {
          return _buildSignInForm();
        }, listener: (_, state) {
          if (state is AuthDataLoadSuccess) {
            name = state.auth.name!;
            number = state.auth.phoneNumber!;
            myId = state.auth.id!;
            _getSettings();
          }
          if (state is AuthSigningIn) {
            _isLoading = true;
          }
          if (state is AuthLoginSuccess) {
            context.read<AuthBloc>().add(AuthDataLoad());
          }
          if (state is AuthOperationFailure) {
            _isLoading = false;

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(getTranslation("signin_error_message")),
              backgroundColor: Colors.red.shade900,
            ));
          }
        }),
      ],
    ));
  }

  void signIn() async {
    result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(getTranslation("button_no_internet_connection_message")),
        backgroundColor: Colors.red.shade900,
      ));
      return;
    }
    _isLoading = true;

    AuthEvent event = AuthLogin(
        Auth(phoneNumber: _auth["phoneNumber"], password: _auth["password"]));

    BlocProvider.of<AuthBloc>(context).add(event);
    // BlocProvider.of<AuthBloc>(context).add(AuthDataLoad());
  }

  Widget _buildSignInForm() {
    return Stack(children: [
      BlocConsumer<SettingsBloc, SettingsState>(
          builder: (context, state) => Container(),
          listener: (context, state) {
            if (state is SettingsLoadSuccess) {
              Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName,
                  ((Route<dynamic> route) => false),
                  arguments: HomeScreenArgument(
                      settings: state.settings,
                      isSelected: false,
                      isFromSplash: true));
            }
          }),
      Form(
        key: _formkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,top: 150),
                    child: Text(
                      Localization.of(context).getTranslation("signin_title"),
                      style: const TextStyle(
                        fontFamily: 'Sifonn',
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: TextFormField(
                      autofocus: true,
                      maxLength: 9,
                      maxLines: 1,
                      cursorColor: themeProvider.getColor,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      style: const TextStyle(fontSize: 18),
                      enabled: phoneEnabled,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: themeProvider.getColor),

                        /*enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5.0),
                        ),*/
                        counterText: "",
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 0, minHeight: 0),
                        alignLabelWithHint: true,
                        //hintText: "Phone number",
                        labelText: Localization.of(context)
                            .getTranslation("phone_number"),
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black45),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text(
                            "+251",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.getColor),
                          ),
                        ),
                        suffix: Text("$textLength/9"),
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.solid)
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return Localization.of(context)
                              .getTranslation("phone_number_required");
                        } else if (value.length < 9) {
                          return Localization.of(context)
                              .getTranslation("phone_number_short");
                        } else if (value.length > 9) {
                          return Localization.of(context)
                              .getTranslation("phone_number_exceed");
                        } else if (value.length == 9) {
                          return null;
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.length >= 9) {}
                        setState(() {
                          textLength = value.length;
                        });
                      },
                      onSaved: (value) {
                        _auth["phoneNumber"] = "+251$value";
                      },
                    ),
                  ),
                  /*Padding(
                    padding: const EdgeInsets.all(10),
                    child: InternationalPhoneNumberInput(
                      onSaved: (value) {
                        _auth["phoneNumber"] = value.toString();
                      },
                      onInputChanged: (PhoneNumber number) {},
                      onInputValidated: (bool value) {},
                      selectorConfig: const SelectorConfig(

                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          trailingSpace: false),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      // selectorTextStyle: const TextStyle,
                      initialValue: PhoneNumber(isoCode: "ET"),
                      formatInput: true,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      spaceBetweenSelectorAndTextField: 0,
                      inputDecoration: InputDecoration(
                          hintText: Localization.of(context)
                              .getTranslation("phone_number_hint_text"),
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            // color: Colors.black45
                          ),
                          // fillColor: Colors.white,
                          filled: true,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none)),
                    ),
                  ),
                  */
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, top: 10, right: 15, bottom: 10),
                    child: TextFormField(
                      obscureText: _visiblePassword,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: Localization.of(context)
                            .getTranslation("password_hint_text"),
                        labelStyle: TextStyle(color: themeProvider.getColor
                          // color: Colors.black45
                        ),
                        prefixIcon: const Icon(
                          Icons.vpn_key,
                          size: 19,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.solid)),
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
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return Localization.of(context).getTranslation(
                              "signin_form_empity_password_validation");
                        } else if (value.length < 4) {
                          return getTranslation(
                              "signin_form_short_password_validation");
                        } else if (value.length > 25) {
                          return getTranslation(
                              "signin_form_long_password_validation");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _auth["password"] = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                final form = _formkey.currentState;
                                if (form!.validate()) {
                                  form.save();
                                  signIn();
                                }
                              },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Text(
                              getTranslation("signin_title"),
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Container(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, MobileVerification.routeName);
                          },
                          child: Text(
                            getTranslation("signin_forgot_passwod_text")+"?",
                            style: Theme.of(context).textTheme.button,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(getTranslation("singim_dont_have_an_account_text")),
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, SignupScreen.routeName);
                            },
                            child: Text(getTranslation("signin_inkwell_text"),
                                style: Theme.of(context).textTheme.button))
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${getTranslation("language")}:"),
                      const SizedBox(
                        width: 10,
                      ),
                      BlocBuilder<LocaleCubit, Locale>(
                        builder: (context, state) => DropdownButton(
                            dropdownColor: Colors.white,
                            value: state == const Locale("en", "US")
                                ? "English"
                                : "Amharic",
                            items: dropDownItems
                                .map((e) => DropdownMenuItem(
                                      child: Text(e,style: TextStyle(color: Colors.black),),
                                      value: e,
                                    ))
                                .toList(),
                            onChanged: (value) {
                              switch (value) {
                                case "Amharic":
                                  context
                                      .read<LocaleCubit>()
                                      .changeLocale(const Locale("am", "ET"));

                                  break;
                                case "English":
                                  context
                                      .read<LocaleCubit>()
                                      .changeLocale(const Locale("en", "US"));

                                  break;
                                default:
                                  context
                                      .read<LocaleCubit>()
                                      .changeLocale(const Locale("en", "US"));
                              }
                            }),
                      )
                    ],
                  )
                ],
              )),
        ),
      )
    ]);
  }

  final List<String> dropDownItems = ["Amharic", "English"];

  String getTranslation(String key) {
    return Localization.of(context).getTranslation(key);
  }

  var textLength = 0;
  var phoneEnabled = true;
}

// Navigator.pushNamedAndRemoveUntil(
//             context, HomeScreen.routeName, ((Route<dynamic> route) => false),
//             arguments:
//                 HomeScreenArgument(isSelected: false, isFromSplash: true));
