import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/cubit/cubits.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/models/user/user.dart';
import 'package:passengerapp/rout.dart';
import '../../widgets/widgets.dart';

class EditProfile extends StatefulWidget {
  static const routeName = "/editaprofile";

  final EditProfileArgument args;

  const EditProfile({Key? key, required this.args}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isImageLoading = false;
  final Map<String, dynamic> _user = {};

  _showModalNavigation() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return ListTile(
            leading: const Icon(Icons.image),
            title: const Text("Gallery"),
            onTap: () async {
              XFile? image = (await ImagePicker.platform.getImage(
                source: ImageSource.gallery,
              ));

              UserEvent event = UploadProfile(image!);

              BlocProvider.of<UserBloc>(ctx).add(event);
              Navigator.pop(context);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserBloc, UserState>(builder: (context, state) {
        return _buildProfileForm();
      }, listener: (context, state) {
        if (state is ImageUploadSuccess) {
          context.read<ProfilePictureCubit>().getProfilePictureUrl();

          _isImageLoading = false;
        }
        if (state is UserImageLoading) {
          _isImageLoading = true;
        }
        if (state is UsersLoadSuccess) {
          _isLoading = false;
          Future.delayed(const Duration(seconds: 1), () {
            BlocProvider.of<AuthBloc>(context).add(AuthDataLoad());
            Navigator.pop(context);
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(getTranslation(context, "update_successfull")),
            backgroundColor: Colors.green,
          ));
        }
        if (state is UserOperationFailure) {
          _isLoading = false;
                    _isImageLoading = false;

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Update Failed"),
            backgroundColor: Colors.red.shade900,
          ));
        }
      }),
    );
  }

  Widget _buildProfileForm() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            // color: const Color.fromRGBO(240, 241, 241, 1),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.12,
                  right: 10,
                  left: 10,
                  child: Container(
                    height: MediaQuery.of(context).size.height * .88,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getTranslation(context, "edit_profile"),
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(getTranslation(context, "edit_profile_body_text")),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              _showModalNavigation();
                            },
                            child: CircleAvatar(
                              radius: 60,
                              child: _isImageLoading
                                  ? const CircularProgressIndicator()
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: BlocBuilder<ProfilePictureCubit,String>(
                                        builder: (_, state) {
                                          
                                            return CachedNetworkImage(
                                              useOldImageOnUrlChange: true,
                                              imageUrl:
                                                  state,
                                              imageBuilder:
                                                  (context, imageProvider) =>
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
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const  Icon(Icons.person,size: 45),
                                            );
                                          
                                          
                                        },
                                      )),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: widget.args.auth.name,
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              isCollapsed: false,
                              isDense: true,
                              hintText: getTranslation(
                                  context, "name_textfield_hint_text"),
                              focusColor: Colors.blue,
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0.6, color: Colors.orange)),
                           
                              prefixIcon: const Icon(
                                Icons.contact_mail,
                                size: 19,
                              ),
                              // fillColor: Colors.white,
                              filled: true,
                              border: const OutlineInputBorder(
                                  //borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide.none)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This field can\'t be empity';
                            } else if (value.length < 4) {
                              return getTranslation(context,
                                  "create_profile_short_name_validation");
                            } else if (value.length > 25) {
                              return getTranslation(context,
                                  "create_profile_long_name_validation");
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _user['name'] = value;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: widget.args.auth.phoneNumber,
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              isCollapsed: false,
                              isDense: true,
                              hintText: getTranslation(
                                  context, "phone_number_hint_text"),
                              focusColor: Colors.blue,
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0.6, color: Colors.orange)),
                              
                              prefixIcon: const Icon(
                                Icons.phone_callback_outlined,
                                size: 19,
                              ),
                              // fillColor: Colors.white,
                              filled: true,
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return getTranslation(context,
                                  "signin_form_empity_password_validation");
                            } else if (value.length < 4) {
                              return getTranslation(context,
                                  "signin_form_short_password_validation");
                            } else if (value.length > 25) {
                              return getTranslation(context,
                                  "signin_form_long_password_validation");
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _user["phone_number"] = value;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: widget.args.auth.email,
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              isCollapsed: false,
                              isDense: true,
                              hintText: getTranslation(
                                  context, "email_textfield_hint_text"),
                              focusColor: Colors.blue,
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0.6, color: Colors.orange)),
                             
                              prefixIcon: const Icon(
                                Icons.mail_outline,
                                size: 19,
                              ),
                              // fillColor: Colors.white,
                              filled: true,
                              border: const OutlineInputBorder(
                                  //borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide.none)),
                          validator: (value) {
                            if (value!.isEmpty) {}
                            return null;
                          },
                          onSaved: (value) {
                            _user["email"] = value;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: widget.args.auth.emergencyContact,
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              isCollapsed: false,
                              isDense: true,
                              hintText: getTranslation(context,
                                  "emergency_contact_number_hint_text"),
                              focusColor: Colors.blue,
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0.6, color: Colors.orange)),
                              
                              prefixIcon: const Icon(
                                Icons.contact_phone_outlined,
                                size: 19,
                              ),
                              // fillColor: Colors.white,
                              filled: true,
                              border: const OutlineInputBorder(
                                  //borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide.none)),
                          onSaved: (value) {
                            //print("now");
                            _user["emergency_contact"] = value;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    final form = _formKey.currentState;
                                    if (form!.validate()) {
                                      form.save();

                                      updateProfile();
                                    }
                                  },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(),
                                Text(
                                  getTranslation(context, "save_changes"),
                                ),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.black,
                                            strokeWidth: 1,
                                          ),
                                        )
                                      : Container(),
                                )
                              ],
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // SizedBox(
                        //   height: 40,
                        //   width: double.infinity,
                        //   child: TextButton(
                        //       style: ButtonStyle(
                        //           shape: MaterialStateProperty.all<
                        //                   RoundedRectangleBorder>(
                        //               RoundedRectangleBorder(
                        //                   borderRadius:
                        //                       BorderRadius.circular(10))),
                        //           side: MaterialStateProperty.all<BorderSide>(
                        //               BorderSide(color: Colors.red.shade900))),
                        //       onPressed: () {
                        //         showDialog(
                        //             context: context,
                        //             builder: (BuildContext context) =>
                        //                 AlertDialog(
                        //                   title: const Text("Confirm"),
                        //                   content: const Text.rich(TextSpan(
                        //                     text:
                        //                         "Are you sure you want to delete your accout? ",
                        //                   )),
                        //                   actions: [
                        //                     TextButton(
                        //                         onPressed: () {},
                        //                         child: const Text("Yes")),
                        //                     TextButton(
                        //                         onPressed: () {
                        //                           Navigator.pop(context);
                        //                         },
                        //                         child: const Text("No")),
                        //                   ],
                        //                 ));
                        //       },
                        //       child: Text("Delete Account",
                        //           style:
                        //               TextStyle(color: Colors.red.shade900))),
                        // )
                      ],
                    ),
                  ),
                ),
                const CustomeBackArrow(),
              ],
            ),
          ),
        ));
  }

  void updateProfile() {
    setState(() {
      _isLoading = true;
    });
    UserEvent event = UserUpdate(User(
        name: _user['name'],
        phoneNumber: _user['phone_number'],
        gender: "Male",
        id: widget.args.auth.id,
        email: _user['email'],
        emergencyContact: _user['emergency_contact']));

    BlocProvider.of<UserBloc>(context).add(event);
  }
}
