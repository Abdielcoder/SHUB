

class User {
  final String UsersID;
  final String username;
  final String profile;
  final String clientID;
  final String CLIENT_NAME;
  final String EMAIL_TO_CLIENT;

  const User({
    this.UsersID,
    this.username,
    this.profile,
    this.clientID,
    this.CLIENT_NAME,
    this.EMAIL_TO_CLIENT,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      UsersID: json['UsersID'],
      username: json['username'],
      profile: json['profile'],
      clientID: json['clientID'],
      CLIENT_NAME: json['CLIENT_NAME'],
      EMAIL_TO_CLIENT: json['EMAIL_TO_CLIENT'],
    );
  }



}
