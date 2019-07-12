import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbBase {
  static Future<Database> getDatabase() async {
    String path = join(await getDatabasesPath(), 'addon_crm.db');
    return openDatabase(path, onCreate: createTables, version: 2);
  }

// Open the database and store the reference
  final Future<Database> database = getDatabase();

  static FutureOr<void> createTables(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Users(id TEXT PRIMARY KEY,username TEXT,token TEXT,roleId TEXT,roleName TEXT)");
  }
}
