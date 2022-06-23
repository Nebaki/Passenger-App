import 'dart:convert';
// import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/auth/auth.dart';
import 'package:passengerapp/models/models.dart';

class UserDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/passengers';
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());
  UserDataProvider({required this.httpClient});
  final _imageBaseUrl = 'https://safeway-api.herokuapp.com/';

  final secureStorage = const FlutterSecureStorage();
  void updateCookie(http.Response response) async {
    final rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      await secureStorage.write(
          key: "refresh_token",
          value: (index == -1) ? rawCookie : rawCookie.substring(0, index));
    }
  }

  Future<User> createPassenger(User user) async {
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

    if (response.statusCode == 200) {
      final output = jsonDecode(response.body);
      updateCookie(response);
      await secureStorage.write(key: 'id', value: output['passenger']['id']);
      await secureStorage.write(
          key: 'phone_number', value: output['passenger']['phone_number']);
      await secureStorage.write(
          key: 'name', value: output['passenger']['name']);
      await secureStorage.write(key: 'token', value: output['token'] ?? "");
      await secureStorage.write(
          key: "email", value: output['passenger']['email'] ?? "");
      await secureStorage.write(
          key: "emergency_contact",
          value: output['passenger']['emergency_contact'] ?? "");

      // prefs.setString('profile_picture_url', _imageBaseUrl + output['passenger']['profile_image']);
      // print(_imageBaseUrl + output['passenger']['profile_image']);
      await secureStorage.write(
          key: 'profile_image',
          value: output['passenger']['profile_image'] != null
              ? _imageBaseUrl + output['passenger']['profile_image']
              : '');

      await secureStorage.write(
          key: "driver_gender",
          value: output["passenger"]['preference']['gender']);
      await secureStorage.write(
          key: "min_rate",
          value: output["passenger"]['preference']['min_rate'].toString());
      await secureStorage.write(
          key: "car_type",
          value: output["passenger"]['preference']['car_type']);
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return createPassenger(user);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception(response.statusCode);
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
      response.stream.transform(utf8.decoder).listen((value) async {
        final data = jsonDecode(value);

        await authDataProvider
            .updateProfile(data['passenger']['profile_image']);
      });
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return uploadImage(file);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception(response.statusCode);
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
      throw Exception(response.statusCode);
    }
  }

  Future<User> updatePassenger(User user) async {
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

    if (response.statusCode == 200) {
      authDataProvider.updateUserData(user);
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode != 204) {
      throw Exception('204 Failed to update user.');
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return updatePassenger(user);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future updatePreference(User user) async {
    final http.Response response = await http.post(
      Uri.parse('$_baseUrl/update-profile'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-access-token': '${await authDataProvider.getToken()}'
      },
      body: jsonEncode(<String, dynamic>{'preference': user.preference}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      authDataProvider.updatePreference(
          data['passenger']['preference']['gender'],
          data['passenger']['preference']['min_rate'].toString(),
          data['passenger']['preference']['car_type']);
    } else if (response.statusCode != 204) {
      throw Exception('204 Failed to update user.');
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return updatePreference(user);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future changePassword(Map<String, String> passwordInfo) async {
    final http.Response response =
        await http.post(Uri.parse('$_baseUrl/change-password'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'x-access-token': '${await authDataProvider.getToken()}',
            },
            body: json.encode({
              'current_password': passwordInfo['current_password'],
              "new_password": passwordInfo['new_password'],
              "confirm_password": passwordInfo['confirm_password']
            }));
    if (response.statusCode == 200) {
      // throw 'Unable to change password';
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return changePassword(passwordInfo);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<bool> checkPhoneNumber(String phoneNumber) async {
    final http.Response response = await http.get(
      Uri.parse('$_baseUrl/check-phone-number?phone_number=$phoneNumber'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return checkPhoneNumber(phoneNumber);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future forgetPassword(Map<String, String> forgetPasswordInfo) async {
    final http.Response response =
        await http.post(Uri.parse('$_baseUrl/forget-password'),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'phone_number': forgetPasswordInfo['phone_number'],
              'newPassword': forgetPasswordInfo['new_password']
            }));
    if (response.statusCode == 200) {
      // throw 'Unable to rest password';
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return forgetPassword(forgetPasswordInfo);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future setPassengerAvailablity(List location, bool status) async {
    final http.Response response = await http.post(
        Uri.parse('$_baseUrl/set-passenger-availability'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-access-token': '${await authDataProvider.getToken()}',
        },
        body: status ? json.encode({'location': location}) : json.encode({}));

    if (response.statusCode == 200) {
      // throw 'Operation Failure';
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return setPassengerAvailablity(location, status);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception(response.statusCode);
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
