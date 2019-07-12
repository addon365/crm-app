import 'dart:async';

import 'package:crm_app/model/user.dart';
import 'package:sqflite/sqflite.dart';

import 'db_base.dart';

class UserDao extends DbBase {
  static const String tableName = "Users";

  Future<void> insert(User user) async {
    final Database db = await database;
    db.insert("users", user.toDb());
  }

  Future<User> fetchUser() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    if (maps.length == 0) return Future.value(null);
    return Future.value(User.fromDbJson((maps.elementAt(0))));
  }

  Future<User> update(String token) async {
    final Database db = await database;
    db.update(tableName, {"token": token});
  }

  Future<int> deleteUser() async {
    final Database db = await database;
    return db.delete(tableName);
  }
}
