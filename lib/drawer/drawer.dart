import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/bloc/database/location_history_bloc.dart';
import 'package:passengerapp/cubit/cubits.dart';
import 'package:passengerapp/cubit/favorite_location.dart';
import 'package:passengerapp/dataprovider/auth/auth.dart';
import 'package:passengerapp/drawer/custome_paint.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:http/http.dart' as http;

import '../screens/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';
import '../utils/waver.dart';

class NavDrawer extends StatelessWidget {
  final authDataProvider = AuthDataProvider(httpClient: http.Client());

  NavDrawer({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    return Drawer(
        child: Material(
      color: const Color.fromRGBO(240, 241, 241, 1),
      child: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: ClipPath(
              clipper: WaveClipperD(),
              child: Container(
                height: 250,
                color: themeProvider.getColor,
              ),
            ),
          ),
          ClipPath(
            clipper: WaveClipperD(),
            child: Container(
              height: 220,
              color: themeProvider.getColor,
            ),
          ),
          Opacity(
            opacity: 0.2,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: height * 0.8,
                color: themeProvider.getColor,
                child: ClipPath(
                  clipper: WaveClipperBottomD(),
                  child: Container(
                    height: 60,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 40),
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (_, state) {
                    if (state is AuthDataLoadSuccess) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.grey.shade300,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: BlocBuilder<ProfilePictureCubit,String>(builder:  (context, state) =>  CachedNetworkImage(
                                        imageUrl: state,
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
                                          return const Icon(
                                            Icons.person,
                                            color: Colors.black,
                                            size: 50,
                                          );
                                        }),)
                                  )),
                              BlocBuilder<ThemeModeCubit, ThemeMode>(
                                  builder: (context, state) {
                                if (state == ThemeMode.light) {
                                  return IconButton(
                                      onPressed: () {
                                        context
                                            .read<ThemeModeCubit>()
                                            .ActivateDarkTheme();
                                      },
                                      color: Colors.black,
                                      icon: const Icon(Icons.dark_mode_outlined));
                                }
                                if (state == ThemeMode.dark) {
                                  return IconButton(
                                      onPressed: () {
                                        context
                                            .read<ThemeModeCubit>()
                                            .ActivateLightTheme();
                                      },
                                      color: Colors.white,
                                      icon:
                                          const Icon(Icons.light_mode_outlined));
                                }
                                if (state == ThemeMode.system) {
                                  Brightness brightness =
                                      MediaQuery.of(context).platformBrightness;
                                  return brightness == Brightness.dark
                                      ? IconButton(
                                          onPressed: () {
                                            context
                                                .read<ThemeModeCubit>()
                                                .ActivateLightTheme();
                                          },
                                          color: Colors.white,
                                          icon: const Icon(
                                              Icons.light_mode_outlined))
                                      : IconButton(
                                          onPressed: () {
                                            context
                                                .read<ThemeModeCubit>()
                                                .ActivateDarkTheme();
                                          },
                                          color: Colors.black,
                                          icon: const Icon(
                                              Icons.dark_mode_outlined));
                                }
                                return Container();
                              }),
                            ],
                          ),
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
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(top: 50),
                height: height * 0.68,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.popAndPushNamed(
                            context, SavedAddress.routeName);
                      },
                      child: _menuItem(
                          divider: true,
                          context: context,
                          icon: Icons.favorite_outline_outlined,
                          text: getTranslation(context, "saved_addresses")),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.popAndPushNamed(context, HistoryPage.routeName);
                      },
                      child: _menuItem(
                          divider: true,
                          context: context,
                          icon: Icons.history,
                          text: getTranslation(context, "history_title")),
                    ),
                    GestureDetector(
                      onTap: context.read<CurrentWidgetCubit>().state.key ==
                              const Key("whereto")
                          ? () {
                              Navigator.popAndPushNamed(
                                  context, OrderForOtherScreen.routeName);
                            }
                          : null,
                      child: _menuItem(
                          divider: true,
                          context: context,
                          icon: Icons.border_outer_rounded,
                          text: getTranslation(context, "order_for_other")),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.popAndPushNamed(
                            context, SettingScreen.routeName);
                      },
                      child: _menuItem(
                          divider: true,
                          context: context,
                          icon: Icons.settings_outlined,
                          text: getTranslation(context, "settings")),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.popAndPushNamed(
                            context, AwardScreen.routeName);
                      },
                      child: _menuItem(
                          divider: true,
                          context: context,
                          icon: Icons.wallet_giftcard_outlined,
                          text: getTranslation(context, "award")),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              SizedBox(
                height: height * 0.08,
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Card(
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 5, bottom: 5, right: 10),
                          child: GestureDetector(
                            onTap: () {
                              BlocProvider.of<AuthBloc>(context).add(LogOut());
                              BlocProvider.of<LocationHistoryBloc>(context)
                                  .add(LocationHistoryClear());
                              BlocProvider.of<FavoriteLocationCubit>(context)
                                  .clearFavoriteLocations();

                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                SigninScreen.routeName,
                                ((Route<dynamic> route) => false),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: themeProvider.getColor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(getTranslation(context, "logout"),
                                    style: TextStyle(
                                        color: themeProvider.getColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
/*
                              Card(
                                elevation: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 5, bottom: 5, right: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, SettingScreen.routeName);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.settings,
                                          color: themeProvider.getColor,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            "Settings",
                                            style: TextStyle(
                                                color: themeProvider.getColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
*/

                      Container(
                        padding: const EdgeInsets.only(
                            left: 10, bottom: 20, top: 10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: GestureDetector(
                                  onTap: () {
                                    themeProvider.changeTheme(3);
                                  },
                                  child: Container(
                                    //color: ColorProvider().primaryDeepOrange,
                                    height: 40,
                                    width: 40,
                                    decoration: new BoxDecoration(
                                      color: ColorProvider()
                                          .primaryDeepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: GestureDetector(
                                  onTap: () {
                                    themeProvider.changeTheme(4);
                                  },
                                  child: Container(
                                    //color: ColorProvider().primaryDeepBlue,
                                    height: 40,
                                    width: 40,
                                    decoration: new BoxDecoration(
                                      color:
                                      ColorProvider().primaryDeepBlue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: GestureDetector(
                                  onTap: () {
                                    themeProvider.changeTheme(6);
                                  },
                                  child: Container(
                                    //color: ColorProvider().primaryDeepTeal,
                                    height: 40,
                                    width: 40,
                                    decoration: new BoxDecoration(
                                      color:
                                      ColorProvider().primaryDeepTeal,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        /*child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      themeProvider.changeTheme(0);
                                    },
                                    child: Container(
                                      color: ColorProvider().primaryDeepGreen,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      themeProvider.changeTheme(1);
                                    },
                                    child: Container(
                                      color: ColorProvider().primaryDeepRed,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      themeProvider.changeTheme(2);
                                    },
                                    child: Container(
                                      color: ColorProvider().primaryDeepPurple,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      themeProvider.changeTheme(3);
                                    },
                                    child: Container(
                                      color: ColorProvider().primaryDeepOrange,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      themeProvider.changeTheme(4);
                                    },
                                    child: Container(
                                      color: ColorProvider().primaryDeepBlue,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      themeProvider.changeTheme(5);
                                    },
                                    child: Container(
                                      color: ColorProvider().primaryDeepBlack,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      themeProvider.changeTheme(6);
                                    },
                                    child: Container(
                                      color: ColorProvider().primaryDeepTeal,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                ),
                              ],
                            )
                              */
                      ),
                    ]),
              ),
            ],
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
    const color = Colors.black;
    const hoverColor = Colors.white70;
    return ListTile(
      horizontalTitleGap: 0,
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(color: Colors.black)),
      hoverColor: hoverColor,
    );
  }
}
