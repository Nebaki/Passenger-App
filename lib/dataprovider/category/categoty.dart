import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/auth/auth.dart';
import 'package:passengerapp/helper/api_end_points.dart' as API;
import 'package:passengerapp/models/models.dart';

class CategoryDataProvider {
  final http.Client httpClient;

  CategoryDataProvider({required this.httpClient});
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());

  Future<List<Category>> getCategories() async {
    final http.Response response = await httpClient.get(
        Uri.parse(API.CategoryEndPoints.getCategoriesEndPoint()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-access-token': '${await authDataProvider.getToken()}'
        });
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body)['items'] as List;
      return jsonResponse.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Can not get categories');
    }
  }
}
