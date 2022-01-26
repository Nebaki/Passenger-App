import 'package:flutter/material.dart';

class ChangePassword extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: TextFormField(
                decoration: const InputDecoration(
                    hintText: "New Password",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black45),
                    prefixIcon: Icon(
                      Icons.phone,
                      size: 19,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter The New Password';
                  }
                  return null;
                },
              ),
            )),
            Expanded(
                child: Container(
              child: TextFormField(
                decoration: const InputDecoration(
                    hintText: "Confirm Password",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black45),
                    prefixIcon: Icon(
                      Icons.vpn_key,
                      size: 19,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm the password';
                  }
                  return null;
                },
              ),
            )),
            Expanded(
                child: TextButton(
                    onPressed: () {}, child: const Text("Reset Password")))
          ],
        ),
      ),
    );
  }
}
