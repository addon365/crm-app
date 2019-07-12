import 'dart:async';
import 'dart:convert';

import 'package:crm_app/db/user_dao.dart';
import 'package:crm_app/dependency/constants.dart';
import 'package:crm_app/model/user.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  static User currentUser;
  static UserRepository _userRepository;

  static UserRepository getRepository() {
    if (_userRepository == null) _userRepository = new UserRepository();
    return _userRepository;
  }

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
      var error = json.decode(response.body);
      throw Exception(error["message"]);
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

  void updateTokenToDb(String token) {
    UserDao userDao = new UserDao();
    userDao.update(token);
  }

  void updateToken(String token) async {
    final String url = '$baseUrl/User/token';
    String id = currentUser.id;
    Map<String, dynamic> map = {"Id": id, "token": token};

    var response = await http.put(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: map,
        encoding: Encoding.getByName("utf-8"));
    if (response.statusCode == 200) {
      print("TOken Updated successuflly");
    } else {
      throw new Exception("Can't update token");
    }
  }
}
