
class User {
  User({required this.id, required this.name, required this.phone,
    this.email, this.userPicture, this.referral});
  late String id;
  late String name;
  late String phone;
  late String? email;
  late String? userPicture;
  late String? referral;

  User.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    userPicture = json['userPicture'];
    referral = json['referral'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['userPicture'] = userPicture;
    data['referral'] = referral;
    return data;
  }
}