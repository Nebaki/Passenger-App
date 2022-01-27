import 'dart:convert';

import 'package:passengerapp/account/user_manager.dart';
import 'package:passengerapp/models/local_models/models.dart';
import 'package:passengerapp/utils/session.dart';
class UserTest {
  var userMan = UserManager();
  var session = Session();

  void createUser() {
    Map<String, dynamic> tempUser =
    {'id':'1000','name':'tn','phone':'0922877115',
      'email':'pass@123','userPicture':'tester.in','referral':'123456'};
    var user = SecItem("user", jsonEncode(tempUser));
    var createUser = userMan.createUser(user);

    createUser.then((value) => {
    session.logSuccess("create-user", "success: " + value.message)
    }).onError((error, stackTrace) => {
    session.logError("create-user", "failed: " + error.toString())
    });
  }

  void saveToken() {
    var token = SecItem("token", "token-io");
    var saveToken = userMan.saveToken(token);
    saveToken.then((value) => {
    session.logSuccess("save-token", "success: " + value.message)
    }).onError((error, stackTrace) => {
    session.logError("save-token", "failed: " + error.toString())
    });

  }
  String getSavedToken(){
    var tokens = SecItem("token", "token-io");
    String token = "error";
    var loadToken = userMan.getToken(tokens);
    loadToken.then((value) => {
      session.logSuccess("load-token", "success: " + value.message),
      token = value.message
    }).onError((error, stackTrace) => {
      session.logError("load-token", "failed: " + error.toString()),
      token = "error"
    });
    return token;
  }
  Future<bool> isTokenExist() async {
    var exist = false;
    var token = SecItem("token", "token-io");
    await userMan.getToken(token).then((value) => {
      exist = true,
    }).onError((error, stackTrace) => {
      exist = false,
    });
    return exist;
  }

  void loadUser() {
    var loadUser = userMan.loadUser();
    loadUser.then((value) => {
    session.logSuccess("load-user",
    "success: id " + value.id+" name "+
        value.name+" phone "+
        value.phone+" email "+value.email!+
        " userPicture "+value.userPicture!+
        " referral "+value.referral!
    )
    }).onError((error, stackTrace) => {
    session.logError("load-user", "failed: " + error.toString())
    });

  }

  void flushUser(SecItem user){
    userMan.updateUser(user)
    .then((value) => {
      loadUser(),
      session.logSuccess("up-user", "success: " + value.message)
    }).onError((error, stackTrace) => {
      session.logError("up-user", "failed: " + error.toString())
    });
  }
  void updateUser() {
    var isData = false;
    var name = "new name";
    var email = "new email";
    var picture = "picture";
    Map<String, dynamic> tempUser =
    {};
    userMan.loadUser()
    .then((value) => {
      tempUser = {
        'id':value.id,'name':name,'phone':value.phone,
        'email':email,'userPicture':picture,'referral':'123456'
      },
        flushUser(SecItem("user", jsonEncode(tempUser)))
    })
    .onError((error, stackTrace) => {

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
