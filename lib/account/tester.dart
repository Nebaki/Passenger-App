import 'package:passengerapp/account/user_manager.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/utils/session.dart';

class Tester {
  var userMan = UserManager();
  var session = Session();

  void createUser() {
    var id = SecItem("id", "1000");
    var name = SecItem("name", "winux-jun");
    var phone = SecItem("phone", "winux@jun");
    var email = SecItem("email", "0922877115");
    List<SecItem> user = [];
    user.add(id);
    user.add(name);
    user.add(phone);
    user.add(email);
    var createUser = userMan.createUser(user);
    if (createUser.success) {
      session.logSuccess("create-user", "success: " + createUser.message);
    } else {
      session.logSuccess("create-user", "failed: " + createUser.message);
    }
  }

  void saveAndLoadToken() {
    var token = SecItem("token", "token-io");
    var saveToken = userMan.saveToken(token);
    if (saveToken.success) {
      session.logSuccess("save-token", "success: " + saveToken.message);
    } else {
      session.logSuccess("save-token", "failed: " + saveToken.message);
    }

    var loadToken = userMan.getToken(token);
    if (loadToken.success) {
      session.logSuccess("load-token", "success: " + loadToken.message);
    } else {
      session.logSuccess("load-token", "failed: " + loadToken.message);
    }
  }

  void loadUser() {
    var loadUser = userMan.loadUser();
    session.logSuccess("load-user",
        "success: id" + loadUser.id+" name"+
            loadUser.name+" phone"+
            loadUser.phone+" email"+loadUser.email
    );
  }

  void updateUser() {
    var name = SecItem("name", "winux-pro");
    var phone = SecItem("phone", "winux@pro");
    List<SecItem> user = [];
    user.add(name);
    user.add(phone);
    var updateUser = userMan.createUser(user);
    if (updateUser.success) {
      session.logSuccess("up-user", "success: " + updateUser.message);
    } else {
      session.logSuccess("up-user", "failed: " + updateUser.message);
    }
  }

  void removeUser() {
    var removeUser = userMan.removeUser();
    if (removeUser.success) {
      session.logSuccess("rm-user", "success: " + removeUser.message);
    } else {
      session.logSuccess("rm-user", "failed: " + removeUser.message);
    }
  }
}
