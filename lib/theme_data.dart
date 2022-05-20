import 'package:flutter/material.dart';
import 'package:passengerapp/helper/constants.dart';

class ThemesData {
  static final darkTheme = ThemeData(
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.grey.shade900,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          linearTrackColor: Colors.white, color: Colors.green),
      scaffoldBackgroundColor: Colors.grey.shade900,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromRGBO(244, 201, 60, 1)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w300, fontSize: 20)),
        ),
      ),
      canvasColor: Colors.white,
      backgroundColor: Colors.grey.shade900,
      textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.black)),
      colorScheme: const ColorScheme.dark());

  static final lightTheme = ThemeData(
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.grey.shade300,
      ),
      backgroundColor: backGroundColor,
      scaffoldBackgroundColor: backGroundColor,
      primaryColor: const Color.fromRGBO(254, 79, 5, 1),
      textTheme: TextTheme(
          button: const TextStyle(
            color: Color.fromRGBO(254, 79, 5, 1),
          ),
          subtitle1: const TextStyle(color: Colors.black38, fontSize: 14),
          headline5: const TextStyle(fontWeight: FontWeight.bold),
          bodyText2: TextStyle(color: Colors.grey.shade700)),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
        textStyle: MaterialStateProperty.all<TextStyle>(
            const TextStyle(color: Colors.black)),
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromRGBO(244, 201, 60, 1)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w300, fontSize: 20)),
        ),
      ),
      canvasColor: Colors.indigo,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green,
      ).copyWith(secondary: Colors.grey.shade600));
}



 // backgroundColor: MaterialStateProperty.all<Color>(
          //     const Color.fromRGBO(254, 79, 5, 1)),
          // shape:
          //     MaterialStateProperty.all<RoundedRectangleBorder>(
          //         RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(80),
          // ))