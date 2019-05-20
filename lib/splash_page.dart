import 'package:crm_app/login_page.dart';
import 'package:crm_app/repository/user_repository.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    new UserRepository().getUserSession().then((user) {
      if (user != null) {
        UserRepository.currentUser = user;
        Navigator.popAndPushNamed(context, HomePage.routeName);
      } else {
        Navigator.popAndPushNamed(context, LoginPage.routeName);
      }
    }).catchError((onError) {
      Navigator.popAndPushNamed(context, LoginPage.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Theme.of(context).primaryColor,
          child: Center(
              child: Text(
            "Addon Technologies Pvt Ltd",
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ))),
    );
  }
}
