import 'dart:convert';

// import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/auth/auth.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/repository/auth.dart';

class UserDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/passengers';
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());
  UserDataProvider({required this.httpClient}) : assert(httpClient != null);

  Future<User> createPassenger(User user) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create-passenger'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        'name': user.firstName,
        'email': user.email,
        'gender': user.gender,
        'password': user.password,
        'phone_number': user.phoneNumber,
        'emergency_contact': user.emergencyContact,
      }),
    );

    if (response.statusCode == 200) {
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
    final http.Response response = await http.post(
      Uri.parse('$_baseUrl/update-profile'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-access-token': '${await authDataProvider.getToken()}'
      },
      body: jsonEncode(<String, dynamic>{
        'first_name': user.firstName,
        'last_name': user.lastName,
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
