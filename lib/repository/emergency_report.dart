import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/dataprovider/dataproviders.dart';

class EmergencyReportRepository {
  final EmergencyReportDataProvider dataProvider;

  EmergencyReportRepository({required this.dataProvider});

  Future<void> createEmergencyReport(EmergencyReport emergencyReport) async {
    return await dataProvider.createEmergencyReport(emergencyReport);
  }
}
