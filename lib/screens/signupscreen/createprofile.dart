import 'dart:io';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/widgets.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:email_validator/email_validator.dart';

class CreateProfileScreen extends StatefulWidget {
  static const routeName = "/createprofile";
  final CreateProfileScreenArgument args;

  CreateProfileScreen({Key? key, required this.args}) : super(key: key);

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final password = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  XFile? _image;
  final Map<String, dynamic?> _user = {};
  bool _isLoading = false;

  _showModalNavigation() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            child: ListTile(
              leading: Icon(Icons.image),
              title: Text("Gallery"),
              onTap: () async {
                print("heyyyyyyyyyyyyyyyyyyyyy");
                XFile? image = (await ImagePicker.platform.getImage(
                  source: ImageSource.gallery,
                )

                    // .pickImage(
                    //   source:
                    //   maxHeight: 400,
                    //   maxWidth: 400,
                    // )
                    );
                print("testtttttttttttttttttttttttttttttttttttttttttttt");

                print(image.toString() +
                    "testtttttttttttttttttttttttttttttttttttttttttttt");
                setState(() {
                  _image = image;
                });
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<UserBloc, UserState>(
      listener: (_, state) {
        if (state is UserLoading) {
          _isLoading = true;
        }
        if (state is UsersLoadSuccess) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext con) => AlertDialog(
                    title: const Text("Thankyou"),
                    content: const Text.rich(TextSpan(
                      text:
                          "Thank you for registering with SafeWay. Please complete your registration and be activated by visiting our office.",
                    )),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, HomeScreen.routeName,
                                arguments:
                                    HomeScreenArgument(isSelected: false));

                            Navigator.pop(con);
                          },
                          child: const Text("Okay")),
                    ],
                  ));
        }
        if (state is UserOperationFailure) {
          _isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Failed To Create profile"),
            backgroundColor: Colors.red.shade900,
            action:
                SnackBarAction(label: "Try Again", onPressed: createProfile),
          ));
        }
      },
      builder: (_, state) {
        return _buildProfileForm();
      },
    ));
  }

  void createProfile() {
    setState(() {
      _isLoading = true;
    });
    UserEvent event = UserCreate(User(
        firstName: _user["first_name"],
        password: _user["password"],
        phoneNumber: widget.args.phoneNumber,
        lastName: _user["last_name"],
        gender: "Male",
        email: _user["email"],
        emergencyContact: _user["phone_number"]));

    BlocProvider.of<UserBloc>(context).add(event);
  }

  Widget _buildProfileForm() {
    return Stack(
      children: [
        CustomeBackArrow(),
        Padding(
          padding:
              const EdgeInsets.only(top: 80, right: 20, left: 20, bottom: 10),
          child: Form(
            key: _formKey,
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Create Profle",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24.0),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showModalNavigation();
                          },
                          child: CircleAvatar(
                            radius: 40,
                            child: _image == null
                                ? Container()
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Stack(
                                      children: [
                                        Container(
                                          child: Image.file(
                                            File(_image!.path),
                                            fit: BoxFit.cover,
                                          ),
                                          width: 300,
                                          height: 300,
                                        ),
                                        Positioned(
                                          top: 4.0,
                                          right: 4.0,
                                          child: IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {},
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Full Name",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.black45),
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Your Name';
                            } else if (value.length > 25) {
                              return 'Full name must not be longer than 25 charachters';
                            } else if (value.length < 4) {
                              return 'Full name must not be shorter than 4 charachters';
                            } else if (value.split(" ").length == 1) {
                              return ' Last Name required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            //final val = value!.split("")[0];
                            //print();
                            _user["first_name"] = value!.split(" ")[0];
                            _user["last_name"] = value.split(" ")[1];
                          },
                        ),
                        TextFormField(
                            controller: password,
                            decoration: const InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black45),
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Your Name';
                              } else if (value.length > 25) {
                                return 'Full name must not be longer than 25 charachters';
                              } else if (value.length < 8) {
                                return 'Full name must not be shorter than 8 charachters';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _user["password"] = value;
                            }),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Confirm Password",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.black45),
                          ),
                          validator: (value) {
                            if (value != password.text) {
                              return 'Password must match';
                            }
                            return null;
                          },
                        ),
                        InternationalPhoneNumberInput(
                          onInputChanged: (val) {},
                          hintText: "Emergency Contact number",
                          onSaved: (value) {
                            _user["emergency_contact"] = value;
                          },
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          selectorTextStyle:
                              const TextStyle(color: Colors.black),
                          initialValue: PhoneNumber(isoCode: "ET"),
                          formatInput: false,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                        ),
                        TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Email",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black45),
                            ),
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                return EmailValidator.validate(value)
                                    ? null
                                    : "Please enter a valid email";
                              }
                            },
                            onSaved: (value) {
                              _user["email"] = value;
                            }),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Promo/Referal Code",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.black45),
                            fillColor: Colors.white,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Text(
                              """By continuing, iconfirm that i have read
                              & agree to the Terms & conditions and 
                              Privacypolicy""",
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black54,
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
                                      const Text("Register",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      const Spacer(),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: _isLoading
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
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
          ),
        ),
      ],
    );
  }
}
