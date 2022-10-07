import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/utils/waver.dart';
import 'package:shimmer/shimmer.dart';

import '../../helper/constants.dart';
import '../../helper/localization.dart';

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
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CategoryLoadSuccess) {
          BlocProvider.of<SelectedCategoryBloc>(context)
              .add(SelectCategory(state.categories[_selectedIndex]));
        }
        if(state is CategoryOperationFailure){
          ShowSnack(context: context,message: "category load error").show();
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
    return Container(
      decoration: _selectedIndex == index
          ? BoxDecoration(
          boxShadow: [
            BoxShadow(color: Theme.of(context).primaryColor),
          ],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 0.5, color: Colors.black))
          : null,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            const Image(
                height: 40,
                width: 70,
                image: //NetworkImage('$pictureUrl/${category.icon}')
                    AssetImage("assets/icons/economyCarIcon.png")),
            const SizedBox(
              height: 5,
            ),
            Text(category.name, style: TextStyle(color: _selectedIndex == index ?
            Colors.white: Colors.black),)
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItemsX(Category category, index) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Container(
        decoration: _selectedIndex == index
            ? BoxDecoration(
            boxShadow: [
              BoxShadow(color: Theme.of(context).primaryColor),
            ],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 0.5, color: Colors.black))
            : null,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Image(
                  width: 50,
                  height: 50,
                  image: //NetworkImage('$pictureUrl/${category.icon}')
                  AssetImage("assets/icons/economyCarIcon.png")),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(category.name,style: TextStyle(fontSize: 18),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("$duration min"),
                    ),
                  ],
                ),
              ),
              Expanded(child: Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Row(
                  children: const [
                    Icon(Icons.person),
                    Text('Sits'),
                  ],
                ),
              )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text('$price${getTranslation(context, "etb")}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
