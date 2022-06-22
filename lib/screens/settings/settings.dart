import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';

import '../../cubit/cubits.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = "/settings";

  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          BlocBuilder<ProfilePictureCubit,String>(
            builder: (context, state) {
                return SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: false,
                  expandedHeight: 150,
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
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.person,size: 85),
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
                // _buildPreferenceItems(
                //     context, getTranslation(context, "preference"), state),
                // const SizedBox(
                //   height: 10,
                // ),
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
                  .copyWith(color: Colors.blueAccent),
            ),
             const SizedBox(
              height: 20,
            ),
            ListTile(
              horizontalTitleGap: 0,
minVerticalPadding: 0,
              onTap: () {
                _navigateToEditProfileScreen(context, state);
              },
              contentPadding: EdgeInsets.zero,
              title: Text(
                state.auth.phoneNumber??"loading",
              ),
              subtitle:
                  Text(getTranslation(context, "tap_to_change_phone_number")),
            ),
           const Divider(
             height: 0,
            ),
            ListTile(
                            isThreeLine: false,
minVerticalPadding: 0,
              onTap: () {
                _navigateToEditProfileScreen(context, state);
              },
              contentPadding: EdgeInsets.zero,
              title: Text(
                state.auth.name??"loading",
              ),
              subtitle: Text(getTranslation(context, "name_textfield_hint_text")),
            ),
            const Divider(
              height: 0,
            ),
            ListTile(
              onTap: () {
                _navigateToEditProfileScreen(context, state);
              },
              contentPadding: EdgeInsets.zero,
              title: Text(
                state.auth.email??"loading",
              ),
              subtitle:
                  Text(getTranslation(context, "email_textfield_hint_text")),
            ),
             const Divider(
              height: 0,
            ),
            ListTile(
              onTap: () {
                _navigateToEditProfileScreen(context, state);
              },
              contentPadding: EdgeInsets.zero,
              title: Text(
                state.auth.emergencyContact??"loading",
              ),
              subtitle: Text(
                  getTranslation(context, "emergency_contact_number_hint_text")),
            ),
              const  Divider(
              height: 0,
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, ChangePassword.routeName);
              },
              contentPadding: EdgeInsets.zero,
              title: Text(
                getTranslation(context, "change_password"),
              ),
            ),
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
                  .copyWith(color: Colors.blueAccent),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.contact_mail,
                size: 20,
              ),
              minLeadingWidth: 0,
              title: Text(
                getTranslation(context, "contact_us"),
              ),
            ),
             const Divider(
              height: 0,
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              minLeadingWidth: 0,
              contentPadding: EdgeInsets.zero,
              title: Text(
                getTranslation(context, "privacy_policy"),
              ),
            ),
             const Divider(
              height: 0,
            ),
            ListTile(
              leading: const Icon(Icons.present_to_all_sharp),
              minLeadingWidth: 0,
              contentPadding: EdgeInsets.zero,
              title: Text(
                getTranslation(context, "terms_and_conditions"),
              ),
            ),
             const Divider(
              height: 0,
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, Language.routName,
                    arguments: LanguageArgument(
                        index: context.read<LocaleCubit>().state ==
                                const Locale("en", "US")
                            ? 1
                            : 0));
              },
              leading: const Icon(Icons.language),
              minLeadingWidth: 0,
              contentPadding: EdgeInsets.zero,
              title: Text(
                getTranslation(context, "language"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildPreferenceItems(
  //     BuildContext context, String title, AuthDataLoadSuccess state) {
  //   return Card(
  //           margin: const EdgeInsets.symmetric(horizontal: 0),

  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 20),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const SizedBox(
  //             height: 20,
  //           ),
  //           Text(
  //             title,
  //             style: Theme.of(context)
  //                 .textTheme
  //                 .titleLarge!
  //                 .copyWith(color: Colors.blueAccent),
  //           ),
  //           ListTile(
  //             contentPadding: EdgeInsets.zero,
  //             title: Text(
  //               state.auth.pref!['gender'],
  //             ),
  //             subtitle: Text(getTranslation(context, "driver_gender")),
  //           ),
  //            const Divider(
  //             height: 0,
  //           ),
  //           ListTile(
  //             contentPadding: EdgeInsets.zero,
  //             title: Text(
  //               state.auth.pref!['min_rate'],
  //             ),
  //             subtitle: Text(getTranslation(context, "minimum_driver_rating")),
  //           ),
  //            const Divider(
  //             height: 0,
  //           ),
  //           ListTile(
  //             contentPadding: EdgeInsets.zero,
  //             title: Text(
  //               state.auth.pref!['car_type'],
  //             ),
  //             subtitle: Text(getTranslation(context, "car_type")),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
                  .copyWith(color: Colors.blueAccent),
            ), const Divider(
              height: 0,
            ),
            Text.rich(TextSpan(
                text: "${getTranslation(context, "owned_by")}:\n  ",
                children: const [
                  TextSpan(
                      text: " Safeway Transport",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w300))
                ])),const  Divider(
              height: 0,
            ),
            Text.rich(TextSpan(
                text: "${getTranslation(context, "developerd_by")}:\n  ",
                children: const [
                  TextSpan(
                      text: " Vintage Technologies",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w300))
                ])),
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
                  .copyWith(color: Colors.blueAccent),
            ), const Divider(
              height: 0,
            ),
            Text.rich(TextSpan(
                text: "${getTranslation(context, "build_name")}: ",
                children: const [
                  TextSpan(
                      text: " SafeWay",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w300))
                ])), const Divider(
              height: 0,
            ),
            Text.rich(TextSpan(
                text: "${getTranslation(context, "app_version")}: ",
                children: const [
                  TextSpan(
                      text: " 1.0",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w300))
                ])), const Divider(
              height: 0,
            ),
            Text.rich(TextSpan(
                text: "${getTranslation(context, "build_number")}: ",
                children: const [
                  TextSpan(
                      text: " 102034",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w300))
                ])),
          ],
        ),
      ),
    );
  }
}


// Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 5,
//         centerTitle: true,
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: const Icon(
//               Icons.clear,
//               color: Colors.black,
//             )),
//         title: const Text(
//           "Settings",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
//         String name;
//         String phoneNumber;
//         if (state is AuthDataLoadSuccess) {
//           name = state.auth.name!;
//           phoneNumber = state.auth.phoneNumber!;
//           return ListView(
//             padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
//             children: [
//               Card(
//                 elevation: 3,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.only(top: 8, left: 5),
//                       child: Text(
//                         "Profile",
//                         // style: _textStyle,
//                       ),
//                     ),
//                     const Divider(
//                       color: Colors.red,
//                       thickness: 1.5,
//                     ),
//                     Center(
//                       child: CircleAvatar(
//                         radius: 50,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(100),
//                           child: CachedNetworkImage(
//                             imageUrl: state.auth.profilePicture!,
//                             imageBuilder: (context, imageProvider) => Container(
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: imageProvider,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             placeholder: (context, url) =>
//                                 const CircularProgressIndicator(),
//                             errorWidget: (context, url, error) =>
//                                 const Icon(Icons.error),
//                           ),
//                         ),

//                         // ClipRRect(
//                         //   borderRadius: BorderRadius.circular(100),
//                         //   child: Container(
//                         //     width: 300,
//                         //     height: 300,
//                         //     child: Image.network(
//                         //       state.auth.profilePicture!,
//                         //       fit: BoxFit.cover,
//                         //     ),
//                         //   ),
//                         // ),
//                       ),
//                     ),
//                     Center(child: Text(state.auth.name!)),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             state.auth.phoneNumber!,
//                             // style: _textStyle,
//                           ),
//                           Text(
//                             state.auth.email!,
//                             // style: _textStyle,
//                           ),
//                           Text(
//                             state.auth.emergencyContact!,
//                             // style: _textStyle,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Row(mainAxisAlignment: MainAxisAlignment.end, children: [
//                       TextButton(
//                           onPressed: () {
//                             Navigator.pushNamed(context, EditProfile.routeName,
//                                 arguments: EditProfileArgument(
//                                     auth: Auth(
//                                         phoneNumber: state.auth.phoneNumber,
//                                         id: state.auth.id,
//                                         name: state.auth.name,
//                                         email: state.auth.email,
//                                         emergencyContact:
//                                             state.auth.emergencyContact,
//                                         profilePicture:
//                                             state.auth.profilePicture)));
//                           },
//                           child: const Text("Edit Profile")),
//                       TextButton(
//                           onPressed: () {
//                             Navigator.pushNamed(
//                                 context, ChangePassword.routeName);
//                           },
//                           child: const Text("Change Password")),
//                     ])
//                   ],
//                 ),
//               ),
//               Card(
//                 elevation: 3,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.only(top: 8, left: 5),
//                       child: Text(
//                         "Legal",
//                         // style: _textStyle,
//                       ),
//                     ),
//                     const Divider(
//                       color: Colors.red,
//                       thickness: 1.5,
//                     ),
//                     Container(
//                       padding:
//                           const EdgeInsets.only(left: 10, bottom: 20, top: 10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Contact Us",
//                             style: _textStyle,
//                           ),
//                           Text("Privacy Policy", style: _textStyle),
//                           Text("Terms & Conditions", style: _textStyle),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Card(
//                 elevation: 3,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8, left: 5),
//                       child: Text(
//                         "Preference",
//                         style: _textStyle,
//                       ),
//                     ),
//                     const Divider(
//                       color: Colors.red,
//                       thickness: 1.5,
//                     ),
//                     Container(
//                       padding:
//                           const EdgeInsets.only(left: 10, bottom: 20, top: 10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text.rich(TextSpan(
//                               text: "Driver Gender: ",
//                               style: _textStyle,
//                               children: [
//                                 TextSpan(
//                                     text: state.auth.pref!["gender"],
//                                     style: const TextStyle(
//                                         fontStyle: FontStyle.italic,
//                                         fontWeight: FontWeight.w300))
//                               ])),
//                           Text.rich(TextSpan(
//                               text: "Minimum Driver Rating: ",
//                               style: _textStyle,
//                               children: [
//                                 TextSpan(
//                                     text: state.auth.pref!["min_rate"],
//                                     style: const TextStyle(
//                                         fontStyle: FontStyle.italic,
//                                         fontWeight: FontWeight.w300))
//                               ])),
//                           Text.rich(TextSpan(
//                               text: "Car Type: ",
//                               style: _textStyle,
//                               children: [
//                                 TextSpan(
//                                     text: state.auth.pref!["car_type"],
//                                     style: const TextStyle(
//                                         fontStyle: FontStyle.italic,
//                                         fontWeight: FontWeight.w300))
//                               ])),
//                         ],
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                           onPressed: () {
//                             //print(state.auth.);
//                             Navigator.pushNamed(
//                                 context, PreferenceScreen.routeNAme,
//                                 arguments: PreferenceArgument(
//                                     gender: state.auth.pref!['gender'],
//                                     min_rate: double.parse(
//                                       state.auth.pref!['min_rate'],
//                                     ),
//                                     carType: state.auth.pref!["car_type"]));
//                             // Navigator.pushNamed(
//                             //     context, PreferenceScreen.routeNAme);
//                           },
//                           child: const Text("Edit Preference")),
//                     )
//                   ],
//                 ),
//               ),
//               Card(
//                 elevation: 3,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.only(top: 8, left: 5),
//                       child: Text(
//                         "App Info",
//                         // style: _textStyle,
//                       ),
//                     ),
//                     const Divider(
//                       color: Colors.red,
//                       thickness: 1.5,
//                     ),
//                     Container(
//                       padding:
//                           const EdgeInsets.only(left: 10, bottom: 20, top: 10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text.rich(TextSpan(
//                               text: "Build Name: ",
//                               style: _textStyle,
//                               children: const [
//                                 TextSpan(
//                                     text: " SafeWay",
//                                     style: TextStyle(
//                                         fontStyle: FontStyle.italic,
//                                         fontWeight: FontWeight.w300))
//                               ])),
//                           Text.rich(TextSpan(
//                               text: "App Version: ",
//                               style: _textStyle,
//                               children: const [
//                                 TextSpan(
//                                     text: " 1.0",
//                                     style: TextStyle(
//                                         fontStyle: FontStyle.italic,
//                                         fontWeight: FontWeight.w300))
//                               ])),
//                           Text.rich(TextSpan(
//                               text: "Build Number: ",
//                               style: _textStyle,
//                               children: const [
//                                 TextSpan(
//                                     text: " 102034",
//                                     style: TextStyle(
//                                         fontStyle: FontStyle.italic,
//                                         fontWeight: FontWeight.w300))
//                               ])),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Card(
//                 elevation: 3,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8, left: 5),
//                       child: Text(
//                         "About us",
//                         style: _textStyle,
//                       ),
//                     ),
//                     const Divider(
//                       color: Colors.red,
//                       thickness: 1.5,
//                     ),
//                     Container(
//                       padding:
//                           const EdgeInsets.only(left: 10, bottom: 20, top: 10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text.rich(TextSpan(
//                               text: "Owned by:\n  ",
//                               style: _textStyle,
//                               children: const [
//                                 TextSpan(
//                                     text: " Safeway Transport",
//                                     style: TextStyle(
//                                         fontStyle: FontStyle.italic,
//                                         fontWeight: FontWeight.w300))
//                               ])),
//                           Text.rich(TextSpan(
//                               text: "Developed by:\n  ",
//                               style: _textStyle,
//                               children: const [
//                                 TextSpan(
//                                     text: " Vintage Technologies",
//                                     style: TextStyle(
//                                         fontStyle: FontStyle.italic,
//                                         fontWeight: FontWeight.w300))
//                               ])),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         }

//         if (state is AuthDataLoading) {}
//         return Container();
//       }),
//     );