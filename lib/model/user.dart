import 'role_group.dart';

class User {
  final String id;
  final String userId;
  final String userName;
  final String password;
  final String token;
  final RoleGroup roleGroup;

  User(
      {this.id,
      this.userId,
      this.userName,
      this.password,
      this.token,
      this.roleGroup});

  factory User.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return User(
        id: json['id'],
        userId: json['userId'],
        userName: json['userName'],
        roleGroup: RoleGroup.fromJson(json['roleGroup']));
  }

  factory User.fromDbJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return User(
        id: json['id'],
        userId: json['userId'],
        userName: json['userName'],
        roleGroup: new RoleGroup(id: json['roleId'], name: json['roleName']));
  }

  Map<String, dynamic> toDb() {
    return {
      'id': id,
      'userName': userName,
      "token": token,
      "roleId": roleGroup.id,
      "roleName": roleGroup.name
    };
  }
}
