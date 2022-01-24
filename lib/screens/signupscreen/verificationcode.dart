import 'package:flutter/material.dart';

class PhoneVerification extends StatelessWidget {
  static const routeName = '/phoneverification';
  final otpController = TextEditingController();

  // void moveToNextScreen(context) {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => Cards()));
  // }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
          title: const Text('OTP Verification'),
          backgroundColor: Colors.green[900]),
      body: Container(
        margin: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Verification Code Sent',
              style: TextStyle(color: Colors.green[900], fontSize: 24.0),
            ),
            const Text(
              'Enter the verification code sent to you',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 50.0,
                    child: TextFormField(
                      controller: otpController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 26.0),
                      onChanged: (value) {
                        if (value.length == 1) node.nextFocus();
                      },
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          counterText: "",
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    )),
                SizedBox(
                    width: 50.0,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 26.0),
                      onChanged: (value) {
                        if (value.length == 1) node.nextFocus();
                      },
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          counterText: "",
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    )),
                SizedBox(
                    width: 50.0,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 26.0),
                      onChanged: (value) {
                        if (value.length == 1) node.nextFocus();
                      },
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          counterText: "",
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    )),
                SizedBox(
                    width: 50.0,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 26.0),
                      onChanged: (value) {
                        if (value.length == 1) node.nextFocus();
                      },
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          counterText: "",
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    )),
                SizedBox(
                    width: 50.0,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 26.0),
                      onChanged: (value) {
                        if (value.length == 1) node.nextFocus();
                      },
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          counterText: "",
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    )),
                SizedBox(
                    width: 50.0,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 26.0),
                      onChanged: (value) {
                        if (value.length == 1) node.nextFocus();
                      },
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          counterText: "",
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    )),
              ],
            ),
            const SizedBox(
              height: 50.0,
            ),
            Container(
                margin: const EdgeInsets.only(left: 60.0),
                child: Row(
                  children: const [
                    Text(
                      "Didn't receive the code?",
                      style: TextStyle(fontSize: 17.0),
                    ),
                    InkWell(
                        child: Text(' RESEND',
                            style:
                                TextStyle(color: Colors.blue, fontSize: 17.0))),
                  ],
                )),
            Container(
                margin: const EdgeInsets.only(top: 20.0),
                width: 200.0,
                height: 40.0,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Verify',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.green[900]),
                )),
          ],
        ),
      ),
    );
  }
}
