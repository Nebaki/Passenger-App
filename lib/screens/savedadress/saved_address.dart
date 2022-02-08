import 'package:flutter/material.dart';
import 'package:passengerapp/widgets/widgets.dart';

class SavedAddress extends StatelessWidget {
  static const routeName = "/savedadresses";
  @override
  Widget build(BuildContext context) {
    final items = List<String>.generate(10, (i) => 'Item ${i + 1}');
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: WhereTo(),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: MediaQuery.of(context).size.height - 280,
                child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFE6E6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Spacer(),
                              Icon(
                                Icons.delete_outlined,
                                color: Colors.redAccent,
                              )
                              //SvgPicture.asset("assets/icons/Trash.svg"),
                            ],
                          ),
                        ),
                        key: Key("item."),
                        child: _historyItem(
                            context: context,
                            text: "Arat Killo",
                            routename: "routename"),
                      );
                    }))
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
