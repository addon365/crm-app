import 'package:crm_app/home_pages/admin_home_page.dart';
import 'package:crm_app/home_pages/marketing_home_page.dart';

import 'package:crm_app/login_page.dart';
import 'package:crm_app/repository/user_repository.dart';
import 'package:flutter/material.dart';

import 'lead_pages/campaign_list_page.dart';
import 'model/user.dart';

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
        navigateToPage(user);
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
        child: Image.asset("assets/splash.png"),
      ),
    );
  }

  void navigateToPage(User user) {
    String routeName;
    switch (user.roleGroup.name) {
      case "marketing":
        routeName = MarketingHomePage.routeName;
        break;
      case "admin":
        routeName = AdminHomePage.routeName;
        break;
      case "tele":
        routeName = CampaignListPage.routeName;
        break;
    }
    Navigator.popAndPushNamed(context, routeName);
  }
}
