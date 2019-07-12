import 'package:crm_app/dependency/constants.dart';
import 'package:crm_app/home_pages/marketing_home_page.dart';
import 'package:crm_app/home_pages/tele_home_page.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  static String routeName = "/admin-home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constants.getAppBar(context, "Admin Home"),
      body: new Center(
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                navigateTo(context, MarketingHomePage.routeName);
              },
              child: Text("Appointments"),
            ),
            RaisedButton(
                child: Text("Leads"),
                onPressed: () {
                  navigateTo(context, TeleHomePage.routeName);
                })
          ],
        ),
      ),
    );
  }

  void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }
}
