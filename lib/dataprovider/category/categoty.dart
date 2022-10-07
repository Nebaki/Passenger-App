import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/auth/auth.dart';
import 'package:passengerapp/helper/api_end_points.dart' as api;
import 'package:passengerapp/models/models.dart';

import '../../utils/session.dart';

class CategoryDataProvider {
  final http.Client httpClient;

  CategoryDataProvider({required this.httpClient});
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());

  Future<List<Category>> getCategories() async {
    Session().logSession("cats", "init-request");
    final http.Response response = await httpClient.get(
        Uri.parse(api.CategoryEndPoints.getCategoriesEndPoint()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-access-token': '${await authDataProvider.getToken()}'
        });
    Session().logSession("cats", response.body);
    if (response.statusCode == 200) {
      Session().logSession("home", response.body);
      try{
        Session().logSession("door", response.body);
        var jsonResponse = jsonDecode(response.body)['items'] as List;
        Session().logSession("inter", response.body);
        return jsonResponse.map((e) => Category.fromJson(e)).toList();
      }catch(e){
        Session().logSession("hell", response.body);
        throw e.toString();
      }
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();
      if (res.statusCode == 200) {
        return getCategories();
      } else {
        throw Exception(response.statusCode);
      }
    }else {
      Session().logSession("cats-failed", "cat error");
      throw Exception(response.statusCode);
    }
  }
}
