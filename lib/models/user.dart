class MyUser {
  final String uid;
  final String email;
  MyUser({this.uid, this.email});
}

class UserData {
  final String uid;
  final String name;
  final String phoneNumber;
  final String gender;
  final String role;
  final String password;
  final String email;
  final String picURL;
  final List likes;

  UserData({
    this.likes,
    this.picURL,
    this.email,
    this.password,
    this.uid,
    this.name,
    this.phoneNumber,
    this.role,
    this.gender,
  });
}
