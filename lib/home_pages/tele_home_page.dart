import 'dart:async';

import 'package:crm_app/model/view/campaign_view_model.dart';
import 'package:crm_app/repository/campaign_repository.dart';
import 'package:flutter/material.dart';

class CampaignListPage extends StatelessWidget {
  final CampaignRepository _campaignRepository =
      CampaignRepository.getRepository();
  final Function move;
  CampaignListPage(this.move);
  Widget buildListWidget(List<CampaignViewModel> campaigns) {
    return ListView.builder(
        itemCount: campaigns.length,
        itemBuilder: (context, index) {
          return ListTile(

            title: Text(campaigns[index].name),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Campaign List"),),
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
    );
  }
}
