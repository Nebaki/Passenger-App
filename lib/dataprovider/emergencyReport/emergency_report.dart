import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';

class EmergencyReportDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/emergency-reports';
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());

  EmergencyReportDataProvider({required this.httpClient});

  Future<void> createEmergencyReport(EmergencyReport emergencyReport) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create-emergency-report'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "x-access-token": '${await authDataProvider.getToken()}'
      },
      body: json.encode({
        'location': [emergencyReport.location[0], emergencyReport.location[1]]
      }),
    );

    if (response.statusCode == 200) {
      // final data = jsonDecode(response.body);
      // return da
    } else {
      throw Exception('Failed to create emergencyReport.');
    }
  }
}
