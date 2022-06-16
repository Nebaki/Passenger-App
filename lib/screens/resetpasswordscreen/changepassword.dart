import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/widgets/widgets.dart';

class ChangePassword extends StatelessWidget {
  static const routeName = '/changepassword';
  final _formkey = GlobalKey<FormState>();
  final Map<String, String> _passwordInfo = {};
  bool _isLoading = false;

  ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<UserBloc, UserState>(
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
            }));
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
          child: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * 0.12,
                right: 10,
                left: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getTranslation(context, "change_password"),
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(getTranslation(context, "edit_profile_body_text")),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: getTranslation(
                                context, "old_password_hint_text"),
                            prefixIcon: const Icon(
                              Icons.phone,
                              size: 19,
                            ),
                            // fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
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
                        decoration: InputDecoration(
                            hintText: getTranslation(
                                context, "new_password_hint_text"),
                            prefixIcon: const Icon(
                              Icons.phone,
                              size: 19,
                            ),
                            // fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return getTranslation(
                                context, "enter_new_password");
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
                          decoration: InputDecoration(
                              hintText: getTranslation(
                                  context, "confirm_password_hint_text"),
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
                                          color: Colors.black,
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
              const CustomeBackArrow(),
            ],
          ),
        ));
  }
}
