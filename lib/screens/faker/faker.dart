import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/account/trip_test.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';

class Faker extends StatelessWidget {
  static const routeName = "/faker";

  final _textStyle =
      const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
  void startFaker(){
    var trips = TripTest();
    trips.saveTrips();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.clear,
              color: Colors.black,
            )),
        title: const Text(
          "Faker",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
          return ListView(
            padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
            children: [
              Card(
                elevation: 3,
                child: InkWell(
                  onTap: startFaker,
                  child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("Saved Location")
                  ),
                )
              ),
              Card(
                elevation: 3,
                child: InkWell(
                  onTap: startFaker,
                  child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("Trip History")
                  ),
                )
              ),
            ],
          );
      }),
    );
  }

}
