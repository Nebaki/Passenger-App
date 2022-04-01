import '../../models/trips/models.dart';
import '../../utils/constants.dart';
import '../../utils/session.dart';
import '../auth/auth.dart';

import 'package:http/http.dart' as http;
class RequestHeader{
  static const String baseURL = "https://safeway-api.herokuapp.com/api/";
  AuthDataProvider authDataProvider =
  AuthDataProvider(httpClient: http.Client());
  Future<Map<String,String>>? authorisedHeader() async => <String,String>{
    'Content-Type': 'application/json',
    'x-access-token': '${await authDataProvider.getToken()}'};

  Future<Map<String,String>>? defaultHeader() async => <String,String>{
    'Content-Type': 'application/json',
    'app-key': '123456'};
}
class RequestResult{
  Result requestResult(code, String body){
    Session().logSession("response", "code: $code, body $body");
    return Result(code, prepareResult(code));
  }
  String prepareResult(code){
    switch(code){
      case Constants.anAuthorizedC:
        return Constants.anAuthorizedM;
      case Constants.accessForbiddenC:
        return Constants.accessForbiddenM;
      case Constants.notFoundC:
        return Constants.notFoundM;
      case Constants.serverErrorC:
        return Constants.serverErrorM;
      default:
        return Constants.unknownErrorM;
    }
  }
}
