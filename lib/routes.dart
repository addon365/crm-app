import 'package:crm_app/employee_list_page.dart';
import 'package:crm_app/home_pages/admin_home_page.dart';
import 'package:crm_app/home_pages/marketing_home_page.dart';
import 'package:crm_app/home_pages/tele_home_page.dart';
import 'package:crm_app/splash_page.dart';
import 'package:flutter/cupertino.dart';

import 'login_page.dart';

final routes = {
  //SplashPage.routeName:(BuildContext context)=>new SplashPage(),
  MarketingHomePage.routeName: (BuildContext context) =>
      new MarketingHomePage(),
  '/': (BuildContext context) => new SplashPage(),
  LoginPage.routeName: (BuildContext context) => new LoginPage(),
  EmployeeListPage.routeName: (BuildContext context) => EmployeeListPage(),
  TeleHomePage.routeName: (BuildContext context) => TeleHomePage(),
  AdminHomePage.routeName: (BuildContext context) => AdminHomePage(),
};
