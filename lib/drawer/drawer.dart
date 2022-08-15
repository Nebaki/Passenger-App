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

class NavDrawer extends StatelessWidget {
  final authDataProvider = AuthDataProvider(httpClient: http.Client());

  NavDrawer({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Material(
      color: const Color.fromRGBO(240, 241, 241, 1),
      child: CustomPaint(
        painter: DrawerBackGround(context),
        child: Column(
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
              height: MediaQuery.of(context).size.height * 0.7,
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
                  GestureDetector(
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
                    child: _menuItem(
                        divider: false,
                        context: context,
                        icon: Icons.logout,
                        text: getTranslation(context, "logout")),
                  ),
                ],
              ),
            ),
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
      title: Text(text, style: const TextStyle(color: Colors.black)),
      hoverColor: hoverColor,
    );
  }
}
