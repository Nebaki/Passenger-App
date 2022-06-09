import 'package:flutter/material.dart';
import 'package:passengerapp/helper/constants.dart';

class ThemesData {
  static final darkTheme = ThemeData(
      primaryIconTheme: IconThemeData(color: Colors.white),
      inputDecorationTheme: InputDecorationTheme(fillColor: Colors.black),
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Colors.grey.shade900),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.grey.shade900,
          foregroundColor: Colors.white,
          extendedTextStyle: TextStyle(color: Colors.white)),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          linearTrackColor: Colors.white, color: Colors.green),
      scaffoldBackgroundColor: Colors.grey.shade900,
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        textStyle: MaterialStateProperty.all<TextStyle>(
            const TextStyle(color: Colors.black)),
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> state) =>
                  state.contains(MaterialState.disabled)
                      ? Colors.grey.shade300
                      : buttonColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w300, fontSize: 20)),
        ),
      ),
      canvasColor: Colors.white,
      backgroundColor: Colors.grey.shade900,
      textTheme: TextTheme(
        button: TextStyle(color: Colors.white60),
        // bodyLarge: TextStyle(color: Colors.black)
        // subtitle1: const TextStyle(color: Colors.black38, fontSize: 14),
        // headline5: const TextStyle(fontWeight: FontWeight.bold),
        // bodyText2: TextStyle(color: Colors.grey.shade700
        // )
      ),
      colorScheme: const ColorScheme.dark());

  static final lightTheme = ThemeData(
      primaryIconTheme: IconThemeData(color: Colors.black),
      inputDecorationTheme: InputDecorationTheme(fillColor: Colors.white),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: backGroundColor),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.indigo.shade900,
          extendedTextStyle: TextStyle(color: Colors.indigo.shade900)),
      backgroundColor: backGroundColor,
      scaffoldBackgroundColor: backGroundColor,
      primaryColor: const Color.fromRGBO(254, 79, 5, 1),
      textTheme: TextTheme(
          button: TextStyle(color: Colors.indigo.shade900),
          subtitle1: const TextStyle(color: Colors.black38, fontSize: 14),
          headline5: const TextStyle(fontWeight: FontWeight.bold),
          bodyText2: TextStyle(color: Colors.grey.shade700)),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        textStyle: MaterialStateProperty.all<TextStyle>(
            const TextStyle(color: Colors.black)),
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> state) =>
                  state.contains(MaterialState.disabled)
                      ? Colors.grey.shade300
                      : buttonColor),
          // backgroundColor: MaterialStateProperty.all<Color>(
          //     const Color.fromRGBO(244, 201, 60, 1)),
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