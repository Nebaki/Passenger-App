import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';

class NavDrawer extends StatelessWidget {
  GlobalKey<ScaffoldState> _draweKEy = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        key: _draweKEy,
        child: Material(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 110,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black26, blurRadius: 7, spreadRadius: 3)
                  ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey.shade800,
                        // backgroundImage:
                        //     AssetImage("assets/images/restaurant4.jpg"),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Eyob Tilahun",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Text("Addis Ababa",
                              style: Theme.of(context).textTheme.subtitle1),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                height: MediaQuery.of(context).size.height - 170,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    GestureDetector(
                      onTap: () {
                        // print("YAyayyaay")
                        // _draweKEy.currentState!.close();
                      },
                      child: _menuItem(
                          divider: true,
                          context: context,
                          icon: Icons.home,
                          text: "Home"),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, SavedAddress.routeName);
                      },
                      child: _menuItem(
                          divider: true,
                          context: context,
                          icon: Icons.favorite,
                          text: "Saved Addreses"),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, HistoryPage.routeName);
                      },
                      child: _menuItem(
                          divider: true,
                          context: context,
                          icon: Icons.history,
                          text: "History"),
                    ),
                    //const Divider(color: Colors.grey),
                    _menuItem(
                        divider: true,
                        context: context,
                        icon: Icons.person,
                        text: "Award"),
                    _menuItem(
                        divider: true,
                        context: context,
                        icon: Icons.person,
                        text: "Contact us"),
                    //const Divider(color: Colors.grey),
                    GestureDetector(
                      onTap: () {
                        print("sdfasdfa");
                        Navigator.pushNamed(context, SettingScreen.routeName);
                      },
                      child: _menuItem(
                          divider: true,
                          context: context,
                          icon: Icons.settings,
                          text: "Settings"),
                    ),
                    //const Divider(color: Colors.grey),

                    const SizedBox(height: 20),
                    //Divider(color: Colors.grey.shade500),

                    GestureDetector(
                      onTap: () {
                        BlocProvider.of<AuthBloc>(context).add(LogOut());
                        Navigator.pushReplacementNamed(
                            context, SigninScreen.routeName);
                      },
                      child: _menuItem(
                          divider: false,
                          context: context,
                          icon: Icons.logout,
                          text: "Logout"),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
                child: Center(
                  child: Text("Safe Way By Vintage Technologies",
                      style: TextStyle(
                          fontWeight: FontWeight.w100, color: Colors.black45)),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _menuItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required bool divider,
  }) {
    const color = Colors.grey;
    const hoverColor = Colors.white70;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          trailing: IconButton(
              onPressed: () {}, icon: Icon(Icons.navigate_next_rounded)),
          leading: Icon(icon, color: color.shade700),
          title: Text(text, style: Theme.of(context).textTheme.bodyText2),
          hoverColor: hoverColor,
        ),
        divider
            ? Padding(
                padding: const EdgeInsets.only(left: 65, right: 20),
                child: Divider(color: Colors.grey.shade200),
              )
            : Container(),
      ],
    );
  }
}
