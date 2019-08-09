import 'dart:convert';
import 'dart:io';

import 'package:crm_app/dependency/constants.dart';
import 'package:crm_app/lead/campaign_list_widget.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeleHomePage extends StatefulWidget {
  static const String routeName = "tele-home";

  @override
  _TeleHomePageState createState() => _TeleHomePageState();
}

class _TeleHomePageState extends State<TeleHomePage> {
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

    setData();
    _loadIndex();
  }

  void setData() {
    if (Constants.leadStatuses == null) {
      _leadRepository.fetchLeadStatuses().then((leadStatuses) {
        Constants.leadStatuses = leadStatuses;
      });
    }
    fetchLeads();
  }

  Future<void> fetchLeads() {
    _leadRepository.fetchLeads().then((leads) {
      setState(() {
        setState(() {
          _leadViewModel = leads;
        });
      });
    });
    return _leadRepository.fetchLeads();
  }

  void navigateTo(LeadScreen screen, dynamic param) {
    setState(() {
      _leadScreen = screen;
    });
  }

  Widget screenNavigator() {
    switch (_leadScreen) {
      case LeadScreen.list:
        return CampaignListWidget(move);
      case LeadScreen.view:
        return ViewLeadWidget(
            lead, updateLeadStatus, this._leadRepository, move);
      case LeadScreen.comment:
        return CommentWidget(updateComments);
    }
    return LeadListWidget(_leadViewModel, onLeadSelected, fetchLeads);
  }

  void move(int p) {
    if ((_index + p) < 0 || (_index + p) >= _leadViewModel.length) return;
    print(_index);

    _index = _index + p;
    _leadScreen = LeadScreen.view;
    fetchAndViewLead();
    _storeIndex();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: navigateBack,
      child: Scaffold(
          key: globalKey,
          appBar: Constants.getAppBar(context, "Tele Home"),
          body: Stack(
            children: <Widget>[
              _loading ? Center(child: CircularProgressIndicator()) : Text(""),
              screenNavigator()
            ],
          )),
    );
  }

  //Setting value via setter helps to rebuild page.
  set loading(bool value) {
    setState(() {
      _loading = value;
    });
  }

  void fetchAndViewLead() {
    if (_leadViewModel == null) return null;
    if (_index >= _leadViewModel.length) return null;
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
        setState(() {
          _leadScreen = LeadScreen.view;
        });
      } else {
        _leadScreen = LeadScreen.view;
        this.lead.history.removeLast();
        globalKey.currentState.showSnackBar(
            SnackBar(content: Text("Something went wrong, update Again")));
        loading = false;
      }
    });
  }

  _storeIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('index', _index);
  }

  _loadIndex() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('index')) {
      int index = preferences.getInt('index');
      _index = index;
      fetchAndViewLead();
    } else {
      return;
    }
  }

  Future<bool> navigateBack() {
    switch (_leadScreen) {
      case LeadScreen.view:
      case LeadScreen.comment:
        _leadScreen = LeadScreen.list;
        screenNavigator();
        break;
      case LeadScreen.list:
        SystemNavigator.pop();
        break;
    }

    return Future.value(true);
  }
}
