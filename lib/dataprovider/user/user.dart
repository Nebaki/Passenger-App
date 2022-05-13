import 'dart:convert';

// import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/auth/auth.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/repository/auth.dart';

class UserDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/passengers';
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());
  UserDataProvider({required this.httpClient}) : assert(httpClient != null);
  final _imageBaseUrl = 'https://safeway-api.herokuapp.com/';

  final secure_storage = new FlutterSecureStorage();

  Future<User> createPassenger(User user) async {
    print(user.name);
    print(user.email);
    print(user.gender);
    print(user.password);
    print(user.phoneNumber);
    //print(user.emergencyContact);
    final response = await http.post(
      Uri.parse('$_baseUrl/create-passenger'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        'name': user.name,
        'gender': user.gender,
        'password': user.password,
        'phone_number': user.phoneNumber,
      }),
    );
    print("Hererersetttttttttttttttttttttttttttttttttttttt");
    print(response.body);

    if (response.statusCode == 200) {
      final output = jsonDecode(response.body);
      await secure_storage.write(key: 'id', value: output['passenger']['id']);
      await secure_storage.write(
          key: 'phone_number', value: output['passenger']['phone_number']);
      await secure_storage.write(
          key: 'name', value: output['passenger']['name']);
      await secure_storage.write(key: 'token', value: output['token'] ?? "");
      await secure_storage.write(
          key: "email", value: output['passenger']['email'] ?? "");
      await secure_storage.write(
          key: "emergency_contact",
          value: output['passenger']['emergency_contact'] ?? "");

      await secure_storage.write(
          key: 'profile_image',
          value: output['passenger']['profile_image'] != null
              ? _imageBaseUrl + output['passenger']['profile_image']
              : '');

      await secure_storage.write(
          key: "driver_gender",
          value: output["passenger"]['preference']['gender']);
      await secure_storage.write(
          key: "min_rate",
          value: output["passenger"]['preference']['min_rate'].toString());
      await secure_storage.write(
          key: "car_type",
          value: output["passenger"]['preference']['car_type']);
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user.');
    }
  }

  Future uploadImage(XFile file) async {
    final request = http.MultipartRequest(
        'POST', Uri.parse('$_baseUrl/update-profile-image'));
    request.headers['x-access-token'] = '${await authDataProvider.getToken()}';
    request.files.add(await http.MultipartFile.fromPath(
      "profile_image",
      file.path.toString(),
      contentType: MediaType('image', 'jpg'),
    ));
    final response = await request.send();

    if (response.statusCode == 200) {
      await response.stream.transform(utf8.decoder).listen((value) async {
        final data = jsonDecode(value);
        await authDataProvider
            .updateProfile(data['passenger']['profile_image']);
      });

      // var resp = await response.stream.transform(utf8.decoder).listen.;
      // print(resp);

      //final data = jsonDecode(response.);
      //return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to upload image.');
    }
  }

  Future<void> deletePassenger(String id) async {
    final http.Response response = await httpClient.delete(
        Uri.parse('$_baseUrl/delete-passenger/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: {});

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user.');
    }
  }

  Future<User> updatePassenger(User user) async {
    print("heree");
    final http.Response response = await http.post(
      Uri.parse('$_baseUrl/update-profile'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-access-token': '${await authDataProvider.getToken()}'
      },
      body: jsonEncode(<String, dynamic>{
        'name': '${user.name} ',
        'email': user.email,
        'gender': user.gender,
        'phone_number': user.phoneNumber,
        'emergency_contact': user.emergencyContact,
        'preference': user.preference
      }),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      authDataProvider.updateUserData(user);
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode != 204) {
      throw Exception('204 Failed to update user.');
    } else {
      throw Exception('Failed to update user.');
    }
  }

  Future updatePreference(User user) async {
    print("Comeonnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn");
    print(user.preference);
    final http.Response response = await http.post(
      Uri.parse('$_baseUrl/update-profile'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-access-token': '${await authDataProvider.getToken()}'
      },
      body: jsonEncode(<String, dynamic>{'preference': user.preference}),
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['passenger']['preference']['car_type']);
      authDataProvider.updatePreference(
          data['passenger']['preference']['gender'],
          data['passenger']['preference']['min_rate'].toString(),
          data['passenger']['preference']['car_type']);
    } else if (response.statusCode != 204) {
      throw Exception('204 Failed to update user.');
    } else {
      throw Exception('Failed to update user.');
    }
  }

  Future changePassword(Map<String, String> passwordInfo) async {
    final http.Response response =
        await http.post(Uri.parse('$maintenanceUrl/passengers/change-password'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'x-access-token': '${await authDataProvider.getToken()}',
            },
            body: json.encode({
              'current_password': passwordInfo['current_password'],
              "new_password": passwordInfo['new_password'],
              "confirm_password": passwordInfo['confirm_password']
            }));
    print('response ${response.statusCode}');
    if (response.statusCode != 200) {
      throw 'Unable to change password';
    }
  }

  Future<bool> checkPhoneNumber(String phoneNumber) async {
    final http.Response response = await http.get(
      Uri.parse('$_baseUrl/check-phone-number?phone_number=$phoneNumber'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    print('response ${response.statusCode}');
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw 'Unable to check the phonenumber';
    }
  }

  Future forgetPassword(Map<String, String> forgetPasswordInfo) async {
    print(' Pasdre ${forgetPasswordInfo['new_passsword']}o');
    final http.Response response =
        await http.post(Uri.parse('$_baseUrl/forget-password'),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'phone_number': forgetPasswordInfo['phone_number'],
              'newPassword': forgetPasswordInfo['new_password']
            }));
    print('response ${response.statusCode}, ${response.body}');
    if (response.statusCode != 200) {
      throw 'Unable to rest password';
    }
  }

  Future setPassengerAvailablity(List location) async {
    final http.Response response =
        await http.post(Uri.parse('$_baseUrl/set-passenger-availability'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'x-access-token': '${await authDataProvider.getToken()}',
            },
            body: json.encode({'location': location}));

    if (response.statusCode != 200) {
      throw 'Operation Failure';
    }
  }
}


// image upload with dio

// var dio = Dio();

    // dio.interceptors
    //     .add(InterceptorsWrapper(onRequest: (option, handler) async {
    //   print("Yowwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww");

    //   option.headers['x-access-token'] = await authDataProvider.getToken();

    //   return handler.next(option);
    // }, onResponse: (response, handler) {
    //   print("Yowwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww");
    //   print(response.statusMessage);
    //   return handler.next(response);
    // }, onError: (error, handler) {
    //   print(error);
    //   return handler.next(error);
    // }));
    // final formData = FormData.fromMap({
    //   'profile_image': await MultipartFile.fromFile(file.path,
    //       contentType: MediaType('image', 'jpg'))
    // });

    //   final response = await dio.post(
    //     '$_baseUrl/update-profile-image',
    //     data: formData,
    //   );
    //   print(response.statusCode);
