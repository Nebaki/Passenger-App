import 'dart:convert';
import 'package:passengerapp/account/storage.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/utils/session.dart';

class UserManager {
  var session = Session();
  var store = DataStorage();
  var sample = SecItem("phone", "0922877115");

  void checkUser() {
    var item = SecItem("phone", "0922877115");
    store.performAction(ItemActions.containsKey, item);
  }
  Future<Result> createUser(SecItem item) async{
    Result result = Result(false, "init");
    await store.performAction(ItemActions.edit, item)
        .then((value) => {
      result = Result(false, "added "+item.key)
    }).onError((error, stackTrace) => {
      result = Result(false, "Failed to add" +item.key)
    });
    return result;
  }
  Future<User> loadUser() async {
     Map<String,dynamic> data = {};
    await store.loadItem(SecItem("user", "")).then((value) => {
       data = jsonDecode(value)
    }).onError((error, stackTrace) => {
      data = {}
    });
    return _userFromJson(data);
  }
  User _userFromJson(Map<String,dynamic> data){
    User user;
    if(data.isNotEmpty){
      user =  User(data['id'], data['name'], data['phone'],
      data['email'], data['userPicture'], data['referral']);
    }else{
      user =  User('0', 'loading', 'loading','loading', 'loading', 'loading');
    }
    return user;
  }
  Future<Result> removeUser() async {
    Result result = Result(false, "init");
    await store.performAction(ItemActions.removeAccount, sample)
    .then((value) => {result = Result(true, "User Removed")}).onError(
        (error, stackTrace) =>
            {result = Result(false, "Failed to remove " +error.toString())});
    return result;
  }

  Future<Result> updateUser(SecItem items) async {
    Result result = Result(false, "init");
    await store.performAction(ItemActions.edit, items)
        .then((value) => {
      result = Result(true, "User Updated")
    }).onError((error, stackTrace) => {
      result = Result(false, "User Updated Failed")
    });
    return result;
  }
  Future<Result> saveToken(SecItem item) async {
    Result result = Result(false, "init");
    await store.performAction(ItemActions.edit, item)
        .then((value) => {
      result = Result(true, "Token Saved")
    }).onError((error, stackTrace) => {
      result = Result(true, "Token not Saved")
    });
    return result;
  }
  Future<Result> getToken(SecItem item) async {
    Result result = Result(false, "init");
    await store.loadItem(item)
        .then((value) => {
      result = Result(true, value)
    }).onError((error, stackTrace) => {
      result = Result(false, error.toString())
    });
    return result;
  }
}

