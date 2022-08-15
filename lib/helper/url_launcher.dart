import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launch(launchUri.toString());
}

Future<void> sendTextMessage(String phoneNumber, String message) async {
  final Uri launchUri =
      Uri(scheme: 'sms', path: phoneNumber, queryParameters: {"body": message});
  await launch(launchUri.toString());
}

Future<void> sendTelegramMessage(String driverName, String driverNumber) async {
  String message = ''' 
  Driver Name : $driverName,
  
  Driver Phone: $driverNumber

  PickUp Location: $pickupAddress ,

  DropOff Location: $droppOffAddress,

  Plate Number: ${vehicle!["plate_number"]},

  Color: ${vehicle!["color"]},

  Model: ${vehicle!["model"]},
  
  Date: ${DateFormat.yMMMEd().format(DateTime.now())},

  Time: ${DateFormat.jm().format(DateTime.now())}
  ''';
  await FlutterShare.share(title: "Trip Detail", text: message);
  // await SocialShare.shareTelegram("content").then((value) {
  //   print("desn't load");
  //   print(value);
  // });
}
