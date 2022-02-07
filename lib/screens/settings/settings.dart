import 'package:flutter/material.dart';
import 'package:passengerapp/screens/screens.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = "/settings";

  final _textStyle =
      const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.clear,
              color: Colors.black,
            )),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
        children: [
          Card(
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 5),
                  child: Text(
                    "Profile",
                    style: _textStyle,
                  ),
                ),
                const Divider(
                  color: Colors.red,
                  thickness: 1.5,
                ),
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                  ),
                ),
                const Center(child: Text("Abebe Kebede")),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "+251934540217",
                        style: _textStyle,
                      ),
                      Text(
                        "abebe@gmail.com",
                        style: _textStyle,
                      ),
                      Text(
                        "+251934540217",
                        style: _textStyle,
                      ),
                    ],
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, EditProfile.routeName);
                      },
                      child: const Text("Edit Profile")),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, ChangePassword.routeName);
                      },
                      child: const Text("Change Password")),
                ])
              ],
            ),
          ),

          Card(
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 5),
                  child: Text(
                    "Legal",
                    style: _textStyle,
                  ),
                ),
                const Divider(
                  color: Colors.red,
                  thickness: 1.5,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 20, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact Us",
                        style: _textStyle,
                      ),
                      Text("Privacy Policy", style: _textStyle),
                      Text("Terms & Conditions", style: _textStyle),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Card(
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 5),
                  child: Text(
                    "Preference",
                    style: _textStyle,
                  ),
                ),
                const Divider(
                  color: Colors.red,
                  thickness: 1.5,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 20, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(
                          text: "Driver Gender: ",
                          style: _textStyle,
                          children: const [
                            TextSpan(
                                text: " Any",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300))
                          ])),
                      Text.rich(TextSpan(
                          text: "Minimum Driver Rating: ",
                          style: _textStyle,
                          children: const [
                            TextSpan(
                                text: " 3.0",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300))
                          ])),
                      Text.rich(TextSpan(
                          text: "Car Type: ",
                          style: _textStyle,
                          children: const [
                            TextSpan(
                                text: " Any",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300))
                          ])),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {}, child: const Text("Edit Preference")),
                )
              ],
            ),
          ),
          Card(
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 5),
                  child: Text(
                    "App Info",
                    style: _textStyle,
                  ),
                ),
                const Divider(
                  color: Colors.red,
                  thickness: 1.5,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 20, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(
                          text: "Build Name: ",
                          style: _textStyle,
                          children: const [
                            TextSpan(
                                text: " SafeWay",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300))
                          ])),
                      Text.rich(TextSpan(
                          text: "App Version: ",
                          style: _textStyle,
                          children: const [
                            TextSpan(
                                text: " 1.0",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300))
                          ])),
                      Text.rich(TextSpan(
                          text: "Build Number: ",
                          style: _textStyle,
                          children: const [
                            TextSpan(
                                text: " 102034",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300))
                          ])),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Card(
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 5),
                  child: Text(
                    "About us",
                    style: _textStyle,
                  ),
                ),
                const Divider(
                  color: Colors.red,
                  thickness: 1.5,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 20, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(
                          text: "Owned by:\n  ",
                          style: _textStyle,
                          children: const [
                            TextSpan(
                                text: " Safeway Transport",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300))
                          ])),
                      Text.rich(TextSpan(
                          text: "Developed by:\n  ",
                          style: _textStyle,
                          children: const [
                            TextSpan(
                                text: " Vintage Technologies",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300))
                          ])),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // _menuItem(
          //     context: context,
          //     icon: Icons.person,
          //     text: "My profile",
          //     routename: ProfileDetail.routeName),
          // _menuItem(
          //     context: context,
          //     icon: Icons.document_scanner,
          //     text: "Personal Document",
          //     routename: ProfileDetail.routeName),
          // _menuItem(
          //     context: context,
          //     icon: Icons.house,
          //     text: "Bank Details",
          //     routename: ProfileDetail.routeName),
          // _menuItem(
          //     context: context,
          //     icon: Icons.lock,
          //     text: "Change Password",
          //     routename: ProfileDetail.routeName),
          // SizedBox(
          //   height: 10,
          // ),
          // Text(
          //   "HELP",
          //   style: TextStyle(
          //       color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          // _menuItem(
          //     context: context,
          //     icon: Icons.person,
          //     text: "Term & Conditions",
          //     routename: ProfileDetail.routeName),
          // _menuItem(
          //     context: context,
          //     icon: Icons.document_scanner,
          //     text: "Privacy Policies",
          //     routename: ProfileDetail.routeName),
          // _menuItem(
          //     context: context,
          //     icon: Icons.house,
          //     text: "About",
          //     routename: ProfileDetail.routeName),
          // _menuItem(
          //     context: context,
          //     icon: Icons.lock,
          //     text: "Contact Us",
          //     routename: ProfileDetail.routeName),
        ],
      ),
    );
  }

  Widget _menuItem(
      {required BuildContext context,
      required IconData icon,
      required String text,
      required String routename}) {
    const color = Colors.grey;
    const hoverColor = Colors.white70;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(text,
              style:
                  const TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
          hoverColor: hoverColor,
          onLongPress: () {},
          onTap: () {
            Navigator.pushNamed(context, routename);
          },
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
