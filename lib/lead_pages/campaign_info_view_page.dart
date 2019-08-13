import 'package:crm_app/dependency/constants.dart';
import 'package:crm_app/lead_pages/dialog/comment_dialog.dart';

import 'package:crm_app/model/campaign.dart';
import 'package:crm_app/model/lead.dart';
import 'package:crm_app/model/lead_comment.dart';
import 'package:crm_app/model/lead_history.dart';
import 'package:crm_app/model/lead_status.dart';
import 'package:crm_app/model/view/campaign_info_view_model.dart';
import 'package:crm_app/model/view/campaign_view_model.dart';
import 'package:crm_app/repository/campaign_repository.dart';
import 'package:crm_app/repository/lead_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import 'campaign_info_list_page.dart';

class CampaignInfoViewPage extends StatefulWidget {
  static const routeName = "/campaign-info-view-page";
  final CampaignViewModel campaignViewModel;
  CampaignInfoViewPage(this.campaignViewModel);

  @override
  _CampaignInfoViewPageState createState() => _CampaignInfoViewPageState();
}

class _CampaignInfoViewPageState extends State<CampaignInfoViewPage> {
  final LeadRepository _leadRepository = LeadRepository.getRepository();

  final CampaignRepository _campaignRepository =
      CampaignRepository.getRepository();

  int _index = -1;
  CampaignInfo _currentCampaignInfo;
  List<CampaignInfoViewModel> _campaignInfos;
  bool _isLoading = true;

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  initState() {
    super.initState();

    loadLeadStatuses();

    //Loads all the campaign Infos and load the first campaign.
    _campaignRepository
        .fetchCampaignInfos(this.widget.campaignViewModel.id)
        .then((campaignInfos) {
      this._campaignInfos = campaignInfos;
      move(++_index);
    });
  }

  ///sends the lead followup comments to server.
  updateComments(LeadHistory leadHistory, LeadComment leadComment) async {
    setState(() {
      _isLoading = true;
    });
    String jsonBody = json.encode(
        new LeadComment(type: leadComment.type, comment: leadComment.comment)
            .toJson());
    leadHistory.extraData = jsonBody;

    this._currentCampaignInfo.lead.history.add(leadHistory);

    _leadRepository
        .updateLeadHistory(this._currentCampaignInfo.lead)
        .then((resultLead) {
      if (resultLead != null) {
        move(++_index);
      }
    });
  }

  void showCommentDialog(LeadStatus leadStatus) {
    var lead = _currentCampaignInfo.lead;
    var leadHistory = new LeadHistory(
        id: lead.id, statusId: leadStatus.id, status: leadStatus);

    showDialog(
        context: context,
        builder: (BuildContext context) => CommentDailog()).then((result) {
      var leadComment = new LeadComment(type: "text", comment: result);

      updateComments(leadHistory, leadComment);
    });
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Select Status",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: Constants.leadStatuses.map((l) {
                  return FlatButton(
                    child: Text(l.name),
                    onPressed: () {
                      Navigator.pop(context, l);
                    },
                  );
                }).toList(),
              ),
            ],
          );
        }).then((result) {
      showCommentDialog(result);
    });
  }

  Widget getExtraData(LeadHistory aHistory) {
    if (aHistory.extraData == null) return Text("N/A");
    LeadComment leadComment =
        _leadRepository.getLeadComment(aHistory.extraData);

    return Text("${leadComment.comment}");
  }

  @override
  Widget build(BuildContext context) {
    if (_currentCampaignInfo == null) return CircularProgressIndicator();
    final Lead lead = _currentCampaignInfo.lead;
    /* #region Local Widget members*/
    final commentsWidget = ListView.builder(
        itemCount: lead.history.length,
        itemBuilder: (BuildContext context, int index) {
          final LeadHistory aHistory = lead.history[index];

          return ListTile(
            leading: CircleAvatar(
              child: Text(aHistory.status.name[0].toUpperCase()),
            ),
            title: getExtraData(aHistory),
            trailing: Text(Constants.formatDate(aHistory.statusDate)),
          );
        });
    final companyNameWidget = ListTile(
      subtitle: Text(
        "TODO: implement Address Master",
        style: TextStyle(color: Colors.white),
      ),
      title: Text(
        lead.businessContact.businessName,
        style: TextStyle(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
    final proprietorWidget = lead.businessContact.proprietor == null ||
            lead.businessContact.proprietor.firstName == null
        ? Container()
        : Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Proprietor Details",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListTile(
                  onTap: () => {
                    launch(
                        "tel://${lead.businessContact.proprietor.mobileNumber}")
                  },
                  title: Text("${lead.businessContact.proprietor.firstName}"),
                  subtitle:
                      Text("${lead.businessContact.proprietor.mobileNumber}"),
                  trailing: Icon(FontAwesomeIcons.phone),
                )
              ],
            ),
          );
    final contactPersonWidget = Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Contact Person Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: Text("${lead.businessContact.contactPerson.firstName}"),
            subtitle:
                Text("${lead.businessContact.contactPerson.mobileNumber}"),
            trailing: Icon(FontAwesomeIcons.phone),
          )
        ],
      ),
    );
    /* #endregion*/
    //region Bottom Button bars
    final buttonBarWidget = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            move(--_index);
          },
          child: Text("Previous"),
        ),
        RaisedButton(
          onPressed: () {
            showBottomSheet(context);
          },
          child: Text("Update Status"),
        ),
        RaisedButton(
          onPressed: () {
            move(++_index);
          },
          child: Text("Next"),
        )
      ],
    );

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).popAndPushNamed(CampaignInfoListPage.routeName);
        return Future.value(true);
      },
      child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            titleSpacing: 0.0,
            title: companyNameWidget,
          ),
          body: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: <Widget>[
                    proprietorWidget,
                    contactPersonWidget,
                    Expanded(child: commentsWidget),
                    buttonBarWidget,
                  ],
                )),
    );
  }

  void loadCampaignInfo(String campaignInfoId) {
    setState(() {
      _isLoading = true;
    });
    _campaignRepository.fetchCampaignInfo(campaignInfoId).then((campaignInfo) {
      setState(() {
        this._currentCampaignInfo = campaignInfo;
        _isLoading = false;
      });
    });
  }

  void move(final int tempIndex) {
    if (tempIndex < 0) {
      return;
    }

    if (tempIndex >= _campaignInfos.length) return;

    _index = tempIndex;

    loadCampaignInfo(_campaignInfos[_index].id);
  }

  void loadLeadStatuses() {
    if (Constants.leadStatuses != null) return;
    _leadRepository.fetchLeadStatuses().then((leadStatuses) {
      Constants.leadStatuses = leadStatuses;
    });
  }
}
