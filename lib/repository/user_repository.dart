import 'dart:async';
import 'dart:convert';

import 'package:crm_app/db/user_dao.dart';
import 'package:crm_app/dependency/constants.dart';
import 'package:crm_app/model/user.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  static User currentUser;

  Future<User> validateUser(String userName, String password) async {
    final String url = '$baseUrl/User/authenticate';
    Map<String, dynamic> map = {"userId": userName, "password": password};

    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: map,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      User user = User.fromJson(json.decode(response.body));
      UserDao userDao = new UserDao();
      userDao.insert(user);
      return user;
    } else {
      throw Exception(response.body);
    }
  }

  Future<User> getUserSession() async {
    UserDao userDao = new UserDao();
    User user = await userDao.fetchUser();
    return user;
  }

  Future<bool> logout() {
    UserDao userDao = new UserDao();
    userDao.deleteUser();
  }
}
