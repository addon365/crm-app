import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class UtilMethods {
  static DateTime parseDateTime(String dateString) {
    var dates = dateString.split('T')[0].split('-');

    int year = int.parse(dates[0]);
    int month = int.parse(dates[1]);
    int day = int.parse(dates[2]);

    return DateTime(year, month, day);
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    DateTime dt = DateTime.now();

    return File('$path/file_${dt.millisecond}_${dt.second}');
  }

  static Future<File> writeToFile(String base64String) async {
    var bytes = base64.decode(base64String);
    final file = await _localFile;
    return file.writeAsBytes(bytes);
  }
}
