import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/url_launcher.dart';

import '../screens/screens.dart';

class DriverProfile extends StatelessWidget {
  final String assetImage;

  DriverProfile({Key? key, required this.assetImage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverBloc, DriverState>(builder: (_, state) {
      if (state is DriverLoadSuccess) {
        ////////////////////////////////////
        driverName = state.driver.firstName;
        driverImage = state.driver.profileImage;
        driverId = state.driver.id;
        vehicle = state.driver.vehicle;
        driverRating = state.driver.rating;

        ///////////////////////////////////
        return Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                        height: 33,
                        width: 33,
                        color: Colors.green.shade300,
                        child: IconButton(
                            onPressed: () {
                              makePhoneCall(state.driver.phoneNumber);
                            },
                            icon: Icon(
                              Icons.call,
                              size: 18,
                            ))),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                        height: 33,
                        width: 33,
                        color: Colors.red,
                        child: IconButton(
                            onPressed: () {
                              sendTextMessage(state.driver.phoneNumber, "test");
                            },
                            icon: Icon(
                              Icons.mark_chat_read,
                              size: 18,
                            ))),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                        height: 33,
                        width: 33,
                        color: Colors.indigo.shade900,
                        child: IconButton(
                            onPressed: () {
                              print("hey ${state.driver}");
                              print(pickupAddress);
                              print(droppOffAddress);
                              sendTelegramMessage(state.driver.firstName,
                                  state.driver.phoneNumber);

                              //     Navigator.pushNamed(
                              // context,
                              // ReviewScreen
                              //     .routeName);
                              // makePhoneCall(state.driver.phoneNumber);
                            },
                            icon: Icon(
                              Icons.share,
                              size: 18,
                            ))),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Center(
                          child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey.shade800,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                    imageUrl:
                                        'https://safeway-api.herokuapp.com/${state.driver.profileImage}',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                              //colorFilter:
                                              //     const ColorFilter.mode(
                                              //   Colors.red,
                                              //   BlendMode.colorBurn,
                                              // ),
                                            ),
                                          ),
                                        ),
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) {
                                      return const Icon(Icons.error);
                                    }),
                              ))),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.driver.firstName,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w300),
                          ),
                          Row(
                            children: [
                              Text(driverRating!.toString()),
                              SizedBox(
                                width: 3,
                              ),
                              Icon(Icons.star,
                                  size: 15,
                                  color: Color.fromRGBO(244, 201, 60, 1))
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image(height: 50, image: AssetImage(assetImage)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Car Model: ${vehicle!['model']}"),
                              Text("Plate Number: ${vehicle!['plate_number']}")
                            ],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text('Color: ${vehicle!['color']}'),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      }
      return const Text("Loading");
    });
  }
}
