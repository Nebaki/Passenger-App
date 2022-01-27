class Sanitizer{
  bool isNameValid(String name){
    return name.isNotEmpty && name.length < 40;
  }
  bool isPhoneValid(String phone){
    return true;
  }
  bool isEmailValid(String email){
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
  bool isPasswordValid(String password){
    return password.length > 3 && password.length < 26;
  }
  bool isPasswordMatch(String password1 , String password2){
    return isPasswordValid(password1) &&
        isPasswordValid(password1) && password1 == password2 ;
  }

}