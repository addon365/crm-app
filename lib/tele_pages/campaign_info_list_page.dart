import 'package:crm_app/db/widget/app-drawer-widget.dart';

import 'package:crm_app/model/view/campaign_info_view_model.dart';
import 'package:crm_app/model/view/campaign_view_model.dart';
import 'package:crm_app/repository/campaign_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'campaign_info_view_page.dart';

//List all the campaign infos, starting campaign will move to the CampaingInfoViewPage.
class CampaignInfoListPage extends StatelessWidget {
  static const routeName = "/campaign-info-list-widget";

  final CampaignRepository _campaignRepository =
      CampaignRepository.getRepository();
  final CampaignViewModel _campaignViewModel;

  CampaignInfoListPage(this._campaignViewModel);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
        drawer: AppDrawerWidget(),
        appBar: AppBar(
          titleSpacing: 0.0,
          title: ListTile(
            title: Text(
              _campaignViewModel.name,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              _campaignViewModel.description,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<List<CampaignInfoViewModel>>(
                stream: Stream.fromFuture(_campaignRepository
                    .fetchCampaignInfos(_campaignViewModel.id)),
                builder: (BuildContext context,
                    AsyncSnapshot<List<CampaignInfoViewModel>> snapshot) {
                  if (snapshot.hasError)
                    return Text("Error " + snapshot.error.toString());
                  if (snapshot.connectionState != ConnectionState.done)
                    return CircularProgressIndicator();
                  if (!snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done)
                    return Text("No Campaign infos");
                  return _buildListView(snapshot.data);
                },
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    onPressed: () => {
                      Navigator.of(context).pushReplacementNamed(
                          CampaignInfoViewPage.routeName,
                          arguments: _campaignViewModel)
                    },
                    child: Text("Start Campaign"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<CampaignInfoViewModel> data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          CampaignInfoViewModel info = data[index];
          return ListTile(
            title: Text(info.companyName),
            leading: CircleAvatar(
              child: Text(info.statusName[0].toUpperCase()),
            ),
            trailing: Icon(FontAwesomeIcons.chevronRight),
          );
        });
  }
}
