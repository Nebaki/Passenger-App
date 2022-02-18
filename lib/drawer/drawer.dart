import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/dataprovider/auth/auth.dart';
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
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 110,
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 7, spreadRadius: 3)
              ]),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (_, state) {
                  if (state is AuthDataLoadSuccess) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey.shade800,
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
                                    return const Icon(Icons.error);
                                  }),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.auth.name!,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Text(state.auth.phoneNumber,
                                  style: Theme.of(context).textTheme.subtitle1),
                            ],
                          ),
                        )
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20),
            height: MediaQuery.of(context).size.height - 170,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                GestureDetector(
                  onTap: () {
                    // print("YAyayyaay")
                    // _draweKEy.currentState!.close();
                  },
                  child: _menuItem(
                      divider: true,
                      context: context,
                      icon: Icons.home,
                      text: "Home"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, SavedAddress.routeName);
                  },
                  child: _menuItem(
                      divider: true,
                      context: context,
                      icon: Icons.favorite,
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
                _menuItem(
                    divider: true,
                    context: context,
                    icon: Icons.person,
                    text: "Award"),
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<AuthBloc>(context).add(AuthDataLoad());
                  },
                  child: _menuItem(
                      divider: true,
                      context: context,
                      icon: Icons.person,
                      text: "Contact us"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, SettingScreen.routeName);
                  },
                  child: _menuItem(
                      divider: true,
                      context: context,
                      icon: Icons.settings,
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
          const SizedBox(
            height: 15,
            child: Center(
              child: Text("Safe Way By Vintage Technologies",
                  style: TextStyle(
                      fontWeight: FontWeight.w100, color: Colors.black45)),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _menuItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required bool divider,
  }) {
    const color = Colors.grey;
    const hoverColor = Colors.white70;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          trailing: IconButton(
              onPressed: () {}, icon: const Icon(Icons.navigate_next_rounded)),
          leading: Icon(icon, color: color.shade700),
          title: Text(text, style: Theme.of(context).textTheme.bodyText2),
          hoverColor: hoverColor,
        ),
        divider
            ? Padding(
                padding: const EdgeInsets.only(left: 65, right: 20),
                child: Divider(color: Colors.grey.shade200),
              )
            : Container(),
      ],
    );
  }
}
