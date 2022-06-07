import 'package:flutter/material.dart';
import 'package:passengerapp/screens/screens.dart';

class FrontPage extends StatelessWidget {
  const FrontPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            //color: Colors.black,
            child: Image(
              color: Colors.black.withOpacity(0.2),
              colorBlendMode: BlendMode.darken,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              image: const AssetImage("assets/images/safeway.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 4.5,
            //alignment: Alignment.center,
            child: Image(
              height: 250,
              image: AssetImage("assets/icons/logo.png"),
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
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, SigninScreen.routeName);
                          },
                          child: const Text(
                            "Sign In",
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, SignupScreen.routeName);
                          },
                          child: const Text(
                            "Sign Up",
                          )),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
