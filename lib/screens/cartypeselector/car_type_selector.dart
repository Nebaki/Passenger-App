import 'package:flutter/material.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';

class CarTypeSelector extends StatefulWidget {
  static const routName = '/cartypeselector';
  @override
  _CarTypeSelectorState createState() => _CarTypeSelectorState();
}

class _CarTypeSelectorState extends State<CarTypeSelector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 150, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, HomeScreen.routeName,
                      //     arguments: HomeScreenArgument(
                      //       isSelected: false,
                      //       carType: 'Taxi',
                      //     ));
                    },
                    child: Container(
                      height: 80,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: Colors.black)),
                      child: Column(
                        children: const [
                          Image(
                              height: 60,
                              image: AssetImage(
                                  'assets/icons/economyCarIcon.png')),
                          Text('Taxi')
                        ],
                      ),
                    ),
                  ),
                  const Text('Or'),
                  GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, HomeScreen.routeName,
                      //     arguments: HomeScreenArgument(
                      //       isSelected: false,
                      //       carType: 'Truck',
                      //     ));
                    },
                    child: Container(
                      height: 80,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: Colors.black)),
                      child: Column(
                        children: const [
                          Image(
                              height: 64,
                              image: AssetImage('assets/icons/truck-icon.png')),
                          Text('Truck')
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              child: Text(
                'Are you looking for',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
