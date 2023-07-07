class User {
  User({this.username = "", this.mobileNumber = "", this.emailAddress = ""});

  final String username;
  final String mobileNumber;
  final String emailAddress;

  User copyWith({String? email, String? mobile, String? username}) {
    return User(
        emailAddress: email ?? emailAddress,
        mobileNumber: mobile ?? mobileNumber,
        username: username ?? this.username);
  }
}
