import 'package:crm_app/lead_pages/campaign_list_page.dart';

import 'package:flutter/material.dart';

///Telemarketing  people home page view is navigated handled here.
///which list all the campaign to start followup/
class TeleHomePage extends StatefulWidget {
  static const routeName = "tele-home-page";

  @override
  _TeleHomePageState createState() => _TeleHomePageState();
}

class _TeleHomePageState extends State<TeleHomePage> {
  @override
  void initState() {
    super.initState();

    navigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Campaign List"),
        ),
        body: CircularProgressIndicator());
  }

  void navigate() {
    Navigator.popAndPushNamed(context, CampaignListPage.routeName);
  }
}
