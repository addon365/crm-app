import 'package:crm_app/repository/user_repository.dart';
import 'package:flutter/material.dart';

import '../../login_page.dart';

class AppDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text('Drawer Header'),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('Logout'),
          onTap: () {
            UserRepository userRepository = UserRepository.getRepository();
            userRepository.logout();
            Navigator.of(context).popAndPushNamed(LoginPage.routeName);
          },
        ),
        ListTile(
          title: Text('Close drawer'),
          onTap: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
