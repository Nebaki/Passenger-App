
import 'package:connectivity_plus/connectivity_plus.dart';

class Service {
  Future<bool> isNetworkConnected(int i) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  bool isSystemUp() {
    return true;
  }

  bool isUserBlocked() {
    return true;
  }

  bool isLoginBlocked() {
    return true;
  }
}
