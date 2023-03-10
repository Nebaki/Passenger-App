import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/screens/settings/pages/privacy.dart';
import 'package:passengerapp/screens/settings/pages/terms.dart';

import '../../cubit/cubits.dart';
import '../../localization/localization.dart';
import 'pages/feedbacks.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = "/settings";

  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _appBar = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        key: _appBar,
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
                //_buildAppinfoItems(context, getTranslation(context, "app_info")),
                _buildAboutUsItems(
                    context, getTranslation(context, "about_us")),
                const SizedBox(
                  height: 10,
                ),
              ]));
            }
            return const Center(child: Text("Something went wrong"));
          }))
        ],
      ),
    );
  }

  final List<String> dropDownItems = ["Amharic", "English"];

  String getTrans(String key) {
    return Localization.of(context).getTranslation(key);
  }

  _buildLanguageMenu() {
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.language,color: Colors.black,),
              ),
              Text(getTrans("language")),
              const SizedBox(
                width: 10,
              ),
              BlocBuilder<LocaleCubit, Locale>(
                builder: (context, state) => DropdownButton(
                    dropdownColor: Colors.white,
                    value: state == const Locale("en", "US")
                        ? "English"
                        : "Amharic",
                    items: dropDownItems
                        .map((e) => DropdownMenuItem(
                              child: Text(
                                e,
                                style: TextStyle(color: Colors.black),
                              ),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (value) {
                      switch (value) {
                        case "Amharic":
                          context
                              .read<LocaleCubit>()
                              .changeLocale(const Locale("am", "ET"));

                          break;
                        case "English":
                          context
                              .read<LocaleCubit>()
                              .changeLocale(const Locale("en", "US"));

                          break;
                        default:
                          context
                              .read<LocaleCubit>()
                              .changeLocale(const Locale("en", "US"));
                      }
                    }),
              )
            ],
          ),
        ));
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
                  state.auth.phoneNumber ?? "Loading"),
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
                  Icons.phone,
                  getTranslation(context, "emergency_contact_number_hint_text"),
                  state.auth.emergencyContact ?? "loading"),
            ),
            const Divider(
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ChangePassword.routeName);
                  },
                  child: Text(
                    getTranslation(context, "change_password"),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
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
                        child: Text(title),
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
              onTap: () {
                Navigator.pushNamed(
                    context,FeedbackScreen.routeName);
              },
              child: _settingItem(context, Icons.contact_mail, "",
                  getTranslation(context, "contact_us")),
            ),
            const Divider(
              height: 0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context, PrivacyScreen.routeName
                );
              },
              child: _settingItem(context, Icons.privacy_tip_outlined, "",
                  getTranslation(context, "privacy_policy")),
            ),
            const Divider(
              height: 0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context,TermsAndConditionScreen.routeName);
              },
              child: _settingItem(context, Icons.present_to_all_sharp, "",
                  getTranslation(context, "terms_and_conditions")),
            ),
            const Divider(
              height: 0,
            ),
            GestureDetector(
              onTap: () {},/*
              child: _settingItem(context, Icons.language, "",
                  getTranslation(context, "language")),
              */
              child: _buildLanguageMenu(),
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
                        text: " Tropical Trading",
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
                  text: "${getTranslation(context, "build_name")} ",
                  children: const [
                    TextSpan(
                        text: " Gari",
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
                  text: "${getTranslation(context, "app_version")} ",
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
                  text: "${getTranslation(context, "build_number")} ",
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
