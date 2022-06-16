import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocaleCubit extends Cubit<Locale> {
  final storage = const FlutterSecureStorage();
  LocaleCubit() : super(const Locale("en", 'US'));

  void changeLocale(Locale locale) {
    storage.write(key: "languageCode", value: locale.languageCode);
    storage.write(key: "countryCode", value: locale.countryCode);

    emit(locale);
  }

  void getLocal() async {
    final languageCode = await storage.read(key: "languageCode") ?? "en";
    final countryCode = await storage.read(key: "countryCode") ?? "US";
    emit(Locale(languageCode, countryCode));
  }
}
