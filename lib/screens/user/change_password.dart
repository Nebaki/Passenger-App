import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:provider/provider.dart';
import '../../utils/waver.dart';
import '../theme/theme_provider.dart';

class ChangePassword extends StatefulWidget {
  static const routeName = '/changepassword';

  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formkey = GlobalKey<FormState>();

  final Map<String, String> _passwordInfo = {};

  bool _isLoading = false;

  final oldPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
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

  final _appBar = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: SafeAppBar(
        key: _appBar, title: getTranslation(context, "change_password"),
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: SizedBox(
            // color: const Color.fromRGBO(240, 241, 241, 1),
            //height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
                    padding: const EdgeInsets.only(left: 10,top: 100,right: 10),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: oldPasswordController,
                              autofocus: true,
                              obscureText: _visiblePassword,
                              style: const TextStyle(fontSize: 18),
                              decoration: InputDecoration(
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
                                }else if (value.length < 4) {
                                  return getTranslation(
                                      context, "create_profile_short_password_validation");
                                } else if (value.length > 25) {
                                  return getTranslation(
                                      context, "create_profile_long_password_validation");
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
                              controller: passwordController,
                              obscureText: _visiblePassword,
                              style: const TextStyle(fontSize: 18),
                              decoration: InputDecoration(
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
                                  return "New Password cannot be same as old password";
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
                            TextFormField(
                              controller: confirmPasswordController,
                              obscureText: _visiblePassword,
                              style: const TextStyle(fontSize: 18),
                              decoration: InputDecoration(
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
                                if (value != passwordController.text) {
                                  return "Password does not match";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _passwordInfo['confirm_password'] = value!;
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
                                        final form = _formkey.currentState;
                                        if (form!.validate()) {
                                          form.save();
                                          if(oldPasswordController.text != passwordController.text){
                                            changePassword(context);
                                          }else{
                                            ShowSnack(context: context,message:"New Password cannot be same as old password",
                                            textColor: Colors.white,backgroundColor: Colors.red);
                                          }
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
                    ),
                  ),
          ),
        ));
  }
}
