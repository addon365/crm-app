import 'package:crm_app/db/widget/app-drawer-widget.dart';




import 'package:crm_app/marketing_pages/marketing_home_page.dart';
import 'package:crm_app/tele_pages/campaign_list_page.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  static String routeName = "/admin-home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawerWidget(),
      appBar: AppBar(
        title: Text("Home"),
      ),
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
                child: Text("Campaigns"),
                onPressed: () {
                  navigateTo(context, CampaignListPage.routeName);
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
