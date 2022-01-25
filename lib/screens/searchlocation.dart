import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/searchlocation";
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(),
          TextField(),
        ],
      ),
    );
  }
}
