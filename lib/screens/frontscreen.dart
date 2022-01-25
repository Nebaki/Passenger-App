import 'package:flutter/material.dart';
import 'package:passengerapp/screens/screens.dart';

class FrontPage extends StatelessWidget {
  const FrontPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Image(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            image: const AssetImage("assets/images/safeway.jpg"),
            fit: BoxFit.cover,
          ),
          const Align(
            alignment: Alignment.center,
            child: Image(
              image: AssetImage("assetName"),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, SigninScreen.routeName);
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, SignupScreen.routeName);
                          },
                          child: const Text("Sign Up",
                              style: TextStyle(color: Colors.white))),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
