import 'package:flutter/material.dart';
import 'package:passengerapp/screens/screens.dart';

class SigninScreen extends StatefulWidget {
  static const routeName = '/signin';
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Container(
          height: 600,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            child: ListView(
              children: [
                const Expanded(
                    child: Text(
                  "Sign In",
                  style: TextStyle(fontSize: 25),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        hintText: "Phone Number",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black45),
                        prefixIcon: Icon(
                          Icons.phone,
                          size: 19,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Your phone number';
                      }
                      return null;
                    },
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black45),
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          size: 19,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Your Password';
                      }
                      return null;
                    },
                  ),
                )),
                Expanded(
                    child: SizedBox(
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, HomeScreen.routeName);
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: InkWell(
                        onTap: () {
                          //Navigator.pushNamed(context, SigninScreen.routeName);
                        },
                        child: const Text(
                          "Forgot Password",
                          style: TextStyle(
                              color: Color.fromRGBO(39, 49, 110, 1),
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}