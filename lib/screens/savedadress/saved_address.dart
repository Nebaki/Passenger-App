import 'package:flutter/material.dart';
import 'package:passengerapp/widgets/widgets.dart';

class SavedAddress extends StatelessWidget {
  static const routeName = "/savedadresses";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: WhereTo(currentLocation: "currentLocation"),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height - 280,
              child: ListView(
                children: List.generate(
                    5,
                    (index) => _historyItem(
                        context: context,
                        text: "Arat Killo",
                        routename: "routename")),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _historyItem(
      {required BuildContext context,
      required String text,
      required String routename}) {
    const color = Colors.grey;
    const hoverColor = Colors.white70;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.history, color: color.shade700),
          title: Text(text, style: Theme.of(context).textTheme.bodyText2),
          hoverColor: hoverColor,
          onLongPress: () {},
          onTap: () {
            Navigator.pushNamed(context, routename);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 65, right: 20),
          child: Divider(color: Colors.grey.shade400),
        )
      ],
    );
  }
}
