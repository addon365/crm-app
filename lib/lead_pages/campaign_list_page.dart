import 'dart:async';
import 'dart:io';

import 'package:crm_app/db/widget/app-drawer-widget.dart';
import 'package:crm_app/model/view/campaign_view_model.dart';
import 'package:crm_app/repository/campaign_repository.dart';
import 'package:flutter/material.dart';

import 'campaign_info_list_page.dart';

//List all the campaign, CampaignInfoListPage is shown on click the item.

class CampaignListPage extends StatelessWidget {
  static const routeName = "/campaign-list-page";

  final CampaignRepository _campaignRepository =
      CampaignRepository.getRepository();

  Widget buildListWidget(List<CampaignViewModel> campaigns) {
    return ListView.builder(
        itemCount: campaigns.length,
        itemBuilder: (context, index) {
          CampaignViewModel campaignVm = campaigns[index];
          return ListTile(
            onTap: () => navigateTo(context, campaignVm),
            title: Text(campaigns[index].name),
          );
        });
  }

  Future<bool> _onWillPop(BuildContext context) {
    if (Navigator.canPop(context)) {
      return Future.value(true);
    }
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _onWillPop(context);
      },
      child: Scaffold(
        drawer: AppDrawerWidget(),
        appBar: AppBar(
          title: Text("Campaign List"),
        ),
        body: new StreamBuilder<List<CampaignViewModel>>(
            stream: Stream.fromFuture(_campaignRepository.fetchCampaigns()),
            builder: (BuildContext context,
                AsyncSnapshot<List<CampaignViewModel>> asyncSnapshot) {
              if (asyncSnapshot.hasError) {
                return new Text(asyncSnapshot.error.toString());
              }
              if (asyncSnapshot.connectionState != ConnectionState.done) {
                return CircularProgressIndicator();
              }
              if (!asyncSnapshot.hasData &&
                  asyncSnapshot.connectionState == ConnectionState.done)
                return Text("No Campaign");
              return buildListWidget(asyncSnapshot.data);
            }),
      ),
    );
  }

  navigateTo(BuildContext context, CampaignViewModel campaignVm) {
    Navigator.popAndPushNamed(context, CampaignInfoListPage.routeName,
        arguments: campaignVm);
  }
}
