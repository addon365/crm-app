import 'package:crm_app/employee_list_page.dart';
import 'package:crm_app/splash_page.dart';
import 'package:flutter/cupertino.dart';

import 'home_page.dart';
import 'login_page.dart';

final routes = {
  //SplashPage.routeName:(BuildContext context)=>new SplashPage(),
  HomePage.routeName: (BuildContext context) => new HomePage(),
  '/': (BuildContext context) => new SplashPage(),
  LoginPage.routeName: (BuildContext context) => new LoginPage(),
  EmployeeListPage.routeName: (BuildContext context) => EmployeeListPage(),
};
