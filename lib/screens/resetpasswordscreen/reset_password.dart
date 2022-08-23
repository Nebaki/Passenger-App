import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/signinscreen/signin.dart';
import 'package:passengerapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../utils/waver.dart';
import '../theme/theme_provider.dart';

class ResetPassword extends StatefulWidget {
  final ResetPasswordArgument arg;
  ResetPassword({Key? key, required this.arg}) : super(key: key);

  static const routeName = "/resetpassword";

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formkey = GlobalKey<FormState>();

  final newPassword = TextEditingController();

  final Map<String, String> _forgetPasswordInfo = {};

  bool _isLoading = false;

  late ThemeProvider themeProvider;

  @override
  void initState() {
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
              builder: (context, state) => resetPasswordForm(context),
              listener: (context, state) {
                if (state is UserPasswordChanged) {
                  _isLoading = false;

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(getTranslation(context, "password_changed")),
                      backgroundColor: Colors.green.shade900));

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    SigninScreen.routeName,
                    ((Route<dynamic> route) => false),
                  );
                  // Navigator.pop(context);
                }
                if (state is UserOperationFailure) {
                  _isLoading = false;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          getTranslation(context, "operation_failure_message")),
                      backgroundColor: Colors.red.shade900));
                }
              }),
        ],
      ),
    );
  }

  void forgetPassword(BuildContext context) {
    _isLoading = true;
    BlocProvider.of<UserBloc>(context)
        .add(UserForgetPassword(_forgetPasswordInfo));
  }

  Widget resetPasswordForm(BuildContext context) {
    return Stack(children: [
      Form(
        key: _formkey,
        child: SizedBox(
          height: 600,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 200, 20, 20),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    obscureText: true,
                    controller: newPassword,
                    decoration: InputDecoration(
                        labelText:
                            getTranslation(context, "new_password_hint_text"),
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        prefixIcon: const Icon(
                          Icons.vpn_key,
                          size: 19,
                        ),
                        // fillColor: Colors.white,
                        // filled: true,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return getTranslation(
                            context, "signin_form_empity_password_validation");
                      } else if (value.length < 4) {
                        return getTranslation(context,
                            "create_profile_short_password_validation");
                      } else if (value.length > 25) {
                        return getTranslation(
                            context, "create_profile_long_password_validation");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      newPassword.text = value!;
                      _forgetPasswordInfo['new_password'] = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: getTranslation(
                            context, "confirm_password_hint_text"),
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        prefixIcon: const Icon(
                          Icons.vpn_key,
                          size: 19,
                        ),
                        // fillColor: Colors.white,
                        // filled: true,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none)),
                    validator: (value) {
                      if (value != newPassword.text) {
                        return 'Password must match';
                      }
                      return null;
                    },
                    //onSaved: ,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                _forgetPasswordInfo['phone_number'] =
                                    widget.arg.phoneNumber;
                                forgetPassword(context);
                              }
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Text(
                            getTranslation(context, "reset"),
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      const CustomeBackArrow(),
      // Padding(
      //   padding: const EdgeInsets.only(top: 50),
      //   child: Column(
      //     children: [
      //       Align(
      //           alignment: Alignment.topCenter,
      //           child: Text(
      //             getTranslation(context, "award"),
      //             style: Theme.of(context).textTheme.titleLarge,
      //           )),
      //           const Divider(thickness: 0.5,)
      //     ],
      //   ),
      // )
    ]);
  }
}
