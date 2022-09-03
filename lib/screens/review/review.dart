import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/rout.dart';

class ReviewScreen extends StatelessWidget {
  final ReviewScreenArgument arg;
  static const routeName = 'reviewscreen';
  final description = TextEditingController();
  double minRate = 0;
  bool _isLoading = false;

  ReviewScreen({Key? key, required this.arg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<ReviewBloc, ReviewState>(
            builder: ((context, state) => buildScreen(context)),
            listener: (context, state) {
              if (state is ReviewSent) {
                _isLoading = false;

                Navigator.pop(context);
              }
              if (state is ReviewSendingFailure) {
                _isLoading = false;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text(getTranslation(context, "review_not_sent_message")),
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
                    onPressed: () {
                      Navigator.pop(context);
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
          const SizedBox(
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
                child: Text(
                    "${double.parse(arg.price).toStringAsFixed(2)} ${getTranslation(context, "etb")}",
                    style: Theme.of(context).textTheme.titleLarge)),
          ),
          const Divider(),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                getTranslation(context, "how_was_you_trip"),
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
                                  'https://safeway-api.herokuapp.com/$driverImage',
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
                        )),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        driverName ?? "Driver",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    BlocBuilder<DriverBloc, DriverState>(
                      builder: (context, state) {
                        if (state is DriverLoadSuccess) {
                          return RatingBar.builder(
                              itemSize: 20,
                              initialRating: state.driver.rating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              ignoreGestures: true,
                              itemBuilder: (context, _) =>
                                  const Icon(Icons.star, color: Colors.yellow),
                              onRatingUpdate: (rating) {});
                        }
                        return Container();
                      },
                    )
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
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Colors.yellow),
                    onRatingUpdate: (rating) {
                      minRate = rating;
                    }),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Container(
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.white,
                    blurRadius: 4,
                    spreadRadius: 2,
                    blurStyle: BlurStyle.normal)
              ]),
              child: TextFormField(
                controller: description,
                minLines: 4,
                maxLines: 4,
                decoration: InputDecoration(
                    hintText: getTranslation(context, "leave_a_comment"),
                    filled: true,
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none)),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              width: double.infinity,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          createReview(context);
                          // print(driverId);
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Text(
                        getTranslation(context, "submit"),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Container(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void createReview(BuildContext context) {
    _isLoading = true;
    ReviewEvent event =
        ReviewCreate(Review(description: description.text, rating: minRate));
    BlocProvider.of<ReviewBloc>(context).add(event);
  }
}
