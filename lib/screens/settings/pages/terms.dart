import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../utils/waver.dart';

class TermsAndConditionScreen extends StatefulWidget {
  static const routeName = "/terms";

  const TermsAndConditionScreen({Key? key}) : super(key: key);
  @override
  LoadTermsAndConditions createState() => LoadTermsAndConditions();
}

class LoadTermsAndConditions extends State<TermsAndConditionScreen> {

  bool isLoading=true;
  final _key = UniqueKey();
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }
  final _appBar = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SafeAppBar(
            key: _appBar, title: "Terms and Conditions",
            appBar: AppBar(), widgets: []),
      body: Stack(
        children: <Widget>[
          WebView(
            key: _key,
            initialUrl: 'https://flutter.dev',
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading ? const Center( child: CircularProgressIndicator(),)
              : Stack(),
        ],
      )
    );
  }
}
