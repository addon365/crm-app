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

  factory User.fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    return User(
        id: map['id'],
        userId: map['userId'],
        userName: map['userName'],
        roleGroup: RoleGroup.fromJson(map['roleGroup']));
  }

  factory User.fromDbJson(Map<String, dynamic> map) {
    if (map == null) return null;
    return User(
        id: map['id'],
        userName: map['userName'],
        token: map['token'],
        roleGroup: new RoleGroup(id: map['roleId'], name: map['roleName']));
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
