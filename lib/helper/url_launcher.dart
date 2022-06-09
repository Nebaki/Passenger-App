import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchInBrowser(String url) async {
  if (!await launch(
    url,
    forceSafariVC: false,
    forceWebView: false,
    headers: <String, String>{'my_header_key': 'my_header_value'},
  )) {
    throw 'Could not launch $url';
  }
}

Future<void> launchInWebViewOrVC(String url) async {
  if (!await launch(
    url,
    forceSafariVC: true,
    forceWebView: true,
    headers: <String, String>{'my_header_key': 'my_header_value'},
  )) {
    throw 'Could not launch $url';
  }
}

Future<void> _launchInWebViewWithJavaScript(String url) async {
  if (!await launch(
    url,
    forceSafariVC: true,
    forceWebView: true,
    enableJavaScript: true,
  )) {
    throw 'Could not launch $url';
  }
}

Future<void> _launchInWebViewWithDomStorage(String url) async {
  if (!await launch(
    url,
    forceSafariVC: true,
    forceWebView: true,
    enableDomStorage: true,
  )) {
    throw 'Could not launch $url';
  }
}

Future<void> launchUniversalLinkIos(String url) async {
  final bool nativeAppLaunchSucceeded = await launch(
    url,
    forceSafariVC: false,
    universalLinksOnly: true,
  );
  if (!nativeAppLaunchSucceeded) {
    await launch(
      url,
      forceSafariVC: true,
    );
  }
}

// Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
//   if (snapshot.hasError) {
//     return Text('Error: ${snapshot.error}');
//   } else {
//     return const Text('');
//   }
// }

Future<void> makePhoneCall(String phoneNumber) async {
  // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
  // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
  // such as spaces in the input, which would cause `launch` to fail on some
  // platforms.
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launch(launchUri.toString());
}

Future<void> sendTextMessage(String phoneNumber, String message) async {
  // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
  // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
  // such as spaces in the input, which would cause `launch` to fail on some
  // platforms.
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
