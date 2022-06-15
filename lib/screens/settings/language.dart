import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/cubit/cubits.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/rout.dart';

class Language extends StatelessWidget {
  static const routName = "/languageScreen";
  final LanguageArgument args;
  Language({Key? key, required this.args}) : super(key: key);
  final List<String> supportedLanguages = ["am", "us"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslation(context, "language")),
      ),
      body: Column(
        children: [
          RadioListTile(
            value: supportedLanguages[0],
            groupValue: supportedLanguages[args.index],
            onChanged: (value) {
              BlocProvider.of<LocaleCubit>(context)
                  .changeLocale(const Locale("am", "ET"));
              Navigator.pop(context);
            },
            title: const Text("Amharic"),
          ),
          RadioListTile(
            value: supportedLanguages[1],
            groupValue: supportedLanguages[args.index],
            onChanged: (value) {
              BlocProvider.of<LocaleCubit>(context)
                  .changeLocale(const Locale("en", "US"));
              Navigator.pop(context);
            },
            title: const Text("English"),
          )
        ],
      ),
    );
  }
}
