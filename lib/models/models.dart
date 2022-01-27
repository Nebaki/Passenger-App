
class SecItem {
  SecItem(this.key, this.value);
  final String key;
  final String value;
}
class Result {
  Result(this.success,this.message);
  final bool success;
  final String message;
}
class User{
  User(this.id,this.name,this.phone,this.email,this.userPicture,this.referral);
  final String id;
  final String name;
  final String phone;
  final String email;
  final String userPicture;
  final String referral;

}