import 'dart:convert';

import 'package:crm_app/dependency/constants.dart';
import 'package:crm_app/model/lead.dart';
import 'package:crm_app/model/lead_comment.dart';
import 'package:crm_app/model/lead_history.dart';
import 'package:crm_app/model/lead_status.dart';
import 'package:crm_app/model/view/lead_view_model.dart';
import 'package:http/http.dart' as http;

class LeadRepository {
  static LeadRepository leadRepository;

  static LeadRepository getRepository() {
    if (leadRepository == null) leadRepository = new LeadRepository();
    return leadRepository;
  }

  Future<List<LeadViewModel>> fetchLeads() async {
    String url = '$baseUrl/Leads/followup';
    var result = await http.get(url);
    if (result.statusCode == 200) {
      var mapList = List<Map<String, dynamic>>.from(json.decode(result.body));
      return LeadViewModel.fromJsonArray(mapList);
    } else {
      return null;
    }
  }

  Future<Lead> fetchLead(String id) async {
    String url = '$baseUrl/Leads?id=$id';
    var result = await http.get(url);
    if (result.statusCode == 200) {
      var map = json.decode(result.body);
      var resultLead = Lead.fromJson(map);
      return resultLead;
    } else {
      return null;
    }
  }

  Future<List<LeadStatus>> fetchLeadStatuses() async {
    String url = '$baseUrl/LeadStatus';
    var result = await http.get(url);
    if (result.statusCode == 200) {
      var mapList = List<Map<String, dynamic>>.from(json.decode(result.body));
      return LeadStatus.fromJsonArray(mapList);
    } else {
      return null;
    }
  }

  LeadComment getLeadComment(String leadCommentJson){
    var leadComment=LeadComment.fromJson(json.decode(leadCommentJson));
    if(leadComment.type=="text")
      return leadComment;
    else{

    }
  }

  Future<Lead> updateLeadHistory(Lead lead) async {
    Lead l = new Lead(id: lead.id);
    l.history = new List<LeadHistory>();
    l.history.add(lead.history[lead.history.length - 1]);

    var jsonBody = json.encode(l.toJson());
    String url = '$baseUrl/Leads/status';
    var result = await http.put(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonBody);
    if (result.statusCode == 200) {
      return new Lead(); //As update success, we just send lead object for confirmation.
    } else {
      return null;
    }
  }
}
