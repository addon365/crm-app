class CampaignViewModel {
  String id;
  String name;
  String description;
  String filter;
  int count;

  CampaignViewModel(
      {this.id, this.name, this.description, this.filter, this.count});

  static CampaignViewModel fromJson(Map<String, dynamic> map) {
    return CampaignViewModel(
        id: map["id"],
        name: map["name"],
        description: map["description"],
        filter: map["filter"],
        count: map["count"]);
  }

  static List<CampaignViewModel> fromJsonArray(
      List<Map<String, dynamic>> mapList) {
    List<CampaignViewModel> list = new List();
    mapList.forEach((campaignMap) {
      list.add(CampaignViewModel.fromJson(campaignMap));
    });
    return list;
  }
}
