import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../utils/waver.dart';
import '../theme/theme_provider.dart';

class ChangePassword extends StatefulWidget {
  static const routeName = '/changepassword';

  ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formkey = GlobalKey<FormState>();

  final Map<String, String> _passwordInfo = {};

  bool _isLoading = false;

  late ThemeProvider themeProvider;

  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
  }

  final _appBar = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: SafeAppBar(
        key: _appBar, title: getTranslation(context, "password_changed"),
        appBar: AppBar(), widgets: []),
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
                builder: (context, state) => form(context),
                listener: (context, state) {
                  if (state is UserPasswordChanged) {
                    _isLoading = false;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(getTranslation(context, "password_changed")),
                        backgroundColor: Colors.green.shade900));
                    Navigator.pop(context);
                  }
                  if (state is UserOperationFailure) {
                    _isLoading = false;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(getTranslation(context, "operation_failure")),
                        backgroundColor: Colors.red.shade900));
                  }
                }),
          ],
        ));
  }

  void changePassword(BuildContext context) {
    _isLoading = true;
    BlocProvider.of<UserBloc>(context).add(UserChangePassword(_passwordInfo));
  }

  Widget form(BuildContext context) {
    return Form(
        key: _formkey,
        child: SizedBox(
          // color: const Color.fromRGBO(240, 241, 241, 1),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
                  padding: const EdgeInsets.only(left: 20,top: 100,right: 20),
                  child: ListView(
                    children: [
                      /*Text(getTranslation(context, "change_password"),
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(
                        height: 10,
                      ),*/
                      //Text(getTranslation(context, "edit_profile_body_text")),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      TextFormField(
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            labelText: getTranslation(
                                context, "old_password_hint_text"),
                            prefixIcon: const Icon(
                              Icons.vpn_key,
                      size: 19,
                            ),
                            // fillColor: Colors.white,
                            filled: true,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.solid)
                          ),
                        ),

                        validator: (value) {
                          if (value!.isEmpty) {
                            return getTranslation(
                                context, "enter_old_password");
                          }
                          return null;
                        },

                        onSaved: (value) {
                          _passwordInfo['current_password'] = value!;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            labelText: getTranslation(
                                context, "new_password_hint_text"),
                            prefixIcon: const Icon(
                              Icons.vpn_key,
                              size: 19,
                            ),
                            // fillColor: Colors.white,
                            filled: true,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.solid)
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return getTranslation(
                                context, "enter_new_password");
                          } else if (value.length < 4) {
                            return getTranslation(
                                context, "create_profile_short_password_validation");
                          } else if (value.length > 25) {
                            return getTranslation(
                                context, "create_profile_long_password_validation");
                          }else if(_passwordInfo['current_password'] == value){
                            return "New Password can not be same as old password";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _passwordInfo['new_password'] = value!;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: const BoxDecoration(boxShadow: [
                          // BoxShadow(
                          //     color: Colors.grey.shade300,
                          //     blurRadius: 4,
                          //     spreadRadius: 2,
                          //     blurStyle: BlurStyle.normal)
                        ]),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              labelText: getTranslation(
                                  context, "confirm_password_hint_text"),
                              prefixIcon: const Icon(
                                Icons.vpn_key,
                                size: 19,
                              ),
                              // fillColor: Colors.white,
                              filled: true,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(style: BorderStyle.solid)
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return getTranslation(
                                  context, "please_confirm_the_password");
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _passwordInfo['confirm_password'] = value!;
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
                                  final form = _formkey.currentState;
                                  if (form!.validate()) {
                                    form.save();
                                    changePassword(context);
                                  }
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              Text(
                                getTranslation(context, "change_password"),
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
                      )
                    ],
                  ),
                ),
        ));
  }
}
