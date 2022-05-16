import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/models/models.dart';
import 'package:shimmer/shimmer.dart';

class CategoryList extends StatefulWidget {
  final Function changeCost;
  final Function searchNearbyDriver;
  final Function changeCapacity;
  const CategoryList(
      {Key? key,
      required this.changeCost,
      required this.searchNearbyDriver,
      required this.changeCapacity})
      : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int _selectedIndex = 1;
  // String category = 'ax';

  @override
  Widget build(BuildContext context) {
    // print("Now we are listening the typr $category");

    // if (widget.searchNearbyDriver(category) != null) {
    // } else {
    //   BlocProvider.of<DriverBloc>(context).add(DriverSetNotFound());
    // }

    return BlocConsumer<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CategoryLoadSuccess) {
          BlocProvider.of<SelectedCategoryBloc>(context)
              .add(SelectCategory(state.categories[_selectedIndex]));
          // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          //   widget.changeCost(
          //       state.categories[_selectedIndex].initialFare,
          //       state.categories[_selectedIndex].perKiloMeterCost,
          //       state.categories[_selectedIndex].perMinuteCost);

          //   widget.changeCapacity(state.categories[_selectedIndex].capacity);
          //   loadDriver(state.categories[_selectedIndex].name);
          // });
        }
      },
      builder: (context, state) {
        if (state is CategoryLoadSuccess) {
          loadDriver(state.categories[_selectedIndex].name);
          BlocProvider.of<SelectedCategoryBloc>(context)
              .add(SelectCategory(state.categories[_selectedIndex]));
          return SingleChildScrollView(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                      state.categories.length,
                      (index) => GestureDetector(
                          onTap: () {
                            // BlocProvider.of<SelectedCategoryBloc>(context)
                            //     .add(SelectCategory(state.categories[index]));
                            // category = state.categories[index].name;
                            // loadDriver(state.categories[index].name);
                            // widget.changeCost(
                            //     state.categories[index].initialFare,
                            //     state.categories[index].perKiloMeterCost,
                            //     state.categories[index].perMinuteCost);
                            // widget.changeCapacity(
                            //     state.categories[index].capacity);

                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          child: _buildCategoryItems(
                              state.categories[index], index)))));
        }
        return _buildShimmerEffect();
      },
    );
  }

  Widget _buildShimmerEffect() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
            5,
            (index) => Column(
                  children: [
                    Shimmer.fromColors(
                      period: const Duration(milliseconds: 2000),
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.white38,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Container(
                          height: 30,
                          width: 40,
                          color: Colors.white38,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Shimmer.fromColors(
                      period: const Duration(milliseconds: 2000),
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.white38,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Container(
                          height: 10,
                          width: 40,
                          color: Colors.white54,
                        ),
                      ),
                    )
                  ],
                )));
  }

  void loadDriver(category) {
    if (widget.searchNearbyDriver(category) != null) {
      BlocProvider.of<DriverBloc>(context).add(DriverSetFound());
    } else {
      BlocProvider.of<DriverBloc>(context).add(DriverSetNotFound());
    }
  }

  Widget _buildCategoryItems(Category category, index) {
    return Column(
      children: [
        Container(
          decoration: _selectedIndex == index
              ? BoxDecoration(
                  boxShadow: const [
                      BoxShadow(color: Color.fromRGBO(244, 201, 60, 1)),
                    ],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 0.5, color: Colors.black))
              : null,
          child: const Image(
              height: 50,
              image: //NetworkImage('$pictureUrl/${category.icon}')
                  AssetImage("assets/icons/economyCarIcon.png")),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(category.name)
      ],
    );
    // Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
    //   children: [
    //     GestureDetector(
    //       onTap: () {
    //         setState(() {
    //           _selectedIndex = 1;
    //         });
    //       },
    //       child: Column(
    //         children: [
    //           Container(
    //             decoration: _selectedIndex == 1
    //                 ? BoxDecoration(
    //                     boxShadow: const [
    //                         BoxShadow(color: Color.fromRGBO(244, 201, 60, 1)),
    //                       ],
    //                     borderRadius: BorderRadius.circular(10),
    //                     border: Border.all(width: 0.5, color: Colors.black))
    //                 : null,
    //             child: const Image(
    //                 height: 50,
    //                 image: AssetImage("assets/icons/economyCarIcon.png")),
    //           ),
    //           const SizedBox(
    //             height: 5,
    //           ),
    //           const Text("Standart")
    //         ],
    //       ),
    //     ),
    //     const SizedBox(
    //       width: 20,
    //     ),
    //     GestureDetector(
    //       onTap: () {
    //         setState(() {
    //           _selectedIndex = 2;
    //           // priceMultiplier = 2;
    //           // durationMultiplier = 2;

    //           // DriverEvent event = DriverLoad(widget.searchNeabyDriver());
    //           // BlocProvider.of<DriverBloc>(context).add(event);
    //         });
    //       },
    //       child: Column(
    //         children: [
    //           Container(
    //             decoration: _selectedIndex == 2
    //                 ? BoxDecoration(
    //                     boxShadow: const [
    //                         BoxShadow(color: Color.fromRGBO(244, 201, 60, 1)),
    //                       ],
    //                     borderRadius: BorderRadius.circular(10),
    //                     border: Border.all(width: 0.5, color: Colors.black))
    //                 : null,
    //             child: const Image(
    //                 height: 50,
    //                 image: AssetImage("assets/icons/lexuryCarIcon.png")),
    //           ),
    //           const SizedBox(
    //             height: 5,
    //           ),
    //           const Text("XL")
    //         ],
    //       ),
    //     ),
    //     const SizedBox(
    //       width: 20,
    //     ),
    //     GestureDetector(
    //       onTap: () {
    //         setState(() {
    //           _selectedIndex = 3;
    //           // priceMultiplier = 2.5;
    //           // durationMultiplier = 2.5;
    //           // DriverEvent event = DriverLoad(widget.searchNeabyDriver());
    //           // BlocProvider.of<DriverBloc>(context).add(event);
    //         });
    //       },
    //       child: Column(
    //         children: [
    //           Container(
    //             decoration: _selectedIndex == 3
    //                 ? BoxDecoration(
    //                     boxShadow: const [
    //                         BoxShadow(color: Color.fromRGBO(244, 201, 60, 1)),
    //                       ],
    //                     borderRadius: BorderRadius.circular(10),
    //                     border: Border.all(width: 0.5, color: Colors.black))
    //                 : null,
    //             child: const Image(
    //                 height: 50,
    //                 image: AssetImage("assets/icons/familyCarIcon.png")),
    //           ),
    //           const SizedBox(
    //             height: 5,
    //           ),
    //           const Text("Family")
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}
