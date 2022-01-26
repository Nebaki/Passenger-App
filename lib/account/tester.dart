import 'package:passengerapp/account/user_manager.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/utils/session.dart';

class Tester {
  var userMan = UserManager();
  var session = Session();

  void createUser() {
    var id = SecItem("id", "1000");
    var name = SecItem("name", "winux-jun");
    var phone = SecItem("phone", "0922877115");
    var email = SecItem("email", "winux@jun");
    List<SecItem> user = [];
    user.add(id);
    user.add(name);
    user.add(phone);
    user.add(email);
    var createUser = userMan.createUser(user);
    createUser.then((value) => {
    session.logSuccess("create-user", "success: " + value.message)
    }).onError((error, stackTrace) => {
    session.logError("create-user", "failed: " + error.toString())
    });
  }

  void saveAndLoadToken() {
    var token = SecItem("token", "token-io");
    var saveToken = userMan.saveToken(token);
    saveToken.then((value) => {
    session.logSuccess("save-token", "success: " + value.message)
    }).onError((error, stackTrace) => {
    session.logError("save-token", "failed: " + error.toString())
    });

    var loadToken = userMan.getToken(token);
    loadToken.then((value) => {
    session.logSuccess("load-token", "success: " + value.message)
    }).onError((error, stackTrace) => {
    session.logError("load-token", "failed: " + error.toString())
    });
  }
  Future<bool> isTokenExist() async {
    var exist = false;
    var token = SecItem("token", "token-io");
    await userMan.getToken(token).then((value) => {
      exist = true,
    }).onError((error, stackTrace) => {
      exist = false,
    });

    /*
    loadToken.then((value) => {
      exist = true,
      session.logSuccess("load-token", "success: " + value.message)
    }).onError((error, stackTrace) => {
      session.logError("load-token", "failed: " + error.toString())
    });*/
    return exist;
  }

  void loadUser() {
    var loadUser = userMan.loadUser();
    loadUser.then((value) => {
    session.logSuccess("load-user",
    "success: id " + value.id+" name "+
        value.name+" phone "+
        value.phone+" email "+value.email
    )
    }).onError((error, stackTrace) => {
    session.logError("load-user", "failed: " + error.toString())
    });

  }

  void updateUser() {
    var name = SecItem("name", "winux-pro");
    var phone = SecItem("phone", "winux@pro");
    List<SecItem> user = [];
    user.add(name);
    user.add(phone);
    var updateUser = userMan.updateUser(user);
    updateUser.then((value) => {
    session.logSuccess("up-user", "success: " + value.message)
    }).onError((error, stackTrace) => {
    session.logError("up-user", "failed: " + error.toString())
    });
  }

  void removeUser() {
    var removeUser = userMan.removeUser();
    removeUser.then((value) => {
    session.logSuccess("rm-user", "success: " + value.message)
    }).onError((error, stackTrace) => {
    session.logError("rm-user", "failed: " + error.toString())
    });
  }
}
