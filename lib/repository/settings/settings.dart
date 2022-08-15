import 'package:passengerapp/dataprovider/settings/settings.dart';
import 'package:passengerapp/models/models.dart';

class SettingsRepository {
  final SettingsDataProvider settingsDataProvider;
  const SettingsRepository({required this.settingsDataProvider});

  Future<Settings> getSettings (){
    return settingsDataProvider.getSettings();
  }
}