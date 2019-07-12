class LeadViewModel {
  String id;
  String companyName;
  String statusName;
  String extraData;

  LeadViewModel({this.id, this.companyName, this.statusName, this.extraData});

  static List<LeadViewModel> fromJsonArray(List<Map<String, dynamic>> mapList) {
    List<LeadViewModel> list = new List();
    mapList.forEach((customerMap) {
      list.add(LeadViewModel.fromJson(customerMap));
    });
    return list;
  }

  static LeadViewModel fromJson(Map<String, dynamic> map) {
    return LeadViewModel(
        id: map["id"],
        companyName: map["companyName"],
        statusName: map["statusName"],
        extraData: map["extraData"]);
  }
}
