import 'package:crm_app/dependency/util_methods.dart';

import 'lead_status.dart';

class LeadHistory {
  DateTime statusDate;
  String statusId;
  LeadStatus status;
  String extraData;
  int order;
  String id;

  LeadHistory(
      {this.id,
      this.statusDate,
      this.statusId,
      this.status,
      this.extraData,
      this.order});

  static LeadHistory fromJson(Map<String, dynamic> map) {
    var statusDate = UtilMethods.parseDateTime(map['statusDate']);

    return LeadHistory(
        id: map['id'],
        statusDate: statusDate,
        statusId: map["statusId"],
        status: LeadStatus.fromJson(map['status']),
        extraData: map['extraData'],
        order: map['order']);
  }

  static List<LeadHistory> fromJsonArray(List<Map<String, dynamic>> mapList) {
    List<LeadHistory> leadHistorytList = new List<LeadHistory>();
    if (mapList.length == 0) return leadHistorytList;

    mapList.forEach((map) {
      leadHistorytList.add(LeadHistory.fromJson(map));
    });
    return leadHistorytList;
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "statusId": status.id, "extraData": extraData};
  }
}
