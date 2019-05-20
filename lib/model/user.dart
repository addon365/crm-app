class User {
  final String id;
  final String userId;
  final String userName;
  final String password;

  User({this.id, this.userId, this.userName, this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return User(
        id: json['id'], userId: json['userId'], userName: json['userName']);
  }

  Map<String, dynamic> toDb() {
    return {
      'id': id,
      'userName': userName,
    };
  }
}
