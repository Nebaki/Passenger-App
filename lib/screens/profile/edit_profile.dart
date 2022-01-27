import 'package:flutter/material.dart';
import 'package:passengerapp/widgets/widgets.dart';

class EditProfile extends StatelessWidget {
  static const routeName = "/editaprofile";
  final _textStyle =
      const TextStyle(color: Colors.black12, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 180),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage("assetName"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              height: 350,
              child: ListView(scrollDirection: Axis.vertical, children: [
                _buildProfileItems(context: context, text: "Name"),
                _buildProfileItems(context: context, text: "Location"),

                _buildProfileItems(context: context, text: "Email"),

                _buildProfileItems(context: context, text: "Phone"),
                _buildProfileItems(context: context, text: "Password"),

                // Container(
                //   height: 350,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             "Name",
                //             style: _textStyle,
                //           ),
                //           Text("Location", style: _textStyle),
                //           Text("E-mail", style: _textStyle),
                //           Text("Phone", style: _textStyle),
                //           Text("Password", style: _textStyle),
                //         ],
                //       ),
                //       Container(
                //         width: 160,
                //         child: Column(
                //           children: [
                //             TextFormField(),
                //             TextFormField(),
                //             TextFormField(),
                //             TextFormField(),
                //             TextFormField(),
                //           ],
                //         ),
                //       ),
                //       // Container(
                //       //   child: Column(
                //       //     children: [
                //       //       //TextFormField(),
                //       //       // TextFormField(),
                //       //       // TextFormField(),
                //       //       // TextFormField(),
                //       //       // TextFormField(),
                //       //     ],
                //       //   ),
                //       // )
                //     ],
                //   ),
                // ),
              ]),
            ),
          ),
          SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.6,
              child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Save Changes",
                      style: TextStyle(color: Colors.white)))),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextButton(
                style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: Colors.red.shade900))),
                onPressed: () {},
                child: Text("Delete Account",
                    style: TextStyle(color: Colors.red.shade900))),
          )
        ],
      ),
    ));
  }

  Widget _buildProfileItems(
      {required BuildContext context, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: _textStyle,
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextFormField())
        ],
      ),
    );
  }
}

// Stack(
//         children: [
//           SingleChildScrollView(
//             child: Container(
//               child: Form(
//                   child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const CircleAvatar(
//                     radius: 40,
//                     backgroundImage: AssetImage("assetName"),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         children: [
//                           Text(
//                             "Name",
//                             style: _textStyle,
//                           ),
//                           Text("Location", style: _textStyle),
//                           Text("E-mail", style: _textStyle),
//                           Text("Phone", style: _textStyle),
//                           Text("Password", style: _textStyle),
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           TextFormField(),
//                           TextFormField(),
//                           TextFormField(),
//                           TextFormField(),
//                           TextFormField(),
//                         ],
//                       )
//                     ],
//                   ),
//                   ElevatedButton(
//                       onPressed: () {}, child: const Text("Save Changes")),
//                   TextButton(
//                       style: ButtonStyle(
//                           side: MaterialStateProperty.all<BorderSide>(
//                               BorderSide(color: Colors.red.shade900))),
//                       onPressed: () {},
//                       child: Text("Delete Account",
//                           style: TextStyle(color: Colors.red.shade900)))
//                 ],
//               )),
//             ),
//           ),
//           CustomeBackArrow()
//         ],
//       ),