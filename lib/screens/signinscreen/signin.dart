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

  bool _isLoading = false;
  void _getSettings() {
    context.read<SettingsBloc>().add(SettingsStarted());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: const Color.fromRGBO(240, 241, 241, 1),
        body: BlocConsumer<AuthBloc, AuthState>(builder: (_, state) {
      return _buildSigninForm();
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
    }));
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

  Widget _buildSigninForm() {
    return Stack(children: [
      BlocConsumer<SettingsBloc,SettingsState>(builder: (context, state) => Container(), listener: (context, state){
        if (state is SettingsLoadSuccess){
          Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.routeName, ((Route<dynamic> route) => false),
            arguments:
                HomeScreenArgument(settings: state.settings, isSelected: false, isFromSplash: true));
        }
      }),
      Form(
        key: _formkey,
        child: SizedBox(
          height: 600,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: ListView(
                children: [
                  Text(
                    Localization.of(context).getTranslation("signin_title"),
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  Padding(
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
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          hintText: Localization.of(context)
                              .getTranslation("password_hint_text"),
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            // color: Colors.black45
                          ),
                          prefixIcon: const Icon(
                            Icons.vpn_key,
                            size: 19,
                          ),
                          // fillColor: Colors.white,
                          filled: true,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none)),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 40,
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
                                        color: Colors.black,
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
                            getTranslation("signin_forgot_passwod_text"),
                            style: Theme.of(context).textTheme.button,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(getTranslation("singim_dont_have_an_account_text"),
                            style: const TextStyle(fontSize: 16)),
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
                            dropdownColor: Theme.of(context).backgroundColor,
                            value: state == const Locale("en", "US")
                                ? "English"
                                : "Amharic",
                            items: dropDownItems
                                .map((e) => DropdownMenuItem(
                                      child: Text(e),
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
}




// Navigator.pushNamedAndRemoveUntil(
//             context, HomeScreen.routeName, ((Route<dynamic> route) => false),
//             arguments:
//                 HomeScreenArgument(isSelected: false, isFromSplash: true));