import 'package:flutter/material.dart';
import 'package:passengerapp/widgets/widgets.dart';

class EditProfile extends StatelessWidget {
  static const routeName = "/editaprofile";
  final _textStyle =
      const TextStyle(color: Colors.black12, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Form(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              //height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("assetName"),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Name",
                              style: _textStyle,
                            ),
                            Text("Location", style: _textStyle),
                            Text("E-mail", style: _textStyle),
                            Text("Phone", style: _textStyle),
                            Text("Password", style: _textStyle),
                          ],
                        ),
                        // Column(
                        //   children: [
                        //     TextFormField(),
                        //     TextFormField(),
                        //     TextFormField(),
                        //     TextFormField(),
                        //     TextFormField(),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {}, child: const Text("Save Changes")),
                  TextButton(
                      style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(color: Colors.red.shade900))),
                      onPressed: () {},
                      child: Text("Delete Account",
                          style: TextStyle(color: Colors.red.shade900)))
                ],
              ),
            ),
          ),
        )
      ],
    ));
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