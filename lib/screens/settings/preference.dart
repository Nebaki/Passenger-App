import 'package:flutter/material.dart';

class PreferenceScreen extends StatefulWidget {
  static const routeNAme = "/preferencescreen";
  @override
  _PreferenceScreenState createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  @override
  Widget build(BuildContext context) {
    RangeValues rangeValues = const RangeValues(0, 60);
    return Scaffold(
      backgroundColor: Colors.red.shade900,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 80,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 120, bottom: 20),
                        child: Text(
                          "Price",
                          style: TextStyle(color: Colors.white38),
                        ),
                      ),
                      RangeSlider(
                          activeColor: Colors.white,
                          max: 100,
                          divisions: 40,
                          values: rangeValues,
                          onChanged: (onChanged) {}),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Text(
                          "Driver Gender",
                          style: TextStyle(
                              color: Colors.white24,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Radio(
                                  fillColor: MaterialStateProperty.all<Color>(
                                      Colors.white),
                                  overlayColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  value: true,
                                  groupValue: false,
                                  onChanged: (onChanged) {}),
                              const Text(
                                "Male",
                                style: TextStyle(
                                    color: Colors.white24, fontSize: 10),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Radio(
                                toggleable: true,
                                activeColor: Colors.white,
                                fillColor: MaterialStateProperty.all<Color>(
                                    Colors.white),
                                overlayColor: MaterialStateProperty.all<Color>(
                                    Colors.white),
                                value: true,
                                groupValue: false,
                                onChanged: (onChanged) {},
                              ),
                              const Text(
                                "Female",
                                style: TextStyle(
                                    color: Colors.white24, fontSize: 10),
                              )
                            ],
                          ),
                          // RadioListTile(
                          //   value: true,
                          //   groupValue: true,
                          //   onChanged: (value) {},
                          // ),
                          // RadioListTile(
                          //   value: true,
                          //   groupValue: true,
                          //   onChanged: (value) {},
                          // ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Text(
                          "Vehicle",
                          style: TextStyle(
                              color: Colors.white24,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                      _buildVihcleTypeList(),
                      const Padding(
                        padding: EdgeInsets.only(top: 40, bottom: 20),
                        child: Text(
                          "Services",
                          style: TextStyle(
                              color: Colors.white24,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildServiceTypeItems(
                              text: "economy",
                              icon: Icons.supervised_user_circle),
                          _buildServiceTypeItems(
                              text: "Arround the clock",
                              icon: Icons.lock_clock_outlined),
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Colors.white24, width: 1)),
                                child: IconButton(
                                    iconSize: 40,
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.security_rounded,
                                      color: Colors.red,
                                    )),
                              ),
                              const Text(
                                "Secure",
                                style: TextStyle(
                                    color: Colors.white24, fontSize: 10),
                              )
                            ],
                          ),
                          _buildServiceTypeItems(
                              text: "Disabled parking",
                              icon: Icons.hearing_disabled_rounded),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white)),
                      onPressed: () {},
                      child: const Text(
                        "Apply",
                        style: TextStyle(fontWeight: FontWeight.normal),
                      )))
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 60),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Preference",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
              top: 50,
              right: 10,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.white,
                  )))
        ],
      ),
    );
  }

  Widget _buildVihcleTypeList() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.local_taxi_rounded,
              color: Colors.white,
              size: 35,
            ),
            Checkbox(
              side: const BorderSide(width: 1, color: Colors.white),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              value: true,
              onChanged: (value) {},
              fillColor: MaterialStateProperty.all<Color>(Colors.white),
              checkColor: Colors.red,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.car_rental,
              color: Colors.white,
              size: 35,
            ),
            Checkbox(
              side: const BorderSide(width: 1, color: Colors.white),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              value: false,
              onChanged: (value) {},
              fillColor: MaterialStateProperty.all<Color>(Colors.white),
              checkColor: Colors.red,
            )
          ],
        ),
      ],
    );
  }

  Widget _buildServiceTypeItems(
      {required String text, required IconData icon}) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white24, width: 1)),
          child: IconButton(iconSize: 30, onPressed: () {}, icon: Icon(icon)),
        ),
        Text(
          text,
          style: const TextStyle(color: Colors.white24, fontSize: 10),
        )
      ],
    );
  }
}
