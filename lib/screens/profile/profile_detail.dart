import 'package:flutter/material.dart';
import 'package:passengerapp/screens/profile/edit_profile.dart';
import 'package:passengerapp/widgets/custome_back_arrow.dart';

class ProfileDetail extends StatelessWidget {
  static const routeName = "/profiledetail";
  final double _appbarHeight = 220;
  final double _pictureHeight = 120;
  final double _profileHeight = 150;

  final _textStyle = const TextStyle(fontSize: 20, color: Colors.black45);

  @override
  Widget build(BuildContext context) {
    final double top = _appbarHeight - _profileHeight;

    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              appBar(context),
              CustomeBackArrow(),
              Positioned(
                  top: 40,
                  right: 20,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, EditProfile.routeName);
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      )))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20),
            child: Text(
              "PERSONAL INFO",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
            ),
          ),
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.phone_android_rounded,
                      size: 20,
                      color: Colors.black54,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Icon(
                      Icons.mail,
                      size: 20,
                      color: Colors.black54,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Icon(
                      Icons.translate,
                      size: 20,
                      color: Colors.black54,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Icon(
                      Icons.home,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "+251934540217",
                      style: _textStyle,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "haylemikaeltfera@gmail.com",
                      style: _textStyle,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Amharic and English",
                      style: _textStyle,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Addis Ababa,Ethiopia",
                      style: _textStyle,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget profileImage() {
    return CircleAvatar(
      radius: _pictureHeight / 2,
      backgroundColor: Colors.black38,

      //backgroundImage: ,
    );
  }

  Widget appBar(context) {
    //final double top = _appbarHeight - _profileHeight;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned(
            top: 10,
            child: Icon(
              Icons.backspace,
              color: Colors.white,
            )),
        Container(
          margin: EdgeInsets.only(bottom: _profileHeight),
          width: MediaQuery.of(context).size.width,
          height: _appbarHeight,
          decoration: BoxDecoration(color: Colors.grey.shade800),
        ),
        Positioned(
            top: _appbarHeight - _profileHeight / 3,
            left: 20,
            right: 20,
            child: profileContainer(context)),
        //Positioned(top: 400, child: const Text("Eyob Tilahun")),
        Positioned(top: _appbarHeight - _pictureHeight, child: profileImage()),
        Positioned(
            top: _appbarHeight + 15,
            child: const Text(
              "Eyob Tilahun",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            )),
      ],
    );
  }

  Widget profileContainer(context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width,
          height: _profileHeight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
        ),
        //Positioned(child: profileImage())
      ],
    );
  }
}
