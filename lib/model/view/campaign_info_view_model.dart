class CampaignInfoViewModel {
  String id;
  String campaignId;
  String companyName;
  String leadId;
  String statusName;
  bool isInProgress;

  CampaignInfoViewModel(
      {this.id,
      this.campaignId,
      this.companyName,
      this.leadId,
      this.statusName,
      this.isInProgress});

  static CampaignInfoViewModel fromJson(Map<String, dynamic> map) {
    return CampaignInfoViewModel(
        id: map["id"],
        campaignId: map["campaignId"],
        companyName: map["companyName"],
        leadId: map["leadId"],
        statusName: map["statusName"],
        isInProgress: map["isInProgress"]);
  }

  static List<CampaignInfoViewModel> fromJsonArray(
      List<Map<String, dynamic>> mapList) {
    List<CampaignInfoViewModel> list = new List();
    mapList.forEach((campaignMap) {
      list.add(CampaignInfoViewModel.fromJson(campaignMap));
    });
    return list;
  }
}
