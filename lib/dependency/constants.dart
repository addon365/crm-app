import 'package:crm_app/model/employee.dart';
import 'package:crm_app/model/lead_status.dart';
import 'package:crm_app/model/status.dart';
import 'package:crm_app/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../login_page.dart';

String baseUrl = "https://addon365crm.azurewebsites.net/api";
bool isReleaseMode = true;

void setMode(bool bIsReleaseMode) {
  isReleaseMode = bIsReleaseMode;
  if (isReleaseMode) {
    baseUrl = "https://addon365crm.azurewebsites.net/api";
  } else {
//    baseUrl = "https://addon365crm.azurewebsites.net/api";
    baseUrl = "http://192.168.0.102:3000/api";
  }
}

class Constants {
  static List<Status> statuses;
  static List<Employee> employees;
  static List<LeadStatus> leadStatuses;

  static String token;

  static String formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }

  static AppBar getAppBar(BuildContext context, String title) {
    return AppBar(
      leading: Text(""),
      title: Text(title),
      actions: <Widget>[
        IconButton(
            icon: Icon(FontAwesomeIcons.signOutAlt),
            onPressed: () {
              new UserRepository().logout();
              Navigator.popAndPushNamed(context, LoginPage.routeName);
            }),
      ],
    );
  }
}
