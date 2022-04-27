import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/dataprovider/auth/auth.dart';
import 'package:passengerapp/drawer/custome_paint.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:http/http.dart' as http;

class NavDrawer extends StatelessWidget {
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());

  Future<String?> getImageUrl() async {
    return await authDataProvider.getImageUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Material(
      color: const Color.fromRGBO(240, 241, 241, 1),
      child: CustomPaint(
        painter: DrawerBackGround(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 40),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (_, state) {
                  if (state is AuthDataLoadSuccess) {
                    return Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey.shade300,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                  imageUrl: state.auth.profilePicture!,
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
                                    return const Icon(
                                      Icons.person,
                                      color: Colors.black,
                                      size: 50,
                                    );
                                  }),
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          state.auth.name!,
                          style: Theme.of(context).textTheme.headlineSmall,
                        )
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(top: 50),
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, HomeScreen.routeName,
                          arguments: HomeScreenArgument(isSelected: false));
                    },
                    child: _menuItem(
                        divider: true,
                        context: context,
                        icon: Icons.home_max_outlined,
                        text: "Home"),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SavedAddress.routeName);
                    },
                    child: _menuItem(
                        divider: true,
                        context: context,
                        icon: Icons.favorite_outline_outlined,
                        text: "Saved Addreses"),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, HistoryPage.routeName);
                    },
                    child: _menuItem(
                        divider: true,
                        context: context,
                        icon: Icons.history,
                        text: "History"),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, OrderForOtherScreen.routeName);
                    },
                    child: _menuItem(
                        divider: true,
                        context: context,
                        icon: Icons.border_outer_rounded,
                        text: "Order for other"),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.pushNamed(context, ReviewScreen.routeName);
                  //   },
                  //   child: _menuItem(
                  //       divider: true,
                  //       context: context,
                  //       icon: Icons.person,
                  //       text: "Award"),
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     // BlocProvider.of<AuthBloc>(context).add(AuthDataLoad());
                  //     Navigator.pushNamed(context, PlacePickerScreen.routeName);
                  //   },
                  //   child: _menuItem(
                  //       divider: true,
                  //       context: context,
                  //       icon: Icons.person,
                  //       text: "Contact us"),
                  // ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SettingScreen.routeName);
                    },
                    child: _menuItem(
                        divider: true,
                        context: context,
                        icon: Icons.settings_outlined,
                        text: "Settings"),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<AuthBloc>(context).add(LogOut());
                      Navigator.pushReplacementNamed(
                          context, SigninScreen.routeName);
                    },
                    child: _menuItem(
                        divider: false,
                        context: context,
                        icon: Icons.logout,
                        text: "Logout"),
                  ),
                ],
              ),
            ),
            // const SizedBox(
            //   height: 15,
            //   child: Center(
            //     child: Text("Safe Way By Vintage Technologies",
            //         style: TextStyle(
            //             fontWeight: FontWeight.w100, color: Colors.black45)),
            //   ),
            // ),
          ],
        ),
      ),
    ));
  }

  Widget _menuItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required bool divider,
  }) {
    const color = Colors.black;
    const hoverColor = Colors.white70;
    return ListTile(
      horizontalTitleGap: 0,
      leading: Icon(icon, color: color),
      title: Text(text, style: Theme.of(context).textTheme.bodyLarge),
      hoverColor: hoverColor,
    );
  }
}
