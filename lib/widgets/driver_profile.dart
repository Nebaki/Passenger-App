import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/helper/url_launcher.dart';
import 'package:shimmer/shimmer.dart';

class DriverProfile extends StatelessWidget {
  final String assetImage;

  const DriverProfile({Key? key, required this.assetImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverBloc, DriverState>(builder: (_, state) {
      if (state is DriverLoadSuccess) {
        driverName = state.driver.firstName;
        driverImage = state.driver.profileImage;
        driverId = state.driver.id;
        vehicle = state.driver.vehicle;
        driverRating = state.driver.rating;
        driverFcm = state.driver.fcmId;
        var model = vehicle!['model'].toString().substring(0,15);
        return Column(
          children: [
            /*Flexible(
              flex: 2,
              child: Row(
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
                            icon: const Icon(
                              Icons.call,
                              size: 18,
                              color: Colors.white,
                            ))),
                  ),
                  const SizedBox(
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
                            icon: const Icon(
                              Icons.mark_chat_read,
                              size: 18,
                              color: Colors.white,
                            ))),
                  ),
                  const SizedBox(
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
                              sendTelegramMessage(state.driver.firstName,
                                  state.driver.phoneNumber);
                            },
                            icon: const Icon(
                              Icons.share,
                              size: 18,
                              color: Colors.white,
                            ))),
                  ),
                ],
              ),
            ),*/
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
                          icon: const Icon(
                            Icons.call,
                            size: 18,
                            color: Colors.white,
                          ))),
                ),
                const SizedBox(
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
                          icon: const Icon(
                            Icons.mark_chat_read,
                            size: 18,
                            color: Colors.white,
                          ))),
                ),
                const SizedBox(
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
                            sendTelegramMessage(state.driver.firstName,
                                state.driver.phoneNumber);
                          },
                          icon: const Icon(
                            Icons.share,
                            size: 18,
                            color: Colors.white,
                          ))),
                ),
              ],
            ),
            /*Flexible(
              flex: 3,
              child: Column(
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
                                            ),
                                          ),
                                        ),
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) {
                                      return const Icon(Icons.error);
                                    }),
                              ))),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.driver.firstName,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w300),
                          ),
                          Row(
                            children: [
                              Text(driverRating!.toStringAsFixed(1)),
                              const SizedBox(
                                width: 3,
                              ),
                              const Icon(Icons.star,
                                  size: 15,
                                  color: Color.fromRGBO(244, 201, 60, 1))
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),*/
            Column(
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
                                          ),
                                        ),
                                      ),
                                  placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) {
                                    return const Icon(Icons.error);
                                  }),
                            ))),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.driver.firstName,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                        Row(
                          children: [
                            Text(driverRating!.toStringAsFixed(1)),
                            const SizedBox(
                              width: 3,
                            ),
                            const Icon(Icons.star,
                                size: 15,
                                color: Color.fromRGBO(244, 201, 60, 1))
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
           /* Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                          flex: 2,
                          child:
                          Image(height: 40, image: AssetImage(assetImage))),
                      Flexible(
                        flex: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "${getTranslation(context, "car_model")}: ${vehicle!['model']}"),
                                Text(
                                    "${getTranslation(context, "plate_number")}: ${vehicle!['plate_number']}")
                              ],
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                                '${getTranslation(context, "color")}: ${vehicle!['color']}'),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),*/
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*Flexible(
                        flex: 2,
                        child:
                        Image(height: 40, image: AssetImage(assetImage))),
                    */
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Image(height: 40, width: 40,image: AssetImage(assetImage)),
                    ),
                   /* Flexible(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${getTranslation(context, "car_model")}: ${vehicle!['model']}"),
                              Text(
                                  "${getTranslation(context, "plate_number")}: ${vehicle!['plate_number']}")
                            ],
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                              '${getTranslation(context, "color")}: ${vehicle!['color']}'),
                        ],
                      ),
                    )
*/
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${getTranslation(context, "car_model")}: $model",
                                overflow: TextOverflow.fade,
                                maxLines: 2,
                                softWrap: false,),
                              Text(
                                  "${getTranslation(context, "plate_number")}: ${vehicle!['plate_number']}"),
                              Text(
                                  '${getTranslation(context, "color")}: ${vehicle!['color']}'),
                            ],
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      }
      return _buildDriverProffileShimmerEffect();
    });
  }

  Widget _buildDriverProffileShimmerEffect() {
    return Shimmer(
      gradient: shimmerGradient,
      child: Column(
        children: [
          Flexible(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    height: 33,
                    width: 33,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    height: 33,
                    width: 33,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    height: 33,
                    width: 33,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Center(
                        child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.black,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                            ))),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 10,
                          width: 80,
                          color: Colors.black,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 10,
                              width: 40,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            const Icon(Icons.star,
                                size: 15, color: Colors.black)
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                        flex: 2,
                        child:
                            Image(height: 40, image: AssetImage(assetImage))),
                    Flexible(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: 90,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(16))),
                              Container(
                                  width: 60,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(16))),
                            ],
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Container(
                              width: 60,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(16))),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
