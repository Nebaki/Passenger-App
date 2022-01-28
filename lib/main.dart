import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:passengerapp/rout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();

    return MaterialApp(
      title: 'SafeWay',
      theme: ThemeData(
          //F48221
          primaryColor: const Color.fromRGBO(254, 79, 5, 1),
          textTheme: TextTheme(
              button: TextStyle(
                color: const Color.fromRGBO(254, 79, 5, 1),
              ),
              subtitle1: TextStyle(color: Colors.black38, fontSize: 14),
              headline5: TextStyle(fontWeight: FontWeight.bold),
              bodyText2: TextStyle(color: Colors.grey.shade700)),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
            textStyle: MaterialStateProperty.all<TextStyle>(
                const TextStyle(color: Colors.black)),
          )),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(254, 79, 5, 1)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80),
                ))),
          ),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.orange,
          ).copyWith(secondary: Colors.grey.shade600)),
      onGenerateRoute: AppRoute.generateRoute,
    );
  }
}
