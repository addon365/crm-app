import 'package:crm_app/login_page.dart';
import 'package:crm_app/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.signOutAlt),
              onPressed: () {
                signOut();
              }),
        ],
      ),
      body: Center(child: Text("Hello")),
    );
  }

  void signOut() {
    new UserRepository().logout();
    Navigator.popAndPushNamed(context, LoginPage.routeName);
  }
}
