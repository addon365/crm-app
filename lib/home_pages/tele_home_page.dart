import 'dart:convert';
import 'dart:io';

import 'package:crm_app/dependency/constants.dart';
import 'package:crm_app/lead/comment_widget.dart';
import 'package:crm_app/lead/lead_list_widget.dart';
import 'package:crm_app/lead/lead_screen.dart';
import 'package:crm_app/lead/view_lead_widget.dart';
import 'package:crm_app/model/lead.dart';
import 'package:crm_app/model/lead_comment.dart';
import 'package:crm_app/model/lead_history.dart';
import 'package:crm_app/model/lead_status.dart';
import 'package:crm_app/model/view/lead_view_model.dart';
import 'package:crm_app/repository/lead_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class TeleHomePage extends StatefulWidget {
  static const String routeName = "tele-home";

  @override
  _TeleHomePageState createState() => _TeleHomePageState();
}

class _TeleHomePageState extends State<TeleHomePage> {
  final FirebaseMessaging _fireBaseMessaging = FirebaseMessaging();
  LeadScreen _leadScreen;
  final GlobalKey<ScaffoldState> globalKey = new GlobalKey<ScaffoldState>();
  LeadRepository _leadRepository;
  List<LeadViewModel> _leadViewModel;
  int _index = 0;
  Lead lead;
  bool _loading = false;
  LeadHistory _currentHistory;

  @override
  void initState() {
    super.initState();
    init();
    configureFireBase();
    setData();
  }

  void setData() {
    if (Constants.leadStatuses == null) {
      _leadRepository.fetchLeadStatuses().then((leadStatuses) {
        Constants.leadStatuses = leadStatuses;
      });
    }
    _leadRepository.fetchLeads().then((leads) {
      setState(() {
        setState(() {
          _leadViewModel = leads;
        });
      });
    });
  }

  Widget navigateToScreen() {
    switch (_leadScreen) {
      case LeadScreen.list:
        return LeadListWidget(_leadViewModel, onLeadSelected);
      case LeadScreen.view:
        return ViewLeadWidget(lead, updateLeadStatus,this._leadRepository);
      case LeadScreen.comment:
        return CommentWidget(updateComments);
    }
    return LeadListWidget(_leadViewModel, onLeadSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        appBar: Constants.getAppBar(context, "Tele Home"),
        body: Stack(
          children: <Widget>[
            _loading ? Center(child: CircularProgressIndicator()) : Text(""),
            navigateToScreen()
          ],
        ));
  }

  void configureFireBase() {
    _fireBaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print(message);
      return null;
    }, onLaunch: (message) {
      print("OnLaunch $message");
      return null;
    }, onResume: (message) {
      print("OnResume $message");
      return null;
    });
  }

  //Setting value via setter helps to rebuild page.
  set loading(bool value) {
    setState(() {
      _loading = value;
    });
  }

  void fetchAndViewLead() {
    if (_index >= _leadViewModel.length) {
      return;
    }
    if (_loading != true) loading = true;
    LeadViewModel selectedLead = _leadViewModel[_index];
    _leadRepository.fetchLead(selectedLead.id).then((lead) {
      setState(() {
        _loading = false;
        _leadScreen = LeadScreen.view;
        this.lead = lead;
      });
    });
  }

  onLeadSelected(int index) {
    _index = index;
    fetchAndViewLead();
  }

  void init() {
    _leadScreen = LeadScreen.list;
    _leadRepository = LeadRepository.getRepository();
  }

  updateLeadStatus(LeadStatus leadStatus) async {
    Navigator.pop(context);
    _currentHistory = new LeadHistory(
        id: lead.id, statusId: leadStatus.id, status: leadStatus);

    switch (leadStatus.name) {
      case "Appointment":
        break;
      default:
        setState(() {
          _leadScreen = LeadScreen.comment;
        });
        break;
    }
  }

  ///sends the lead followup comments to server.
  updateComments(LeadComment leadComment) async {
    loading = true;
    if (leadComment.type == "audio") {
      File file = new File(leadComment.comment);
      var result = await file.readAsBytes();
      var resultBase64 = base64.encode(result);

      String jsonBody = json.encode(
          new LeadComment(type: leadComment.type, comment: resultBase64)
              .toJson());
      _currentHistory.extraData = jsonBody;
    } else {
      String jsonBody = json.encode(
          new LeadComment(type: leadComment.type, comment: leadComment.comment)
              .toJson());
      _currentHistory.extraData = jsonBody;
    }

    this.lead.history.add(_currentHistory);
    _leadRepository.updateLeadHistory(this.lead).then((resultLead) {
      _currentHistory = null;
      if (resultLead != null) {
        _index++;

        fetchAndViewLead();
      } else {
        _leadScreen = LeadScreen.view;
        this.lead.history.removeLast();
        globalKey.currentState.showSnackBar(
            SnackBar(content: Text("Something went wrong, update Again")));
        loading = false;
      }
    });
  }
}
