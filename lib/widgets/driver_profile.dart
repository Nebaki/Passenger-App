import 'package:flutter/material.dart';

class DriverProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Center(
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 30,
            ),
          ),
          Text(
            "Yonas Kebede",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.green,
              ),
              Icon(
                Icons.star,
                color: Colors.green,
              ),
              Icon(
                Icons.star,
                color: Colors.green,
              ),
              Icon(
                Icons.star,
                color: Colors.green,
              ),
              Icon(
                Icons.star,
                color: Colors.green,
              )
            ],
          ),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                    color: Colors.green,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.sms,
                        ))),
              ),
              SizedBox(
                width: 30,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                    color: Colors.red,
                    child: IconButton(
                        onPressed: () {}, icon: Icon(Icons.call_end_outlined))),
              )
            ],
          ),
        ],
      ),
    );
  }
}
