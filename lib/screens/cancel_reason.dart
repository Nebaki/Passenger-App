import 'package:flutter/material.dart';

class CancelReason extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.clear,
              color: Colors.black,
            )),
        title: const Text("Cancel Trip"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                _builReasonItem(context: context, text: "Rider isn't here"),
                _builReasonItem(context: context, text: "Wrong address shown"),
                _builReasonItem(context: context, text: "Don't charge rider"),
                _builReasonItem(context: context, text: "Don't charge rider"),
                _builReasonItem(context: context, text: "Don't charge rider"),
                _builReasonItem(context: context, text: "Don't charge rider"),
              ],
            ),
            SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Confirm",
                      style: TextStyle(color: Colors.white),
                    )))
          ],
        ),
      ),
    );
  }

  Widget _builReasonItem({required context, required String text}) {
    return Column(
      children: [
        ListTile(
          leading: Radio(
            value: "value",
            groupValue: "groupValue",
            onChanged: (value) {},
          ),
          title: Text(text),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 65, right: 20),
          child: Divider(color: Colors.grey.shade200),
        ),
      ],
    );
  }
}
