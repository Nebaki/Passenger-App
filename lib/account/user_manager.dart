import 'dart:ffi';

import 'package:passengerapp/account/storage.dart';
import 'package:passengerapp/models/models.dart';

class UserManager {
  var store = DataStorage();
  var sample = SecItem("phone", "0922877115");

  void checkUser() {
    var item = SecItem("phone", "0922877115");
    store.performAction(ItemActions.containsKey, item);
  }

  Result createUser(List<SecItem> items) {
    Result result = Result(false, "init");
    List<Result> created = [];
    List<Result> failed = [];
    for (SecItem item in items) {
      store.performAction(ItemActions.edit, item)
          .then((value) => {
        created.add(Result(false, "added "+item.key))
      }).onError((error, stackTrace) => {
        failed.add(Result(false, "Failed to add" +item.key))
      });
    }
    if(!failed.isNotEmpty){
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
  User loadUser() {
    var id,name,phone,email;
    store.loadItem(SecItem("id", "")).then((value) => {
      id = value
    }).onError((error, stackTrace) => {
      id = "Unavailable"
    });
    store.loadItem(SecItem("name", "")).then((value) => {
      name = value
    }).onError((error, stackTrace) => {
      name = "Unavailable"
    });
    store.loadItem(SecItem("phone", "")).then((value) => {
      phone = value
    }).onError((error, stackTrace) => {
      name = "Unavailable"
    });
    store.loadItem(SecItem("email", "")).then((value) => {
      email = value
    }).onError((error, stackTrace) => {
      name = "Unavailable"
    });
    User user = User(id, name, phone, email);
    return user;
  }
  Result removeUser() {
    Result result = Result(false, "init");
    var res = store.performAction(ItemActions.removeAccount, sample);
    res.then((value) => {result = Result(true, "User Removed")}).onError(
        (error, stackTrace) =>
            {result = Result(false, "Failed to remove " +error.toString())});
    return result;
  }

  Result updateUser(List<SecItem> items) {
    Result result = Result(false, "init");
    var res = store.performAction(ItemActions.edit, sample);
    res.then((value) => {
      result = Result(true, "User Removed")
    }).onError((error, stackTrace) => {

    });
    return result;
  }
  Result saveToken(SecItem item) {
    Result result = Result(false, "init");
    var res = store.performAction(ItemActions.edit, item);
    res.then((value) => {
      result = Result(true, "Token Saved")
    }).onError((error, stackTrace) => {
      result = Result(true, "Token not Saved")
    });
    return result;
  }
  Result getToken(SecItem item) {
    Result result = Result(false, "init");
    var res = store.loadItem(item);
    res.then((value) => {
      result = Result(true, value)
    }).onError((error, stackTrace) => {
      result = Result(false, error.toString())
    });
    return result;
  }
}

