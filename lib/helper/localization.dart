import 'package:flutter/cupertino.dart';
import 'package:passengerapp/localization/localization.dart';

String getTranslation(BuildContext context, String key) {
  return Localization.of(context).getTranslation(key);
}
