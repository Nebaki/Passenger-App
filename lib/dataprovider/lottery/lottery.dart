import 'dart:convert';
import 'dart:math';

// import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../../models/auth/auth.dart';
import '../../models/lottery/award.dart';
import '../../models/lottery/ticket.dart';
import '../../utils/session.dart';
import '../auth/auth.dart';
import '../header/header.dart';

class LotteryDataProvider {
  final _baseUrl = RequestHeader.baseURL + 'lottery-numbers';
  final _baseUrlA = RequestHeader.baseURL + 'awards';
  final http.Client httpClient;

  AuthDataProvider authDataProvider =
  AuthDataProvider(httpClient: http.Client());
  LotteryDataProvider({required this.httpClient});

  Future<LotteryStore> loadLotteryTickets(page, limit) async {
    String user = await authDataProvider.getUserId() ?? "null";
    final http.Response response = await http.get(
      Uri.parse('$_baseUrl/get-my-lottery-numbers?'
          'driver_id=$user&orderBy[0].[field]=createdAt&'
          'orderBy[0].[direction]=desc&top=$limit&skip=$page'),
      headers: await RequestHeader().authorisedHeader(),
    );
    Session().logSession("lottery", "user: $user -> ${response.statusCode.toString()}");
    if (response.statusCode == 200) {
      Session().logSession("ticket", "success");

      final List maps = jsonDecode(response.body)['items'];
      final int size = jsonDecode(response.body)['total'];
      List<Ticket> lotteries = maps.map((job) => Ticket.fromJson(job)).toList();

      Session().logSession("ticket", response.body);
      return LotteryStore(lotteries: lotteries,total: size);
      //return CreditStore.fromJson(jsonDecode(response.body));
    } else {
      Session().logSession("ticket", "failure");
      List<Ticket> lotteries = [];
      int i = 0;
      while (i < 10) {
        var rng = Random();
        int money = rng.nextInt(100) * i + 237;
        var type = i % 2 == 0 ? 'Gift' : 'Message';
        if (i == 4 || i == 8) {
          type = "Message";
        }
        //credits.add(credit);
        i++;
      }
      if(response.statusCode == 401){
        _refreshToken(loadLotteryTickets);
      }
      return LotteryStore(lotteries: lotteries,total: 10);
    }
  }
  _refreshToken(Function function) async {
    final res =
    await AuthDataProvider(httpClient: http.Client()).refreshToken();
    if (res.statusCode == 200) {
      return function();
    }
  }



  Future<AwardStore> loadLotteryAwards(page, limit) async {
    String id = await authDataProvider.getUserId() ?? "null";
    Auth user = await authDataProvider.getUserData();
    //var driverTypeR = user.vehicleType;
    //var driverType = '${driverTypeR?.toLowerCase()}_driver';
    var driverType = 'passenger';
    Session().logSession("award", "driver_type: $driverType");

    final http.Response response = await http.get(
      Uri.parse('$_baseUrlA/get-award-types-by-type?'
          'passenger_id=$id&orderBy[0].[field]=createdAt&'
          'orderBy[0].[direction]=desc&top=$limit&skip=$page'
          '&type=$driverType'
      ),
      headers: await RequestHeader().authorisedHeader(),
    );
    Session().logSession("award", "user: $user -> ${response.statusCode.toString()}");
    if (response.statusCode == 200) {
      Session().logSession("award", "success");

      final List maps = jsonDecode(response.body)['items'];
      final int size = jsonDecode(response.body)['total'];
      List<Award> awards = maps.map((job) => Award.fromJson(job)).toList();

      Session().logSession("award", 'size $size');
      return AwardStore(awards: awards,total: size);
      //return CreditStore.fromJson(jsonDecode(response.body));
    } else {
      Session().logSession("award", "failure");
      List<Award> awards = [];
      int i = 0;
      while (i < 10) {
        var rng = Random();
        int money = rng.nextInt(100) * i + 237;
        var type = i % 2 == 0 ? 'Gift' : 'Message';
        if (i == 4 || i == 8) {
          type = "Message";
        }
        i++;
      }
      if(response.statusCode == 401){
        _refreshToken(loadLotteryTickets);
      }
      return AwardStore(awards: awards,total: 10);
    }
  }
}
