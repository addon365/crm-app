import 'package:crm_app/dependency/constants.dart';
import 'package:crm_app/pages/license_generator_page.dart';
import 'package:crm_app/repository/user_repository.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../login_page.dart';

class AppDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: ListTile(
                contentPadding: EdgeInsets.all(0.0),
                leading: getRoleWidget(currentUser.roleGroup.name),
                title: Text(
                  currentUser.userName,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  "Role - ${currentUser.roleGroup.name}",
                  style: TextStyle(color: Colors.white),
                )),
            decoration: BoxDecoration(
              color: Colors.red,
            ),
          ),
          ListTile(
            title: Text("License Generator"),
            trailing: Icon(FontAwesomeIcons.key),
            onTap: () {
              Navigator.pushNamed(context, LicenseGeneratorPage.routeName);
            },
          ),
          ListTile(
            trailing: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              UserRepository userRepository = UserRepository.getRepository();
              userRepository.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginPage.routeName, (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  Widget getRoleWidget(String roleName) {
    switch (roleName) {
      case "admin":
        return CircleAvatar(
          radius: 40,
          child: Image.asset(
            'assets/images/admin_face.png',
          ),
        );
      case "tele":
        return CircleAvatar(
          radius: 40,
          child: Image.asset(
            'assets/images/tele_caller_face.png',
          ),
        );
      default:
        return CircleAvatar(
          radius: 40,
          child: Image.asset(
            'assets/images/service_person_face.png',
          ),
        );
    }
  }
}
