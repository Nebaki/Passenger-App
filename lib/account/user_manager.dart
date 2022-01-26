import 'dart:ffi';

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

  Future<Result> createUser(List<SecItem> items) async {
    Result result = Result(false, "init");
    List<Result> created = [];
    List<Result> failed = [];
    for (SecItem item in items) {
      await store.performAction(ItemActions.edit, item)
          .then((value) => {
        created.add(Result(false, "added "+item.key))
      }).onError((error, stackTrace) => {
        session.logError("user-add", item.key),
        failed.add(Result(false, "Failed to add" +item.key))
      });
    }
    if(failed.isNotEmpty){
      var data = "--";
      for(Result result in failed){
        data+"," + result.message;
      }
      data+"--";
      result = Result(false, "Failed to add "+data);
    }else{
      result = Result(true, "user created");
    }
    return result;
  }
  Future<User> loadUser() async {
    var id,name,phone,email;
    await store.loadItem(SecItem("id", "")).then((value) => {
      id = value
    }).onError((error, stackTrace) => {
      id = "Unavailable"
    });
    await store.loadItem(SecItem("name", "")).then((value) => {
      name = value
    }).onError((error, stackTrace) => {
      name = "Unavailable"
    });
    await store.loadItem(SecItem("phone", "")).then((value) => {
      phone = value
    }).onError((error, stackTrace) => {
      name = "Unavailable"
    });
    await store.loadItem(SecItem("email", "")).then((value) => {
      email = value
    }).onError((error, stackTrace) => {
      name = "Unavailable"
    });
    User user = User(id, name, phone, email);
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

  Future<Result> updateUser(List<SecItem> items) async {
    Result result = Result(false, "init");
    await store.performAction(ItemActions.edit, sample)
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

