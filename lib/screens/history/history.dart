import 'package:flutter/material.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/widgets.dart';

class HistoryPage extends StatelessWidget {
  final _textStyle = TextStyle(fontSize: 20);

  static const routeName = "/history";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          "Trips",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        children: List.generate(10, (index) => _builHistoryCard(context)
            //_savedItems(context: context, text: "Mon, 18 Feb")
            ),
      ),
    );
  }

  Widget _savedItems({
    required BuildContext context,
    required String text,
  }) {
    const color = Colors.grey;
    const hoverColor = Colors.white70;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          trailing: Text(
            "\$40",
            style: _textStyle,
          ),
          //leading: Icon(Icons.history, color: color.shade700),
          title: Text(text, style: _textStyle),
          subtitle: Text(
            "25 Trips",
          ),
          hoverColor: hoverColor,
          onLongPress: () {},
          onTap: () {
            Navigator.pushNamed(context, DetailHistoryScreen.routeName);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Divider(color: Colors.grey.shade400),
        )
      ],
    );
  }

  Widget _builHistoryCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, DetailHistoryScreen.routeName);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    blurStyle: BlurStyle.normal,
                    color: Colors.grey.shade200,
                    blurRadius: 8,
                    spreadRadius: 8)
              ]),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        color: Colors.grey,
                        child: const Text("P",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        "700 Mathew St.",
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        "San Joes",
                        style: TextStyle(color: Colors.black38),
                      )
                    ],
                  )
                ],
              ),
              const Divider(),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "05/02/2022",
                        style: TextStyle(color: Colors.black38),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "10:16 AM",
                        style: TextStyle(color: Colors.black38),
                      ),
                    ],
                  ),
                  const Text(
                    "\$15",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
