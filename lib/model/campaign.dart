import 'lead.dart';

class Campaign {
  String id;
  String name;
  String description;
  String filter;
  List<CampaignInfo> infos;

  Campaign({this.id, this.name, this.description, this.filter, this.infos});

  static Campaign fromJson(Map<String, dynamic> map) {
    var infoMap = List<Map<String, dynamic>>.from(map['infos']);
    return Campaign(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        filter: map['filter'],
        infos: CampaignInfo.fromJsonArray(infoMap));
  }
}

class CampaignInfo {
  String id;
  String leadId;
  Lead lead;
  bool isInProgress;

  CampaignInfo({this.id, this.leadId, this.lead, this.isInProgress});

  static CampaignInfo fromJson(Map<String, dynamic> infoMap) {
    return CampaignInfo(
        id: infoMap['id'],
        leadId: infoMap['leadId'],
        lead: Lead.fromJson(infoMap['lead']));
  }

  static List<CampaignInfo> fromJsonArray(List<Map<String, dynamic>> infoMap) {
    List<CampaignInfo> campaignInfos = new List();
    infoMap.forEach((campaignInfo) {
      campaignInfos.add(CampaignInfo.fromJson(campaignInfo));
    });
    return campaignInfos;
  }
}
