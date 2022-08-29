import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';

import '../../cubit/cubits.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = "/settings";

  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          BlocBuilder<ProfilePictureCubit, String>(
            builder: (context, state) {
              return SliverAppBar(
                floating: true,
                pinned: true,
                iconTheme: IconThemeData(color: Colors.white),
                snap: false,
                expandedHeight: 200,
                backgroundColor: Theme.of(context).primaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: state,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        const Icon(Icons.person, size: 85),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person, size: 85),
                  ),
                  title: Text(getTranslation(context, "settings")),
                ),
              );
            },
          ),
          BlocBuilder<AuthBloc, AuthState>(builder: ((context, state) {
            if (state is AuthDataLoadSuccess) {
              return SliverList(
                  delegate: SliverChildListDelegate([
                _buildAccountItems(
                    context, getTranslation(context, "account"), state),
                const SizedBox(
                  height: 10,
                ),
                _buildLegalItems(context, getTranslation(context, "legal")),
                const SizedBox(
                  height: 10,
                ),
                _buildAppinfoItems(
                    context, getTranslation(context, "app_info")),
                const SizedBox(
                  height: 10,
                ),
                _buildAboutUsItems(context, getTranslation(context, "about_us"))
              ]));
            }
            return Container();
          }))
        ],
      ),
    );
  }

  void _navigateToEditProfileScreen(
      BuildContext context, AuthDataLoadSuccess state) {
    Navigator.pushNamed(context, EditProfile.routeName,
        arguments: EditProfileArgument(
            auth: Auth(
                phoneNumber: state.auth.phoneNumber,
                id: state.auth.id,
                name: state.auth.name,
                email: state.auth.email,
                emergencyContact: state.auth.emergencyContact,
                profilePicture: state.auth.profilePicture)));
  }

  Widget _buildAccountItems(
      BuildContext context, String title, AuthDataLoadSuccess state) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                _navigateToEditProfileScreen(context, state);
              },
              child: _settingItem(
                  context,
                  Icons.phone,
                  getTranslation(context, "tap_to_change_phone_number"),
                  state.auth.phoneNumber ?? "loading"),
            ),
            const Divider(
              height: 0,
            ),
            GestureDetector(
              onTap: () {
                _navigateToEditProfileScreen(context, state);
              },
              child: _settingItem(
                  context,
                  Icons.person,
                  getTranslation(context, "name_textfield_hint_text"),
                  state.auth.name ?? "loading"),
            ),
            const Divider(
              height: 0,
            ),
            GestureDetector(
              onTap: () {
                _navigateToEditProfileScreen(context, state);
              },
              child: _settingItem(
                  context,
                  Icons.email,
                  getTranslation(context, "email_textfield_hint_text"),
                  state.auth.email ?? "loading"),
            ),
            const Divider(
              height: 0,
            ),
            GestureDetector(
              onTap: () {
                _navigateToEditProfileScreen(context, state);
              },
              child: _settingItem(
                  context,
                  Icons.emergency,
                  getTranslation(context, "emergency_contact_number_hint_text"),
                  state.auth.emergencyContact ?? "loading"),
            ),
            const Divider(
              height: 0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ChangePassword.routeName);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            getTranslation(context, "change_password"),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _settingItem(
      BuildContext context, IconData iconData, String title, String value) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            title != ""
                ? Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(title,
                            style: TextStyle(
                              fontSize: 11,
                              //color: Theme.of(context).primaryColor
                            )),
                      ),
                    ],
                  )
                : Container(),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(iconData, color: Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(value),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLegalItems(BuildContext context, String title) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            GestureDetector(
              onTap: () {},
              child: _settingItem(context, Icons.contact_mail, "",
                  getTranslation(context, "contact_us")),
            ),
            const Divider(
              height: 0,
            ),
            GestureDetector(
              onTap: () {},
              child: _settingItem(context, Icons.privacy_tip_outlined, "",
                  getTranslation(context, "privacy_policy")),
            ),
            const Divider(
              height: 0,
            ),
            GestureDetector(
              onTap: () {},
              child: _settingItem(context, Icons.present_to_all_sharp, "",
                  getTranslation(context, "terms_and_conditions")),
            ),
            const Divider(
              height: 0,
            ),
            GestureDetector(
              onTap: () {},
              child: _settingItem(context, Icons.language, "",
                  getTranslation(context, "language")),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildPreferenceItems(
  Widget _buildAboutUsItems(BuildContext context, String title) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            const Divider(
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(TextSpan(
                  text: "${getTranslation(context, "owned_by")}:\n  ",
                  children: [
                    TextSpan(
                        text: " Safeway Transport",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300))
                  ])),
            ),
            const Divider(
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(TextSpan(
                  text: "${getTranslation(context, "developed_by")}:\n  ",
                  children: [
                    TextSpan(
                        text: " Vintage Technologies: +251916772303",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300))
                  ])),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppinfoItems(BuildContext context, String title) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            const Divider(
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(TextSpan(
                  text: "${getTranslation(context, "build_name")}: ",
                  children: const [
                    TextSpan(
                        text: " SafeWay",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300))
                  ])),
            ),
            const Divider(
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(TextSpan(
                  text: "${getTranslation(context, "app_version")}: ",
                  children: const [
                    TextSpan(
                        text: " 1.0",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300))
                  ])),
            ),
            const Divider(
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(TextSpan(
                  text: "${getTranslation(context, "build_number")}: ",
                  children: const [
                    TextSpan(
                        text: " 102034",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300))
                  ])),
            ),
          ],
        ),
      ),
    );
  }
}
