import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/signinscreen/signin.dart';
import 'package:passengerapp/widgets/widgets.dart';

class ResetPassword extends StatelessWidget {
  final ResetPasswordArgument arg;
  ResetPassword({Key? key, required this.arg}) : super(key: key);

  static const routeName = "/resetpassword";
  final _formkey = GlobalKey<FormState>();
  final newPassword = TextEditingController();
  final Map<String, String> _forgetPasswordInfo = {};
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0.3,
      //   backgroundColor: Colors.white,
      //   iconTheme: const IconThemeData(color: Colors.black),
      //   title: Text(getTranslation(context, "reset_password")),
      //   centerTitle: true,
      // ),
      body: BlocConsumer<UserBloc, UserState>(
          builder: (context, state) => resetPasswordForm(context),
          listener: (context, state) {
            if (state is UserPasswordChanged) {
              _isLoading = false;

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(getTranslation(context, "password_changed")),
                  backgroundColor: Colors.green.shade900));

              Navigator.pushReplacementNamed(context, SigninScreen.routeName);
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
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: newPassword,
                    decoration: InputDecoration(
                        hintText:
                            getTranslation(context, "new_password_hint_text"),
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.bold, ),
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
                    decoration: InputDecoration(
                        hintText: getTranslation(
                            context, "confirm_password_hint_text"),
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.bold,),
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
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              final form = _formkey.currentState;
                              if (form!.validate()) {
                                form.save();
                                _forgetPasswordInfo['phone_number'] =
                                    arg.phoneNumber;
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
