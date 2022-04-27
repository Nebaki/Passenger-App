import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:passengerapp/bloc/savedlocation/saved_location_bloc.dart';
import 'package:passengerapp/models/savedlocation/saved_location.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/widgets.dart';
import 'package:shimmer/shimmer.dart';

class SavedAddress extends StatelessWidget {
  static const routeName = "/savedadresses";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: BlocBuilder<SavedLocationBloc, SavedLocationState>(
                builder: (context, state) {
              if (state is SavedLocationsLoadSuccess) {
                final items = List.generate(state.savedLocation.length,
                    (index) => state.savedLocation[index].name);
                // List<String>.generate(10, (i) => 'Item ${i + 1}');

                return Container(
                  padding: EdgeInsets.only(top: 80),
                  child: Column(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 5, right: 5),
                      //   child: WhereTo(setIsSelected: () {}),
                      // ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: MediaQuery.of(context).size.height - 80,
                          child: ListView.builder(
                              itemCount: state.savedLocation.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return Dismissible(
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFE6E6),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        children: const [
                                          Spacer(),
                                          Icon(
                                            Icons.delete_outlined,
                                            color: Colors.redAccent,
                                          )
                                          //SvgPicture.asset("assets/icons/Trash.svg"),
                                        ],
                                      ),
                                    ),
                                    onDismissed: (DismissDirection d) {
                                      if (d == DismissDirection.endToStart) {
                                        print(
                                            "hererere ${state.savedLocation[index].id}");
                                        state.savedLocation.removeAt(index);
                                        // BlocProvider.of<SavedLocationBloc>(
                                        //         context)
                                        //     .add(SavedLocationDelete(state
                                        //         .savedLocation[index].id!));
                                      }
                                    },
                                    key: Key("item."),
                                    child: _builHistoryCard(
                                        context, state.savedLocation[index]));
                                // _historyItem(
                                //     context: context,
                                //     text: state.savedLocation[index].name,
                                //     routename: "routename"),
                                // );
                              }))
                    ],
                  ),
                );
              }
              return _buildShimmer(context);
            }),
          ),
          CustomeBackArrow(),
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AddAddressScreen.routeName,
                      arguments: AddAdressScreenArgument(edit: false));
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Saved Addresses",
                  style: Theme.of(context).textTheme.titleLarge,
                )),
          )
        ],
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height - 80,
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurStyle: BlurStyle.normal,
                                  color: Colors.grey.shade300,
                                  blurRadius: 8,
                                  spreadRadius: 5)
                            ]),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.white,
                                      child: Container(
                                        width: 50,
                                        height: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.white,
                                      child: Container(
                                          width: 130,
                                          height: 15,
                                          color: Colors.grey),
                                    )
                                  ],
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                      height: 30,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      color:
                                          const Color.fromRGBO(244, 201, 60, 1),
                                      child: const Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 15,
                                      )),
                                ),
                              ],
                            ),
                            const Divider(),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ));
                    // _historyItem(
                    //     context: context,
                    //     text: state.savedLocation[index].name,
                    //     routename: "routename"),
                    // );
                  }))
        ],
      ),
    );
  }

  Widget _historyItem(
      {required BuildContext context,
      required String text,
      required String routename}) {
    const color = Colors.grey;
    const hoverColor = Colors.white70;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.history, color: color.shade700),
          title: Text(text, style: Theme.of(context).textTheme.bodyText2),
          hoverColor: hoverColor,
          onLongPress: () {},
          onTap: () {
            // Navigator.pushNamed(context, routename);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 65, right: 20),
          child: Divider(color: Colors.grey.shade400),
        )
      ],
    );
  }

  Widget _builHistoryCard(BuildContext context, SavedLocation location) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AddAddressScreen.routeName,
              arguments:
                  AddAdressScreenArgument(edit: true, savedLocation: location));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    blurStyle: BlurStyle.normal,
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    spreadRadius: 5)
              ]),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.name,
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        location.address,
                        style: TextStyle(color: Colors.black38),
                      )
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        color: const Color.fromRGBO(244, 201, 60, 1),
                        child: const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 15,
                        )),
                  ),
                ],
              ),
              const Divider(),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
