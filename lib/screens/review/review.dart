import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/widgets.dart';

class ReviewScreen extends StatelessWidget {
  static const routeName = 'reviewscreen';
  final description = TextEditingController();
  double min_rate = 1;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(240, 241, 241, 1),
        body: BlocConsumer<ReviewBloc, ReviewState>(
            builder: ((context, state) => buildScreen(context)),
            listener: (context, state) {
              if (state is ReviewSent) {
                                _isLoading = false;

                Navigator.pushNamed(context, HomeScreen.routeName,
                    arguments: HomeScreenArgument(isSelected: false));
              }
              if (state is ReviewSendingFailure) {
                _isLoading = false;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text("Review not Sent please try again"),
                  backgroundColor: Colors.red.shade900,
                ));
              }
            }));
  }

  Widget buildScreen(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: ListView(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: TextButton(
                    //padding: EdgeInsets.zero,
                    //color: Colors.white,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, HomeScreen.routeName,
                          arguments: HomeScreenArgument(isSelected: false));
                    },
                    child: const Icon(
                      Icons.clear,
                      size: 25,
                      color: Colors.black87,
                    ),
                  ),
                ),
              )
              // CustomeBackArrow(),
            ],
          ),
          SizedBox(
            height: 60,
          ),
          Center(
            child: Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(100)),
              child: const Icon(
                Icons.done,
                color: Colors.white,
                size: 90,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text("130.55",
                    style: Theme.of(context).textTheme.titleLarge)),
          ),
          const Divider(),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "How was your trip?",
                style: Theme.of(context).textTheme.titleLarge,
              )),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey.shade800,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                              imageUrl:
                                  'https://safeway-api.herokuapp.com/${driverImage}',
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
                        )),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        driverName ?? "Miki",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    RatingBar.builder(
                        itemSize: 20,
                        initialRating: 4,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        //itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) =>
                            Icon(Icons.star, color: Colors.green),
                        onRatingUpdate: (rating) {}),
                  ],
                ),
                const VerticalDivider(),
                RatingBar.builder(
                    itemSize: 30,
                    initialRating: 1,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    //itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) =>
                        Icon(Icons.star, color: Colors.green),
                    onRatingUpdate: (rating) {
                      min_rate = rating;
                    }),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 4,
                    spreadRadius: 2,
                    blurStyle: BlurStyle.normal)
              ]),
              child: TextFormField(
                controller: description,
                minLines: 4,
                maxLines: 4,
                decoration: const InputDecoration(
                    hintText: "Leave a comment..",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black45),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter The Old password';
                  }
                  return null;
                },
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: _isLoading?null:() {
                    createReview(context);
                    // print(driverId);
                  },
                  child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            const Text(
                              "Finish",
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black,
                                      ),
                                    )
                                  : Container(),
                            )
                          ],
                        ),),
            ),
          ),
        ],
      ),
    );
  }

  void createReview(BuildContext context) {
    _isLoading = true;
    ReviewEvent event =
        ReviewCreate(Review(description: description.text, rating: min_rate));
    BlocProvider.of<ReviewBloc>(context).add(event);
  }
}
