// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// enum MyThemeModes { light, dark }

class ThemeModeCubit extends Cubit<ThemeMode> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  ThemeModeCubit() : super(ThemeMode.system);

  void ActivateDarkTheme() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("theme_mode", "dark");
    emit(ThemeMode.dark);
  }

  void ActivateLightTheme() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("theme_mode", "light");

    emit(ThemeMode.light);
  }

  void getThemeMode() async {
    final SharedPreferences prefs = await _prefs;
    final themeMode = prefs.getString("theme_mode");

    emit(themeMode == "light"
        ? ThemeMode.light
        : themeMode == "dark"
            ? ThemeMode.dark
            : ThemeMode.system);
  }
}
