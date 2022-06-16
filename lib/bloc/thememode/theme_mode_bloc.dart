// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// enum MyThemeModes { light, dark }

class ThemeModeCubit extends Cubit<ThemeMode> {
  ThemeModeCubit(ThemeMode initialState) : super(initialState);

  void ActivateDarkTheme() => emit(ThemeMode.dark);
  void ActivateLightTheme() => emit(ThemeMode.light);
}



// import 'package:equatable/equatable.dart';

// abstract class ThemeModEvent extends Equatable {
//   const ThemeModEvent();
// }

// class ActivateDarkTheme extends ThemeModEvent {
//   @override
//   List<Object?> get props => [];

// }

// class ActivateLighTheme extends ThemM

// class ThemeModeState extends Equatable {
//   const ThemeModeState();

//   @override
//   List<Object?> get props => [];
// }

// class DarkThemeModeActivated extends ThemeModeState {}

// class LightThemeModeActivated extends ThemeModeState {}
