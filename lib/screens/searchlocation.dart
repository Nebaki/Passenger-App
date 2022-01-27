import 'package:flutter/material.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/searchlocation";
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: Column(
          children: [
            TextField(),
            TextField(),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, HomeScreen.routeName,
                      arguments: HomeScreenArgument(isSelected: true));
                },
                child: const Text("Continue"))
          ],
        ),
      ),
    );
  }
}
