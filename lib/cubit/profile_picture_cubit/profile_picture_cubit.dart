import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilePictureCubit extends Cubit<String> {
  final secureStorage = const FlutterSecureStorage();

  ProfilePictureCubit() : super("");
  void getProfilePictureUrl() async {
    final url = await secureStorage.read(key:"profile_image");
        print("YOOOOOOOOOOOOOOOOWWW $url");

    emit(url??'');
  }

  void updateProfilePictureUrl(String url) async {
    await secureStorage.write(key:"profile_image", value:url);
            print("YOOOOOOOOOOOOOOOOWWW $url");

    emit(url);
  }
}
